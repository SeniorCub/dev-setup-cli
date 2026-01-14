#!/usr/bin/env bash

set -e

INSTALL_DIR="/usr/local/bin"
CLI_NAME="dev-setup"

echo "Installing $CLI_NAME..."

TEMP_DIR="${TMPDIR:-/tmp}"
TEMP_FILE="$TEMP_DIR/dev-setup-install-$$"

curl -fsSL https://raw.githubusercontent.com/seniorcub/dev-setup-cli/main/dev-setup.sh -o "$TEMP_FILE" || {
    echo "Failed to download dev-setup.sh"
    exit 1
}

sudo mv "$TEMP_FILE" "$INSTALL_DIR/$CLI_NAME" || {
    rm -f "$TEMP_FILE"
    echo "Failed to install to $INSTALL_DIR. Do you have sudo permissions?"
    exit 1
}

sudo chmod +x "$INSTALL_DIR/$CLI_NAME"

echo "✅ Installed! Run with: $CLI_NAME"
