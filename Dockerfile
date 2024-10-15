FROM node:14-alpine
WORKDIR /usr/src/app
COPY . .
RUN npm install -g http-server
EXPOSE 99
CMD ["http-server", "-p", "99"]
