# build stage
FROM node:12-alpine as build-stage
WORKDIR /app

COPY package*.json ./
COPY binding.node /usr/src/app/node-sass/
ENV SASS_BINARY_PATH /usr/src/app/node-sass/binding.node
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories && \
    ## apk add python2 make g++ && \
    npm --registry=https://registry.npm.taobao.org install
COPY . .
ARG action
RUN if [ "$action" ];then \
        echo $action ; \
        npm run $action; \
     else \
        echo $action ; \
        npm run build; \
     fi

# production stage
FROM nginx:alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
