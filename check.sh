#!/usr/bin/env bash

set -o errexit -p pipefail -o nounset

LINUX_HEADERS=(
    ctype.h
    dirent.h
    error.h
    fcntl.h
    malloc/dynarray.gl.h
    malloc/dynarray-skeleton.gl.h
    inttypes.h
    langinfo.h
    locale.h
    pthread.h
    sched.h
    signal.h
    stdio.h
    stdlib.h
    string.h
    strings.h
    sys/random.h
    sys/stat.h
    sys/time.h
    sys/types.h
    sys/wait.h
    time.h
    uchar.h
    unistd.h
    wchar.h
    wctype.h
    alloca.h
    limits.h
    sigsegv.h
    stdckdint.h
    stddef.h
    unicase.h
    unictype.h
    uninorm.h
    unistr.h
    unitypes.h
    uniwidth.h
)

bazel build //...

for header in "${LINUX_HEADERS[@]}"; do
    if ! diff "bazel-bin/lib/$header" "../diffutils-3.12/lib/$header" >/dev/null; then
        echo "$header" is different
    fi
done
