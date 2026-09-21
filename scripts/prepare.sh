#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update
sudo apt-get install -y qemu-system-x86 qemu-utils curl unzip

mkdir -p vm state
echo "QEMU preparado."
