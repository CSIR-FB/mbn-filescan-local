FROM alpine:3.19

LABEL maintainer="Craig Strydom"

# Install required packages
RUN apk add --no-cache \
    bash \
    pv \
    nodejs \
    npm \
    clamav \
    clamav-daemon \
    clamav-libunrar

RUN apk add --no-cache tzdata

ENV TZ=Africa/Johannesburg

RUN cp /usr/share/zoneinfo/Africa/Johannesburg /etc/localtime \
 && echo "Africa/Johannesburg" > /etc/timezone

# Setup ClamAV directories
RUN mkdir -p /run/clamav \
    && chown -R clamav:clamav /run/clamav \
    && mkdir -p /var/log/clamav \
    && touch /var/log/clamav/freshclam.log \
    && chown -R clamav:clamav /var/log/clamav

# Set working directory
ENV APP_PATH=/usr/src/app
WORKDIR $APP_PATH

# Copy package files
COPY src/package*.json ./

# Install Node dependencies
RUN npm install --omit=dev

# Copy application source
COPY src/. .

# Optional but recommended: initial signature update
RUN freshclam || true

EXPOSE 3000

COPY bootstrap.sh /bootstrap.sh
ENTRYPOINT ["sh", "/bootstrap.sh"]
