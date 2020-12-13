# Base Node image
FROM node:lts AS base
WORKDIR /app

# Dependencies
FROM base AS dependencies
WORKDIR /app
# Copy package*.json files, install dependencies
COPY ./package*.json ./
# Install packages and clear npm cache
RUN npm install && npm cache clean --force
# then copy everything else

# Copy files/Build
FROM dependencies AS build
WORKDIR /app
COPY . .
RUN npm run build

# Release with Alpine
FROM node:lts-alpine AS release
WORKDIR /app
COPY --from=dependencies /app/package.json ./
# Install app dependencies
RUN npm install --only=production
COPY --from=build /app/dist ./dist

USER node
EXPOSE 4000
ENTRYPOINT ["node", "dist/main.js"]