#!/usr/bin/env python3
"""Lexical false-mismatch audit — mirrors TajweedLexicalScoring.normalizeArabic."""

from __future__ import annotations

import json
import re
import unicodedata
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

REPO = Path(__file__).resolve().parents[3]

DIACRITICS = set("\u064B\u064C\u064D\u064E\u064F\u0650\u0651\u0652\u0615\u0653\u0654\u06E1")
FORMAT_CONTROLS = {0x200B, 0x200C, 0x200D, 0xFEFF, 0x00A0, 0x202F, 0x2009, 0x200A, 0x2060, 0x061C}
HEH_FAMILY = {0x0647, 0x06C1, 0x06BE, 0x0629, 0x06D5, 0x06C2, 0x06C3}


def is_ignorable_mark(ch: str) -> bool:
    cp = ord(ch)
    return ch in DIACRITICS or cp == 0x0640 or (0x06D6 <= cp <= 0x06ED) or cp in FORMAT_CONTROLS


def is_heh_family(code: int) -> bool:
    return code in HEH_FAMILY


def normalize_arabic(text: str) -> str:
    scalars = list(text)
    out: list[str] = []
    i = 0
    while i < len(scalars):
        ch = scalars[i]
        cp = ord(ch)
        if ch.isspace():
            i += 1
            continue
        if cp == 0x0670:
            j = i + 1
            while j < len(scalars) and is_ignorable_mark(scalars[j]):
                j += 1
            if j >= len(scalars) or scalars[j].isspace():
                next_cp = 0
            else:
                next_cp = ord(scalars[j])
            if not is_heh_family(next_cp):
                out.append("\u0627")
            i += 1
            continue
        if cp == 0x0671:
            out.append("\u0627")
            i += 1
            continue
        if is_ignorable_mark(ch):
            i += 1
            continue
        if is_heh_family(cp):
            out.append("\u0647")
            i += 1
            continue
        out.append(ch)
        i += 1
    s = "".join(out)
    for a, b in [
        ("أ", "ا"),
        ("إ", "ا"),
        ("آ", "ا"),
        ("ى", "ي"),
        ("ک", "ك"),
        ("ی", "ي"),
    ]:
        s = s.replace(a, b)
    return s.strip()


def split_words(text: str) -> list[str]:
    parts = re.split(r"[\s\t\n\r\u000b\u000c]+", text)
    return [p.strip() for p in parts if p.strip() and normalize_arabic(p)]


def lexical_words(text: str, reference_text: str | None = None) -> list[str]:
    reference = reference_text if reference_text is not None else text
    canonical = [normalize_arabic(w) for w in split_words(reference) if normalize_arabic(w)]
    stream = normalize_arabic(text)
    i = 0
    out: list[str] = []
    for word in canonical:
        if stream[i : i + len(word)] == word:
            out.append(word)
            i += len(word)
        else:
            return [normalize_arabic(w) for w in split_words(text) if normalize_arabic(w)]
    if i != len(stream):
        return [normalize_arabic(w) for w in split_words(text) if normalize_arabic(w)]
    return out


def codepoint_label(ch: str) -> str:
    return f"U+{ord(ch):04X} {unicodedata.name(ch, '?')}"


def describe_unicode(raw: str) -> str:
    bases = []
    marks = []
    for ch in raw:
        cp = ord(ch)
        if is_ignorable_mark(ch) or ch.isspace():
            marks.append(codepoint_label(ch))
        elif cp in FORMAT_CONTROLS:
            marks.append(codepoint_label(ch))
        else:
            bases.append(codepoint_label(ch))
    return "bases=[" + ", ".join(bases[:12]) + ("…" if len(bases) > 12 else "") + "]"


