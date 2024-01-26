FROM debian:bookworm as build
RUN apt-get -qq update && \
    apt-get -qq install -y build-essential dpkg-dev devscripts
ADD debian/ /opt/ceph/debian
WORKDIR /opt/ceph

RUN yes | mk-build-deps -i debian/control

ADD . /opt/ceph
RUN git submodule update --init --depth 1 --recursive && \
    dpkg-buildpackage -b -nc --no-sign

FROM debian:bookworm
COPY --from=build /opt/*.deb /opt/ceph/
RUN dpkg -A -R /opt/ceph
