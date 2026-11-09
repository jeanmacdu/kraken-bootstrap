FROM python:3.12-slim

# Pas de .pyc écrits dans l'image, logs non bufferisés (visibles tout de suite dans docker logs)
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    OUTPUT_DIR=output

# Utilisateur non-root (uid 1000)
RUN useradd --create-home --uid 1000 app

WORKDIR /app

# Dépendances d'abord : cette couche reste en cache tant que requirements.txt ne change pas
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY --chown=app:app app/ app/
COPY --chown=app:app data/ data/

# Dossier de sortie par défaut, inscriptible par l'utilisateur non-root
RUN mkdir -p output && chown app:app output

USER app

CMD ["python", "-m", "app.main"]
