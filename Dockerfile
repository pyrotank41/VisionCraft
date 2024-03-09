# Stage 1: Build the Next.js application for production
# Use the Node.js official image as the base image
FROM node:21.7.0-slim AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and package-lock.json
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of your app's source code from your host to your image filesystem.
COPY . .

# Build the Next.js application for production
RUN npm run build

# Stage 2: Serve the Next.js application for production
FROM node:21.7.0-slim AS production

WORKDIR /app

# Copy package.json and other relevant files
COPY --from=builder /app/next.config.js ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# Expose the port the app runs on
EXPOSE 3000

# Set the command to run your app using CMD which defines your runtime
CMD ["npm", "start"]

# Stage 3: Setup for development with hot reloading
# This stage is used for development purposes only
FROM node:21.7.0-slim AS development


# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and package-lock.json (or yarn.lock if using Yarn)
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of your app's source code from your host to your image filesystem.
COPY . .

# Expose the port the app runs on
EXPOSE 3000

# Start the development server
CMD ["npm", "run", "dev"]


# docker build --target development -t my-nextjs-app-dev .
# docker run -it -p 3000:3000 my-nextjs-app-dev

# docker build -t my-nextjs-app-prod .
# docker run -it -p 3000:3000 my-nextjs-app-prod
