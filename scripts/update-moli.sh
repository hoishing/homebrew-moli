#!/usr/bin/env bash
# Sync Formula/moli.rb with the latest lexmount/moli release.
# Requires: gh (authenticated), jq, curl, shasum.
set -euo pipefail

formula="$(dirname "$0")/../Formula/moli.rb"
release=$(gh api repos/lexmount/moli/releases/latest)
latest=$(jq -r '.tag_name | ltrimstr("v")' <<<"$release")
current=$(sed -nE 's/^  version "(.*)"/\1/p' "$formula")

if [[ "$latest" == "$current" ]]; then
  echo "moli is up to date ($current)"
  exit 0
fi

sed -i.bak -E "s/^  version \".*\"/  version \"$latest\"/" "$formula"
for target in aarch64-apple-darwin x86_64-apple-darwin aarch64-unknown-linux-gnu x86_64-unknown-linux-gnu; do
  sha=$(jq -r --arg n "moli-$target.tar.gz" \
    '.assets[] | select(.name == $n) | .digest | ltrimstr("sha256:")' <<<"$release")
  [[ "$sha" =~ ^[0-9a-f]{64}$ ]] || { echo "missing digest for $target" >&2; exit 1; }
  # Replace the sha256 line that follows this target's url line.
  awk -v t="moli-$target.tar.gz" -v s="$sha" '
    index($0, t) { hit = 1; print; next }
    hit && /sha256 "/ { sub(/"[0-9a-f]+"/, "\"" s "\""); hit = 0 }
    { print }
  ' "$formula" >"$formula.tmp" && mv "$formula.tmp" "$formula"
done

# Skills resource: source tarball of the same tag (no API digest, so hash it).
src_url="https://github.com/lexmount/moli/archive/refs/tags/v$latest.tar.gz"
src_sha=$(curl -fsSL "$src_url" | shasum -a 256 | cut -d' ' -f1)
[[ "$src_sha" =~ ^[0-9a-f]{64}$ ]] || { echo "failed to hash $src_url" >&2; exit 1; }
awk -v u="$src_url" -v s="$src_sha" '
  /archive\/refs\/tags\/v.*\.tar\.gz/ { sub(/"[^"]+"/, "\"" u "\""); hit = 1; print; next }
  hit && /sha256 "/ { sub(/"[0-9a-f]+"/, "\"" s "\""); hit = 0 }
  { print }
' "$formula" >"$formula.tmp" && mv "$formula.tmp" "$formula"
rm -f "$formula.bak"

echo "moli updated: $current -> $latest"
[[ -n "${GITHUB_OUTPUT:-}" ]] && echo "version=$latest" >>"$GITHUB_OUTPUT"
exit 0
