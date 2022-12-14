#!/usr/bin/env bash
set -eux
source "$(dirname "$0")/common.bash"

/bin/bash "$CUR_DIR/setup-homebrew.bash"
/bin/bash "$CUR_DIR/setup-links.bash"
/bin/bash "$CUR_DIR/setup-mac.bash"
/bin/bash "$CUR_DIR/setup-asdf.bash"
/bin/bash "$CUR_DIR/setup-zinit.bash"
