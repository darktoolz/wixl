ARG SOURCE_DATE_EPOCH=0
ARG LANG=${LANG:-C.UTF-8}

FROM debian:sid-slim AS build
ARG SOURCE_DATE_EPOCH
ARG LANG
ENV DEBCONF_NONINTERACTIVE_SEEN=true
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install --no-install-recommends --no-install-suggests -y \
  ca-certificates \
  curl \
  iproute2 \
  binutils \
	locales \
  git \
  uuid \
  make \
  mingw-w64 \
  build-essential \
  pkg-config \
  automake \
  libtool \
  autotools-dev \
  libxml-xpath-perl \
  meson \
  valac \
  ninja-build \
  bison \
  libglib2.0-dev \
  libglib2.0-dev-bin \
  libgsf-1-dev \
  gobject-introspection \
  libgcab-dev \
  gcab \
  diffutils

RUN touch /usr/bin/rpm && chmod +x /usr/bin/rpm
RUN git clone --recursive https://github.com/darktoolz/msitools /build
WORKDIR /build
RUN meson _build -Dvalidate-wxi=true && ninja -C _build
RUN cp _build/tools/msibuild _build/tools/msiextract _build/tools/msiinfo \
  _build/tools/wixl/wixl _build/tools/wixl/wixl-heat /usr/bin/

WORKDIR /
RUN apt autoremove -y && apt-get clean -y && apt-get remove -y \
  git \
  make \
  mingw-w64 \
  build-essential \
  pkg-config \
  automake \
  libtool \
  autotools-dev \
  libxml-xpath-perl \
  meson \
  valac \
  ninja-build \
  bison \
  libglib2.0-dev \
  libglib2.0-dev-bin \
  libgsf-1-dev \
  gobject-introspection \
  libgcab-dev \
  gcab \
  diffutils

RUN rm -rf /build .git .github /var/lib/apt /var/cache /var/log/apt /var/log/dpkg* /var/log/* \
        /var/lib/dpkg* /usr/libexec/dpkg* /usr/share/doc /usr/share/man /var/log/alt*

RUN mkdir /wix && chmod 777 /wix
RUN ln /usr/bin/uuid /usr/bin/uuidgen

FROM scratch
ARG SOURCE_DATE_EPOCH
ARG LANG
COPY --from=build / /
ENV LANG=${LANG:-C.UTF-8}

WORKDIR /wix
ENTRYPOINT ["/usr/bin/wixl"]
