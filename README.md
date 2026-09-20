# Knowledge Assistant container images

This repository contains the auditable source for container images used by
Knowledge Assistant infrastructure. Each image has an independent directory,
build context, documentation, and published package.

## Images

| Image | Purpose | Package |
| --- | --- | --- |
| [`qwen3-embedding`](images/qwen3-embedding/) | Run `Qwen/Qwen3-Embedding-8B` with vLLM on a RunPod GPU Pod | `ghcr.io/valery-judah/knowledge-assistant-qwen3-embedding:v0.29.0-qwen3-8b` |

The repository contains no document corpus, embeddings, model weights, API
keys, private SSH keys, or application environment files.

## Layout

Every directory under `images/` is a separate Docker build context. Build from
the selected image directory so its local `.dockerignore` allowlist is applied.
