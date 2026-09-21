#!/usr/bin/env bash
set -euo pipefail

mkdir -p vm state

if [ -f state/windows11-latest.qcow2 ]; then
  echo "Restaurando último estado..."
  cp state/windows11-latest.qcow2 vm/windows11.qcow2
else
  echo "Nenhum estado persistente encontrado."
fi
