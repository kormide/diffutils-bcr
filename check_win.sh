#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

HEADERS=(
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
    errno.h
    fnmatch.h
    limits.h
    sigsegv.h
    stdbit.h
    stddef.h
    stdint.h
    unicase.h
    unictype.h
    uninorm.h
    unistr.h
    unitypes.h
    uniwidth.h
)


for header in "${HEADERS[@]}"; do
    if ! diff "../diffutils-prebuilt/bazel-out/windows_amd64-fastbuild/bin/external/diffutils+/lib/$header" "../diffutils-3.12-win/lib/$header" >/dev/null; then
        echo "$header" is different
    fi
done
