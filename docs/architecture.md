# Student Grade Tracker - Architecture Design

## 1. Service Overview

### Frontend Service

- **Purpose:** Serves the user interface and proxies API requests to the backend.
- **Starter Files:** `frontend/src/index.html`
- **Technology:** Nginx
- **Container Port:** 80
- **Host Port:** 8080

### Backend Service

- **Purpose:** Provides the REST API for managing students and grades.
- **Starter Files:**
  - `backend/package.json`
  - `backend/src/server.js`
- **Technology:** Node.js with Express
- **Container Port:** 3000
- **Host Port:** 3000

### Database Service

- **Purpose:** Stores student and grade data persistently.
- **Starter Files:** `database/init.sql`
- **Technology:** PostgreSQL
- **Container Port:** 5432
- **Host Port:** Not exposed (internal only)

---

## 2. Service Communication Flow

```text
┌─────────────────────────────────────────────────────────────────────┐
│                     Student Grade Tracker                           │
│                                                                     │
│  User Browser                                                       │
│       │                                                             │
│       │ HTTP Request (http://localhost:8080)                        │
│       ▼                                                             │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │                  Frontend (Nginx)                             │  │
│  │  - Serves static HTML files                                   │  │
│  │  - Proxies /api/* requests                                    │  │
│  │  - Container Port: 80                                          │  │
│  └───────────────────────────┬───────────────────────────────────┘  │
│                              │                                      │
│                              │ Proxy /api/*                         │
│                              ▼                                      │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │               Backend (Node.js + Express)                     │  │
│  │  - REST API                                                   │  │
│  │  - /health                                                    │  │
│  │  - /api/students                                              │  │
│  │  - /api/grades                                                │  │
│  │  - Container Port: 3000                                       │  │
│  └───────────────────────────┬───────────────────────────────────┘  │
│                              │                                      │
│                              │ PostgreSQL Connection                │
│                              ▼                                      │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │                Database (PostgreSQL)                          │  │
│  │  - Stores student and grade records                           │  │
│  │  - Initialized using init.sql                                 │  │
│  │  - Container Port: 5432                                       │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                                                     │
│ Docker Network : grade-tracker-network                             │
│ Named Volume   : postgres-data                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### Frontend to Backend Communication

The frontend communicates with the backend through the `/api/*` endpoints.

Nginx forwards API requests to the backend container using the Docker service name.

Example proxy configuration:

```nginx
location /api/ {
    proxy_pass http://backend:3000/api/;
}
```

---

### Backend to Database Communication

The backend connects to PostgreSQL using environment variables supplied by Docker Compose.

Example configuration:

```javascript
const pool = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
});
```

---

## 3. Ports Exposed

| Service | Container Port | Host Port | Purpose |
|---------|---------------:|----------:|---------|
| Frontend | 80 | 8080 | Access the web application |
| Backend | 3000 | 3000 | REST API and health checks |
| Database | 5432 | Not exposed | Internal database communication |

---

## 4. Environment Variables

### Frontend

The frontend is a static Nginx server and does not require environment variables.

### Backend

| Variable | Description |
|----------|-------------|
| `DB_HOST` | Database service hostname |
| `DB_PORT` | Database port |
| `DB_NAME` | PostgreSQL database name |
| `DB_USER` | PostgreSQL username |
| `DB_PASSWORD` | PostgreSQL password |
| `PORT` | Backend application port |

### Database

| Variable | Description |
|----------|-------------|
| `POSTGRES_DB` | Database name |
| `POSTGRES_USER` | PostgreSQL administrator |
| `POSTGRES_PASSWORD` | PostgreSQL password |

---

## 5. Persistent Storage

| Service | Storage | Purpose |
|---------|---------|---------|
| Database | Named volume (`postgres-data`) | Persistent database storage |
| Database | Bind mount (`./database/init.sql`) | Initialize database on first startup |
| Frontend | None | Static files only |
| Backend | None | Stateless application |

### Database Volume

| Property | Value |
|----------|-------|
| Volume Name | `postgres-data` |
| Mount Path | `/var/lib/postgresql/data` |
| Driver | `local` |
| Persistence | Data survives container restarts |

---

## 6. Docker Network

| Property | Value |
|----------|-------|
| Network Name | `grade-tracker-network` |
| Driver | Bridge |
| Purpose | Enable communication between containers |

### Service Communication

| Source | Destination | Protocol | Port |
|--------|-------------|----------|-----:|
| Frontend | Backend | HTTP | 3000 |
| Backend | Database | PostgreSQL | 5432 |

---

## 7. Startup Order

The application starts in the following order:

1. PostgreSQL Database
2. Backend API
3. Frontend

Docker Compose dependencies:

```yaml
database:
  healthcheck: pg_isready

backend:
  depends_on:
    database:
      condition: service_healthy

frontend:
  depends_on:
    backend:
      condition: service_healthy
```

---

## 8. Health Checks

| Service | Health Check | Purpose |
|---------|--------------|---------|
| Frontend | `http://localhost/` | Confirms Nginx is serving content |
| Backend | `/health` | Confirms API and database connectivity |
| Database | `pg_isready` | Confirms PostgreSQL is accepting connections |

---

## 9. Architecture Summary

| Component | Technology | Purpose | Persistent Storage | Host Port |
|-----------|------------|---------|-------------------|----------:|
| Frontend | Nginx | User interface and API proxy | No | 8080 |
| Backend | Node.js + Express | REST API | No | 3000 |
| Database | PostgreSQL | Data storage | Yes | Internal |

### Key Features

- Three isolated Docker containers
- Custom frontend and backend images
- Docker bridge networking
- Persistent PostgreSQL storage
- Health checks for all services
- Environment variable configuration
- Multi-stage backend build
- Non-root containers for improved security
```
````
