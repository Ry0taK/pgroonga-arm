#!/bin/bash

set -eux

PGROONGA_VERSION=$1
GROONGA_VERSION=$2
PGROONGA_SHA256=$3
GROONGA_SHA256=$4

MECAB_VERSION=0.996
MECAB_SHA256=e073325783135b72e666145c781bb48fada583d5224fb2490fb6c1403ba69c59

NAIST_JDIC_SHA256=cb37700dc9a77b953f2bf3b15b49cfecd67848530a2cf8abcb09b594ca5628cc

mkdir build
cd build

wget \
  -O mecab.tar.gz \
  "https://packages.groonga.org/source/mecab/mecab-${MECAB_VERSION}.tar.gz"
if [ "$(sha256sum "mecab.tar.gz" | awk '{print $1}')" != "$MECAB_SHA256" ]; then
  echo "Incorrect SHA256 hash for mecab.tar.gz"
  exit 1
fi
tar xf mecab.tar.gz
cd mecab-*
sed -i.bak -e 's,ipadic,naist-jdic,g' mecabrc.in
./configure \
  --prefix=/usr/local \
  --build=arm-unknown-linux-gnu \
  --host=arm-unknown-linux-gnu \
  --target=arm-unknown-linux-gnu
make -j$(nproc)
make install
cd -

wget \
  -O mecab-naist-jdic.tar.gz \
  "https://ja.osdn.net/frs/redir.php?m=nchc&f=naist-jdic%2F53500%2Fmecab-naist-jdic-0.6.3b-20111013.tar.gz"
if [ "$(sha256sum "mecab-naist-jdic.tar.gz" | awk '{print $1}')" != "$NAIST_JDIC_SHA256" ]; then
  echo "Incorrect SHA256 hash for mecab-naist-jdic.tar.gz"
  exit 1
fi
tar xf mecab-naist-jdic.tar.gz
cd mecab-naist-jdic-*
./configure \
  --prefix=/usr/local \
  --with-charset=utf-8 \
  --build=arm-unknown-linux-gnu \
  --host=arm-unknown-linux-gnu \
  --target=arm-unknown-linux-gnu
make -j$(nproc)
make install
cd -

wget https://packages.groonga.org/source/groonga/groonga-${GROONGA_VERSION}.tar.gz
if [ "$(sha256sum "groonga-${GROONGA_VERSION}.tar.gz" | awk '{print $1}')" != "$GROONGA_SHA256" ]; then
  echo "Incorrect SHA256 hash for groonga-${GROONGA_VERSION}.tar.gz"
  exit 1
fi
tar xf groonga-${GROONGA_VERSION}.tar.gz
cd groonga-${GROONGA_VERSION}
./configure \
  --prefix=/usr/local \
  --disable-groonga-httpd \
  --disable-document \
  --disable-glibtest \
  --disable-benchmark \
  --enable-mruby
make -j$(nproc)
make install
cd -

wget https://packages.groonga.org/source/pgroonga/pgroonga-${PGROONGA_VERSION}.tar.gz
if [ "$(sha256sum "pgroonga-${PGROONGA_VERSION}.tar.gz" | awk '{print $1}')" != "$PGROONGA_SHA256" ]; then
  echo "Incorrect SHA256 hash for pgroonga-${PGROONGA_VERSION}.tar.gz"
  exit 1
fi
tar xf pgroonga-${PGROONGA_VERSION}.tar.gz
cd pgroonga-${PGROONGA_VERSION}
make PGRN_DEBUG=yes HAVE_MSGPACK=1 MSGPACK_PACKAGE_NAME=msgpack-c -j$(nproc)
make install
cd -

cd ..
rm -rf build