def proper_norm_candidates(expected_norm: str, hyp_norm: str) -> dict[str, str]:
    """Heuristic 'should-be-equivalent' norms for audit (not production)."""
    c: dict[str, str] = {}

    def drop_dagger_alef_expansion(s: str) -> str:
        # Undo spurious ا from IndoPak dagger-alif before ya-family
        return s.replace("علاي", "علي").replace("ذالك", "ذلك")

    def fold_alef_hamza_in_demo(s: str) -> str:
        return s.replace("اولائك", "اولئك")

    c["drop_dagger_before_ya"] = drop_dagger_alef_expansion(expected_norm)
    c["demo_pronoun_fold"] = fold_alef_hamza_in_demo(expected_norm)
    c["both"] = fold_alef_hamza_in_demo(drop_dagger_alef_expansion(expected_norm))
    return c


def is_annotation_only(norm: str) -> bool:
    # After normalize, pause marks should be empty; ٭ might survive if not in strip set
    raw_only = norm in {"٭", "ۚ", "ۖ", "ۛ", "ۙ", "ؕ"}
    return raw_only or norm == ""


def classify_mismatch(
    op: str,
    ref: str,
    expected_norm: str,
    hyp_norm: str | None,
    expected_raw: str | None,
    hyp_raw: str | None,
    ctx: dict[str, Any],
) -> dict[str, Any]:
    row: dict[str, Any] = {
        "ref": ref,
        "op": op,
        "expected_token": expected_norm,
        "recognized_token": hyp_norm or "—",
        "expected_norm": expected_norm,
        "hyp_norm": hyp_norm or "—",
    }

    if op == "miss":
        if expected_norm == "و" and hyp_norm is None:
            # check if next hyp starts with و
            nxt = ctx.get("next_hyp_norm")
            if nxt and nxt.startswith("و") and nxt != "و":
                row["should_equivalent"] = True
                row["failure_category"] = "attached_conjunction"
                row["why_fails"] = (
                    "Expected splits standalone clitic و; ASR CTC attaches it to the "
                    f"following word ({nxt}). Spoken content present; word boundary differs."
                )
                row["smallest_fix"] = (
                    "Pre-alignment: strip leading و from hyp tokens when preceding expected "
                    "token is و (clitic split pass), or align on letterstream with optional "
                    "و-boundary — not a normalizeArabic change."
                )
                return row
        if expected_norm in {"٭", "ؕ"} or is_annotation_only(expected_norm):
            row["should_equivalent"] = True
            row["failure_category"] = "quranic_annotation"
            row["why_fails"] = (
                "IndoPak pause/ayah-end mark is a non-lexical mushaf annotation; ASR never "
                "emits it. normalizeArabic strips U+0615 in marks but ٭ (U+066D) survives "
                "as its own expected token via lexicalWords."
            )
            row["smallest_fix"] = (
                "Drop expected tokens whose normalizeArabic is empty or whose sole codepoint "
                "is in {U+066D, U+06D9, …} before alignWords; do not add fuzzy ASR rules."
            )
            return row
        if expected_norm == "و" and ctx.get("prev_hyp_norm", "").endswith("و"):
            row["should_equivalent"] = True
            row["failure_category"] = "attached_conjunction"
            row["why_fails"] = "Duplicate و miss from DP shift after prior attachment."
            row["smallest_fix"] = "Same clitic split as other و misses."
            return row

        row["should_equivalent"] = False
        row["failure_category"] = "true_miss"
        row["why_fails"] = "Hypothesis omits spoken content (ASR truncation or silence)."
        row["smallest_fix"] = "None in normalization — ASR / recitation coverage."
        return row

    if op == "extra":
        row["should_equivalent"] = False
        row["failure_category"] = "true_extra"
        row["why_fails"] = "ASR emitted word not in expected ayah."
        row["smallest_fix"] = "None in normalization."
        return row

    # sub
    assert hyp_norm is not None
    if expected_norm == hyp_norm:
        row["should_equivalent"] = True
        row["failure_category"] = "bug_should_be_match"
        row["why_fails"] = "Norms equal but aligner labeled sub (unexpected)."
        row["smallest_fix"] = "Investigate alignWords input token lists."
        return row

    # Attached و + word
    if expected_norm.startswith("عل") and hyp_norm.startswith("و") and hyp_norm[1:] == expected_norm.replace("علاي", "علي"):
        row["should_equivalent"] = True
        row["failure_category"] = "attached_conjunction"
        row["why_fails"] = (
            f"Expected token {expected_norm!r} vs hyp {hyp_norm!r}: و prefixed on ASR side; "
            "prior expected و was separate."
        )
        row["smallest_fix"] = "Clitic split pass on hyp words before align (see و miss rows)."
        return row

    if expected_norm == "اولائك" and hyp_norm == "واولئك":
        row["should_equivalent"] = True
        row["failure_category"] = "attached_conjunction"
        row["why_fails"] = "Expected و + اولائك; ASR has single token واولئك."
        row["smallest_fix"] = "Split leading و from hyp token when expected has standalone و."
        return row

    if expected_norm == "اولائك" and hyp_norm == "اولئك":
        row["should_equivalent"] = True
        row["failure_category"] = "dagger_alif_madd"
        row["why_fails"] = (
            "IndoPak اُولٰٓئِکَ expands dagger/madd to extra ا (اولائك); Imlaei "
            "أُولَئِكَ → اولئك. Same demonstrative."
        )
        row["smallest_fix"] = (
            "In normalizeArabic: do not expand U+0670 to ا when followed by hamza-bearing "
            "alef or ya-family in demonstrative pattern; OR map اولائك→اولئك as post-step "
            "(narrower: only when hyp lacks middle alef)."
        )
        return row

    if expected_norm == "علاي" and hyp_norm == "علي":
        row["should_equivalent"] = True
        row["failure_category"] = "dagger_alif_before_ya"
        row["why_fails"] = (
            "IndoPak عَلٰی (dagger alif U+0670 + Farsi yeh U+06CC) → علاي; Imlaei "
            "عَلَى (alif maqsura) → علي. Same preposition."
        )
        row["smallest_fix"] = (
            "In normalizeArabic: when U+0670 is followed by ی/ي/ى (after mark skip), "
            "drop dagger instead of mapping to ا (mirrors heh-family exception)."
        )
        return row

    if expected_norm == "ذالك" and hyp_norm == "ذلك":
        row["should_equivalent"] = True
        row["failure_category"] = "dagger_alif"
        row["why_fails"] = (
            "IndoPak ذٰلِکَ inserts dagger alif → ذالك; Imlaei ذَلِكَ has no expanded "
            "alef → ذلك."
        )
        row["smallest_fix"] = (
            "Same dagger rule: drop U+0670 before ك/ک rather than → ا, OR treat ذالك≡ذلك "
            "if letterstream after dropping dagger-only ا matches."
        )
        return row

    if expected_norm == "الذين" and hyp_norm == "والذين":
        row["should_equivalent"] = True
        row["failure_category"] = "attached_conjunction"
        row["why_fails"] = "Expected initial و separate; ASR merged وَالَّذِينَ."
        row["smallest_fix"] = "Clitic split on hyp leading و."
        return row

    if expected_norm == "ما" and hyp_norm == "وما":
        row["should_equivalent"] = True
        row["failure_category"] = "attached_conjunction"
        row["why_fails"] = "Expected و then ما; ASR وما single token."
        row["smallest_fix"] = "Clitic split on hyp leading و."
        return row

    if expected_norm == "بالااخره" and hyp_norm == "وبالاخرات":
        row["should_equivalent"] = False
        row["failure_category"] = "asr_morphology"
        row["why_fails"] = (
            "Different lemmas: expected singular آخِرَة (norm بالااخره); ASR plural "
            "الْآخِرَات (norm وبالاخرات after و attach). Not orthography."
        )
        row["smallest_fix"] = "None — genuine ASR word error; do not normalize away."
        return row

    if expected_norm == "بالااخره" and hyp_norm == "وبالاخره":
        row["should_equivalent"] = True
        row["failure_category"] = "attached_conjunction"
        row["why_fails"] = "و attached; otherwise same word after splitting و."
        row["smallest_fix"] = "Clitic split only."
        return row

    if expected_norm == "يقيمون" and hyp_norm == "ويقيمون":
        row["should_equivalent"] = True
        row["failure_category"] = "attached_conjunction"
        row["why_fails"] = "Expected standalone و before يقيمون; ASR merged."
        row["smallest_fix"] = "Clitic split on hyp."
        return row

    if expected_norm == "الصلاوه" and hyp_norm == "الصلاه":
        row["should_equivalent"] = True
        row["failure_category"] = "heh_family"
        row["why_fails"] = (
            "Both should fold to same via heh-family rule: ة/ۃ→ه. If still sub, "
            f"got {expected_norm!r} vs {hyp_norm!r} — check ta marbuta in ASR vs waw+heh in IndoPak."
        )
        row["smallest_fix"] = (
            "Verify heh fold applies to trailing ة in الصلوة; if ASR uses ه not ة, "
            "already equivalent — may be truncation shifting alignment."
        )
        return row

    # Garbled ASR
    garbled_pairs = {
        ("للمتقين", "لاستف"),
        ("للمتقين", "لتقين"),
        ("الضالين", "الاين"),
        ("ينفقون", "ومماون"),
        ("رزقنهم", "وام"),
        ("يوقنون", "يوقن"),
    }
    if (expected_norm, hyp_norm) in garbled_pairs:
        row["should_equivalent"] = False
        row["failure_category"] = "true_asr_error"
        row["why_fails"] = f"ASR garbage/truncation: {hyp_norm!r} is not orthographic variant of {expected_norm!r}."
        row["smallest_fix"] = "None in normalization."
        return row

    row["should_equivalent"] = False
    row["failure_category"] = "unclassified"
    row["why_fails"] = f"No known orthographic equivalence: {expected_norm!r} ≠ {hyp_norm!r}."
    row["smallest_fix"] = "Manual review."
    if expected_raw:
        row["expected_unicode"] = describe_unicode(expected_raw)
    if hyp_raw:
        row["hyp_unicode"] = describe_unicode(hyp_raw)
    return row


