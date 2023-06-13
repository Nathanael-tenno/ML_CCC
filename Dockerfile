# Base image
FROM node:14

# Create and set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the server.js file
COPY server.js .

# Copy the serviceAccountKey.json file
COPY serviceAccountKey.json .

# Copy the app.py file
COPY app.py .

# Install Python and required packages
RUN apt-get update && \
    apt-get install -y python3 && \
    apt-get install -y python3-pip && \
    pip3 install opencv-python-headless && \
    pip3 install torch && \
    pip3 install numpy && \
    pip3 install tensorflow && \
    pip3 install tensorflow_hub && \
    pip3 install requests

# Expose the desired port
EXPOSE 80

# Run the server.js file
CMD [ "node", "server.js" ]
