# Base
FROM node:16-alpine AS base

WORKDIR /base-app

# Dependencies
COPY package*.json ./
RUN npm ci

# Build
COPY . ./
RUN npm run build && npm prune --production

# Application
FROM node:16-alpine AS application

COPY --from=base /base-app/dist ./dist
COPY --from=base /base-app/node_modules ./node_modules

USER node
ENV PORT=8080
EXPOSE 8080

CMD ["node", "dist/main.js"]
