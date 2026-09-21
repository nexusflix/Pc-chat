#!/usr/bin/env bash
set -euo pipefail

mkdir -p vm state

DISK="vm/windows11.qcow2"
STATE="state/windows11-latest.qcow2"

echo "======================================"
echo "RESTAURANDO VM"
echo "======================================"

if [ -f "$STATE" ]; then

    echo "Estado persistente encontrado."

    echo "Verificando estado..."

    qemu-img check "$STATE" || true

    echo ""
    echo "Restaurando disco..."

    cp "$STATE" "$DISK"

    echo ""
    echo "Disco restaurado."

    qemu-img info "$DISK"

else

    echo "Nenhum estado persistente encontrado."

fi