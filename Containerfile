LABEL description="Ceedling container for unit testing C projects"
LABEL license="MIT"

FROM alpine:3.15

# Set build argument for Ceedling version
ARG CEEDLING_VERSION=1.0.0-13d0e3d

# Install dependencies, download and install Ceedling gem, and clean up
RUN apk add --no-cache --virtual .build-deps wget \
    && apk add --no-cache ruby ruby-dev build-base \
    && wget https://github.com/ThrowTheSwitch/Ceedling/releases/download/${CEEDLING_VERSION}/ceedling-${CEEDLING_VERSION}.gem \
    && gem install --conservative --minimal-deps ceedling-${CEEDLING_VERSION}.gem \
    && rm ceedling-${CEEDLING_VERSION}.gem \
    && apk del .build-deps

# Set the entrypoint to call ceedling by default
ENTRYPOINT ["ceedling"]
