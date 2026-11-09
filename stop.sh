#!/usr/bin/env bash
set -euo pipefail

# Stop the MiMo-V2.6-Flash-MOPD container (idempotent).
#
# Leaves the stopped container in place for post-mortem (podman logs / inspect);
# re-running ./start.sh removes it and recreates with fresh config.

CONTAINER_NAME="${CONTAINER_NAME:-mimo26-flash-strix}"

if ! podman ps -a --format '{{.Names}}' | grep -qx "${CONTAINER_NAME}"; then
  echo "Container ${CONTAINER_NAME} not found; nothing to stop."
  exit 0
fi

if podman ps --format '{{.Names}}' | grep -qx "${CONTAINER_NAME}"; then
  echo "Stopping ${CONTAINER_NAME} (60 s grace period) ..."
  podman stop -t 60 "${CONTAINER_NAME}" >/dev/null
  echo "Stopped ${CONTAINER_NAME} (kept for post-mortem: podman logs ${CONTAINER_NAME})"
else
  echo "Container ${CONTAINER_NAME} already stopped."
fi