def parse_log_line(line: str) -> dict[str, Any]:
    ref_m = re.search(r"ref=(\d+:\d+)", line)
    ref = ref_m.group(1) if ref_m else "?"
    def grab(name: str) -> str | None:
        m = re.search(rf"{name}='([^']*)'", line)
        return m.group(1) if m else None
    def grab_list(name: str) -> list[str]:
        m = re.search(rf"{name}=\[(.*?)\]", line)
        if not m:
            return []
        inner = m.group(1)
        return json.loads("[" + inner.replace("'", '"') + "]")
    return {
        "ref": ref,
        "expected_raw": grab("expectedRaw"),
        "hyp_raw": grab("hypRaw"),
        "expected_norm": grab_list("expectedNorm"),
        "hyp_norm": grab_list("hypNorm"),
        "ops": grab_list("ops"),
        "acc": re.search(r"acc=([\d.]+)", line),
    }


def rows_from_case(case: dict[str, Any], source: str) -> list[dict[str, Any]]:
    ref = case["ref"]
    exp = case["expected_norm"]
    hyp = case["hyp_norm"]
    ops = case["ops"]
    rows = []
    ei = hi = 0
    for op in ops:
        ctx: dict[str, Any] = {}
        if op == "match":
            ctx["expected_raw"] = None
            ei += 1
            hi += 1
            continue
        if op == "sub":
            en, hn = exp[ei], hyp[hi]
            ctx["next_hyp_norm"] = hyp[hi + 1] if hi + 1 < len(hyp) else None
            ctx["prev_hyp_norm"] = hyp[hi - 1] if hi > 0 else ""
            r = classify_mismatch("sub", ref, en, hn, None, None, ctx)
            r["source"] = source
            r["unique_key"] = f"{ref}|sub|{en}|{hn}"
            rows.append(r)
            ei += 1
            hi += 1
        elif op == "miss":
            en = exp[ei]
            ctx["next_hyp_norm"] = hyp[hi] if hi < len(hyp) else None
            ctx["prev_hyp_norm"] = hyp[hi - 1] if hi > 0 else ""
            r = classify_mismatch("miss", ref, en, None, None, None, ctx)
            r["source"] = source
            r["unique_key"] = f"{ref}|miss|{en}|—"
            rows.append(r)
            ei += 1
        elif op == "extra":
            hn = hyp[hi]
            r = classify_mismatch("extra", ref, "—", hn, None, None, {})
            r["source"] = source
            r["unique_key"] = f"{ref}|extra|—|{hn}"
            rows.append(r)
            hi += 1
    return rows


