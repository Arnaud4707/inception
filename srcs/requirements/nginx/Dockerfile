FROM alpine:3.22

RUN apk add --no-cache nginx

COPY nginx.conf /etc/nginx/nginx.conf

COPY certs/server.key /etc/nginx/ssl/server.key
COPY certs/server.crt /etc/nginx/ssl/server.crt

RUN chown root:nginx /etc/nginx/ssl/server.key /etc/nginx/ssl/server.crt \
    && chmod 640 /etc/nginx/ssl/server.key /etc/nginx/ssl/server.crt

RUN mkdir -p /var/cache/nginx /var/run && \
    chown -R nginx:nginx /var/cache/nginx /var/run /etc/nginx \
    && chmod -R 755 /var/cache/nginx /var/run /etc/nginx

USER nginx

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
