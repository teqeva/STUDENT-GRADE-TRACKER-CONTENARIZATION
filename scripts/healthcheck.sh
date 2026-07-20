#!/bin/bash

echo "Running health checks..."
echo ""

# Configuration
FRONTEND_URL=${FRONTEND_URL:-"http://localhost:8080"}
BACKEND_URL=${BACKEND_URL:-"http://localhost:3000"}

# Check frontend
echo "Checking frontend: ${FRONTEND_URL}"
if curl -s -o /dev/null -w "%{http_code}" --max-time 5 ${FRONTEND_URL} | grep -q "200"; then
    echo "Frontend is healthy"
else
    echo "Frontend is not responding"
    exit 1
fi

# Check backend health
echo "Checking backend: ${BACKEND_URL}/health"
if curl -s --max-time 5 ${BACKEND_URL}/health | grep -q "OK"; then
    echo "Backend is healthy"
else
    echo "Backend is not healthy"
    exit 1
fi

# Check backend API
echo "Checking backend API: ${BACKEND_URL}/api/students"
if curl -s --max-time 5 ${BACKEND_URL}/api/students | grep -q "\["; then
    echo "Backend API is responding"
else
    echo "Backend API is not responding"
    exit 1
fi

# Check API through frontend proxy
echo "Checking API through frontend proxy: ${FRONTEND_URL}/api/students"
if curl -s --max-time 5 ${FRONTEND_URL}/api/students | grep -q "\["; then
    echo "Frontend proxy is working"
else
    echo "Frontend proxy is not working"
    exit 1
fi

echo ""
echo "All health checks passed! ✓"
exit 0