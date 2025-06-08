# Operating system levels in this file
FROM python:3.11-alpine3.22
LABEL maintainers="minhappdeveloper.com"

ENV PYTHONUNBUFFERED=1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
# Tạo virtual environment, cài pip và requirements
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-dev \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-dev 

# Tạo user không cần home folder
RUN adduser -D -H django-user

ENV PATH="/py/bin:$PATH"

USER django-user

# CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]