FROM node:22-alpine

RUN apk add --no-cache postgresql-client netcat-openbsd

WORKDIR /app

RUN npm init -y && npm install pg

COPY test.sh /test.sh
RUN chmod +x /test.sh

EXPOSE 3000

CMD ["/test.sh"]