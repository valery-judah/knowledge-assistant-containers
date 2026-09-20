# syntax=docker/dockerfile:1.7

ARG VLLM_IMAGE="vllm/vllm-openai:v0.29.0@sha256:c2914767605584b6d8f45686b82de173ecc99e781897aa3d0a66dacd72c51ae1"
FROM ${VLLM_IMAGE}

USER root

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
        curl \
        openssh-server \
    && rm -rf /var/lib/apt/lists/*

COPY sshd_config.conf /etc/ssh/sshd_config.d/99-runpod-key-only.conf
COPY entrypoint.sh /usr/local/bin/knowledge-assistant-runpod-entrypoint

RUN chmod 0755 /usr/local/bin/knowledge-assistant-runpod-entrypoint \
    && mkdir -p /run/sshd

LABEL org.opencontainers.image.source="https://github.com/valery-judah/knowledge-assistant-containers"

ENV HF_HOME=/workspace/.cache/huggingface \
    VLLM_ENABLE_V1_MULTIPROCESSING=0

EXPOSE 22

HEALTHCHECK --interval=30s --timeout=5s --start-period=15m --retries=3 \
    CMD curl --fail --silent --show-error http://127.0.0.1:8000/health >/dev/null || exit 1

STOPSIGNAL SIGTERM

ENTRYPOINT ["/usr/local/bin/knowledge-assistant-runpod-entrypoint"]
CMD ["Qwen/Qwen3-Embedding-8B", "--revision", "1d8ad4ca9b3dd8059ad90a75d4983776a23d44af", "--served-model-name", "Qwen/Qwen3-Embedding-8B", "--runner", "pooling", "--host", "127.0.0.1", "--port", "8000", "--dtype", "auto", "--enforce-eager", "--gpu-memory-utilization", "0.90", "--max-model-len", "1024"]
