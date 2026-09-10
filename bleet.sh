#!/bin/sh
# bleet.sh <textfile> [model]   -- summarize a transcript with a local model
f="$1"
[ -f "$f" ] || { echo "usage: $0 <file> [model]" >&2; exit 2; }

if [ -n "$2" ]; then
  m="$2"
else
  # ~4 chars per token; switch up before the transcript crowds out the reply
  [ "$(wc -c < "$f")" -gt 90000 ] && m=qwen3.5-64k || m=qwen3.5-32k
fi

echo "== $m, $(wc -w < "$f") words" >&2

ollama run "$m" "Summarize this transcript. Give a two-sentence gist, the main claims, every named person and organization, and flag where the speaker asserts fact versus speculates.

$(cat "$f")"
