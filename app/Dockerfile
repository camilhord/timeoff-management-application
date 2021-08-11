# -------------------------------------------------------------------
# Minimal dockerfile from alpine base
#
# Instructions:
# =============
# 1. Create an empty directory and copy this file into it.
#
# 2. Create image with: 
#	docker build --tag timeoff:latest .
#
# 3. Run with: 
#	docker run -d -p 3000:3000 --name alpine_timeoff timeoff
#
# 4. Login to running container (to update config (vi config/app.json): 
#	docker exec -ti --user root alpine_timeoff /bin/sh
# --------------------------------------------------------------------
FROM node:13.0.0-alpine

EXPOSE 8080

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.docker.cmd="docker run -d -p 8080:8080 --name alpine_timeoff"

RUN apk add --no-cache \
    git \
    make \
    python \
    vim

RUN adduser --system app --home /app

USER app
WORKDIR /app

COPY --chown=app:root . /app/timeoff-management

WORKDIR /app/timeoff-management

ENV NODE_ENV production

RUN npm install mysql
RUN npm install

CMD PORT=8080 npm start
