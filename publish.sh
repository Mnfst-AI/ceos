#!/usr/bin/env bash
set -euo pipefail

# publish.sh — Push skills, templates, and docs to the public repo (bradfeld/ceos).
# Company data (data/) never leaves this machine.
#
# Usage:
#   ./publish.sh              Preview what would be published
#   ./publish.sh --push       Actually push to public

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Verify we have the upstream remote
if ! git remote get-url upstream &>/dev/null; then
    echo "Error: No 'upstream' remote found."
    echo "Add it: git remote add upstream https://github.com/bradfeld/ceos.git"
    exit 1
fi

# Files/dirs that go to public (everything except data/ and private config)
PUBLIC_PATHS=(
    skills/
    templates/
    docs/
    README.md
    CONTRIBUTING.md
    LICENSE
    setup.sh
    .ceos
    .github/
    .gitignore
)

PUSH_MODE=false
if [[ "${1:-}" == "--push" ]]; then
    PUSH_MODE=true
fi

# Create a temporary working directory
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

echo "Cloning public repo..."
git clone --quiet https://github.com/bradfeld/ceos.git "$TMPDIR/public"

echo ""
echo "Copying publishable files..."

for item in "${PUBLIC_PATHS[@]}"; do
    if [[ -e "$SCRIPT_DIR/$item" ]]; then
        # Create parent directory if needed
        parent=$(dirname "$TMPDIR/public/$item")
        mkdir -p "$parent"

        if [[ -d "$SCRIPT_DIR/$item" ]]; then
            # Directory — sync contents (delete removed files too)
            rsync -a --delete "$SCRIPT_DIR/$item" "$TMPDIR/public/$item"
        else
            cp "$SCRIPT_DIR/$item" "$TMPDIR/public/$item"
        fi
        echo "  [sync] $item"
    fi
done

echo ""

# Show what changed
cd "$TMPDIR/public"
git add -A

if git diff --cached --quiet; then
    echo "Nothing to publish — public repo is already up to date."
    exit 0
fi

echo "Changes to publish:"
echo "───────────────────────────────────────────────"
git diff --cached --stat
echo "───────────────────────────────────────────────"

if [[ "$PUSH_MODE" == true ]]; then
    git commit -m "chore: sync skills, templates, and docs from private repo"
    git push
    echo ""
    echo "Published to https://github.com/bradfeld/ceos"
else
    echo ""
    echo "Dry run. To actually publish, run:"
    echo "  ./publish.sh --push"
fi
