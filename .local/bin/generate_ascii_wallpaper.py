#!/usr/bin/env python3

import math
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


WIDTH = 1920
HEIGHT = 1080
FPS = 25
DURATION = 20
FRAMES = FPS * DURATION
COLS = 96
ROWS = 40
CELL_W = WIDTH // COLS
CELL_H = HEIGHT // ROWS
FONT_PATH = "/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf"
FONT = ImageFont.truetype(FONT_PATH, 28)

BG = "#1e1e2e"
PALETTE = [
    "#6c7086",  # overlay0
    "#a6adc8",  # subtext0
    "#bac2de",  # subtext1
    "#cba6f7",  # mauve
    "#f5c2e7",  # pink
    "#f2cdcd",  # flamingo
    "#fab387",  # peach
    "#f9e2af",  # yellow
]
PINK_PALETTE = [
    "#6c7086",  # overlay0
    "#9399b2",  # overlay2
    "#bac2de",  # subtext1
    "#f2cdcd",  # flamingo
    "#f5c2e7",  # pink
    "#f5bde6",  # rosewater-ish lift
    "#f5e0dc",  # rosewater
]

SPIRAL_CHARS = " .,:;ox%#@"
DESIGN_CHARS = " .:+*oO0#@"
FALLING_CHARS = ".:|/"


def lerp(a: float, b: float, t: float) -> float:
    return a + (b - a) * t


def mix_hex(c1: str, c2: str, t: float) -> str:
    a = tuple(int(c1[i : i + 2], 16) for i in (1, 3, 5))
    b = tuple(int(c2[i : i + 2], 16) for i in (1, 3, 5))
    rgb = tuple(round(lerp(x, y, t)) for x, y in zip(a, b))
    return "#%02x%02x%02x" % rgb


def cell_center(col: int, row: int) -> tuple[float, float]:
    x = col * CELL_W + CELL_W / 2
    y = row * CELL_H + CELL_H / 2
    return x, y


def render_spiral(frame_idx: int) -> Image.Image:
    img = Image.new("RGB", (WIDTH, HEIGHT), BG)
    draw = ImageDraw.Draw(img)
    t = frame_idx / FPS
    cx = WIDTH / 2
    cy = HEIGHT / 2
    twist = t * 1.4

    for row in range(ROWS):
        for col in range(COLS):
            x, y = cell_center(col, row)
            nx = (x - cx) / HEIGHT
            ny = (y - cy) / HEIGHT
            radius = math.hypot(nx, ny)
            angle = math.atan2(ny, nx)

            wave = math.sin(18 * radius - 4.2 * angle - twist * 6.0)
            ripple = math.cos(28 * radius + twist * 4.0)
            value = 0.5 + 0.3 * wave + 0.2 * ripple
            value = max(0.0, min(1.0, value))

            char_idx = min(len(SPIRAL_CHARS) - 1, int(value * len(SPIRAL_CHARS)))
            char = SPIRAL_CHARS[char_idx]
            if char == " ":
                continue

            color_band = int((value * (len(PALETTE) - 1)))
            color = PALETTE[color_band]
            if radius < 0.12:
                color = mix_hex("#f5e0dc", color, 0.4)
            draw.text((col * CELL_W, row * CELL_H - 2), char, font=FONT, fill=color)

    return img


def render_design(frame_idx: int) -> Image.Image:
    img = Image.new("RGB", (WIDTH, HEIGHT), BG)
    draw = ImageDraw.Draw(img)
    t = frame_idx / FPS
    cx = WIDTH / 2
    cy = HEIGHT / 2

    for row in range(ROWS):
        for col in range(COLS):
            x, y = cell_center(col, row)
            nx = (x - cx) / WIDTH
            ny = (y - cy) / HEIGHT

            wave_a = math.sin((nx * 14.0 + t * 0.7) * math.pi)
            wave_b = math.cos((ny * 10.0 - t * 0.9) * math.pi)
            swirl = math.sin((math.hypot(nx, ny) * 22.0 - t * 3.5) * math.pi)
            lattice = math.sin((nx + ny + t * 0.3) * math.pi * 12.0)
            value = 0.5 + 0.18 * wave_a + 0.18 * wave_b + 0.18 * swirl + 0.14 * lattice
            value = max(0.0, min(1.0, value))

            char_idx = min(len(DESIGN_CHARS) - 1, int(value * len(DESIGN_CHARS)))
            char = DESIGN_CHARS[char_idx]
            if char == " ":
                continue

            band = min(len(PALETTE) - 1, int(value * len(PALETTE)))
            color = PALETTE[band]
            if (row + col) % 7 == 0:
                color = mix_hex(color, "#cdd6f4", 0.35)

            draw.text((col * CELL_W, row * CELL_H - 2), char, font=FONT, fill=color)

    return img


