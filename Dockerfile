FROM node:lts-alpine as build
WORKDIR /app
COPY package.json ./
RUN npm install
COPY . .
RUN pwd
RUN ls
RUN npm run build

FROM nginx:mainline-alpine as prod
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
COPY docker-entrypoint.sh /app/docker-entrypoint.sh
RUN chmod +x /app/docker-entrypoint.sh
ENTRYPOINT ["/app/docker-entrypoint.sh"]