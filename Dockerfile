FROM node:18.12.1

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install Node.js dependencies
RUN npm install

# Install Python 3 and its dependencies
RUN apt-get update && apt-get install -y python3 python3-pip

<<<<<<< HEAD
# Upgrade pip for Python 3
RUN python3 -m pip install --no-cache-dir --upgrade pip

# Copy requirements.txt and install Python dependencies
COPY requirements.txt ./
=======
# # Upgrade pip for Python 3
# RUN python3 -m pip install --no-cache-dir --upgrade pip

# Copy requirements.txt and install Python dependencies
COPY requirements.txt .
>>>>>>> cad3c2b82a9510dd54a105c43ebee7a64adf8702
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy all files to the working directory
COPY . .

# Expose the port
EXPOSE 5000

# Start the application
<<<<<<< HEAD
CMD [ "npm", "run", "start" ]
=======

CMD [ "node", "server.js" ]
>>>>>>> cad3c2b82a9510dd54a105c43ebee7a64adf8702
