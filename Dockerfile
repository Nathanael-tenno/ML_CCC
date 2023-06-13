# Use the official Node.js 14 image as the base image
FROM node:14

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install Node.js dependencies
RUN npm install

# Copy the rest of the application code to the container
COPY . .

# Install Python dependencies
RUN apt-get update && apt-get install -y python3 python3-pip
RUN pip3 install opencv-python torch numpy tensorflow tensorflow_hub

# Copy requirements.txt and install Python dependencies
COPY requirements.txt ./
RUN pip install -r reqruitments.txt


# Expose port 80 for the application
EXPOSE 80

# Start the application
CMD [ "node", "server.js" ]
