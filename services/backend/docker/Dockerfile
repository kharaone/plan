FROM python:3.6.0-alpine

RUN apk update \
    && apk add bash netcat-openbsd mysql-client \
    && rm -rf /var/cache/apk/*

RUN mkdir -p /workspace
WORKDIR /workspace

# Usefull when starting the ptpython or other
# python REPLs.
ENV PYTHONPATH="/workspace/src":$PYTHONPATH

# Install pip packges
COPY requirements.txt .
RUN pip install --egg -r requirements.txt

# Copy over source code
COPY src /workspace/src

# Entrypoint
COPY docker/watch.sh /
CMD ["/watch.sh"]
