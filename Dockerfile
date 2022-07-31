# eb init --region=eu-west-1 --profile=epam-admin2
# eb create development --single --cname=varachai-cart-api-dev

# Base
FROM node:16-alpine AS base

WORKDIR /app

# Dependencies
COPY package*.json ./
RUN npm install

# Build
WORKDIR /app
COPY . .
RUN npm run build

# Application
FROM node:16-alpine AS application

COPY --from=base /app/package*.json ./
RUN npm install --only=production
RUN npm install pm2 -g
COPY --from=base /app/dist ./dist

USER node
ENV PORT=8080
EXPOSE 8080

# pm2 start --name="MyPRocess" npm -- run dev
CMD ["pm2", "start",  "dist/main.js"]
