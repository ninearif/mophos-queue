FROM mophos/mmis-nginx

LABEL maintainer="Satit Rianpit <rianpit@gmail.com>"

WORKDIR /home/queue

RUN apk add --upgrade --no-cache --virtual deps python build-base

RUN npm i npm@latest -g

RUN npm i -g pm2

COPY ./queue-api ./queue-api

COPY ./queue-web ./queue-web

COPY ./queue-mqtt ./queue-mqtt

RUN cd queue-web && npm i && npm run build && cd ..

RUN cd queue-api && npm i && npm i mssql@4.1.0 && npm run build && cd ..

RUN cd queue-mqtt && npm i && cd ..

COPY ./queue-docker/nginx.conf /etc/nginx/

COPY ./queue-docker/process.json .

CMD /usr/sbin/nginx && /usr/bin/pm2-runtime process.json
