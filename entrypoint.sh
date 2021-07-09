#!/usr/bin/env bash
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

if [ "$SRC_DIR" == "/" ]; then
  SRC_DIR=""
fi

export SRC_DIR

bash --version

source "$SRC_DIR/src/main.sh"

main "$@"
