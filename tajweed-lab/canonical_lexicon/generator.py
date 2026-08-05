"""Generate versioned canonical spoken-Quran lexicon pack."""

from __future__ import annotations

import hashlib
import json
import subprocess
from datetime import datetime, timezone
from pathlib import Path

from canonical_lexicon.models import AyahRecord, CanonicalWord, LexiconManifest, SurfaceForms
from canonical_lexicon.segment import extract_indopak_surfaces, extract_surface_spans, project_word_boundaries
from canonical_lexicon.stage2 import split_ascii_words, stage2_letterstream, stage2_word

REPO_ROOT = Path(__file__).resolve().parents[2]
UTHMANI_PATH = REPO_ROOT / "assets" / "quran" / "text" / "uthmani.json"
INDOPAK_PATH = REPO_ROOT / "assets" / "quran" / "text" / "indopak.json"
PAAK_PATH = REPO_ROOT / "assets" / "raw" / "quran_paak.json"

SCHEMA_VERSION = 1
LEXICON_VERSION = "1.0.0"
LINGUISTIC_SPEC_VERSION = "1.0.0"
STAGE2_FOLD_REVISION = "2026-07-31"


class LexiconGenerationError(Exception):
    pass


def _git_commit() -> str:
    try:
        out = subprocess.check_output(
            ["git", "rev-parse", "HEAD"],
            cwd=REPO_ROOT,
            stderr=subprocess.DEVNULL,
            text=True,
        ).strip()
        return out[:12]
    except (subprocess.CalledProcessError, FileNotFoundError):
        return "unknown"


def _load_ayah_maps() -> tuple[dict[str, str], dict[str, str], dict[str, str]]:
    uthmani = {
        f"{a['surah']}:{a['ayah']}": a["text"]
        for a in json.loads(UTHMANI_PATH.read_text(encoding="utf-8"))["ayahs"]
    }
    indopak = {
        f"{a['surah']}:{a['ayah']}": a["text"]
        for a in json.loads(INDOPAK_PATH.read_text(encoding="utf-8"))["ayahs"]
    }
    paak: dict[str, str] = {}
    for surah in json.loads(PAAK_PATH.read_text(encoding="utf-8")):
        sn = int(surah["@index"])
        for aya in surah.get("aya") or []:
            paak[f"{sn}:{int(aya['@index'])}"] = aya.get("@text") or ""
    return uthmani, indopak, paak


def generate_ayah_record(
    ref: str,
    uthmani_text: str,
    indopak_text: str,
    paak_text: str,
) -> AyahRecord:
    surah, ayah = (int(x) for x in ref.split(":"))
    uth_words = split_ascii_words(uthmani_text)
    if not uth_words:
        raise LexiconGenerationError(f"{ref}: empty Uthmani word list")

    paak_words = split_ascii_words(paak_text)
    paak_stream = stage2_letterstream(paak_text)
    if not paak_stream:
        raise LexiconGenerationError(f"{ref}: empty paak letterstream")

    if len(paak_words) == len(uth_words):
        canonical_words = [stage2_word(w) for w in paak_words]
        if "".join(canonical_words) != paak_stream:
            canonical_words, _ = project_word_boundaries(uth_words, paak_stream)
    else:
        canonical_words, _ = project_word_boundaries(uth_words, paak_stream)
    if len(canonical_words) != len(uth_words):
        raise LexiconGenerationError(
            f"{ref}: canonical word count {len(canonical_words)} != uthmani {len(uth_words)}"
        )
    for idx, c in enumerate(canonical_words):
        if not c:
            raise LexiconGenerationError(f"{ref}: empty canonical at word {idx}")

    if "".join(canonical_words) != paak_stream:
        raise LexiconGenerationError(
            f"{ref}: canonical concat != paak stream "
            f"({''.join(canonical_words)!r} vs {paak_stream!r})"
        )

    try:
        if len(paak_words) == len(uth_words):
            imlaei_surfaces = paak_words
        else:
            imlaei_surfaces = extract_surface_spans(paak_text, canonical_words)
    except ValueError as e:
        raise LexiconGenerationError(f"{ref}: imlaei surface segmentation failed: {e}") from e

    indo_words = split_ascii_words(indopak_text)
    try:
        if len(indo_words) == len(uth_words):
            indopak_surfaces = indo_words
        else:
            indopak_surfaces = extract_indopak_surfaces(uth_words, indopak_text)
    except ValueError as e:
        raise LexiconGenerationError(f"{ref}: indopak surface segmentation failed: {e}") from e

    # Uthmani surfaces are authoritative whitespace tokens (no re-segmentation).
    uthmani_surfaces = uth_words
    if len(indopak_surfaces) != len(uth_words):
        raise LexiconGenerationError(
            f"{ref}: indopak surface count {len(indopak_surfaces)} != {len(uth_words)}"
        )

    words: list[CanonicalWord] = []
    for i, canonical in enumerate(canonical_words):
        words.append(
            CanonicalWord(
                id=f"{surah}:{ayah}:{i}",
                canonical=canonical,
                surfaceForms=SurfaceForms(
                    uthmani=uthmani_surfaces[i],
                    indopak=indopak_surfaces[i],
                    imlaei=imlaei_surfaces[i],
                ),
                pronunciation=None,
                tajweed=None,
            )
        )

    return AyahRecord(
        ref=ref,
        surah=surah,
        ayah=ayah,
        schemaVersion=SCHEMA_VERSION,
        wordCount=len(words),
        letterstream=paak_stream,
        words=words,
    )


