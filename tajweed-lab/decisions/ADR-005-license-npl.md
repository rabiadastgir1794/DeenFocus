# ADR-005: NPL-1.0 license risk for a monetized app

## Status

Open — needs product/legal decision before App Store shipping

## Context

`fastconformer-quran` and CoreML siblings use **Quran-Lab No-Profit License (NPL-1.0)**:

- No profit from the model or derivatives
- Local use must cost users nothing
- Hosted services: cost recovery only
- Share-alike + attribution

DeenFocus currently uses Superwall / IAP.

## Decision (interim)

Proceed with **lab evaluation and local prototyping** only. Do **not** gate the tajweed feature behind paid plans, and do **not** ship commercially, until one of:

1. Written permission / commercial license from Quran-Lab / Muno459, or  
2. Product decision to ship the feature free (and compliant) with attribution, or  
3. Replacement model under a compatible license.

## Consequences

- Feature F7.3 (premium gating) is blocked.
- Engineering can continue safely in the lab.
- Attribution must be planned regardless.
