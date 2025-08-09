#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Get the absolute path of the directory where this script is located.
# This makes the script runnable from any location.
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
echo "--- Running script from: $SCRIPT_DIR"

# Define paths for clarity and easier maintenance
KSU_NEXT_DIR="$SCRIPT_DIR/KernelSU-Next"
PATCH_FILE="$SCRIPT_DIR/patches/latest_ksu.patch"

# --- Step 1: Download and run the KernelSU-Next setup script ---
# The setup script will clone the KernelSU-Next repository into the current directory.
# We run this from SCRIPT_DIR to ensure it's cloned into kernel/xiaomi/sm8350/
echo "--- Downloading and setting up KernelSU-Next..."
cd "$SCRIPT_DIR"
curl -LSs "https://raw.githubusercontent.com/KernelSU-Next/KernelSU-Next/next/kernel/setup.sh" | bash -
echo "--- KernelSU-Next setup complete."

# --- Step 2: Navigate into the KernelSU-Next git repository ---
# Check if the directory was created successfully before trying to enter it.
if [ ! -d "$KSU_NEXT_DIR" ]; then
    echo "❌ ERROR: The directory '$KSU_NEXT_DIR' was not created. Aborting."
    exit 1
fi
echo "--- Changing directory to $KSU_NEXT_DIR"
cd "$KSU_NEXT_DIR"

# --- Step 3: Apply the patch ---
# Check if the patch file exists before trying to apply it.
if [ ! -f "$PATCH_FILE" ]; then
    echo "❌ ERROR: Patch file not found at '$PATCH_FILE'. Aborting."
    exit 1
fi
echo "--- Applying 3-way patch: $PATCH_FILE"
git apply --3way "$PATCH_FILE"

echo ""
echo "✅ Patch applied successfully. KernelSU-Next is ready."