# Developer Documentation

## Project Setup From Scratch

### Prerequisites

Make sure the following tools are installed:

- Docker
- Docker Compose
- GNU Make
- OpenSSL

Check with:

```bash
docker --version
docker compose version
make --version
openssl version
```

## Required Host Configuration

Add your domain to /etc/hosts:
```bash
127.0.0.1 <your_login>.42.fr
```

## Project Structure

```bash
.
├── Makefile
├── srcs/
│   ├── docker-compose.yml
│   ├── .env
│   ├── requirements/
│   │   ├── mariadb/
│   │   ├── nginx/
│   │   └── wordpress/
│   └── secrets/
```

## Environment Variables

All non-sensitive configuration values are stored in:

```bash
srcs/.env
```
- database name
- database user
- domain name
- WordPress title

These variables are automatically loaded by Docker Compose.

## Secrets

Sensitive data is stored in:

```
db_root_password.txt
db_password.txt
wp_admin_password.txt
wp_user_password.txt
```

These secrets are mounted at runtime inside containers in:

```
/run/secrets/
```

## Building and Launching the Project

Build images:

*From the root of the repository*

```bash
make build
```

Start the infrastructure

```
make
```

This will:

- Create the data directories in /home/<your_login>/data
- Generate SSL certificates
- Build Docker images
- Start containers

## Stopping the Project

Stop containers:

```
make down
```

Stop and remove everything:

```
make fclean
```

Rebuild from scratch:

```
make re
```

## Useful Docker Commands

List running containers

```
docker ps
```

View logs

```
make logs
```

Access a container shell

```
docker exec -it <container_name> sh
```

Inspect volumes

```
docker volume ls
```

## Data Persistence

All persistent data is stored on the host machine:

```
/home/<your_login>/data/
```

WordPress files

```
/home/<your_login>/data/wp
```

Database files

```
/home/<your_login>/data/db
```

These directories are mounted into containers using bind mounts.

## Docker Volumes

Declared in docker-compose.yml:

- wp_data
- db_data

They use:

```
driver: local
driver_opts:
  type: none
  device: /home/<your_login>/data/...
  o: bind
```

## Docker Network

All services communicate through a dedicated bridge network:

```
wp-network
```

This allows:

- Isolation from the host
- Internal DNS resolution between containers

Example:

WordPress connects to MariaDB using:

```
db:3306
```

## NGINX Configuration Test

To validate the configuration:

```
make nginx-test
```

## Full Cleanup

To remove:

- Containers
- Images
- Volumes
- Networks
- Build cache

```
make fclean
```

## Development Workflow

Typical workflow for making changes:

1. Modify configuration or source files

2. Rebuild images:

```
make build
```

3. Restart containers:

```
make up
```

## Troubleshooting
## Containers not starting

Check logs:

```
make logs
```

## Database connection issues

Inspect MariaDB container:

```
docker compose logs db
```

## Permission issues on volumes

Fix with:

```
sudo chown -R $USER:$USER /home/<your_login>/data
```

## Summary

This project provides:

- A fully reproducible Docker environment
- Secure secret management
- Persistent data storage
- Automated build and deployment via Makefile
