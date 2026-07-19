#!/bin/bash

# Build script for Student Grade Tracker
# Usage: ./scripts/build.sh [version]

# Exit on error
set -e

# Get version from argument or use default
VERSION=${1:-"1.0.0"}

echo "Building Student Grade Tracker images"
echo "Version: ${VERSION}"
echo ""

# Build frontend
echo "Building frontend..."
if docker build -t "grade-tracker-frontend:${VERSION}" -f ./frontend/Dockerfile ./frontend; then
    echo "✓ Frontend built successfully: grade-tracker-frontend:${VERSION}"
else
    echo "✗ Failed to build frontend"
    exit 1
fi
echo ""

# Build backend
echo "Building backend..."
if docker build -t "grade-tracker-backend:${VERSION}" -f ./backend/Dockerfile ./backend; then
    echo "✓ Backend built successfully: grade-tracker-backend:${VERSION}"
else
    echo "✗ Failed to build backend"
    exit 1
fi
echo ""

echo "All images built successfully!"


