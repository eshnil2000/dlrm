# Use the anibali/pytorch image as the base image
FROM anibali/pytorch:2.0.1-nocuda

# Switch to root user for system package installation and directory setup
USER root

# Update package lists and install system dependencies
RUN apt-get update -y && apt-get install -y nano wget tmux numactl

# Create a directory for DLRM and set correct permissions
RUN mkdir -p /dlrm && chown user:user /dlrm

# Switch to non-root user
USER user
RUN pip install tensorflow
# Clone the DLRM repository inside /dlrm
RUN git clone https://github.com/eshnil2000/dlrm.git /dlrm

# Set the working directory
WORKDIR /dlrm

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Clone and install mlperf-logging
RUN git clone https://github.com/mlperf/logging.git mlperf-logging && \
    pip install --no-cache-dir -e mlperf-logging
