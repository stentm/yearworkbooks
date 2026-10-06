#!/usr/bin/env bash
# Rigenera gli zip di deploy per Cloudflare Pages, uno per ogni sito.
# Output in ../webapp-compiti-dist (fuori dal repo, non versionato).
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIST_DIR="$(dirname "$REPO_DIR")/webapp-compiti-dist"

SITES=(year2 year3 year4 year5 year6 landing)

mkdir -p "$DIST_DIR"

for site in "${SITES[@]}"; do
  [ -d "$REPO_DIR/$site" ] || { echo "skip $site (cartella non trovata)"; continue; }
  rm -f "$DIST_DIR/$site.zip"
  (cd "$REPO_DIR/$site" && zip -rq "$DIST_DIR/$site.zip" . -x "CLAUDE.md")
  echo "creato $site.zip"
done

if [ -d "$REPO_DIR/redirects" ]; then
  for dir in "$REPO_DIR"/redirects/*/; do
    [ -d "$dir" ] || continue
    name="$(basename "$dir")"
    rm -f "$DIST_DIR/redirect-$name.zip"
    (cd "$dir" && zip -rq "$DIST_DIR/redirect-$name.zip" .)
    echo "creato redirect-$name.zip"
  done
fi

echo ""
echo "Zip pronti in: $DIST_DIR"
ls -la "$DIST_DIR"
