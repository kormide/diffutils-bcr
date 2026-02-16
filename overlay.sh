#!/usr/bin/env bash

set -o nounset -o errexit -o pipefail

MODULE=~/Code/bazel-central-registry/modules/diffutils/3.12

FILES=(
    BUILD.bazel
    config_linux.bzl
    config_macos.bzl
    lib/BUILD.bazel
    lib/config_linux_amd64.h
    lib/config_linux_arm64.h
    lib/config_macos.h
    src/BUILD.bazel
    utils.bzl
)

for file in "${FILES[@]}"; do
    cp "$file" "$MODULE/overlay/$file"
done

echo "\"overlay\": {"
for file in "${FILES[@]}"; do
    echo "  \"$file\": \"sha256-$(shasum -a 256 "$file" | awk '{print $1}' | xxd -r -p | base64)\","
done
echo "}"
