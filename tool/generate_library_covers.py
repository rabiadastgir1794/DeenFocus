#!/usr/bin/env python3
"""Generate flat minimal WebP cover art for Islamic Library hub + Dua categories."""

from __future__ import annotations

import math
from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "assets" / "islamic_library" / "covers"
W, H = 320, 180

# DeenFocus greens + soft accents
BG_TOP = (78, 154, 124)       # #4E9A7C
BG_BOTTOM = (46, 107, 82)
ACCENT = (200, 230, 210)
ACCENT_SOFT = (142, 196, 168)
WHITE = (255, 255, 255, 230)
WHITE_SOFT = (255, 255, 255, 140)


def lerp(a: int, b: int, t: float) -> int:
    return int(a + (b - a) * t)


def gradient_bg() -> Image.Image:
    img = Image.new("RGBA", (W, H))
    px = img.load()
    for y in range(H):
        t = y / max(H - 1, 1)
        r = lerp(BG_TOP[0], BG_BOTTOM[0], t)
        g = lerp(BG_TOP[1], BG_BOTTOM[1], t)
        b = lerp(BG_TOP[2], BG_BOTTOM[2], t)
        for x in range(W):
            px[x, y] = (r, g, b, 255)
    return img


def save(name: str, img: Image.Image) -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    path = OUT / f"{name}.webp"
    rgb = Image.new("RGB", img.size, (247, 245, 240))
    rgb.paste(img, mask=img.split()[3] if img.mode == "RGBA" else None)
    rgb.save(path, "WEBP", quality=82, method=6)
    kb = path.stat().st_size / 1024
    print(f"  {path.name}: {kb:.1f} KB")


