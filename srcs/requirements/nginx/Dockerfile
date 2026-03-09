FROM alpine:3.22

# Install nginx and openssl
RUN apk add --no-cache nginx

# # Copy the config of nginx
COPY nginx.conf /etc/nginx/nginx.conf
# COPY index.html /usr/share/nginx/html

# Expose HTTPS's port
EXPOSE 443

# Launch nginx
CMD ["nginx", "-g", "daemon off;"]
