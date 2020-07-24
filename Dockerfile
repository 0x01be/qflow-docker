FROM alpine:3.12.0 as builder

RUN apk add --no-cache --virtual build-dependencies \
    git \
    build-base

RUN git clone git://opencircuitdesign.com/qflow /qflow

WORKDIR /qflow

RUN ./configure --prefix=/opt/qflow/ && make

RUN make install

FROM alpine:3.12.0

RUN apk add --no-cache --virtual build-dependencies \
    tcsh

COPY --from=builder /opt/qflow/ /opt/qflow/

ENV PATH /opt/qflow/bin/:$PATH

