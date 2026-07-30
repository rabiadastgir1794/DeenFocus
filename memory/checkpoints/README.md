# Checkpoints

Optional point-in-time snapshots for big migrations (e.g. before a large
refactor, a risky model/version upgrade, or a CoreML contract change that
must remain reproducible). Not used yet — empty until a migration needs one.

When you do add one, name it `YYYY-MM-DD-<slug>.md` and record: what state
the repo/model was in, why the checkpoint was taken, and how to verify
against it later.
