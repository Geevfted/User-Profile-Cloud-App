# Use the official Node.js image
FROM node:24-alpine

# Create the working directory
WORKDIR /app

# Copy dependency files first
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the project
COPY . .

# Tell Docker the app uses port 3000
EXPOSE 3000

# Start the application
CMD ["npm", "start"]