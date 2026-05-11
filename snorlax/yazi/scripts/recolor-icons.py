#!/usr/bin/env python3
"""
recolor-icons.py — generate a yazi [icon] block with per-category colors.

Reads yazi's upstream theme-dark.toml preset (cached after first fetch) and
emits a new [icon] block where:
  - every dirs entry      -> --dir fg
  - every files entry     -> --default fg
  - archive-ext entries   -> --archive fg
  - image/audio/video ext -> --media fg
  - every other ext       -> --default fg
  - conds (state-based fallback tier) is regenerated with:
      orphan/dummy -> --hero
      link/devices -> --muted
      sticky/dir   -> --dir
      exec         -> --archive (matches "actionable file" convention)
      !dir         -> --default
  - each entry's text (glyph) is preserved verbatim from the preset

Usage:
    recolor-icons.py --dir HEX --archive HEX --media HEX --default HEX [options]

Example:
    recolor-icons.py \\
        --dir '#58b0b8' --archive '#78b098' \\
        --media '#7887ba' --default '#5090b0' \\
        -o icon-block.toml

Options:
    --preset PATH   read from a local preset instead of fetch + cache
    --cache PATH    where to cache the fetched preset (default: alongside script)
    --refresh       force re-fetch even if cache exists
    -o, --output    output file path (default: stdout)
"""

import argparse
import re
import sys
import urllib.request
from pathlib import Path

PRESET_URL = (
    "https://raw.githubusercontent.com/sxyazi/yazi/shipped/"
    "yazi-config/preset/theme-dark.toml"
)
DEFAULT_CACHE = Path(__file__).resolve().parent / "cache" / "theme-dark.toml"

ARCHIVE_EXTS = {
    "7z", "ace", "alz", "apk", "arc", "arj", "bz", "bz2", "bz3", "cab", "cpio",
    "deb", "dmg", "ear", "egg", "epub", "gz", "iso", "jar", "lha", "lz", "lz4",
    "lzh", "lzma", "lzo", "rar", "rpm", "rz", "tar", "tbz", "tbz2", "tgz", "tlz",
    "txz", "tz", "tzo", "war", "xar", "xpi", "xz", "z", "zip", "zst", "zstd",
}

IMAGE_EXTS = {
    "ai", "avif", "blp", "bmp", "bpg", "cr2", "cur", "dds", "dng", "eps", "exr",
    "fig", "gif", "heic", "heif", "hdr", "icns", "ico", "jfif", "jpe", "jpeg",
    "jpg", "jxl", "nef", "orf", "pbm", "pcd", "pcx", "pdn", "pgm", "pic", "pict",
    "pnm", "png", "ppm", "psd", "psp", "qoi", "raf", "raw", "rgb", "rgba", "svg",
    "svgz", "targa", "tga", "tif", "tiff", "vtf", "webp", "wmf", "xbm", "xcf",
    "xpm", "xwd",
}

AUDIO_EXTS = {
    "3ga", "8svx", "aac", "ac3", "aif", "aifc", "aiff", "amr", "ape", "au",
    "caf", "dff", "dsf", "dts", "dtshd", "eac3", "flac", "iff", "m3u", "m3u8",
    "m4a", "m4b", "m4p", "mid", "midi", "mka", "mogg", "mp3", "mpa", "mpc",
    "oga", "ogg", "opus", "pcm", "ra", "shn", "snd", "spx", "tta", "voc", "wav",
    "wma", "wpl", "wv",
}

VIDEO_EXTS = {
    "3g2", "3gp", "3gpp", "3gpp2", "amv", "asf", "avi", "divx", "drc",
    "f4a", "f4b", "f4p", "f4v", "flv", "gifv", "ifv", "m2ts", "m2v", "m4v",
    "mkv", "mov", "mp2", "mp4", "mpe", "mpeg", "mpg", "mpv", "mts", "mxf",
    "nsv", "ogv", "rm", "rmvb", "roq", "svi", "vob", "webm", "wmv",
    "yuv",
}

MEDIA_EXTS = IMAGE_EXTS | AUDIO_EXTS | VIDEO_EXTS

ENTRY_RE = re.compile(
    r'\{\s*name\s*=\s*"([^"]+)"\s*,\s*'
    r'text\s*=\s*"([^"]*)"\s*,\s*'
    r'fg\s*=\s*"[^"]+"\s*\}'
)

COND_RE = re.compile(
    r'\{\s*if\s*=\s*"([^"]+)"\s*,\s*'
    r'text\s*=\s*"([^"]*)"\s*,\s*'
    r'fg\s*=\s*"[^"]+"\s*\}'
)

HEX_RE = re.compile(r"^#[0-9a-fA-F]{6}$")