def load_stages_json(path: Path) -> dict[str, Any]:
    data = json.loads(path.read_text())
    return {
        "ref": data.get("ref", "?"),
        "expected_raw": data.get("originalExpectedAyah") or data.get("expected"),
        "hyp_raw": data.get("originalAsrHypothesis") or data.get("hypothesis"),
        "expected_norm": data.get("normalizedExpectedWords", []),
        "hyp_norm": data.get("normalizedAsrWords", []),
        "ops": [o["op"] for o in data.get("lexicalOps", []) if o["op"] != "match"],
        "lexical_ops": data.get("lexicalOps", []),
    }


def ayah_text(corpus: dict[str, Any], surah: int, ayah: int) -> str:
    for row in corpus["ayahs"]:
        if row["surah"] == surah and row["ayah"] == ayah:
            return row["text"]
    raise KeyError(f"{surah}:{ayah}")


def verify_script_parity(ref: str, word_context: str) -> list[dict[str, str]]:
    """Load IndoPak vs Uthmani snippet for a ref and compare norms."""
    indo = json.loads((REPO / "assets/quran/text/indopak.json").read_text())
    uth = json.loads((REPO / "assets/quran/text/uthmani.json").read_text())
    s, a = map(int, ref.split(":"))
    indo_text = ayah_text(indo, s, a)
    uth_text = ayah_text(uth, s, a)
    indo_lex = lexical_words(indo_text, uth_text)
    uth_lex = lexical_words(uth_text, uth_text)
    return [
        {
            "ref": ref,
            "indo_lexical": "|".join(indo_lex),
            "uth_lexical": "|".join(uth_lex),
            "equal": indo_lex == uth_lex,
        }
    ]


