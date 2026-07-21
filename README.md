# Student Grade Tracker

> A production-ready, containerized three-tier web application for managing student grades, built with Docker and Docker Compose.

![License](https://img.shields.io/badge/License-Educational-blue)
![Docker Compose](https://img.shields.io/badge/Docker%20Compose-v2.20+-blue)
![Build](https://img.shields.io/badge/Build-Passing-brightgreen)
![GitHub last commit](https://img.shields.io/github/last-commit/teqeva/STUDENT-GRADE-TRACKER-CONTENARIZATION)
![GitHub repo size](https://img.shields.io/github/repo-size/teqeva/STUDENT-GRADE-TRACKER-CONTENARIZATION)
[![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)](https://www.docker.com/)
[![Node.js](https://img.shields.io/badge/Node.js-339933?style=flat&logo=nodedotjs&logoColor=white)](https://nodejs.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=flat&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Nginx](https://img.shields.io/badge/Nginx-009639?style=flat&logo=nginx&logoColor=white)](https://nginx.org/)

---

## Table of Contents

- [Overview](#overview)
- [Key Highlights](#key-highlights)
- [Features](#features)
- [Architecture](#architecture)
- [Technology Stack](#technology-stack)
- [Docker Features](#docker-features)
- [Security Best Practices](#security-best-practices)
- [Project Structure](#project-structure)
- [Services](#services)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [API Endpoints](#api-endpoints)
- [Docker Commands](#docker-commands)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)
- [Deployment](#deployment)
- [Author](#author)

---

## Overview

**Student Grade Tracker** is a web application that helps teachers manage student grades efficiently. It is built as a **three-tier containerized stack**:

- **Frontend** – Nginx serves the user interface.
- **Backend** – Node.js + Express provides a REST API.
- **Database** – PostgreSQL stores all student and grade data.

All services are orchestrated with Docker Compose, ensuring portability, reproducibility, and security.

---

## Key Highlights

- Three-tier architecture (frontend, backend, database)
- Docker Compose orchestration
- Reverse proxy with Nginx
- RESTful API using Express
- PostgreSQL persistence with named volumes
- Health checks on all services
- Multi-stage Docker builds
- Non-root users for container security
- Vulnerability scanning with Trivy

---

## Features

| Feature | Description |
|---------|-------------|
| Add Students | Register students with name and email |
| Record Grades | Add grades for any subject |
| View Statistics | Class average, top score, total students and grades |
| Grade History | View all grades in a sortable table |
| Dockerized | Runs anywhere with Docker |
| Secure | Non-root users, health checks, multi-stage builds |
| Persistent | Data survives container restarts |

---

## Architecture

The application follows a classic **three-tier architecture** where the frontend communicates with the backend through an Nginx reverse proxy, and the backend interacts with PostgreSQL over an isolated Docker network.

### Request Flow

```text
┌─────────────────────────────────────────────────────────────────────────────────────────────┐
│                                     DOCKER HOST                                             │
│                                                                                             │
│  User Browser                                                                               │
│       │                                                                                      │
│       │ http://localhost:8080                                                               │
│       ▼                                                                                      │
│  ┌─────────────────────────────────────────────────────────────────────────────────────┐   │
│  │                       DOCKER BRIDGE NETWORK                                         │   │
│  │                       grade-tracker-network                                          │   │
│  │                                                                                     │   │
│  │  ┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐              │   │
│  │  │   FRONTEND      │─────▶│    BACKEND      │─────▶│    DATABASE     │              │   │
│  │  │   (Nginx)       │      │  (Node.js)      │      │  (PostgreSQL)   │              │   │
│  │  │   Port: 80      │      │   Port: 3000    │      │   Port: 5432    │              │   │
│  │  │   User: nginx   │      │   User: appuser │      │   User: postgres│              │   │
│  │  └─────────────────┘      └─────────────────┘      └────────┬────────┘              │   │
│  │         │                         │                        │                        │   │
│  │         │                         │                        │                        │   │
│  │         ▼                         ▼                        ▼                        │   │
│  │    Host Port: 8080          Host Port: 3000         Named Volume                    │   │
│  │    Container: 80            Container: 3000         postgres-data                    │   │
│  │                                                     Mount: /var/lib/postgresql/data │   │
│  │                                                                                     │   │
│  │                                                     Bind Mount                      │   │
│  │                                                     init.sql                        │   │
│  │                                                     Mount: /docker-entrypoint-      │   │
│  │                                                     initdb.d/init.sql               │   │
│  └─────────────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                             │
└─────────────────────────────────────────────────────────────────────────────────────────────┘
```

### How It Works

1. The user opens [http://localhost:8080](http://localhost:8080) in their browser.
2. Nginx serves the HTML page with JavaScript.
3. JavaScript makes API calls like `fetch('/api/students')`.
4. Nginx proxies `/api/*` requests to `http://backend:3000/api/*`.
5. The backend processes the request and queries PostgreSQL.
6. The database returns the data.
7. The response flows back through Nginx to the browser.
8. JavaScript updates the page with the data.

All services communicate over a **custom Docker network** called `grade-tracker-network`.

---

## Application Preview

---

## Technology Stack

| Area | Tools |
|------|-------|
| **Frontend** | HTML, CSS, JavaScript, Nginx 1.26.0-alpine |
| **Backend** | Node.js 20-alpine, Express 4.19.2, pg 8.12.0 |
| **Database** | PostgreSQL 15-alpine |
| **Containerization** | Docker 24.0+, Docker Compose v2.20+ |
| **Security** | Trivy 0.72.0 for vulnerability scanning |

### Why These Technologies?

- **Docker** – Portability, isolation, and reproducibility.
- **Node.js + Express** – Lightweight, fast, and event-driven; ideal for APIs.
- **Nginx** – Excellent static file server and reverse proxy; Alpine version is tiny (~5MB).
- **PostgreSQL** – ACID-compliant relational database for structured data.
- **Alpine Linux** – Minimal base images (~5MB) with a small attack surface.

---

## Docker Features

| Feature | Implementation |
|---------|----------------|
| **Docker Compose orchestration** | All services defined in a single file |
| **Multi-stage builds** | Production images exclude dev dependencies, keeping them small and secure |
| **Named volumes** | Persistent database storage (`postgres-data`) |
| **Custom bridge network** | Service discovery by name (`backend`, `database`) |
| **Health checks** | Each service has a health check for automatic recovery |
| **Restart policies** | `unless-stopped` ensures containers restart on failure |

---

## Security Best Practices

| Practice | Implementation |
|----------|----------------|
| **Non-root users** | Frontend: `nginx`, Backend: `appuser` |
| **Pinned image versions** | No `latest` – specific tags for reproducibility |
| **Environment variables** | Secrets in `.env` (excluded from Git) |
| **.dockerignore** | Excludes env files, logs, IDE files |
| **Alpine base images** | Minimal attack surface |
| **Vulnerability scanning** | Trivy scans for CVEs |

---

## Project Structure

```
student-grade-tracker/
│
├── frontend/
│   ├── Dockerfile          # Nginx with non-root user
│   ├── .dockerignore
│   ├── nginx.conf          # Reverse proxy configuration
│   └── src/
│       └── index.html
│
├── backend/
│   ├── Dockerfile          # Multi-stage build
│   ├── .dockerignore
│   ├── package.json
│   └── src/
│       └── server.js
│
├── database/
│   └── init.sql            # Schema and seed data
│
├── scripts/
│   ├── build.sh
│   └── healthcheck.sh
│
├── docs/
│   ├── architecture.md
│   └── images/
│       ├── dashboard.png
│       └── record-grade.png
│
├── docker-compose.yml
├── .env.example
├── .gitignore
└── README.md
```

---

## Services

| Service | Container Image | Port | Responsibility |
|---------|-----------------|------|----------------|
| **Frontend** | `teqiee/student-grade-tracker-frontend:<version>` | 8080 | Serves UI and proxies API requests |
| **Backend** | `teqiee/student-grade-tracker-backend:<version>` | 3000 | REST API for students and grades |
| **Database** | `postgres:15-alpine` | Internal (5432) | Persistent data storage |

---

## Getting Started


## Prerequisites

Before you begin, ensure you have the following installed on your system:

### Required Software

| Tool | Minimum Version | Purpose |
|------|-----------------|---------|
| [Docker Engine](https://docs.docker.com/engine/install/) | 20.10 or later | Container runtime for running the application |
| [Docker Compose](https://docs.docker.com/compose/install/) | v2.20 or later | Multi-container orchestration |
| [Git](https://git-scm.com/downloads) | Latest stable | Cloning the repository |

### Optional (for development)

| Tool | Purpose |
|------|---------|
| [Trivy](https://github.com/aquasecurity/trivy) | Vulnerability scanning |

### Verify Installation

Run the following commands to confirm everything is installed correctly:

```bash
# Check Docker version
docker --version

# Check Docker Compose version
docker compose version

# Check Git version
git --version

### 1. Clone the Repository

```bash
git clone https://github.com/teqeva/STUDENT-GRADE-TRACKER-CONTENARIZATION.git
cd STUDENT-GRADE-TRACKER-CONTENARIZATION
```

### 2. Configure Environment Variables

```bash
cp .env.example .env
```

Edit `.env` with your secure values:

```env
POSTGRES_DB=grades_db
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_secure_password
DB_HOST=database
DB_PORT=5432
DB_NAME=grades_db
DB_USER=postgres
DB_PASSWORD=your_secure_password
PORT=3000
```

### 3. Build and Start the Stack

```bash
docker compose up --build -d
```

Allow a few seconds for all containers to initialize and report a healthy status.

### 4. Verify Everything is Healthy

```bash
docker compose ps
```

All services should show `(healthy)`.

### 5. Access the Application

Once all services are healthy, open:

[http://localhost:8080](http://localhost:8080)

### 6. Stop the Application

```bash
# Stop containers (keep data)
docker compose down

# Stop and remove all data
docker compose down -v
```

---

## Usage

### Add a Student

1. Enter a name (e.g., "Eva Muhtoni") and email.
2. Click **"Add Student"**.
3. Success message appears, student count updates.

### Record a Grade

1. Select a student from the dropdown.
2. Enter a subject and score (0–100).
3. Click **"Record Grade"**.
4. Grade appears in the table, statistics update.

### View Statistics

- **Students** – Total number of students
- **Grades Recorded** – Total number of grades
- **Class Average** – Average score across all grades
- **Top Score** – Highest score recorded

---

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/health` | Health check |
| GET | `/api/students` | List all students |
| POST | `/api/students` | Add a new student |
| GET | `/api/grades` | List all grades |
| POST | `/api/grades` | Record a new grade |

### Example: Add a Student

```bash
curl -X POST http://localhost:3000/api/students \
  -H "Content-Type: application/json" \
  -d '{"name":"Eva Muthoni","email":"lakita@kubeverse.io"}'
```

Response:
```json
{
  "id": 6,
  "name": "Eva Muthoni",
  "email": "lakita@kubeverse.io"",
  "created_at": "2026-07-20T10:30:00.000Z"
}
```

---

## Docker Commands

| Command | Description |
|---------|-------------|
| `docker compose up -d` | Start all services in background |
| `docker compose down` | Stop and remove containers |
| `docker compose down -v` | Stop and remove containers + volumes |
| `docker compose ps` | Show running containers |
| `docker compose logs -f` | Follow all logs |
| `docker compose logs backend` | View backend logs |
| `docker compose exec backend sh` | Open shell in backend |
| `docker compose exec database psql -U postgres -d grades_db` | Connect to PostgreSQL |
| `docker compose restart` | Restart all services |
| `docker compose build` | Rebuild images |

---

## Testing

### Run the Health Check Script

```bash
chmod +x scripts/healthcheck.sh
./scripts/healthcheck.sh
```

Expected output:
```
Running health checks...

Checking frontend: http://localhost:8080
Frontend is healthy
Checking backend: http://localhost:3000/health
Backend is healthy
Checking backend API: http://localhost:3000/api/students
Backend API is responding
Checking API through frontend proxy: http://localhost:8080/api/students
Frontend proxy is working

```

### Manual Tests

```bash
# Test backend health
curl http://localhost:3000/health

# Test frontend
curl http://localhost:8080

# Test API
curl http://localhost:3000/api/students

# Test API through frontend proxy
curl http://localhost:8080/api/students

# Check database
docker compose exec database psql -U postgres -d grades_db -c "SELECT COUNT(*) FROM students;"
```

### Data Persistence Test

```bash
# Restart the database
docker compose restart database
sleep 5

# Data should still be there
curl http://localhost:3000/api/students | grep "Alice"
```

---

## Troubleshooting

### Port Already in Use

Change the host port in `docker-compose.yml`:

```yaml
frontend:
  ports:
    - "8081:80"
```

Then access at [http://localhost:8081](http://localhost:8081).

### Database Fails to Start

```bash
docker compose logs database
docker compose down -v
docker compose up -d
```

### Backend Can't Connect to Database

Wait for the database health check to pass, then restart the backend.

### View Logs

```bash
docker compose logs -f backend
```

### Permission Denied

```bash
chmod +x scripts/*.sh
```

## Deployment

### Using Prebuilt Docker Hub Images

```bash
docker compose pull
docker compose up -d
```

### Building Locally

```bash
docker compose up --build -d
```


## Author

**Eva Muthoni**

- GitHub: [@teqeva](https://github.com/teqeva)
- Docker Hub: [@teqiee](https://hub.docker.com/u/teqiee)
---