def render_falling(frame_idx: int) -> Image.Image:
    img = Image.new("RGB", (WIDTH, HEIGHT), BG)
    draw = ImageDraw.Draw(img)
    cycle = frame_idx / FRAMES
    cycle_angle = cycle * math.tau
    center_x = (COLS - 1) / 2

    for row in range(ROWS):
        for col in range(COLS):
            haze = 0.5 + 0.5 * math.sin(col * 0.11 + row * 0.19 + cycle_angle * 0.18)
            shimmer = 0.5 + 0.5 * math.cos(col * 0.07 - row * 0.13 + cycle_angle * 0.11)
            if haze * shimmer < 0.972:
                continue
            color = mix_hex(BG, "#6c7086", 0.12 + 0.08 * haze)
            draw.text((col * CELL_W, row * CELL_H - 2), ".", font=FONT, fill=color)

    for row in range(ROWS):
        for col in range(COLS):
            nx = (col - center_x) / COLS
            ribbon_a = row - (ROWS * 0.36 + math.sin(nx * 10.5 + cycle_angle * 0.26) * 3.8)
            ribbon_b = row - (ROWS * 0.62 + math.sin(nx * 8.2 - cycle_angle * 0.19 + 1.2) * 3.1)
            ribbon_strength = 0.0
            for ribbon in (ribbon_a, ribbon_b):
                closeness = max(0.0, 1.0 - abs(ribbon) / 1.45)
                ribbon_strength = max(ribbon_strength, closeness)

            if ribbon_strength < 0.58:
                continue

            pulse = 0.72 + 0.28 * math.sin(cycle_angle * 0.9 + col * 0.1 + row * 0.08)
            intensity = ribbon_strength * pulse
            band = min(len(PINK_PALETTE) - 1, int(intensity * (len(PINK_PALETTE) - 1)))
            color = mix_hex(PINK_PALETTE[band], "#f5e0dc", 0.14 * intensity)
            char = ":" if ribbon_strength > 0.82 else "."
            if (row + col) % 11 == 0 and ribbon_strength > 0.72:
                char = "*"
            draw.text((col * CELL_W, row * CELL_H - 2), char, font=FONT, fill=color)

    for lane in range(COLS):
        lane_seed = lane * 0.41
        base_x = lane * CELL_W
        side_drift = 0.24 * math.sin(cycle_angle * 0.27 + lane_seed)
        side_drift += 0.09 * math.sin(cycle_angle * 0.73 + lane_seed * 1.7)
        x_offset = int(side_drift * CELL_W * 0.45)
        lane_brightness = 0.72 + 0.28 * math.sin(lane_seed * 2.0 + cycle_angle * 0.16)

        if lane % 5 not in (0, 3):
            continue

        for row in range(ROWS):
            primary = 0.5 + 0.5 * math.sin(row * 0.72 - cycle_angle * (1.25 + 0.05 * (lane % 7)) + lane_seed * 1.8)
            secondary = 0.5 + 0.5 * math.sin(row * 1.18 - cycle_angle * (0.66 + 0.03 * (lane % 5)) + lane_seed * 0.9)
            veil = 0.5 + 0.5 * math.cos(row * 0.33 + cycle_angle * 0.41 + lane_seed * 1.4)
            intensity = primary * 0.58 + secondary * 0.27 + veil * 0.15
            intensity *= lane_brightness
            intensity = max(0.0, min(1.0, intensity))

            if intensity < 0.72:
                continue

            color_idx = min(len(PINK_PALETTE) - 1, int(intensity * (len(PINK_PALETTE) - 1)))
            color = PINK_PALETTE[color_idx]
            if intensity > 0.94:
                char = ":"
                color = mix_hex("#f5e0dc", color, 0.32)
            elif intensity > 0.86:
                char = "|"
            elif intensity > 0.79:
                char = "/"
            else:
                char = "."

            draw.text((base_x + x_offset, row * CELL_H - 2), char, font=FONT, fill=color)

    for star_idx in range(14):
        sx = (17 * star_idx + 11) % COLS
        sy = (7 * star_idx + 5) % ROWS
        twinkle = 0.5 + 0.5 * math.sin(cycle_angle * (0.8 + star_idx * 0.03) + star_idx * 1.7)
        if twinkle < 0.56:
            continue
        color = mix_hex("#f5c2e7", "#f5e0dc", twinkle * 0.45)
        char = "*" if twinkle > 0.82 else "+"
        draw.text((sx * CELL_W, sy * CELL_H - 2), char, font=FONT, fill=color)

    return img


def main() -> int:
    if len(sys.argv) != 3:
        print("usage: generate_ascii_wallpaper.py <spiral|design|falling> <output_dir>", file=sys.stderr)
        return 1

    mode = sys.argv[1]
    out_dir = Path(sys.argv[2])
    out_dir.mkdir(parents=True, exist_ok=True)

    render = {
        "spiral": render_spiral,
        "design": render_design,
        "falling": render_falling,
    }.get(mode)

    if render is None:
        print(f"unknown mode: {mode}", file=sys.stderr)
        return 1

    for frame_idx in range(FRAMES):
        img = render(frame_idx)
        img.save(out_dir / f"frame-{frame_idx:04d}.png")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
