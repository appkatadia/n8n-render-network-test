FROM node:22-alpine

RUN apk add --no-cache postgresql-client netcat-openbsd

RUN npm install pg

EXPOSE 3000

COPY test.sh /test.sh
RUN chmod +x /test.sh

CMD ["/test.sh"]