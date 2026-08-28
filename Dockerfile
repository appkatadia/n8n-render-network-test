FROM node:22-alpine

RUN apk add --no-cache postgresql-client netcat-openbsd

CMD ["sleep", "3600"]
