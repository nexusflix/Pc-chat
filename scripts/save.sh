#!/usr/bin/env bash
set -euo pipefail

mkdir -p state

if [ -f vm/windows11.qcow2 ]; then
  echo "Compactando estado da VM..."
  qemu-img check vm/windows11.qcow2 || true
  qemu-img convert -O qcow2 -c vm/windows11.qcow2 state/windows11-latest.qcow2
  echo "Estado salvo em state/windows11-latest.qcow2"
else
  echo "Disco não encontrado; nada para salvar."
fi
