#!/usr/bin/env bash

# Copy files over to a local bazel-central-registry.
#
# Args:
#   <BCR> - Path to the registry root to copy files to

set -o nounset -o errexit -o pipefail

if [ -z "${1:-}" ]; then
    echo "error: missing BCR root argument"
    exit 1
fi

BCR="${1%/}"
VERSION="3.12"
INTEGRITY="sha256-fIt/n8hgkUH96pzs6FJJ0whiQ5H/Yd7a9Sj8szdyff0="
MODULE="$BCR/modules/diffutils/${VERSION}"

FILES=(
    BUILD.bazel
    config_linux.bzl
    config_macos.bzl
    config_windows.bzl
    lib/BUILD.bazel
    lib/config_linux_amd64.h
    lib/config_linux_arm64.h
    lib/config_macos_amd64.h
    lib/config_macos_arm64.h
    src/BUILD.bazel
    test/BUILD.bazel
    utils.bzl
)

for file in "${FILES[@]}"; do
    cp "$file" "$MODULE/overlay/$file"
done

{
    for file in "${FILES[@]}"; do
        jq --null-input \
            --compact-output \
            --arg file "$file" \
            --arg sha "sha256-$(shasum -a 256 "$file" | awk '{print $1}' | xxd -r -p | base64)" \
            '{$file:$sha}'
    done
} | jq --slurp \
    --arg url "https://mirror.cs.odu.edu/gnu/diffutils/diffutils-${VERSION}.tar.xz" \
    --arg integrity "$INTEGRITY" \
    --arg strip_prefix "diffutils-${VERSION}" \
    --indent 4 \
    '{url: $url, integrity: $integrity, strip_prefix: $strip_prefix, overlay: add}' > "$MODULE/source.json"

cp MODULE.bazel "$MODULE/"
