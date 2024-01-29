FROM alpine:3

ARG CACHEBUST=1
WORKDIR /app

RUN echo "$CACHEBUST" > $(mktemp -p /app)

# generate a random file name with random content in the /app directory
RUN LC_ALL=C tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' </dev/urandom | head -c 26 > $(mktemp -p /app)

ENTRYPOINT ["sleep", "60m"]
