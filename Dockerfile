FROM postgres:15-bullseye

MAINTAINER Justin Tutty <justin.tutty at domain.com.au>

ENV POSTGIS_MAJOR 3
ENV POSTGIS_VERSION 3.3.2+dfsg-1.pgdg110+1
ENV PLV8_BRANCH r3.1

RUN apt-get update && apt-get install -y postgresql-contrib-$PG_MAJOR

# Install postgis

RUN apt-cache showpkg postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR \
    && apt-get install -y --no-install-recommends \
         postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR=$POSTGIS_VERSION \
         postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR-scripts=$POSTGIS_VERSION
 
# Install plv8

RUN buildDependencies="build-essential \
    ca-certificates \
    curl \
    git-core \
    gpp \
    cpp \
    pkg-config \
    zlib1g-dev \
    ninja-build \
    wget \
    apt-transport-https \
    cmake \
    libc++-dev \
    libc++abi-dev \
    postgresql-server-dev-$PG_MAJOR" \
  && runtimeDependencies="libc++1 libtinfo5 libc++abi1" \
  && apt-get update \
  && apt-get install -y --no-install-recommends ${buildDependencies} ${runtimeDependencies}

RUN cd /tmp && git clone -b $PLV8_BRANCH https://github.com/plv8/plv8.git \
  && cd /tmp/plv8 \
  && make all install \
  && cd /tmp && rm -Rf plv8

RUN apt-get clean \
  && apt-get remove -y ${buildDependencies} \
  && apt-get autoremove -y
