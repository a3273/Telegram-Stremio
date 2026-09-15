FROM python:3.12-slim-bookworm

# Copia il binario uv dall'immagine ufficiale
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Imposta le variabili d'ambiente
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV LANG=en_US.UTF-8
ENV PATH="/app/.venv/bin:$PATH"

# Installa le dipendenze di sistema
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        bash \
        git \
        curl \
        ca-certificates \
        locales && \
    locale-gen en_US.UTF-8 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

# Sincronizza le dipendenze con uv
RUN uv sync --locked

RUN chmod +x start.sh

CMD ["bash", "start.sh"]
