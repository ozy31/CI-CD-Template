FROM node:20-alpine AS test
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY spec ./spec
COPY src ./src
RUN npm test

FROM node:20-alpine
WORKDIR /app
ENV NODE_ENV=production \
    SQLITE_DB_LOCATION=/app/data/todo.db
COPY package.json package-lock.json ./
RUN npm ci --omit=dev && mkdir -p /app/data && chown node:node /app/data
COPY src ./src
USER node
EXPOSE 3000
CMD ["node", "src/index.js"]
