# User Documentation

## Overview

This project provides a complete WordPress website running in a Dockerized infrastructure.

The stack is composed of:

- **NGINX** → Secure HTTPS web server (entry point)
- **WordPress** → Content management system
- **MariaDB** → Database for WordPress

All services run in isolated containers and communicate through a private Docker network.

---

## Starting the Project

From the root of the repository, run:

*From the root of folder*
```bash
make
```

This will:

- Build the Docker images

- Create the required volumes

- Generate SSL certificates (if not already present)

- Start all containers

## Stopping the Project

To stop the containers:

```bash
make down
```

To stop and remove everything (containers, images, volumes):

```bash
make fclean
```

## Accessing the Website

Once the project is running, open your browser and go to:

```cpp
https://<your_login>.42.fr
```
**You must have this line in your /etc/hosts**:

```
127.0.0.1 <your_login>.42.fr
```

Because a self-signed certificate is used, your browser will display a security warning.
You can safely accept it.

## Accessing the WordPress Administration Panel

Go to:

```
https://<your_login>.42.fr/wp-admin
```

Log in using the administrator credentials defined during the setup.

## Credentials Management

All sensitive data is stored using Docker secrets.

Secrets are located in:

```
srcs/secrets/
```
- db_root_password.txt
- db_password.txt
- wp_admin_password.txt
- wp_user_password.txt

They are automatically injected into the containers at runtime.

## Verifying That Services Are Running
### Check containers 

*FRom requirements folder*
```
docker ps
```
You should see:

- nginx
- wordpress (php-fpm)
- mariadb

## Check logs

*From the root of folder*
```bash
make logs
```

## Test NGINX configuration

```bash
make nginx-test
```

## Checking Data Persistence

Project data is stored on the host in:

```bash
/home/<your_login>/data/
```

## Restarting the Project

If needed in srcs folder then:

```bash
make re
```

This will completely rebuild and restart the infrastructure.

## Common Issues

Website not accessible

Make sure:

- The containers are running → docker ps
- Your domain is present in /etc/hosts
- Port 443 is not already used

## Database connection error

Check MariaDB logs:

*From requirements folder*
```bash
docker compose logs db
```

## Summary

This project allows you to:

- Run a secure WordPress website
- Use Docker for full service isolation
- Keep persistent data
- Manage credentials safely using secrets