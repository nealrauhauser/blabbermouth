#!/bin/sh
# yeet.sh <url or video id>  -- pull + parakeet transcript
set -e
PMODEL=${PMODEL:-~/work/parakeet/parakeet-tdt-0.6b-v3}
[ -n "$1" ] || { echo "usage: $0 <url>" >&2; exit 2; }

f=$(yt-dlp --write-comments --write-info-json \
    --print after_move:filepath --no-simulate "$1" | tail -1)
[ -f "$f" ] || { echo "no media file from yt-dlp" >&2; exit 3; }
b="${f%.*}"

ffmpeg -n -loglevel error -i "$f" -vn -ac 1 -c:a pcm_s16le "$b.src.wav"
ffmpeg -n -loglevel error -i "$b.src.wav" -ar 16000 "$b.16k.wav"

parakeet-mlx "$b.16k.wav" \
  --model "$PMODEL" \
  --output-format all \
  --output-template "{filename}.parakeet"

echo "transcript: $b.16k.parakeet.txt"
