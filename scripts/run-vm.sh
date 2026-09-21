#!/usr/bin/env bash
set -euo pipefail

mkdir -p vm

DISK="vm/windows11.qcow2"
ISO="vm/windows11.iso"
PID_FILE="vm/qemu.pid"

echo "======================================"
echo "THYOCLOUD WINDOWS 11"
echo "======================================"

if [ ! -f "$DISK" ]; then
    echo "Erro: disco Windows não encontrado:"
    echo "$DISK"
    exit 1
fi

if [ ! -f "$ISO" ]; then
    echo "Erro: ISO não encontrada:"
    echo "$ISO"
    exit 1
fi

# Evita iniciar duas VMs usando o mesmo disco.
if [ -f "$PID_FILE" ]; then
    OLD_PID=$(cat "$PID_FILE" || true)

    if [ -n "${OLD_PID:-}" ] && kill -0 "$OLD_PID" 2>/dev/null; then
        echo "QEMU já está executando."
        echo "PID: $OLD_PID"
        exit 0
    fi

    rm -f "$PID_FILE"
fi

if [ ! -f vm/installed.flag ]; then

    echo "Primeira inicialização."
    echo "Inicializando pela ISO do Windows 11."

    qemu-system-x86_64 \
        -machine q35 \
        -accel tcg,thread=multi \
        -m 6144 \
        -smp 4 \
        -cpu max \
        -drive file="$DISK",if=virtio,format=qcow2 \
        -cdrom "$ISO" \
        -boot order=d \
        -nic user,model=virtio-net-pci,hostfwd=tcp::3389-:3389 \
        -display none \
        -monitor none \
        -serial none \
        >/tmp/thycloud-qemu.log 2>&1 &

else

    echo "Inicializando Windows pelo disco persistente."

    qemu-system-x86_64 \
        -machine q35 \
        -accel tcg,thread=multi \
        -m 6144 \
        -smp 4 \
        -cpu max \
        -drive file="$DISK",if=virtio,format=qcow2 \
        -nic user,model=virtio-net-pci,hostfwd=tcp::3389-:3389 \
        -display none \
        -monitor none \
        -serial none \
        >/tmp/thycloud-qemu.log 2>&1 &

fi

QEMU_PID=$!

echo "$QEMU_PID" > "$PID_FILE"

echo ""
echo "QEMU iniciado."
echo "PID: $QEMU_PID"
echo ""

sleep 3

if ! kill -0 "$QEMU_PID" 2>/dev/null; then
    echo "Erro: QEMU encerrou imediatamente."
    echo ""
    echo "Log do QEMU:"
    cat /tmp/thycloud-qemu.log || true

    rm -f "$PID_FILE"

    exit 1
fi

echo "QEMU está executando normalmente."