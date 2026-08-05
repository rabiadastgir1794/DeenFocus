"""Fail-closed validation for generated canonical lexicon packs."""

from __future__ import annotations

import hashlib
import json
import re
from dataclasses import dataclass
from pathlib import Path

from canonical_lexicon.models import AyahRecord, CanonicalWord, LexiconManifest, SurfaceForms
from canonical_lexicon.stage2 import stage2_letterstream, stage2_word

WORD_ID_RE = re.compile(r"^\d+:\d+:\d+$")


@dataclass(frozen=True)
class ValidationIssue:
    ref: str
    message: str

    def __str__(self) -> str:
        return f"{self.ref}: {self.message}"


def load_pack(pack_dir: Path) -> tuple[LexiconManifest, list[AyahRecord]]:
    manifest_path = pack_dir / "manifest.json"
    ndjson_path = pack_dir / "ayahs.ndjson"
    if not manifest_path.is_file() or not ndjson_path.is_file():
        raise FileNotFoundError(f"missing manifest.json or ayahs.ndjson in {pack_dir}")

    manifest_raw = json.loads(manifest_path.read_text(encoding="utf-8"))
    manifest = LexiconManifest(**manifest_raw)

    records: list[AyahRecord] = []
    for line_no, line in enumerate(ndjson_path.read_text(encoding="utf-8").splitlines(), 1):
        if not line.strip():
            continue
        raw = json.loads(line)
        records.append(
            AyahRecord(
                ref=raw["ref"],
                surah=raw["surah"],
                ayah=raw["ayah"],
                schemaVersion=raw["schemaVersion"],
                wordCount=raw["wordCount"],
                letterstream=raw["letterstream"],
                words=[
                    CanonicalWord(
                        id=w["id"],
                        canonical=w["canonical"],
                        surfaceForms=SurfaceForms(
                            uthmani=w["surfaceForms"]["uthmani"],
                            indopak=w["surfaceForms"]["indopak"],
                            imlaei=w["surfaceForms"]["imlaei"],
                        ),
                        pronunciation=w.get("pronunciation"),
                        tajweed=w.get("tajweed"),
                    )
                    for w in raw["words"]
                ],
            )
        )
    return manifest, records


def validate_record(record: AyahRecord) -> list[ValidationIssue]:
    issues: list[ValidationIssue] = []
    ref = record.ref

    if record.wordCount != len(record.words):
        issues.append(
            ValidationIssue(ref, f"wordCount {record.wordCount} != len(words) {len(record.words)}")
        )

    canonical_concat = "".join(w.canonical for w in record.words)
    if canonical_concat != record.letterstream:
        issues.append(ValidationIssue(ref, "canonical concat != letterstream"))

    seen_ids: set[str] = set()
    for idx, word in enumerate(record.words):
        expected_id = f"{record.surah}:{record.ayah}:{idx}"
        if word.id != expected_id:
            issues.append(ValidationIssue(ref, f"id mismatch at {idx}: {word.id!r} != {expected_id!r}"))
        if word.id in seen_ids:
            issues.append(ValidationIssue(ref, f"duplicate id {word.id!r}"))
        seen_ids.add(word.id)
        if not WORD_ID_RE.match(word.id):
            issues.append(ValidationIssue(ref, f"invalid id format {word.id!r}"))
        if not word.canonical:
            issues.append(ValidationIssue(ref, f"empty canonical at {word.id}"))
        for script, surface in word.surfaceForms.to_dict().items():
            if not surface.strip():
                issues.append(ValidationIssue(ref, f"empty {script} surface at {word.id}"))
            folded = stage2_word(surface)
            if script == "imlaei" and folded != word.canonical:
                issues.append(
                    ValidationIssue(
                        ref,
                        f"imlaei fold mismatch at {word.id}: {folded!r} != {word.canonical!r}",
                    )
                )

    return issues


def validate_pack(pack_dir: Path) -> list[ValidationIssue]:
    manifest, records = load_pack(pack_dir)
    issues: list[ValidationIssue] = []

    ndjson_path = pack_dir / "ayahs.ndjson"
    body = ndjson_path.read_text(encoding="utf-8").strip("\n")
    payload_sha = hashlib.sha256(body.encode("utf-8")).hexdigest()
    if payload_sha != manifest.payloadSha256:
        issues.append(ValidationIssue("manifest", "payloadSha256 mismatch"))

    if manifest.ayahCount != len(records):
        issues.append(
            ValidationIssue(
                "manifest",
                f"ayahCount {manifest.ayahCount} != ndjson rows {len(records)}",
            )
        )

    refs = [r.ref for r in records]
    if len(set(refs)) != len(refs):
        issues.append(ValidationIssue("pack", "duplicate ayah refs in ndjson"))

    for record in records:
        issues.extend(validate_record(record))

    return issues


def assert_pack_valid(pack_dir: Path) -> LexiconManifest:
    issues = validate_pack(pack_dir)
    if issues:
        sample = "\n".join(str(i) for i in issues[:30])
        more = f"\n... and {len(issues) - 30} more" if len(issues) > 30 else ""
        raise ValueError(f"Lexicon pack validation failed: {len(issues)} issue(s)\n{sample}{more}")
    manifest, _ = load_pack(pack_dir)
    return manifest
