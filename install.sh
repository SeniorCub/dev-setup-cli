#!/usr/bin/env bash

set -e

INSTALL_DIR="/usr/local/bin"
CLI_NAME="dev-setup"

echo "Installing $CLI_NAME..."

curl -fsSL https://raw.githubusercontent.com/seniorcub/dev-setup-cli/main/dev-setup.sh \
  -o "$INSTALL_DIR/$CLI_NAME"

chmod +x "$INSTALL_DIR/$CLI_NAME"

echo "✅ Installed! Run with: $CLI_NAME"
