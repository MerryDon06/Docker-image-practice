# ---- Base image ----
FROM node:20-alpine

# ---- Set working directory inside the container ----
WORKDIR /usr/src/app

# ---- Install dependencies first (better layer caching) ----
COPY package*.json ./
RUN npm install --omit=dev

# ---- Copy the rest of the application source ----
COPY . .

# ---- Run as a non-root user for better security ----
USER node

# ---- Document the port the app listens on ----
EXPOSE 3000

# ---- Basic container health check ----
HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

# ---- Start the app ----
CMD ["node", "app.js"]

