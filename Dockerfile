FROM python:3.10-alpine AS builder

WORKDIR /app

RUN apk add --no-cache build-base gfortran openblas-dev

COPY requirements/ requirements/
RUN pip install --user --no-cache-dir -r requirements/backend.txt

FROM python:3.10-alpine

WORKDIR /app

RUN apk add --no-cache openblas

COPY --from=builder /root/.local /root/.local

ENV PATH=/root/.local/bin:$PATH \
    PYTHONPATH=/app

COPY build/ build/
COPY spaceship/ spaceship/

CMD ["uvicorn", "spaceship.main:app", "--host", "0.0.0.0", "--port", "8000"]