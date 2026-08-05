"""M2.6 real-world dataset schema and loaders (lab only)."""

from __future__ import annotations

import json
import shutil
from dataclasses import asdict, dataclass, field
from pathlib import Path
from typing import Any, Iterator

REPO_ROOT = Path(__file__).resolve().parents[2]
DEFAULT_DATASET = REPO_ROOT / "memory" / "features" / "tajweed" / "fixtures" / "m26_real_world"
LIVE_FIXTURES = REPO_ROOT / "memory" / "features" / "tajweed" / "fixtures" / "m2_live_captures"
SAMPLES = REPO_ROOT / "tajweed-lab" / "samples"
INDOPAK_PATH = REPO_ROOT / "assets" / "quran" / "text" / "indopak.json"
UTHMANI_PATH = REPO_ROOT / "assets" / "quran" / "text" / "uthmani.json"

SPEAKER_TAGS = frozenset(
    {
        "pakistani",
        "indian",
        "arab",
        "turkish",
        "indonesian",
        "african",
        "american_convert",
        "child",
        "adult_male",
        "adult_female",
        "unknown",
        "qari_professional",
    }
)

FAILURE_CAUSES = frozenset(
    {"asr", "canonical_lexical", "pronunciation", "tajweed", "policy", "unknown"}
)


@dataclass
class RecordingMeta:
    recording_id: str
    ref: str
    speaker_id: str
    speaker_tags: list[str]
    audio_relpath: str
    expected_arabic: str
    lexical_reference_arabic: str
    hypothesis: str | None = None
    notes: str = ""
    source: str = ""
    human_label: str | None = None  # correct | incorrect | partial | null


@dataclass
class DatasetManifest:
    version: str
    description: str
    recordings: list[RecordingMeta] = field(default_factory=list)

    def to_dict(self) -> dict[str, Any]:
        return {
            "version": self.version,
            "description": self.description,
            "recordingCount": len(self.recordings),
            "recordings": [asdict(r) for r in self.recordings],
        }


def _load_script_maps() -> tuple[dict[str, str], dict[str, str]]:
    indo = {
        f"{a['surah']}:{a['ayah']}": a["text"]
        for a in json.loads(INDOPAK_PATH.read_text(encoding="utf-8"))["ayahs"]
    }
    uth = {
        f"{a['surah']}:{a['ayah']}": a["text"]
        for a in json.loads(UTHMANI_PATH.read_text(encoding="utf-8"))["ayahs"]
    }
    return indo, uth


def load_manifest(dataset_dir: Path = DEFAULT_DATASET) -> DatasetManifest:
    path = dataset_dir / "manifest.json"
    raw = json.loads(path.read_text(encoding="utf-8"))
    recordings = [RecordingMeta(**r) for r in raw["recordings"]]
    return DatasetManifest(
        version=raw.get("version", "0"),
        description=raw.get("description", ""),
        recordings=recordings,
    )


