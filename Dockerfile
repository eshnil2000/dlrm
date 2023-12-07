# Use the anibali/pytorch image as the base image
FROM anibali/pytorch:2.0.1-nocuda

USER 1001
# Install additional dependencies
RUN pip install tensorflow

USER 0
# Clone the dlrm repository to /tmp/dlrm
RUN git clone https://github.com/eshnil2000/dlrm.git /dlrm

# Set the working directory to /tmp/dlrm
WORKDIR /dlrm

# Install Python dependencies from requirements.txt
RUN pip install -r requirements.txt

USER 1001
# Clone the mlperf-logging repository
RUN git clone https://github.com/mlperf/logging.git mlperf-logging

# Install mlperf-logging as a Python package
RUN pip install -e mlperf-logging

# Run the test script
CMD ["sh", "test/dlrm_s_test.sh"]
