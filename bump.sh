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
cd "$(dirname "$0")"

name="${1:?usage: bump.sh <name> <version>}"
version="${2:?usage: bump.sh <name> <version>}"

file="Casks/$name.rb"
[ -f "$file" ] || file="Formula/$name.rb"
[ -f "$file" ] || { echo "no Casks/$name.rb or Formula/$name.rb"; exit 1; }

# 1. Set the version first so the URL interpolation below uses it.
/usr/bin/sed -i '' -E "s/^([[:space:]]*version )\"[^\"]+\"/\\1\"$version\"/" "$file"

# 2. Render the download URL with #{version} substituted, then hash it.
url="$(ruby -e 'src=File.read(ARGV[0]); m=src[/url\s+"([^"]+)"/,1] or abort "no url"; puts m.gsub(/#\{version\}/, ARGV[1])' "$file" "$version")"
echo "▸ fetching $url"
sha="$(curl -fsSL "$url" | shasum -a 256 | cut -d' ' -f1)"
[ -n "$sha" ] || { echo "empty sha — download failed"; exit 1; }
echo "▸ sha256 $sha"

# 3. Write the sha, commit, push (rebase first to avoid stale-ref rejections).
/usr/bin/sed -i '' -E "s/^([[:space:]]*sha256 )\"[^\"]+\"/\\1\"$sha\"/" "$file"
git pull --rebase --quiet origin main || true
git add "$file"
git commit -q -m "$name $version"
git push -q origin HEAD
echo "✓ $name $version pushed"
