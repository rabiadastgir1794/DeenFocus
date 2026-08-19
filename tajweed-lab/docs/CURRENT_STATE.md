# Current state

Last updated: 2026-07-24

## Snapshot

| Area | State |
| --- | --- |
| Workspace `tajweed-lab/` | ✅ Ready |
| Docs + ADRs | ✅ Ready |
| HF gated access | ✅ Token in gitignored `.env` |
| Slim model kit (`web-asr`) | ✅ Downloaded (~458 MB ONNX + head + tajweed + demos) |
| Python venv | ✅ `.venv` with ONNX Runtime stack |
| Offline ASR smoke test | ✅ Demo wav → `مَالِكِ يَوْمِ الدِّينِ` |
| Web UI | ✅ FastAPI at http://127.0.0.1:8765 |
| Mispronunciation / rules UI | ⏳ Not wired yet (sources in `vendor/tajweed/`) |
| Flutter / CoreML integration | ⏳ Not started |
| License vs monetization | ⚠️ Open — see ADR-005 |

## Working now

```bash
cd tajweed-lab
source .venv/bin/activate
uvicorn web.app:app --reload --host 127.0.0.1 --port 8765
# open http://127.0.0.1:8765
```

- Demo / upload / mic → local CTC transcription
- Artifacts under `models/`, `samples/`, `vendor/tajweed/` (gitignored)

## Risks

1. **NPL-1.0** forbids using the model in support of any revenue-generating product — resolve before App Store shipping.
2. **Rotate the HF token** that was pasted in chat.
3. Mic upload may be `webm`; if decode fails, convert to wav or prefer demo/upload for now.

## Next

1. Wire `vendor/tajweed` full scorer + reference ayah comparison in the web UI  
2. Pull/evaluate upstream CoreML offline package  
3. Product decision on license / free feature posture  
