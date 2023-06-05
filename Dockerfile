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
    GROONGA_VERSION=13.0.1 \
    PGROONGA_SHA256=d35779a47ed02bbda8aedb5b7a54f3ab0a43052f7ea986209fb71cf6a199fd12 \
    GROONGA_SHA256=1c2d1a6981c1ad3f02a11aff202b15ba30cb1c6147f1fa9195b519a2b728f8ba

COPY ./build.sh /
RUN \
  chmod +x /build.sh && \
  /build.sh ${PGROONGA_VERSION} ${GROONGA_VERSION} ${PGROONGA_SHA256} ${GROONGA_SHA256} && \
  rm -f build.sh

RUN \
  apk del \
    build-base \
    clang15 \
    clang15-dev \
    llvm15
