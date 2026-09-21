#!/usr/bin/env bash
set -euo pipefail

mkdir -p state

DISK="vm/windows11.qcow2"
STATE="state/windows11-latest.qcow2"
PID_FILE="vm/qemu.pid"

echo "======================================"
echo "SALVANDO ESTADO DA VM"
echo "======================================"

if [ ! -f "$DISK" ]; then
    echo "Disco não encontrado."
    exit 0
fi

# ============================================================
# GARANTE QUE O QEMU NÃO ESTÁ USANDO O DISCO
# ============================================================

if [ -f "$PID_FILE" ]; then

    PID=$(cat "$PID_FILE" || true)

    if [ -n "${PID:-}" ] && kill -0 "$PID" 2>/dev/null; then

        echo "QEMU ainda está executando."
        echo "Encerrando antes do backup..."
        echo "PID: $PID"

        kill -TERM "$PID" 2>/dev/null || true

        for i in $(seq 1 30); do

            if ! kill -0 "$PID" 2>/dev/null; then
                break
            fi

            sleep 1
        done

        if kill -0 "$PID" 2>/dev/null; then
            echo "QEMU não encerrou."
            echo "Forçando encerramento..."

            kill -KILL "$PID" 2>/dev/null || true

            sleep 3
        fi
    fi

    rm -f "$PID_FILE"
fi

# ============================================================
# VERIFICAÇÃO DO DISCO
# ============================================================

echo ""
echo "Verificando disco..."

qemu-img check "$DISK" || true

# ============================================================
# REMOVE ESTADO ANTIGO
# ============================================================

rm -f "$STATE"

# ============================================================
# COMPACTA O DISCO
# ============================================================

echo ""
echo "Compactando estado da VM..."

qemu-img convert \
    -p \
    -O qcow2 \
    -c \
    "$DISK" \
    "$STATE"

# ============================================================
# VERIFICAÇÃO FINAL
# ============================================================

echo ""
echo "Verificando estado salvo..."

qemu-img check "$STATE" || true

echo ""
echo "======================================"
echo "ESTADO SALVO COM SUCESSO"
echo "======================================"

ls -lh "$STATE"

echo ""
echo "Arquivo:"
echo "$STATE"