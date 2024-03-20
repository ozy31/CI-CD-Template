FROM node:12-alpine
WORKDIR /app
COPY . .
RUN yarn install --dev
CMD ["node", "/app/src/index.js"]