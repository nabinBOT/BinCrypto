# Stage 1: Build the frontend
FROM node:20-slim as frontend-builder
WORKDIR /app/frontend
COPY crypto-frontend/package.json crypto-frontend/pnpm-lock.yaml ./ 
RUN npm install -g pnpm && pnpm install --frozen-lockfile
COPY crypto-frontend/ ./
RUN pnpm run build

# Stage 2: Build the backend
FROM python:3.11-slim-buster as backend-builder
WORKDIR /app/backend
COPY cryptography_tool/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY cryptography_tool/ ./

# Stage 3: Final image
FROM python:3.11-slim-buster
WORKDIR /app

# Copy backend code
COPY --from=backend-builder /app/backend ./cryptography_tool

# Install Python dependencies
RUN pip install --no-cache-dir -r cryptography_tool/requirements.txt

# Copy frontend build output
COPY --from=frontend-builder /app/frontend/dist ./crypto-frontend/dist

# Expose the Flask port
EXPOSE 5000

# Set environment variables
ENV FLASK_APP=cryptography_tool/src/main.py
ENV FLASK_RUN_HOST=0.0.0.0

# Run the app
CMD ["python", "cryptography_tool/src/main.py"]
