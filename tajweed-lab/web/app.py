"""FastAPI app — local offline tester for FastConformer-Quran."""

from __future__ import annotations

import sys
from pathlib import Path

from dotenv import load_dotenv
from fastapi import FastAPI, File, Form, HTTPException, UploadFile
from fastapi.responses import FileResponse
from fastapi.staticfiles import StaticFiles

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
load_dotenv(ROOT / ".env")

from web.asr.session import ENGINE  # noqa: E402
from web.quran_data import (  # noqa: E402
    compare_texts,
    get_ayah,
    list_ayahs,
    list_surahs,
)

STATIC = Path(__file__).resolve().parent / "static"
SAMPLES = ROOT / "samples"

app = FastAPI(title="DeenFocus Tajweed Lab", version="0.2.0")
app.mount("/static", StaticFiles(directory=STATIC), name="static")


@app.get("/")
def index() -> FileResponse:
    return FileResponse(STATIC / "index.html")


@app.get("/api/health")
def health() -> dict:
    ready = ENGINE.ready
    onnx = None
    if ready:
        try:
            onnx = str(ENGINE.onnx_path or ENGINE._resolve_onnx())
        except FileNotFoundError:
            ready = False
    return {
        "ok": True,
        "model_ready": ready,
        "onnx": onnx,
        "samples": sorted(p.name for p in SAMPLES.glob("*.wav")),
        "surah_count": len(list_surahs()),
    }


@app.get("/api/surahs")
def api_surahs() -> dict:
    return {"surahs": list_surahs()}


@app.get("/api/surahs/{surah}/ayahs")
def api_ayahs(surah: int) -> dict:
    ayahs = list_ayahs(surah)
    if not ayahs:
        raise HTTPException(404, f"Surah {surah} not found")
    return {"surah": surah, "ayahs": ayahs}


@app.get("/api/ayah/{surah}/{ayah}")
def api_ayah(surah: int, ayah: int) -> dict:
    row = get_ayah(surah, ayah)
    if not row:
        raise HTTPException(404, f"Ayah {surah}:{ayah} not found")
    return row


@app.get("/api/samples")
def list_samples() -> dict:
    return {
        "samples": [
            {"id": p.name, "url": f"/api/samples/{p.name}"}
            for p in sorted(SAMPLES.glob("*.wav"))
        ]
    }


@app.get("/api/samples/{name}")
def get_sample(name: str) -> FileResponse:
    path = SAMPLES / name
    if not path.exists() or path.suffix.lower() != ".wav":
        raise HTTPException(404, "sample not found")
    return FileResponse(path, media_type="audio/wav")


def _practice_payload(
    *,
    text: str,
    duration: float,
    filename: str | None,
    surah: int | None,
    ayah: int | None,
) -> dict:
    payload: dict = {
        "text": text,
        "duration_sec": round(duration, 3),
        "filename": filename,
    }
    if surah is not None and ayah is not None:
        expected = get_ayah(surah, ayah)
        if not expected:
            raise HTTPException(404, f"Ayah {surah}:{ayah} not found")
        payload["expected"] = expected
        payload["comparison"] = compare_texts(expected["arabic"], text)
    return payload


@app.post("/api/practice")
async def practice(
    file: UploadFile = File(...),
    surah: int = Form(...),
    ayah: int = Form(...),
) -> dict:
    if not ENGINE.ready:
        raise HTTPException(
            503,
            "Model not downloaded. Run ./scripts/download_model.py --profile web-asr",
        )
    data = await file.read()
    if not data:
        raise HTTPException(400, "empty audio")
    try:
        text, duration = ENGINE.transcribe_bytes(data, filename=file.filename)
    except Exception as exc:  # noqa: BLE001
        raise HTTPException(500, f"transcription failed: {exc}") from exc
    return _practice_payload(
        text=text,
        duration=duration,
        filename=file.filename,
        surah=surah,
        ayah=ayah,
    )


@app.post("/api/transcribe")
async def transcribe(
    file: UploadFile = File(...),
    surah: int | None = Form(None),
    ayah: int | None = Form(None),
) -> dict:
    if not ENGINE.ready:
        raise HTTPException(
            503,
            "Model not downloaded. Run ./scripts/download_model.py --profile web-asr",
        )
    data = await file.read()
    if not data:
        raise HTTPException(400, "empty audio")
    try:
        text, duration = ENGINE.transcribe_bytes(data, filename=file.filename)
    except Exception as exc:  # noqa: BLE001
        raise HTTPException(500, f"transcription failed: {exc}") from exc
    return _practice_payload(
        text=text,
        duration=duration,
        filename=file.filename,
        surah=surah,
        ayah=ayah,
    )


@app.post("/api/transcribe/sample/{name}")
def transcribe_sample(
    name: str,
    surah: int | None = None,
    ayah: int | None = None,
) -> dict:
    if not ENGINE.ready:
        raise HTTPException(503, "Model not downloaded")
    path = SAMPLES / name
    if not path.exists():
        raise HTTPException(404, "sample not found")
    text, duration = ENGINE.transcribe_path(path)
    return _practice_payload(
        text=text,
        duration=duration,
        filename=name,
        surah=surah,
        ayah=ayah,
    )
