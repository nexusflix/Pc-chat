#!/usr/bin/env bash
set -euo pipefail

PID_FILE="vm/qemu.pid"

if [ ! -f "$PID_FILE" ]; then
    echo "Nenhum PID do QEMU encontrado."
    exit 0
fi

PID=$(cat "$PID_FILE" || true)

if [ -z "${PID:-}" ]; then
    rm -f "$PID_FILE"
    exit 0
fi

if ! kill -0 "$PID" 2>/dev/null; then
    echo "QEMU já está parado."

    rm -f "$PID_FILE"

    exit 0
fi

echo "Parando QEMU..."
echo "PID: $PID"

# Primeiro tenta encerramento normal.
kill -TERM "$PID" 2>/dev/null || true

echo "Aguardando encerramento normal..."

for i in $(seq 1 30); do

    if ! kill -0 "$PID" 2>/dev/null; then
        echo "QEMU encerrado normalmente."

        rm -f "$PID_FILE"

        exit 0
    fi

    sleep 1
done

echo "QEMU não encerrou após 30 segundos."
echo "Enviando SIGKILL..."

kill -KILL "$PID" 2>/dev/null || true

sleep 2

rm -f "$PID_FILE"

echo "QEMU encerrado."