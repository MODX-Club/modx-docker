FROM docker:24-dind

RUN apk add --no-cache docker-compose bash curl

WORKDIR /project

COPY . /project/

RUN chmod +x /project/entrypoint.sh

ENTRYPOINT ["/project/entrypoint.sh"]
