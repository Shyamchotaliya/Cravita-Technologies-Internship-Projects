# Use an official Python 3.9 slim-buster image as a base
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt .

# Install the Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the main application script into the container
COPY main.py .

# Define the command to run the application when the container starts
CMD ["python", "main.py"]