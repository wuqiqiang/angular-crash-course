FROM node:latest

WORKDIR /usr/src/app

COPY ./package.json ./

RUN npm install --registry=https://registry.npm.taobao.org

COPY . .

EXPOSE 4200

CMD ["npm", "run", "start", "--", "--host", "0.0.0.0"]
