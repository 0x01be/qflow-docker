FROM 0x01be/yosys as yosys
FROM 0x01be/magic:build as magic

FROM alpine as build


RUN apk add --no-cache --virtual qflow-build-dependencies \
    git \
    build-base \
    python3-dev

COPY --from=yosys /opt/yosys/ /opt/yosys/
COPY --from=magic /opt/magic/ /opt/magic/
# Still missing: netgen qrouter graywolf ot-shell sta RePlAce ntuplace3 ntuplace4h

ENV PATH=${PATH}:/opt/yosys/bin:/opt/magic/bin/ \
    REVISION=master
RUN git clone --depth 1 --branch ${REVISION} git://opencircuitdesign.com/qflow /qflow

WORKDIR /qflow

RUN ./configure --prefix=/opt/qflow/
RUN make
RUN make install

