ARG BUILDPLATFORM

# The output is static HTML, so build natively and only copy into the target arch.
FROM --platform=$BUILDPLATFORM ghcr.io/gohugoio/hugo:v0.168.0@sha256:1fb8fe7f417abd5802d86747d297728aa48078d763159e7dff6559fe3f8bb8e7 AS build
USER root
WORKDIR /project
COPY . .
RUN hugo --minify --gc --panicOnWarning

FROM nginxinc/nginx-unprivileged:1.31-alpine@sha256:378d0c32f6562f7fd9629170797f57d2b953aa09be983b3daaf4809bb039ca00

ARG BUILD_TIMESTAMP="n/a"
ARG COMMIT_HASH="n/a"
ARG IMAGE_NAME="blog"
ARG IMAGE_URL_BASE="github.com/barnes-c"
ARG VERSION="dev"

LABEL \
    org.opencontainers.image.authors="https://${IMAGE_URL_BASE}" \
    org.opencontainers.image.created="${BUILD_TIMESTAMP}" \
    org.opencontainers.image.description="Blog for https://blog.barnes.biz" \
    org.opencontainers.image.documentation="https://blog.barnes.biz" \
    org.opencontainers.image.ref.name="${VERSION}" \
    org.opencontainers.image.revision="${COMMIT_HASH}" \
    org.opencontainers.image.source="https://${IMAGE_URL_BASE}/${IMAGE_NAME}.git" \
    org.opencontainers.image.title="${IMAGE_NAME}" \
    org.opencontainers.image.url="https://${IMAGE_URL_BASE}/${IMAGE_NAME}" \
    org.opencontainers.image.vendor="Barnes-C" \
    org.opencontainers.image.version="${VERSION}"

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /project/public /usr/share/nginx/html

EXPOSE 8080
