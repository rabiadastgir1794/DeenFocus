"""Canonical lexicon schema (ADR-010 v1)."""

from __future__ import annotations

from dataclasses import asdict, dataclass, field
from typing import Any


@dataclass(frozen=True)
class SurfaceForms:
    uthmani: str
    indopak: str
    imlaei: str

    def to_dict(self) -> dict[str, str]:
        return {"uthmani": self.uthmani, "indopak": self.indopak, "imlaei": self.imlaei}


@dataclass(frozen=True)
class CanonicalWord:
    id: str
    canonical: str
    surfaceForms: SurfaceForms
    pronunciation: dict[str, Any] | None = None
    tajweed: dict[str, Any] | None = None

    def to_dict(self) -> dict[str, Any]:
        out: dict[str, Any] = {
            "id": self.id,
            "canonical": self.canonical,
            "surfaceForms": self.surfaceForms.to_dict(),
        }
        if self.pronunciation is not None:
            out["pronunciation"] = self.pronunciation
        if self.tajweed is not None:
            out["tajweed"] = self.tajweed
        return out


@dataclass(frozen=True)
class AyahRecord:
    ref: str
    surah: int
    ayah: int
    schemaVersion: int
    wordCount: int
    letterstream: str
    words: list[CanonicalWord]

    def to_dict(self) -> dict[str, Any]:
        return {
            "ref": self.ref,
            "surah": self.surah,
            "ayah": self.ayah,
            "schemaVersion": self.schemaVersion,
            "wordCount": self.wordCount,
            "letterstream": self.letterstream,
            "words": [w.to_dict() for w in self.words],
        }


@dataclass
class LexiconManifest:
    schemaVersion: int
    lexiconVersion: str
    generatorCommit: str
    generatedAt: str
    ayahCount: int
    payloadSha256: str
    linguisticSpecVersion: str
    stage2FoldRevision: str
    sourceAssets: dict[str, str] = field(default_factory=dict)

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)
