# Qwen3 Embedding image

This directory contains the complete custom layer used by the
`ghcr.io/valery-judah/knowledge-assistant-qwen3-embedding` container image.
It runs `Qwen/Qwen3-Embedding-8B` with vLLM on a RunPod GPU Pod and provides
key-only SSH access for a private tunnel to the embedding service.

## What is included

- The pinned `vllm/vllm-openai:v0.29.0` base image.
- `curl` and OpenSSH server packages.
- A small entrypoint that installs a runtime SSH public key and starts vLLM.
- A key-only SSH configuration.
- Pinned Qwen model and vLLM startup arguments.

The image does not contain model weights, API keys, private SSH keys, a document
corpus, embeddings, or application source code. Qwen model files are downloaded
at runtime into the persistent `/workspace` volume.

## Published image

```text
ghcr.io/valery-judah/knowledge-assistant-qwen3-embedding:v0.29.0-qwen3-8b
```

## RunPod template

Use these settings for the current deployment:

- Template type: Pods
- Compute: NVIDIA GPU
- Recommended compatible GPU: A100 PCIe
- Container disk: 40 GB
- Persistent volume: 100 GB mounted at `/workspace`
- TCP port: 22 for SSH
- Public HTTP ports: none

RunPod supplies `PUBLIC_KEY` at container startup. The image validates that key,
starts SSH, and then starts the vLLM embedding server on `127.0.0.1:8000`. Access
to the server is through an SSH tunnel rather than a public HTTP endpoint.

## Build

```sh
docker buildx build --platform linux/amd64 \
  --tag knowledge-assistant-qwen3-embedding:local \
  --load .
```

Run the build command from this directory. The `.dockerignore` file restricts
the build context to the three runtime files.
Upstream software and model use remain subject to their respective licenses.
