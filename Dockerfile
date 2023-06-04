FROM postgres:15.2-alpine

RUN \
  apk --no-cache add \
    build-base \
    clang-dev \
    llvm15 \
    lz4-dev \
    msgpack-c-dev \
    zstd-dev

ENV PGROONGA_VERSION=2.4.5 \
    GROONGA_VERSION=13.0.0

COPY ./build.sh /
RUN \
  chmod +x /build.sh && \
  /build.sh ${PGROONGA_VERSION} ${GROONGA_VERSION} && \
  rm -f build.sh

RUN \
  apk del \
    build-base \
    clang \
    clang-dev \
    llvm15
