#!/usr/bin/env bash
#
# standalone script without lib dependency so it can be called directly from bootstrapped CI before submodules, 
# since that is the exact problem that needs to be solved to allow CI/CD systems with incorrect ownership of the 
# checkout directory to be able to checkout the necessary git submodules
set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

dir="${1:-$srcdir/..}"
cd "$dir"

echo "Setting directory as safe: $PWD"
git config --global --add safe.directory "$PWD"

while read -r submodule_dir; do
    dir="$PWD/$submodule_dir"
    echo "Setting directory as safe: $dir"
    git config --global --add safe.directory "$dir"
done < <(git submodule | awk '{print $2}')

echo "Done"
