#!/usr/bin/env bash
set -euo pipefail

echo "======================================"
echo "PREPARANDO QEMU"
echo "======================================"

sudo apt-get update

sudo apt-get install -y \
    qemu-system-x86 \
    qemu-utils \
    curl \
    unzip

mkdir -p vm
mkdir -p state

echo ""
echo "QEMU preparado."

qemu-system-x86_64 --version
qemu-img --version