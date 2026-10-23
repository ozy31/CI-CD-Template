#!/usr/bin/env sh
set -eu
# Unit tests run inside the build stage, so a failing test fails the build.
docker build --force-rm -t "${APP_REPO_NAME}:${BUILD_NUMBER}" .
