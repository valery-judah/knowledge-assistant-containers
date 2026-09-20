# Qwen3 Embedding AWQ image

This directory contains the complete custom layer used by the
`ghcr.io/valery-judah/knowledge-assistant-qwen3-embedding-awq` container image.
It runs the 4-bit AWQ build `LostGentoo/Qwen3-Embedding-8B-AWQ` with vLLM on a
RunPod GPU Pod and provides key-only SSH access for a private tunnel to the
embedding service.

This image is additional to the full-precision `qwen3-embedding` image. It does
not replace that image or its published package.

## What is included

- The pinned `vllm/vllm-openai:v0.29.0` base image.
- `curl` and OpenSSH server packages.
- A small entrypoint that installs a runtime SSH public key and starts vLLM.
- A key-only SSH configuration.
- A pinned revision of the W4A16, group-size-128 AWQ checkpoint.
- Last-token pooling and embedding-runner arguments recommended by the model
  publisher.

The image does not contain model weights, API keys, private SSH keys, a document
corpus, embeddings, or application source code. Model files are downloaded at
runtime into the persistent `/workspace` volume.

The AWQ checkpoint is a third-party quantization of
`Qwen/Qwen3-Embedding-8B`. Its model card reports an on-disk size of about
4.8 GB and publishes quality comparisons with the original BF16 model. Treat it
as a distinct dense model when naming an index and recording its fingerprint.

## Published image

```text
ghcr.io/valery-judah/knowledge-assistant-qwen3-embedding-awq:v0.29.0-qwen3-8b-awq
```

## RunPod template

Use these settings for the initial deployment:

- Template type: Pods
- Compute: NVIDIA GPU
- Recommended compatible GPU: RTX PRO 4000 Blackwell, 24 GB
- Container disk: 40 GB
- Persistent volume: 30 GB or more, mounted at `/workspace`
- TCP port: 22 for SSH
- Public HTTP ports: none

RunPod supplies `PUBLIC_KEY` at container startup. The image validates that key,
starts SSH, and then starts the vLLM embedding server on `127.0.0.1:8000`. Access
to the server is through an SSH tunnel rather than a public HTTP endpoint.

## Build

```sh
docker buildx build --platform linux/amd64 \
  --tag knowledge-assistant-qwen3-embedding-awq:local \
  --load .
```

Run the build command from this directory. The `.dockerignore` file restricts
the build context to the three runtime files.
Upstream software and model use remain subject to their respective licenses.
