#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ignore_file="$script_dir/.codex_ignore"

declare -A ignore_map
if [ -f "$ignore_file" ]; then
  while IFS= read -r line; do
    trimmed="${line#"${line%%[![:space:]]*}"}"
    trimmed="${trimmed%"${trimmed##*[![:space:]]}"}"
    [ -z "$trimmed" ] && continue
    [ "${trimmed#\#}" != "$trimmed" ] && continue
    if [[ "$trimmed" == "~/"* ]]; then
      trimmed="$HOME/${trimmed#~/}"
    fi
    ignore_map["$trimmed"]=1
  done < "$ignore_file"
fi

dirs=()
for dir in "$HOME"/.codex_*; do
  base="${dir##*/}"
  if [ "${ignore_map[$dir]+x}" = "x" ] || [ "${ignore_map[$base]+x}" = "x" ]; then
    continue
  fi
  dirs+=("$dir")
done
if [ "${#dirs[@]}" -eq 0 ]; then
  echo "No ~/.codex_* directories found."
  exit 1
fi

echo "Select a profile:"
for i in "${!dirs[@]}"; do
  printf "%d) %s\n" "$((i + 1))" "${dirs[$i]}"
done

read -r -p "Enter number: " choice
if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
  echo "Invalid input: expected a number."
  exit 1
fi

index=$((choice - 1))
if [ "$index" -lt 0 ] || [ "$index" -ge "${#dirs[@]}" ]; then
  echo "Invalid selection."
  exit 1
fi

CODEX_HOME="${dirs[$index]}" exec codex "$@"
