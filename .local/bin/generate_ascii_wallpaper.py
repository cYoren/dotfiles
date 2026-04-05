#!/usr/bin/env python3

import math
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


WIDTH = 1920
HEIGHT = 1080
FPS = 24
DURATION = 8
FRAMES = FPS * DURATION
COLS = 96
ROWS = 36
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
FALLING_CHARS = ".oO0@"


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

    for col in range(COLS):
        base_x = col * CELL_W
        column_seed = col * 0.173
        lane_count = 2 + (col % 3)

        for lane in range(lane_count):
            lane_seed = lane * 1.913 + column_seed
            travel_loops = 1 + ((col + lane) % 4)
            trail_len = 6 + ((col * 3 + lane * 5) % 10)
            phase = (0.19 * col + 0.31 * lane) % 1.0
            head = (((cycle * travel_loops) + phase) % 1.0) * (ROWS + trail_len + 8) - trail_len

            drift_wave = math.sin(cycle_angle + lane_seed)
            drift_wave += 0.55 * math.sin(cycle_angle * 2.0 + lane_seed * 1.7)
            drift_wave += 0.25 * math.cos(cycle_angle * 3.0 - lane_seed * 0.9)
            x_offset = int(drift_wave * CELL_W * 0.9)

            streak_density = 0.55 + 0.45 * math.sin(cycle_angle * 2.0 + lane_seed * 2.2)

            for row in range(ROWS):
                distance = row - head
                if distance < -0.75 or distance > trail_len:
                    continue

                tail = 1.0 - (max(distance, 0.0) / trail_len)
                sparkle = 0.5 + 0.5 * math.sin(row * 1.2 + lane_seed * 3.3 + cycle_angle * 4.0)
                breakup = 0.5 + 0.5 * math.sin(row * 2.1 - lane_seed * 2.7 + cycle_angle * 3.0)
                intensity = tail * (0.78 + 0.22 * sparkle) * (0.72 + 0.28 * streak_density)
                intensity *= 0.72 + 0.28 * breakup
                intensity = max(0.0, min(1.0, intensity))

                if intensity < 0.13:
                    continue

                char_idx = min(len(FALLING_CHARS) - 1, int(intensity * len(FALLING_CHARS)))
                char = FALLING_CHARS[char_idx]
                color_idx = min(len(PINK_PALETTE) - 1, int(intensity * len(PINK_PALETTE)))
                color = PINK_PALETTE[color_idx]

                if distance < 0.45:
                    color = mix_hex("#f5e0dc", color, 0.18)
                    char = "@"
                elif distance < 1.6:
                    char = "0"
                elif breakup > 0.82 and tail > 0.2:
                    char = "|"

                draw.text((base_x + x_offset, row * CELL_H - 2), char, font=FONT, fill=color)

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
