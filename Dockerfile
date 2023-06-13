# Use the official Node.js image as the base image
FROM node:14

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json files to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Install additional dependencies for cv2
RUN apt-get update && apt-get install -y libsm6 libxext6 libxrender-dev libglib2.0-0 python3-pip

# Install cv2
RUN pip3 install opencv-python-headless

# Copy the source code to the working directory
COPY . .

# Expose port 80
EXPOSE 80

# Start the application
CMD ["node", "server.js"]
