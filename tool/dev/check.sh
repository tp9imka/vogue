#!/usr/bin/env bash
# Local check — mirrors what CI would run. Keep this green before every PR.
set -euo pipefail
cd "$(dirname "$0")/../.."

echo "== format =="
dart format --set-exit-if-changed lib test

echo "== analyze =="
flutter analyze

echo "== test =="
flutter test

echo "== secrets =="
bash tool/lint/no_committed_secrets.sh

echo "ALL GREEN"
