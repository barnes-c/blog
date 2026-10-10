ARG BUILDPLATFORM

# The output is static HTML, so build natively and only copy into the target arch.
FROM --platform=$BUILDPLATFORM ghcr.io/gohugoio/hugo:v0.167.0@sha256:7bb99a126eddeea8fbfaacedc5ef6708805411bdeaa01e668405a137fd02d048 AS build
USER root
WORKDIR /project
COPY . .
RUN hugo --minify --gc

FROM nginxinc/nginx-unprivileged:1.31-alpine@sha256:b9241c6e7b8e9a862f129d8d4199ab64b10390949a78bdd5603379b32c844083

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
