*This project has been created as part of the 42 curriculum by amugisha.*

# Inception

## Description

Inception is a system administration project focused on containerization using Docker.  
The goal is to build a small infrastructure composed of multiple services running in isolated containers and orchestrated with Docker Compose.

The project consists of:

- A **MariaDB** database container
- A **WordPress** container running with PHP-FPM
- An **Nginx** container acting as a reverse proxy with SSL (HTTPS)
- Persistent volumes for database and website data
- Docker secrets for sensitive credentials

The entire stack runs inside Docker containers without using pre-built images (except base OS images), ensuring full control over configuration and security.

---

## Project Architecture

The infrastructure is composed of three main services:

- **Nginx** (HTTPS only, port 443)
- **WordPress + PHP-FPM**
- **MariaDB**

Each service:
- Has its own Dockerfile
- Runs in its own container
- Communicates through a Docker bridge network
- Uses persistent volumes for data storage

Sensitive information (database passwords, admin passwords) is managed using Docker secrets.

---

## Design Choices

### Why Docker?

Docker allows lightweight containerization compared to traditional virtual machines.  
It ensures reproducibility, isolation, and portability of services.

### Virtual Machines vs Docker

| Virtual Machines | Docker |
|------------------|--------|
| Full OS per VM | Shared host kernel |
| Heavy resource usage | Lightweight |
| Slower startup | Fast startup |
| Hardware-level virtualization | OS-level virtualization |

Docker is more efficient for microservice-based architectures like this project.

---

### Secrets vs Environment Variables

| Secrets | Environment Variables |
|----------|----------------------|
| Encrypted and mounted securely | Visible in container environment |
| Stored in `/run/secrets/` | Accessible via `printenv` |
| Used for sensitive data | Used for configuration |

In this project:
- Database passwords use **Docker secrets**
- Configuration values use **environment variables**

---

### Docker Network vs Host Network

| Bridge Network | Host Network |
|---------------|-------------|
| Isolated container communication | Shares host network |
| Secure and controlled | Less isolated |
| Custom network creation | Direct host exposure |

This project uses a **custom bridge network** to isolate services and allow internal communication between containers.

---

### Docker Volumes vs Bind Mounts

| Docker Volumes | Bind Mounts |
|----------------|------------|
| Managed by Docker | Linked to host filesystem |
| Portable | Host-dependent |
| Better abstraction | Direct host access |

In this project:
- Database and WordPress data use **bind mounts** for persistence.
- This ensures data remains available even if containers are removed.

---

## Instructions

### 1. Requirements

- Docker
- Docker Compose
- Linux environment

### 2. Clone the repository

```bash
git clone <repository_url>
cd inception
