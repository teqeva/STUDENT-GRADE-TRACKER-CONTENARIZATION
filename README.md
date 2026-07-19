# Student Grade Tracker

A containerized 3-tier web application for tracking student grades using Docker and Docker Compose.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [Services](#services)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [How to Use the Application](#how-to-use-the-application)
- [Docker Commands](#docker-commands)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)
- [Security Features](#security-features)
- [Author](#author)

---

# Project Overview

Student Grade Tracker is a containerized three-tier web application for managing student records and grades.

The application enables users to:

- Add students with a name and email address.
- Record grades for different subjects.
- View all recorded grades.
- Display class statistics, including the average score, highest score, and total number of students.

---

# Architecture

```text
┌─────────────────────────────────────────────────────────────────────┐
│                     Student Grade Tracker                           │
│                                                                     │
│  User Browser                                                       │
│       │                                                             │
│       ▼                                                             │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │                  Nginx (Frontend)                             │  │
│  │  Serves the HTML user interface                               │  │
│  │  Host Port: 8080                                               │  │
│  └───────────────────────────┬───────────────────────────────────┘  │
│                              │                                      │
│                        HTTP /api/* Requests                         │
│                              ▼                                      │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │               Node.js REST API (Backend)                      │  │
│  │  Internal Port: 3000                                          │  │
│  │  Processes application requests                               │  │
│  └───────────────────────────┬───────────────────────────────────┘  │
│                              │                                      │
│                      PostgreSQL Connection                          │
│                              ▼                                      │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │                  PostgreSQL Database                          │  │
│  │  Internal Port: 5432                                          │  │
│  │  Stores students and grades                                   │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  Docker Network: grade-tracker-network                             │
│  Docker Volume : postgres-data                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---
# Services

| Service | Docker Image | Port | Description |
|---------|--------------|------|-------------|
| Frontend | `teqiee/student-grade-tracker-frontend:1.0.0` | 8080 | Serves the web interface using Nginx |
| Backend | `teqiee/student-grade-tracker-backend:1.0.0` | 3000 | Provides the REST API |
| Database | `postgres:15-alpine` | 5432 | Stores application data |

---

# Prerequisites

Before starting, ensure you have installed:

- Docker Engine 20.10 or newer
- Docker Compose 2.x
- Git

Verify the installation:

```bash
docker --version
docker compose version
git --version
```

---

# Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/yourusername/student-grade-tracker.git
cd student-grade-tracker
```

### 2. Configure the environment

```bash
cp .env.example .env
```

Update the values inside `.env`.

### 3. Build the Docker images

```bash
docker compose build
```

### 4. Start the application

```bash
docker compose up -d
```

### 5. Verify all services

```bash
docker compose ps
```

All services should report a **healthy** status.

### 6. Open the application

Visit:

```
http://localhost:8080
```

### 7. Stop the application

```bash
docker compose down
```

To remove all stored data:

```bash
docker compose down -v
```

---

# How to Use the Application

After opening the application:

1. Add a student by entering their name and email.
2. Select a student from the dropdown list.
3. Enter a subject and score.
4. Submit the grade.
5. View the updated statistics.
6. Review all recorded grades in the table.

---

# Docker Commands

| Command | Description |
|---------|-------------|
| `docker compose up -d` | Start all services |
| `docker compose down` | Stop all services |
| `docker compose down -v` | Remove containers and volumes |
| `docker compose build` | Build Docker images |
| `docker compose restart` | Restart all services |
| `docker compose ps` | Show running containers |
| `docker compose logs -f` | View all logs |
| `docker compose logs backend` | View backend logs |
| `docker compose exec backend sh` | Open backend shell |
| `docker compose exec database psql -U postgres -d grades_db` | Connect to PostgreSQL |

---

# Testing

Run the health check script:

```bash
chmod +x scripts/healthcheck.sh
./scripts/healthcheck.sh
```

Manual checks:

```bash
curl http://localhost:8080
```

```bash
curl http://localhost:3000/health
```

```bash
curl http://localhost:8080/api/students
```

Check database connectivity:

```bash
docker compose exec database psql -U postgres -d grades_db -c "SELECT 1;"
```

---

# Troubleshooting

### Port already in use

Modify the port mapping in `docker-compose.yml`.

Example:

```yaml
ports:
  - "8081:80"
```

---

### Database will not start

```bash
docker compose logs database
```

Reset the database:

```bash
docker compose down -v
docker compose up -d
```

---

### Backend cannot connect to the database

```bash
docker compose ps
```

```bash
docker compose logs backend
```

Wait for PostgreSQL to become healthy before restarting the backend.

---

### Missing `.env`

```bash
cp .env.example .env
```

Update the environment variables.

---

### Permission denied

```bash
chmod +x scripts/*.sh
```

---

### View logs

```bash
docker compose logs -f
```

Specific service:

```bash
docker compose logs -f backend
```

---

# Security Features

- Runs containers as non-root users.
- Uses specific image versions.
- Implements Docker health checks.
- Uses `.dockerignore` files.
- Stores secrets in environment variables.
- Uses multi-stage Docker builds.
- Uses lightweight Alpine Linux images.

---

# Author

**Eva Muthoni**

- GitHub: https://github.com/teqeva
- Email: evaamuthoni@gmail.com