def save_manifest(manifest: DatasetManifest, dataset_dir: Path = DEFAULT_DATASET) -> None:
    dataset_dir.mkdir(parents=True, exist_ok=True)
    (dataset_dir / "manifest.json").write_text(
        json.dumps(manifest.to_dict(), ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )


def audio_path(dataset_dir: Path, meta: RecordingMeta) -> Path:
    return dataset_dir / meta.audio_relpath


def seed_dataset(dataset_dir: Path = DEFAULT_DATASET) -> DatasetManifest:
    """Create/overwrite manifest from golden clips + live captures (hypothesis-first)."""
    indo, uth = _load_script_maps()
    audio_dir = dataset_dir / "audio"
    audio_dir.mkdir(parents=True, exist_ok=True)
    recordings: list[RecordingMeta] = []

    golden = [
        (
            "01_alafasy_fatihah.wav",
            "1:4",
            "alafasy",
            ["arab", "adult_male", "qari_professional"],
            "Golden clip — Mishary Alafasy (Arab professional)",
        ),
        (
            "02_basfar_ikhlas.wav",
            "112:1",
            "basfar",
            ["arab", "adult_male", "qari_professional"],
            "Golden clip — Abdullah Basfar (Arab professional)",
        ),
        (
            "03_alafasy_naba.wav",
            "38:67",
            "alafasy",
            ["arab", "adult_male", "qari_professional"],
            "Golden clip — Mishary Alafasy (Arab professional)",
        ),
    ]
    for fname, ref, speaker, tags, notes in golden:
        src = SAMPLES / fname
        if not src.is_file():
            continue
        dest_name = f"golden_{fname}"
        shutil.copy2(src, audio_dir / dest_name)
        recordings.append(
            RecordingMeta(
                recording_id=f"golden_{Path(fname).stem}",
                ref=ref,
                speaker_id=speaker,
                speaker_tags=tags,
                audio_relpath=f"audio/{dest_name}",
                expected_arabic=indo.get(ref, uth.get(ref, "")),
                lexical_reference_arabic=uth.get(ref, ""),
                hypothesis=None,  # filled by ASR at eval time
                notes=notes,
                source=str(src.relative_to(REPO_ROOT)),
                human_label="correct",
            )
        )

    # Live captures — store stages JSON as hypothesis source; copy WAV if present
    live_wav_map = {
        "2:5": Path("/Users/rabiadastgir/Downloads/last.wav"),
        "2:7": Path("/Users/rabiadastgir/Downloads/last 2.wav"),
    }
    for stages_path in sorted(LIVE_FIXTURES.glob("*.json")):
        data = json.loads(stages_path.read_text(encoding="utf-8"))
        ref = data.get("ref")
        if not ref:
            continue
        hyp = data.get("originalAsrHypothesis") or data.get("hypothesis") or ""
        expected = data.get("originalExpectedAyah") or data.get("expected") or indo.get(ref, "")
        rid = f"live_{ref.replace(':', '_')}_{stages_path.stem}"
        wav_src = live_wav_map.get(ref)
        audio_rel = ""
        if wav_src and wav_src.is_file():
            dest_name = f"{rid}.wav"
            shutil.copy2(wav_src, audio_dir / dest_name)
            audio_rel = f"audio/{dest_name}"
        else:
            # Placeholder: hypothesis-only recording (no audio on disk)
            audio_rel = f"audio/{rid}.missing.wav"
        recordings.append(
            RecordingMeta(
                recording_id=rid,
                ref=ref,
                speaker_id="live_user_unknown",
                speaker_tags=["unknown", "adult_male"],
                audio_relpath=audio_rel,
                expected_arabic=expected,
                lexical_reference_arabic=uth.get(ref, expected),
                hypothesis=hyp,
                notes=f"Live device capture from {stages_path.name}; demographics unknown",
                source=str(stages_path.relative_to(REPO_ROOT)),
                human_label=None,
            )
        )

    # Diversity placeholders — slots for future speakers (no audio yet)
    for i, (sid, tags, note) in enumerate(
        [
            ("slot_pakistani_f", ["pakistani", "adult_female"], "Placeholder — add recording"),
            ("slot_indian_m", ["indian", "adult_male"], "Placeholder — add recording"),
            ("slot_turkish_m", ["turkish", "adult_male"], "Placeholder — add recording"),
            ("slot_indonesian_f", ["indonesian", "adult_female"], "Placeholder — add recording"),
            ("slot_african_m", ["african", "adult_male"], "Placeholder — add recording"),
            ("slot_american_convert_f", ["american_convert", "adult_female"], "Placeholder — add recording"),
            ("slot_child", ["child", "unknown"], "Placeholder — add recording"),
        ]
    ):
        recordings.append(
            RecordingMeta(
                recording_id=f"slot_{i:02d}_{sid}",
                ref="1:1",
                speaker_id=sid,
                speaker_tags=tags,
                audio_relpath=f"audio/{sid}.missing.wav",
                expected_arabic=indo.get("1:1", ""),
                lexical_reference_arabic=uth.get("1:1", ""),
                hypothesis=None,
                notes=note,
                source="placeholder",
                human_label=None,
            )
        )

    manifest = DatasetManifest(
        version="0.1.0",
        description=(
            "ADR-010 M2.6 real-world / multi-speaker lab dataset. "
            "Seeded with golden professional clips + existing live captures; "
            "diversity slots reserved for future recordings."
        ),
        recordings=recordings,
    )
    save_manifest(manifest, dataset_dir)
    (dataset_dir / "README.md").write_text(
        """# M2.6 Real-World Recitation Dataset

Lab-only. Not used by production scoring.

## Layout

```
manifest.json          # recording metadata
audio/*.wav            # PCM 16 kHz mono preferred
reports/               # generated by run_m26_evaluation.py
```

## Adding a recording

1. Copy `audio.wav` into `audio/`.
2. Append a record to `manifest.json` with:
   - `recording_id`, `ref` (e.g. `2:3`)
   - `speaker_id`, `speaker_tags` (from allowed set)
   - `expected_arabic` (display Mushaf), `lexical_reference_arabic` (Uthmani)
   - optional `hypothesis` (skip ASR) or leave null to run ONNX ASR at eval time
   - `human_label`: `correct` | `incorrect` | `partial` | null
3. Re-run: `python scripts/run_m26_evaluation.py`

## Allowed speaker_tags

pakistani, indian, arab, turkish, indonesian, african, american_convert,
child, adult_male, adult_female, unknown, qari_professional
""",
        encoding="utf-8",
    )
    return manifest


def iter_evaluable(manifest: DatasetManifest, dataset_dir: Path) -> Iterator[RecordingMeta]:
    """Yield recordings that have hypothesis or a real audio file."""
    for r in manifest.recordings:
        if r.source == "placeholder":
            continue
        wav = audio_path(dataset_dir, r)
        if r.hypothesis:
            yield r
        elif wav.is_file() and not wav.name.endswith(".missing.wav"):
            yield r
