#!/usr/bin/env bash
# Media recipes for the site. Needs ffmpeg.
#
#   scripts/media.sh web    in.mp4 [out.mp4]   web-safe H.264 for a page video (keeps audio, max 1280 px wide)
#   scripts/media.sh cover  in.(mp4|gif) out.mp4   small silent loop for a homepage card (max 640 px wide)
#   scripts/media.sh poster in.(mp4|gif) out.jpg [seconds]   still frame, used as video poster and link preview
#
# With no out file, `web` replaces the input, but only if the result is at least 20% smaller.
# Browsers show a gray box for H.264 above level 4.x or with a bogus frame rate, so every
# recipe forces High profile, level 4.0, yuv420p, a sane fps and +faststart.
set -euo pipefail

h264=(-c:v libx264 -preset slow -profile:v high -level 4.0 -pix_fmt yuv420p -movflags +faststart)
# even dimensions, never upscale
scale() { echo "scale='min($1,iw)':-2"; }

cmd=${1:?usage: media.sh web|cover|poster in [out]}
in=${2:?missing input}

case $cmd in
  web)
    out=${3:-}
    tmp=$(mktemp --suffix=.mp4); chmod 644 "$tmp"
    ffmpeg -v error -y -i "$in" -vf "$(scale 1280),fps=fps='min(source_fps,30)'" "${h264[@]}" -crf 26 \
      -c:a aac -b:a 96k "$tmp"
    if [[ -n $out ]]; then
      mv "$tmp" "$out"
    elif (( $(stat -c%s "$tmp") * 10 < $(stat -c%s "$in") * 8 )); then
      mv "$tmp" "$in"
    else
      rm "$tmp"; echo "kept $in (re-encode not smaller)"
    fi
    ;;
  cover)
    out=${3:?missing output}
    ffmpeg -v error -y -i "$in" -vf "$(scale 640),fps=fps='min(source_fps,30)'" "${h264[@]}" -crf 28 -an "$out"
    ;;
  poster)
    out=${3:?missing output}
    ffmpeg -v error -y -ss "${4:-0}" -i "$in" -frames:v 1 -q:v 3 "$out"
    ;;
  *)
    echo "unknown command: $cmd" >&2; exit 1 ;;
esac