def hex_arg(s):
    if not HEX_RE.match(s):
        raise argparse.ArgumentTypeError(f"expected #RRGGBB, got {s!r}")
    return s.lower()


def fetch_preset(cache, refresh=False):
    if cache.exists() and not refresh:
        return cache.read_text()
    cache.parent.mkdir(parents=True, exist_ok=True)
    with urllib.request.urlopen(PRESET_URL) as r:
        data = r.read().decode()
    cache.write_text(data)
    return data


def extract_list(preset, key):
    pattern = rf"^{re.escape(key)}\s*=\s*\[\s*$(.*?)^\s*\]\s*$"
    m = re.search(pattern, preset, re.MULTILINE | re.DOTALL)
    if not m:
        return ""
    body = m.group(1).rstrip()
    body = re.sub(r"^\s*#.*$\n?", "", body, flags=re.MULTILINE)
    body = re.sub(r"\n{2,}", "\n", body).strip("\n")
    return body


def recolor(block, color_for):
    def repl(m):
        name, text = m.group(1), m.group(2)
        return f'{{ name = "{name}", text = "{text}", fg = "{color_for(name)}" }}'
    return ENTRY_RE.sub(repl, block)


def ext_color(archive_fg, media_fg, default_fg):
    def inner(name):
        n = name.lower()
        if n in ARCHIVE_EXTS:
            return archive_fg
        if n in MEDIA_EXTS:
            return media_fg
        return default_fg
    return inner


COND_COLOR_MAP = {
    "orphan": "hero",
    "dummy": "hero",
    "link": "muted",
    "block": "muted",
    "char": "muted",
    "fifo": "muted",
    "sock": "muted",
    "sticky": "dir",
    "dir": "dir",
    "exec": "archive",
    "!dir": "default",
}


def recolor_conds(block, palette):
    def repl(m):
        cond, text = m.group(1), m.group(2)
        role = COND_COLOR_MAP.get(cond, "default")
        fg = palette[role]
        return f'{{ if = "{cond}", text = "{text}", fg = "{fg}" }}'
    return COND_RE.sub(repl, block)


def build(preset, dir_fg, archive_fg, media_fg, default_fg, hero_fg, muted_fg):
    dirs_block = extract_list(preset, "dirs")
    files_block = extract_list(preset, "files")
    exts_block = extract_list(preset, "exts")
    conds_block = extract_list(preset, "conds")

    palette = {
        "dir": dir_fg,
        "archive": archive_fg,
        "media": media_fg,
        "default": default_fg,
        "hero": hero_fg,
        "muted": muted_fg,
    }

    dirs_out = recolor(dirs_block, lambda _: dir_fg)
    files_out = recolor(files_block, lambda _: default_fg)
    exts_out = recolor(exts_block, ext_color(archive_fg, media_fg, default_fg))
    conds_out = recolor_conds(conds_block, palette)

    return (
        "[icon]\n"
        "globs = []\n"
        "dirs = [\n"
        f"{dirs_out}\n"
        "]\n"
        "files = [\n"
        f"{files_out}\n"
        "]\n"
        "exts = [\n"
        f"{exts_out}\n"
        "]\n"
        "conds = [\n"
        f"{conds_out}\n"
        "]\n"
    )


def main(argv=None):
    p = argparse.ArgumentParser(
        description=__doc__.split("\n\n")[0],
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="See header docstring for full usage.",
    )
    p.add_argument("--dir", type=hex_arg, required=True)
    p.add_argument("--archive", type=hex_arg, required=True)
    p.add_argument("--media", type=hex_arg, required=True)
    p.add_argument("--default", type=hex_arg, required=True, dest="default_fg")
    p.add_argument("--hero", type=hex_arg, default="#e878a8",
                   help="fg for orphan/dummy icons (default: Grove hero pink)")
    p.add_argument("--muted", type=hex_arg, default="#5a7880",
                   help="fg for link/block/char/fifo/sock icons (default: Grove base03)")
    p.add_argument("--preset", type=Path, default=None)
    p.add_argument("--cache", type=Path, default=DEFAULT_CACHE)
    p.add_argument("--refresh", action="store_true")
    p.add_argument("-o", "--output", type=Path, default=None)

    args = p.parse_args(argv)

    if args.preset:
        preset = args.preset.read_text()
    else:
        preset = fetch_preset(args.cache, refresh=args.refresh)

    result = build(
        preset,
        args.dir, args.archive, args.media, args.default_fg,
        args.hero, args.muted,
    )

    if args.output:
        args.output.write_text(result)
    else:
        sys.stdout.write(result)


if __name__ == "__main__":
    main()
