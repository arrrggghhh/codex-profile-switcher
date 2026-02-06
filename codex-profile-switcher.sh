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
  note=""
  note_file="${dirs[$i]}/.cps_note.txt"
  if [ -f "$note_file" ]; then
    IFS= read -r note < "$note_file" || true
  fi
  if [ -n "$note" ]; then
    printf "%d) %s - %s\n" "$((i + 1))" "${dirs[$i]}" "$note"
  else
    printf "%d) %s\n" "$((i + 1))" "${dirs[$i]}"
  fi
done

read -r -p "Enter number (or N -> main): " choice

mode="run"
if [[ "$choice" =~ ^[[:space:]]*([0-9]+)[[:space:]]*$ ]]; then
  selected="${BASH_REMATCH[1]}"
elif [[ "$choice" =~ ^[[:space:]]*([0-9]+)[[:space:]]*-\>[[:space:]]*main[[:space:]]*$ ]]; then
  selected="${BASH_REMATCH[1]}"
  mode="copy_to_main"
else
  echo "Invalid input: expected a number or 'N -> main'."
  exit 1
fi

index=$((selected - 1))
if [ "$index" -lt 0 ] || [ "$index" -ge "${#dirs[@]}" ]; then
  echo "Invalid selection."
  exit 1
fi

if [ "$mode" = "copy_to_main" ]; then
  target_dir="$HOME/.codex"
  rm -rf -- "$target_dir"
  mkdir -p -- "$target_dir"
  if command -v rsync >/dev/null 2>&1; then
    rsync -a -- "${dirs[$index]}/" "$target_dir/"
  else
    cp -R "${dirs[$index]}/." "$target_dir/"
  fi
  echo "Copied ${dirs[$index]} to $target_dir."
  exit 0
fi

CODEX_HOME="${dirs[$index]}" exec codex "$@"
