#!/usr/bin/env bash
#
# Bump a cask or formula to a new version and push it.
#
#   ./bump.sh <name> <version>
#
# Sets the `version`, re-renders the `url` with that version, downloads it to
# compute the `sha256`, rewrites both lines in place, then commits and pushes.
# Works for casks (Casks/<name>.rb) and formulas (Formula/<name>.rb) alike, as
# long as the file uses `version "x"` + a `#{version}`-interpolated `url`.
#
# The release artifact (DMG/zip asset, or the git tag whose tarball GitHub
# generates) must already be published — this only fetches it.
set -euo pipefail

usage() { echo "usage: bump.sh <name> <version>" >&2; exit 1; }
[ "$#" -eq 2 ] || usage
name="$1"
version="$2"
[[ "$name" =~ ^[A-Za-z0-9][A-Za-z0-9._+-]*$ ]] || { echo "invalid package name: $name" >&2; exit 1; }
[[ "$version" =~ ^[0-9]+(\.[0-9]+)+$ ]] || { echo "invalid version: $version" >&2; exit 1; }

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
cd -- "$script_dir"

for tool in git curl shasum ruby dirname mktemp rm; do
  command -v "$tool" >/dev/null 2>&1 || { echo "required tool not found: $tool" >&2; exit 1; }
done

branch="$(git symbolic-ref --quiet --short HEAD)" || { echo "not on a branch" >&2; exit 1; }
[ "$branch" = main ] || { echo "current branch must be main (found $branch)" >&2; exit 1; }
[ -z "$(git status --porcelain)" ] || { echo "working tree must be clean (including untracked files)" >&2; exit 1; }

git fetch origin main
local_head="$(git rev-parse HEAD)"
git rev-parse --verify origin/main >/dev/null

file="Casks/$name.rb"
[ "$(git cat-file -t "origin/main:$file" 2>/dev/null || true)" = blob ] || file="Formula/$name.rb"
[ "$(git cat-file -t "origin/main:$file" 2>/dev/null || true)" = blob ] \
  || { echo "no Casks/$name.rb or Formula/$name.rb on origin/main" >&2; exit 1; }
[ -f "$file" ] || { echo "missing local $file" >&2; exit 1; }

metadata="$(git show "origin/main:$file" | ruby -e '
  src = STDIN.read
  versions = src.scan(/^[ \t]*version\s+"([^"]+)"/).flatten
  urls = src.scan(/^[ \t]*url\s+"([^"]+)"/).flatten
  shas = src.scan(/^[ \t]*sha256\s+"([^"]+)"/).flatten
  abort "expected exactly one version, url, and sha256" unless [versions, urls, shas].all? { |matches| matches.length == 1 }
  abort %q{url must contain literal #{version}} unless urls[0].include?(%q{#{version}})
  puts versions[0], shas[0], urls[0].gsub(/#\{version\}/, ARGV[0])
' "$version")"
current_version="${metadata%%$'\n'*}"
metadata="${metadata#*$'\n'}"
current_sha="${metadata%%$'\n'*}"
url="${metadata#*$'\n'}"

tmp="$(mktemp "${TMPDIR:-/tmp}/bump.XXXXXX")"
trap 'rm -f -- "$tmp"' EXIT
echo "▸ fetching $url"
if ! curl --fail --location --show-error --output "$tmp" "$url"; then
  echo "download failed: $url" >&2
  exit 1
fi
sha_output="$(shasum -a 256 "$tmp")"
sha="${sha_output%% *}"
[[ "$sha" =~ ^[0-9a-f]{64}$ ]] || { echo "failed to compute sha256" >&2; exit 1; }
echo "▸ sha256 $sha"

read -r behind ahead < <(git rev-list --left-right --count origin/main...HEAD)
if [ "$behind" -eq 0 ] && [ "$ahead" -eq 1 ]; then
  [ "$(git log -1 --format=%s HEAD)" = "$name $version" ] \
    || { echo "refusing to resume: local commit subject does not match $name $version" >&2; exit 1; }
  [ "$(git diff --name-only origin/main..HEAD)" = "$file" ] \
    || { echo "refusing to resume: local commit must change exactly $file" >&2; exit 1; }
  local_metadata="$(ruby -e '
    src = File.read(ARGV[0])
    versions = src.scan(/^[ \t]*version\s+"([^"]+)"/).flatten
    shas = src.scan(/^[ \t]*sha256\s+"([^"]+)"/).flatten
    abort "expected exactly one version and sha256" unless [versions, shas].all? { |matches| matches.length == 1 }
    puts versions[0], shas[0]
  ' "$file")"
  [ "$local_metadata" = "$version"$'\n'"$sha" ] \
    || { echo "refusing to resume: local $file does not match version $version and sha256 $sha" >&2; exit 1; }
  git push origin "$local_head:refs/heads/main"
  echo "✓ $name $version pushed"
  exit 0
fi
[ "$behind" -eq 0 ] && [ "$ahead" -eq 0 ] \
  || { echo "local main must match origin/main, except for one valid resumable bump commit (behind $behind, ahead $ahead)" >&2; exit 1; }

if [ "$current_version" = "$version" ] && [ "$current_sha" = "$sha" ]; then
  echo "✓ $name is already at $version with sha256 $sha"
  exit 0
fi

ruby -e '
  path, version, sha = ARGV
  src = File.read(path)
  abort "version edit failed" unless src.sub!(/^([ \t]*version\s+)"[^"]+"/) { %(#{$1}"#{version}") }
  abort "sha256 edit failed" unless src.sub!(/^([ \t]*sha256\s+)"[^"]+"/) { %(#{$1}"#{sha}") }
  File.write(path, src)
' "$file" "$version" "$sha"

git add -- "$file"
staged="$(git diff --cached --name-only)"
[ "$staged" = "$file" ] || { echo "refusing to commit unexpected staged paths: $staged" >&2; exit 1; }
git commit -q -m "$name $version"
git push origin HEAD:refs/heads/main
echo "✓ $name $version pushed"
