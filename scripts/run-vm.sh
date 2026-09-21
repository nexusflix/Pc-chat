#!/usr/bin/env bash
set -euo pipefail

mkdir -p vm

# Primeira inicialização: boot pela ISO.
# Depois que o Windows estiver instalado, remova -cdrom para iniciar somente
# pelo disco.
if [ ! -f vm/installed.flag ]; then
  echo "Primeira inicialização: instale o Windows pelo console da VM."
  qemu-system-x86_64 \
    -machine q35 \
    -m 6144 \
    -smp 4 \
    -cpu max \
    -drive file=vm/windows11.qcow2,if=virtio,format=qcow2 \
    -cdrom vm/windows11.iso \
    -boot order=d \
    -nic user,model=virtio-net-pci \
    -display none \
    -monitor none \
    -serial stdio &
else
  echo "Iniciando Windows pelo disco persistente."
  qemu-system-x86_64 \
    -machine q35 \
    -m 6144 \
    -smp 4 \
    -cpu max \
    -drive file=vm/windows11.qcow2,if=virtio,format=qcow2 \
    -nic user,model=virtio-net-pci \
    -display none \
    -monitor none \
    -serial stdio &
fi

echo $! > vm/qemu.pid
echo "PID: $(cat vm/qemu.pid)"
