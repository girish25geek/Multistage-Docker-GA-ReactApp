# Stage 1: Build React App
FROM node:20 AS build

WORKDIR /app

# Copy package files and install dependencies using npm
COPY package.json ./
COPY package-lock.json ./
RUN npm install

# Copy source code and build
COPY . .
RUN npm run build

# Stage 2: Serve with NGINX
FROM nginx:stable-alpine

WORKDIR /usr/share/nginx/html

# Remove default static content from NGINX
RUN rm -rf ./*

# Copy built files from previous stage
COPY --from=build /app/build ./

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
