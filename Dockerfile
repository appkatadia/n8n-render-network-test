FROM node:22-alpine

RUN apk add --no-cache postgresql-client netcat-openbsd

EXPOSE 3000

CMD ["node", "-e", "require('http').createServer((req,res)=>{res.end('network-test')}).listen(3000,'0.0.0.0')"]