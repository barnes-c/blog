ARG BUILDPLATFORM

# The output is static HTML, so build natively and only copy into the target arch.
FROM --platform=$BUILDPLATFORM ghcr.io/gohugoio/hugo:v0.169.0@sha256:a146e0639230bbc73358e6563240f0a6103466f0390b80a457c775068ec802a9 AS build
USER root
WORKDIR /project
COPY . .
RUN hugo --minify --gc --panicOnWarning

FROM nginxinc/nginx-unprivileged:1.31-alpine@sha256:b5047b9b76845eac124358373c6852377c52e4b05834a47647e955dd91cb8f1e

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
