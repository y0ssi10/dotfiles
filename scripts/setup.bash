#!/usr/bin/env bash
set -eux
source "$(dirname "$0")/common.bash"

/bin/bash "$CUR_DIR/setup-homebrew.bash"
/bin/bash "$CUR_DIR/setup-symlink.bash"
/bin/bash "$CUR_DIR/setup-mac.bash"
