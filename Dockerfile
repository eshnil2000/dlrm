# Use the anibali/pytorch image as the base image
FROM anibali/pytorch:2.0.1-nocuda

# Install additional dependencies
RUN pip install tensorflow

RUN apt-get update -y 

# Clone the dlrm repository
RUN git clone https://github.com/eshnil2000/dlrm.git


# Set the working directory to dlrm/
WORKDIR /dlrm

# Install Python dependencies from requirements.txt
RUN pip install -r requirements.txt

# Clone the mlperf-logging repository
RUN git clone https://github.com/mlperf/logging.git mlperf-logging

# Install mlperf-logging as a Python package
RUN pip install -e mlperf-logging

# Run the test script
CMD ["sh", "test/dlrm_s_test.sh"]
