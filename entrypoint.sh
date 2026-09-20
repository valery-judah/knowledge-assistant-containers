#!/usr/bin/env bash
set -Eeuo pipefail

fail() {
  printf 'error: %s\n' "$*" >&2
  exit 64
}

[[ $# -gt 0 ]] || fail "a vLLM model argument is required"
[[ -n "${PUBLIC_KEY:-}" ]] || fail "PUBLIC_KEY is required for private SSH access"

install -d -m 0700 /root/.ssh
install -d -m 0755 /run/sshd
install -d -m 0755 "${HF_HOME:-/workspace/.cache/huggingface}"

authorized_keys=$(mktemp /root/.ssh/authorized_keys.XXXXXX)
trap 'rm -f "$authorized_keys"' EXIT
printf '%s\n' "$PUBLIC_KEY" | tr -d '\r' >"$authorized_keys"
chmod 0600 "$authorized_keys"

if ! ssh-keygen -l -f "$authorized_keys" >/dev/null 2>&1; then
  fail "PUBLIC_KEY is not a valid OpenSSH public key"
fi

mv "$authorized_keys" /root/.ssh/authorized_keys
trap - EXIT

ssh-keygen -A >/dev/null
/usr/sbin/sshd -t
/usr/sbin/sshd

printf 'SSH is ready; starting the private vLLM embedding service.\n'
exec vllm serve "$@"
