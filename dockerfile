## Builder for the Angular application
FROM node:latest as builder

# Perpare for build
WORKDIR /usr/src/app
COPY . .
RUN npm install

# Build
RUN npm run build

# Clean up build dependencies
RUN rm -rf /usr/src/app/node_modules
RUN rm -rf /usr/src/app/src/app

# Copy the built Angular application to the correct place.
RUN mv /usr/src/app/dist/MinecraftServerStatus /usr/src/app/src/app

## Begin building the final image
FROM node:latest as server

# Update the systems packages
RUN apt-get update && apt-get upgrade -y

# Prepare the server
WORKDIR /usr/src/app
COPY --from=builder /usr/src/app/src/app /usr/src/app/src/app

# Install the server dependencies
RUN npm install

# Expose the port
EXPOSE 80 443

# Start the server
CMD ["npm", "run", "server"]