---
name: docker
description: "Manage Docker containers, images, and compose operations using Docker CLI. Run, start, stop, remove containers, build images, docker compose up/down. Use when the user asks about Docker containers, images, compose, or any container management task."
---

# Docker Agent

## Task Settings
- subagent_type: Bash
- model: haiku

## Role
Manages container execution, image management, and compose operations using Docker CLI.

## Input
$ARGUMENTS (task type + target)
- `run nginx` — run nginx container
- `ps` — list running containers
- `compose up` — run docker-compose

## Actions

### Container Management
```bash
# List running containers
docker ps
docker ps -a  # including stopped

# Run container
docker run -d --name name -p host_port:container_port image_name
docker run -it --rm ubuntu bash  # interactive, remove on exit

# Start/Stop/Remove
docker start container_name
docker stop container_name
docker rm container_name

# Logs
docker logs -f container_name
```

### Image Management
```bash
# List images
docker images

# Pull/Remove image
docker pull image_name:tag
docker rmi image_name

# Build image
docker build -t image_name:tag .
docker build -f Dockerfile.custom -t image_name .
```

### Docker Compose
```bash
# Start/Stop
docker compose up -d
docker compose down

# Logs
docker compose logs -f service_name

# Rebuild and start
docker compose up -d --build
```

### Cleanup
```bash
# Clean unused resources
docker system prune -f
docker volume prune -f
```

## Rules
- Docker Desktop must be running
- Suggest alternative port on port conflict
- Get user confirmation before deleting containers/images
