FROM python:3.11-alpine3.16

ENV PYTHONUNBUFFERED=1

# Create non root user
RUN adduser -D leftxs

# Create dirs and set permissions to non root user
RUN mkdir /docs
RUN chown -R leftxs:leftxs /docs

# Perform build and cleanup artifacts
RUN apk add --no-cache \
    git curl bash \
    && apk add --no-cache --virtual .build gcc musl-dev \
    && pip install --upgrade pip

# Set build directory
WORKDIR /tmp

# Copy requirements.txt
COPY --chown=leftxs:leftxs requirements.txt requirements.txt

# Copy files necessary for build

#COPY requirements.txt requirements.txt

USER leftxs
RUN pip install --user -r requirements.txt

USER root
RUN apk del .build gcc musl-dev \
    && rm -rf /tmp/*

USER leftxs

ENV PATH="/home/leftxs/.local/bin:${PATH}"

#ENV PATH=$PATH:/root/.local/bin

# Trust git directory, required for git >= 2.35.2
RUN git config --global --add safe.directory /docs

# Set working directory
WORKDIR /docs

# Expose MkDocs development server port
EXPOSE 8000

# Start development server by default
#ENTRYPOINT ["mkdocs"]
#CMD ["serve", "--dev-addr=0.0.0.0:8000"]
ENTRYPOINT ["bash"]