def base() -> tuple[Image.Image, ImageDraw.ImageDraw]:
    img = gradient_bg()
    d = ImageDraw.Draw(img)
    # subtle geometric pattern
    for i in range(-2, 6):
        d.arc(
            (W // 2 - 140 + i * 18, -40, W // 2 + 140 + i * 18, H + 40),
            200,
            340,
            fill=(*ACCENT_SOFT, 35),
            width=2,
        )
    return img, d


def circle(d: ImageDraw.ImageDraw, cx: float, cy: float, r: float, fill) -> None:
    d.ellipse((cx - r, cy - r, cx + r, cy + r), fill=fill)


def rect(d: ImageDraw.ImageDraw, xy, fill, radius: int = 12) -> None:
    d.rounded_rectangle(xy, radius=radius, fill=fill)


def book(d: ImageDraw.ImageDraw) -> None:
    cx, cy = W // 2, H // 2 + 4
    rect(d, (cx - 58, cy - 38, cx + 58, cy + 38), WHITE, 10)
    rect(d, (cx - 48, cy - 28, cx - 4, cy + 28), (*ACCENT, 200), 8)
    rect(d, (cx + 4, cy - 28, cx + 48, cy + 28), (*ACCENT_SOFT, 180), 8)
    d.line((cx, cy - 28, cx, cy + 28), fill=(*BG_BOTTOM, 180), width=3)


def scroll(d: ImageDraw.ImageDraw) -> None:
    cx, cy = W // 2, H // 2
    rect(d, (cx - 52, cy - 30, cx + 52, cy + 30), WHITE, 14)
    for y in range(cy - 18, cy + 20, 10):
        d.line((cx - 34, y, cx + 34, y), fill=(*ACCENT_SOFT, 160), width=3)


def hands(d: ImageDraw.ImageDraw) -> None:
    cx, cy = W // 2, H // 2 + 8
    circle(d, cx, cy - 8, 28, (255, 255, 255, 200))
    for i, dx in enumerate([-18, 0, 18]):
        circle(d, cx + dx, cy + 18, 10, (*ACCENT, 220 if i == 1 else 180))


def prayer_mat(d: ImageDraw.ImageDraw) -> None:
    cx, cy = W // 2, H // 2 + 12
    d.polygon(
        [(cx, cy - 42), (cx + 46, cy + 28), (cx - 46, cy + 28)],
        fill=WHITE,
    )
    d.polygon(
        [(cx, cy - 28), (cx + 28, cy + 14), (cx - 28, cy + 14)],
        fill=(*ACCENT, 190),
    )


def scales(d: ImageDraw.ImageDraw) -> None:
    cx, cy = W // 2, H // 2
    d.line((cx, cy - 36, cx, cy + 34), fill=WHITE, width=5)
    d.line((cx - 56, cy - 18, cx + 56, cy - 18), fill=WHITE, width=5)
    circle(d, cx - 56, cy + 4, 16, (*ACCENT, 210))
    circle(d, cx + 56, cy + 4, 16, (*ACCENT_SOFT, 210))


def star_field(d: ImageDraw.ImageDraw) -> None:
    cx, cy = W // 2, H // 2
    circle(d, cx, cy, 34, WHITE)
    for angle in range(0, 360, 45):
        rad = math.radians(angle)
        x = cx + math.cos(rad) * 48
        y = cy + math.sin(rad) * 48
        circle(d, x, y, 6, (*ACCENT, 220))


def pillars(d: ImageDraw.ImageDraw, count: int) -> None:
    base_y = H // 2 + 36
    gap = 88 / max(count, 1)
    start = W // 2 - gap * (count - 1) / 2
    for i in range(count):
        x = start + i * gap
        rect(d, (x - 8, base_y - 56, x + 8, base_y), (255, 255, 255, 210), 6)
        d.polygon(
            [(x - 12, base_y - 56), (x + 12, base_y - 56), (x, base_y - 68)],
            fill=(*ACCENT, 200),
        )


def mosque(d: ImageDraw.ImageDraw) -> None:
    cx, cy = W // 2, H // 2 + 10
    rect(d, (cx - 44, cy - 10, cx + 44, cy + 34), WHITE, 8)
    d.polygon(
        [(cx - 52, cy - 10), (cx + 52, cy - 10), (cx, cy - 44)],
        fill=(*ACCENT, 210),
    )
    circle(d, cx, cy - 52, 8, WHITE)


def crescent(d: ImageDraw.ImageDraw) -> None:
    cx, cy = W // 2, H // 2
    circle(d, cx, cy, 36, WHITE)
    circle(d, cx + 14, cy - 6, 30, (*BG_TOP, 255))


def sun(d: ImageDraw.ImageDraw, rising: bool) -> None:
    cy = H // 2 + (18 if rising else -8)
    circle(d, W // 2, cy, 26, WHITE)
    for angle in range(0, 360, 45):
        rad = math.radians(angle)
        x1 = W // 2 + math.cos(rad) * 34
        y1 = cy + math.sin(rad) * 34
        x2 = W // 2 + math.cos(rad) * 44
        y2 = cy + math.sin(rad) * 44
        d.line((x1, y1, x2, y2), fill=(*ACCENT, 200), width=3)
    if rising:
        d.arc((40, H - 70, W - 40, H + 30), 190, 350, fill=WHITE, width=4)
    else:
        d.arc((40, -20, W - 40, 80), 10, 170, fill=WHITE, width=4)


def home_icon(d: ImageDraw.ImageDraw) -> None:
    cx, cy = W // 2, H // 2 + 8
    d.polygon([(cx, cy - 40), (cx + 46, cy + 6), (cx - 46, cy + 6)], fill=WHITE)
    rect(d, (cx - 28, cy + 2, cx + 28, cy + 40), (*ACCENT, 210), 6)


def moon_stars(d: ImageDraw.ImageDraw) -> None:
    crescent(d)
    circle(d, W // 2 + 56, H // 2 - 28, 4, WHITE)
    circle(d, W // 2 + 68, H // 2 - 12, 3, (*ACCENT, 220))


def bowl(d: ImageDraw.ImageDraw) -> None:
    cx, cy = W // 2, H // 2 + 10
    d.pieslice((cx - 40, cy - 20, cx + 40, cy + 36), 190, 350, fill=WHITE)
    d.line((cx - 40, cy + 8, cx + 40, cy + 8), fill=(*ACCENT, 220), width=4)


def path_icon(d: ImageDraw.ImageDraw) -> None:
    d.arc((W // 2 - 70, H // 2 - 10, W // 2 + 70, H // 2 + 70), 200, 340, fill=WHITE, width=8)
    circle(d, W // 2 + 48, H // 2 + 18, 10, (*ACCENT, 230))


def shield(d: ImageDraw.ImageDraw) -> None:
    cx, cy = W // 2, H // 2 + 6
    d.polygon(
        [(cx, cy - 40), (cx + 34, cy - 18), (cx + 34, cy + 18), (cx, cy + 42), (cx - 34, cy + 18), (cx - 34, cy - 18)],
        fill=WHITE,
    )


def wave(d: ImageDraw.ImageDraw) -> None:
    for i, y in enumerate([H // 2 - 6, H // 2 + 10, H // 2 + 26]):
        d.arc((60 + i * 10, y - 20, W - 60 - i * 10, y + 20), 0, 180, fill=WHITE if i == 1 else (*ACCENT, 200), width=5)


def figures(d: ImageDraw.ImageDraw) -> None:
    for dx in (-22, 22):
        cx = W // 2 + dx
        circle(d, cx, H // 2 - 10, 12, WHITE)
        rect(d, (cx - 14, H // 2 + 4, cx + 14, H // 2 + 38), (*ACCENT, 210), 8)


def heart(d: ImageDraw.ImageDraw) -> None:
    cx, cy = W // 2, H // 2 + 4
    circle(d, cx - 14, cy - 10, 16, WHITE)
    circle(d, cx + 14, cy - 10, 16, WHITE)
    d.polygon([(cx - 30, cy - 4), (cx + 30, cy - 4), (cx, cy + 34)], fill=WHITE)


MODULES = {
    "quran": book,
    "hadith": scroll,
    "duas_adhkar": hands,
    "prayer_methods": prayer_mat,
    "fiqh_differences": scales,
    "names_of_allah": star_field,
    "pillars_of_islam": lambda d: pillars(d, 5),
    "pillars_of_iman": lambda d: pillars(d, 6),
    "prophets": mosque,
    "islamic_occasions": crescent,
}

DUAS = {
    "morning": lambda d: sun(d, True),
    "evening": lambda d: sun(d, False),
    "daily_life": home_icon,
    "sleep": moon_stars,
    "food": bowl,
    "travel": path_icon,
    "illness": heart,
    "protection": shield,
    "forgiveness": wave,
    "parents": figures,
}


def main() -> None:
    print("Generating module covers…")
    for name, draw_fn in MODULES.items():
        img, d = base()
        draw_fn(d)
        save(f"module_{name}", img)

    print("Generating dua category covers…")
    for name, draw_fn in DUAS.items():
        img, d = base()
        draw_fn(d)
        save(f"dua_{name}", img)

    total = sum(p.stat().st_size for p in OUT.glob("*.webp")) / 1024
    print(f"Done — {len(list(OUT.glob('*.webp')))} files, {total:.0f} KB total")


if __name__ == "__main__":
    main()