def main() -> None:
    transcript = Path(
        "/Users/rabiadastgir/.cursor/projects/Users-rabiadastgir-DeenFocus/agent-transcripts/"
        "7c2b314d-a121-418d-99da-ec209be00b4a/7c2b314d-a121-418d-99da-ec209be00b4a.jsonl"
    )
    pat = re.compile(r"\[TajweedLexical\]\s*(.*)")
    log_cases = []
    seen_logs: set[str] = set()
    with transcript.open() as f:
        for line in f:
            obj = json.loads(line)
            if obj.get("role") != "user":
                continue
            for part in obj.get("message", {}).get("content", []):
                if part.get("type") != "text":
                    continue
                for m in pat.finditer(part.get("text", "")):
                    s = m.group(1).strip()
                    if s not in seen_logs:
                        seen_logs.add(s)
                        parsed = parse_log_line(s)
                        parsed["ops"] = re.findall(
                            r"ops=\[(.*?)\]", s
                        )
                        if parsed["ops"]:
                            inner = parsed["ops"][0]
                            parsed["ops"] = json.loads("[" + inner.replace("'", '"') + "]")
                        acc_m = re.search(r"acc=([\d.]+)", s)
                        parsed["acc"] = float(acc_m.group(1)) if acc_m else None
                        log_cases.append(parsed)

    # stages json — rebuild full ops including match for alignment indices
    stage_files = [
        Path("/Users/rabiadastgir/Downloads/last_stages.json"),
        Path("/Users/rabiadastgir/Downloads/last_stages 2.json"),
    ]
    all_rows: list[dict[str, Any]] = []
    for i, lc in enumerate(log_cases):
        all_rows.extend(rows_from_case(lc, f"log:{lc['ref']}:{i}"))

    for sf in stage_files:
        if not sf.exists():
            continue
        data = json.loads(sf.read_text())
        case = {
            "ref": data["ref"],
            "expected_norm": data["normalizedExpectedWords"],
            "hyp_norm": data["normalizedAsrWords"],
            "ops": [o["op"] for o in data["lexicalOps"]],
        }
        all_rows.extend(rows_from_case(case, sf.name))

    # dedupe by unique_key keeping first
    dedup: dict[str, dict[str, Any]] = {}
    for r in all_rows:
        if r["op"] in ("match",):
            continue
        k = r.get("unique_key", "")
        if k not in dedup:
            dedup[k] = r

    false_rows = [r for r in dedup.values() if r.get("should_equivalent")]
    true_rows = [r for r in dedup.values() if not r.get("should_equivalent")]

    out_dir = REPO / "tajweed-lab/experiments/diy_coreml_poc/reports/lexical_audit"
    out_dir.mkdir(parents=True, exist_ok=True)

    report_path = out_dir / "false_mismatch_report.md"
    lines = [
        "# Lexical false-mismatch audit — 2026-07-31",
        "",
        "Analysis only; no code changes.",
        "",
        f"Unique mismatch ops collected: **{len(dedup)}** ({len(false_rows)} false / "
        f"{len(true_rows)} true).",
        "",
        "## Summary by failure category",
        "",
    ]
    from collections import Counter

    cat_counts = Counter(r["failure_category"] for r in dedup.values())
    for cat, n in cat_counts.most_common():
        lines.append(f"- **{cat}**: {n}")

    lines.extend(["", "## Full mismatch table", ""])
    lines.append(
        "| Ref | Op | Expected token | Recognized token | Expected norm | Hyp norm | "
        "Equivalent? | Why fails today | Smallest fix |"
    )
    lines.append("|---|---|---|---|---|---|---|---|---|")
    for r in sorted(dedup.values(), key=lambda x: (x["ref"], x["op"], x["expected_token"])):
        eq = "YES" if r.get("should_equivalent") else "no"
        lines.append(
            f"| {r['ref']} | {r['op']} | {r['expected_token']} | {r['recognized_token']} | "
            f"{r['expected_norm']} | {r['hyp_norm']} | {eq} | {r['why_fails']} | {r['smallest_fix']} |"
        )

    lines.extend(["", "## False mismatches only", ""])
    for r in false_rows:
        lines.append(
            f"- **{r['ref']}** {r['op']} `{r['expected_token']}` vs `{r['recognized_token']}` "
            f"({r['failure_category']}): {r['smallest_fix']}"
        )

    lines.extend(["", "## IndoPak vs Uthmani lexicalWords parity (sample refs)", ""])
    for ref in sorted({r["ref"] for r in dedup.values()}):
        v = verify_script_parity(ref, "")
        lines.append(f"- {ref}: equal={v[0]['equal']}")

    # Spot-check problematic glyphs
    lines.extend(["", "## Glyph normalization spot-checks", ""])
    samples = [
        ("IndoPak علٰی", "عَلٰی"),
        ("Imlaei على", "عَلَى"),
        ("IndoPak ذٰلِکَ", "ذٰلِکَ"),
        ("Imlaei ذلك", "ذَلِكَ"),
        ("IndoPak اولٰٓئک", "اُولٰٓئِکَ"),
        ("Imlaei اولئك", "أُولَئِكَ"),
        ("Pause ٭", "٭"),
        ("Ayah end ؕ", "ؕ"),
        ("IndoPak للّٰہ", "لِلّٰہِ"),
        ("Uthmani لله", "لِلَّهِ"),
        ("IndoPak الصلوة", "الصَّلٰوۃَ"),
        ("Imlaei الصلاة", "الصَّلَاةَ"),
        ("2:4 آخرة", "الْآخِرَةِ"),
        ("2:4 آخرات", "الْآخِرَاتِ"),
    ]
    lines.append("| Label | Raw | normalizeArabic |")
    lines.append("|---|---|---|")
    for label, raw in samples:
        lines.append(f"| {label} | `{raw}` | `{normalize_arabic(raw)}` |")

    report_path.write_text("\n".join(lines))
    json_path = out_dir / "mismatch_rows.json"
    json_path.write_text(json.dumps(list(dedup.values()), ensure_ascii=False, indent=2))

    print(f"Wrote {report_path}")
    print(f"Wrote {json_path}")
    print(f"Total unique mismatches: {len(dedup)}, false: {len(false_rows)}, true: {len(true_rows)}")


if __name__ == "__main__":
    main()
