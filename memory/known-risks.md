# Known Risks
> Standing production/business risks the assistant must account for when
> changing code in these areas.
> Status: Open / Partially mitigated / Mitigated.

## RISK-001 — NPL-1.0 license blocks monetizing the tajweed feature
**Area:** `tajweed-lab` model + any DeenFocus feature built on it
**Severity:** High (business/legal)
**Status:** Open
**Description:** `Muno459/fastconformer-quran` and its CoreML siblings are
licensed under the Quran-Lab No-Profit License v1.0: no profit from the model
or a derivative, local use must be free, hosted use is cost-recovery only,
share-alike + attribution required. DeenFocus uses Superwall / IAP elsewhere.
**Mitigation in place:** Tajweed work is confined to `tajweed-lab/` (research)
and, per plan, positioned as a free on-device feature — never behind a paywall.
**Remaining risk:** Must not ship this feature behind any paid plan without a
resolution. See `tajweed-lab/decisions/ADR-005-license-npl.md`.

## RISK-002 — Hugging Face token was exposed in an assistant chat
**Area:** `tajweed-lab` credentials
**Severity:** Medium
**Status:** Open (until a human confirms rotation)
**Description:** An `HF_TOKEN` value was pasted directly into an assistant
conversation during initial setup. It was only ever written to the gitignored
`tajweed-lab/.env` (never staged or committed), but chat transcripts are not a
secure secret store.
**Mitigation in place:** `.env` confirmed gitignored; verified via
`git check-ignore` that it was never staged.
**Remaining risk:** The token itself has not been confirmed rotated. Treat it
as compromised until a human rotates it at
https://huggingface.co/settings/tokens.

## RISK-003 — Model is Hafs-only
**Area:** Any tajweed/ASR feature surfaced to users
**Severity:** Medium
**Status:** Partially mitigated
**Description:** FastConformer-Quran is trained on Hafs ‘an Asim recitation
only. Feeding non-Hafs or non-Quranic Arabic audio produces unreliable
transcripts and pronunciation scores, silently.
**Mitigation in place:** Documented in `tajweed-lab/docs/MODEL.md`; a UX
caption is planned in the iOS integration plan.
**Remaining risk:** No runtime guard exists against non-Hafs input yet —
relies entirely on UX copy.

## RISK-004 — iOS cannot export Screen Time totals into Digital Balance
**Area:** Digital Balance / `IosAppUsageBridge`
**Severity:** Medium (product)
**Status:** Open
**Description:** Family Controls authorization works, but the iPhoneOS 26.2
SDK has no host-app API for per-app durations. `DeviceActivityReport` is
sandboxed. `FamilyActivityData` / `approvedWithDataAccess` are iOS 26.4+
and EU-only for customer installs. Adding
`com.apple.developer.family-controls.app-and-website-usage` now would be
an invalid entitlement on this SDK/profile.
**Mitigation in place:** iOS returns `unsupported` (no fake numbers). Android
UsageStats is unchanged.
**Remaining risk:** Digital Balance on iPhone stays empty until Apple ships
a usable data-access API in a later SDK *and* (for App Store) the user is
in the EU, or Apple expands region support.
