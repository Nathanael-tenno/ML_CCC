# Use the official Node.js 14 image as the base image
FROM node:14

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install Node.js dependencies
RUN npm install

# Install Python 3 and its dependencies
RUN apt-get update && apt-get install -y python3 python3-pip

# Install pip
RUN python -m ensurepip --default-pip

# Install PyTorch
RUN pip install torch torchvision torchaudio

# Upgrade pip for Python 3
RUN python3 -m pip install --no-cache-dir --upgrade pip

# Copy requirements.txt and install Python dependencies
COPY requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy the rest of the application code to the container
COPY . .

# Expose port 80 for the application
EXPOSE 80

# Start the application
CMD [ "node", "server.js", "npm", "run", "start" ]