def generate_lexicon() -> tuple[LexiconManifest, list[AyahRecord]]:
    uthmani, indopak, paak = _load_ayah_maps()
    records: list[AyahRecord] = []
    errors: list[str] = []

    for ref in sorted(uthmani.keys(), key=lambda r: (int(r.split(":")[0]), int(r.split(":")[1]))):
        if ref not in indopak or ref not in paak:
            errors.append(f"{ref}: missing indopak or paak text")
            continue
        try:
            records.append(
                generate_ayah_record(ref, uthmani[ref], indopak[ref], paak[ref])
            )
        except LexiconGenerationError as e:
            errors.append(str(e))

    if errors:
        sample = "\n".join(errors[:20])
        more = f"\n... and {len(errors) - 20} more" if len(errors) > 20 else ""
        raise LexiconGenerationError(
            f"Lexicon generation failed closed: {len(errors)} ayah(s)\n{sample}{more}"
        )

    ndjson_body = "\n".join(
        json.dumps(r.to_dict(), ensure_ascii=False, separators=(",", ":"))
        for r in records
    )
    payload_sha = hashlib.sha256(ndjson_body.encode("utf-8")).hexdigest()

    manifest = LexiconManifest(
        schemaVersion=SCHEMA_VERSION,
        lexiconVersion=LEXICON_VERSION,
        generatorCommit=_git_commit(),
        generatedAt=datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        ayahCount=len(records),
        payloadSha256=payload_sha,
        linguisticSpecVersion=LINGUISTIC_SPEC_VERSION,
        stage2FoldRevision=STAGE2_FOLD_REVISION,
        sourceAssets={
            "uthmani": str(UTHMANI_PATH.relative_to(REPO_ROOT)),
            "indopak": str(INDOPAK_PATH.relative_to(REPO_ROOT)),
            "imlaei": str(PAAK_PATH.relative_to(REPO_ROOT)),
        },
    )
    return manifest, records


def write_pack(output_dir: Path) -> LexiconManifest:
    output_dir.mkdir(parents=True, exist_ok=True)
    manifest, records = generate_lexicon()
    ndjson_path = output_dir / "ayahs.ndjson"
    ndjson_lines = [
        json.dumps(r.to_dict(), ensure_ascii=False, separators=(",", ":"))
        for r in records
    ]
    ndjson_path.write_text("\n".join(ndjson_lines) + "\n", encoding="utf-8")
    (output_dir / "manifest.json").write_text(
        json.dumps(manifest.to_dict(), ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    return manifest
