"""M2 evaluation corpus loaders."""

from __future__ import annotations

import json
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Iterator

REPO_ROOT = Path(__file__).resolve().parents[2]
FIXTURES = REPO_ROOT / "memory" / "features" / "tajweed" / "fixtures"
PRESENTATION_CASES = FIXTURES / "presentation_space_cases.json"
LIVE_FIXTURES = FIXTURES / "m2_live_captures"
PAAK_PATH = REPO_ROOT / "assets" / "raw" / "quran_paak.json"
INDOPAK_PATH = REPO_ROOT / "assets" / "quran" / "text" / "indopak.json"
UTHMANI_PATH = REPO_ROOT / "assets" / "quran" / "text" / "uthmani.json"

GOLDEN_AYAHS = [
    *(f"1:{a}" for a in range(1, 8)),
    *(f"2:{a}" for a in range(2, 8)),
]


@dataclass(frozen=True)
class EvalCase:
    case_id: str
    ref: str
    corpus_kind: str
    expected_arabic: str
    hypothesis: str
    lexical_reference_arabic: str
    source: str
    notes: str = ""


def _load_text_maps() -> tuple[dict[str, str], dict[str, str], dict[str, str]]:
    indopak = {
        f"{a['surah']}:{a['ayah']}": a["text"]
        for a in json.loads(INDOPAK_PATH.read_text(encoding="utf-8"))["ayahs"]
    }
    uthmani = {
        f"{a['surah']}:{a['ayah']}": a["text"]
        for a in json.loads(UTHMANI_PATH.read_text(encoding="utf-8"))["ayahs"]
    }
    paak: dict[str, str] = {}
    for surah in json.loads(PAAK_PATH.read_text(encoding="utf-8")):
        sn = int(surah["@index"])
        for aya in surah.get("aya") or []:
            paak[f"{sn}:{int(aya['@index'])}"] = aya.get("@text") or ""
    return indopak, uthmani, paak


def iter_golden_perfect_recitation() -> Iterator[EvalCase]:
    """Correct Imlaei recitation vs IndoPak display expected (legacy orthography stress)."""
    indopak, uthmani, paak = _load_text_maps()
    for ref in GOLDEN_AYAHS:
        if ref not in indopak or ref not in uthmani or ref not in paak:
            continue
        yield EvalCase(
            case_id=f"golden_perfect:{ref}",
            ref=ref,
            corpus_kind="golden_perfect",
            expected_arabic=indopak[ref],
            hypothesis=paak[ref],
            lexical_reference_arabic=uthmani[ref],
            source="quran_paak.json + indopak.json",
            notes="Simulated correct ASR (Imlaei) with IndoPak Mushaf expected",
        )


def iter_presentation_space_cases() -> Iterator[EvalCase]:
    """763 IndoPak presentation-boundary cases — correct Imlaei ASR hypothesis."""
    indopak, uthmani, paak = _load_text_maps()
    data = json.loads(PRESENTATION_CASES.read_text(encoding="utf-8"))
    for i, row in enumerate(data["cases"]):
        ref = f"{row['surah']}:{row['ayah']}"
        hyp = paak.get(ref, "")
        if not hyp:
            continue
        yield EvalCase(
            case_id=f"presentation_space:{ref}:{i}",
            ref=ref,
            corpus_kind="presentation_space",
            expected_arabic=row["indopak"],
            hypothesis=hyp,
            lexical_reference_arabic=row["uthmani"],
            source="presentation_space_cases.json",
            notes="IndoPak display with Uthmani reference; Imlaei-perfect hypothesis",
        )


def stages_json_to_case(path: Path, *, corpus_kind: str = "live_capture") -> EvalCase | None:
    data = json.loads(path.read_text(encoding="utf-8"))
    ref = data.get("ref")
    if not ref:
        return None
    expected = data.get("originalExpectedAyah") or data.get("expected") or ""
    hyp = data.get("originalAsrHypothesis") or data.get("hypothesis") or ""
    if not expected or not hyp:
        return None
    _, uthmani, _ = _load_text_maps()
    return EvalCase(
        case_id=f"{corpus_kind}:{path.stem}:{ref}",
        ref=ref,
        corpus_kind=corpus_kind,
        expected_arabic=expected,
        hypothesis=hyp,
        lexical_reference_arabic=uthmani.get(ref, expected),
        source=str(path),
        notes=f"Live capture export ({path.name})",
    )


def iter_live_captures(extra_paths: list[Path] | None = None) -> Iterator[EvalCase]:
    seen_refs: set[str] = set()
    if LIVE_FIXTURES.is_dir():
        for path in sorted(LIVE_FIXTURES.glob("*.json")):
            case = stages_json_to_case(path)
            if case:
                seen_refs.add(case.ref)
                yield case
    defaults = [
        Path("/Users/rabiadastgir/Downloads/last_stages.json"),
        Path("/Users/rabiadastgir/Downloads/last_stages 2.json"),
    ]
    for path in (extra_paths or []) + defaults:
        if not path.is_file():
            continue
        case = stages_json_to_case(path)
        if case and case.ref not in seen_refs:
            yield case


def import_live_captures_to_fixtures(extra_paths: list[Path] | None = None) -> list[Path]:
    """Copy live last_stages.json exports into repo fixtures (sanitized)."""
    LIVE_FIXTURES.mkdir(parents=True, exist_ok=True)
    written: list[Path] = []
    for case in iter_live_captures(extra_paths):
        src = Path(case.source)
        if not src.is_file():
            continue
        dest = LIVE_FIXTURES / f"{case.ref.replace(':', '_')}_{src.stem.replace(' ', '_')}.json"
        if dest.exists():
            written.append(dest)
            continue
        data = json.loads(src.read_text(encoding="utf-8"))
        # Keep evaluation-relevant fields only.
        slim = {
            k: data[k]
            for k in [
                "ref",
                "platform",
                "originalExpectedAyah",
                "originalAsrHypothesis",
                "expected",
                "hypothesis",
                "normalizedExpectedWords",
                "normalizedAsrWords",
                "lexicalOps",
                "wordAccuracy",
            ]
            if k in data
        }
        dest.write_text(json.dumps(slim, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        written.append(dest)
    return written


def load_all_cases(
    *,
    include_golden: bool = True,
    include_presentation: bool = True,
    include_live: bool = True,
    extra_live_paths: list[Path] | None = None,
) -> list[EvalCase]:
    cases: list[EvalCase] = []
    if include_golden:
        cases.extend(iter_golden_perfect_recitation())
    if include_presentation:
        cases.extend(iter_presentation_space_cases())
    if include_live:
        cases.extend(iter_live_captures(extra_live_paths))
    return cases
