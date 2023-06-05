FROM postgres:15.3-alpine

RUN \
  apk --no-cache add \
    build-base \
    clang15-dev \
    clang15 \
    llvm15 \
    lz4-dev \
    msgpack-c-dev \
    zstd-dev

ENV PGROONGA_VERSION=3.0.6 \
    GROONGA_VERSION=13.0.1

COPY ./build.sh /
RUN \
  chmod +x /build.sh && \
  /build.sh ${PGROONGA_VERSION} ${GROONGA_VERSION} && \
  rm -f build.sh

RUN \
  apk del \
    build-base \
    clang15 \
    clang15-dev \
    llvm15
