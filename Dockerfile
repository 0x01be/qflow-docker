FROM 0x01be/yosys as yosys
FROM 0x01be/replace as replace
FROM 0x01be/qrouter as qrouter
FROM 0x01be/magic:xpra-threads as magic
FROM 0x01be/netgen:xpra as netgen
FROM 0x01be/openroad:xpra as openroad

FROM 0x01be/base as build

COPY --from=yosys /opt/yosys/ /opt/yosys/
COPY --from=replace /opt/replace/ /opt/replace/
COPY --from=replace /opt/qrouter/ /opt/qrouter/
COPY --from=magic /opt/magic/ /opt/magic/
COPY --from=netgen /opt/netgen/ /opt/netgen/

WORKDIR /qflow

ENV PATH=${PATH}:/opt/yosys/bin:/opt/replace/bin:/opt/magic/bin/:/opt/netgen/bin:/opt/qrouter/bin:/opt/openroad/bin \
    LD_LIBRARY_PATH=/lib:/usr/lib:/opt/yosys/lib:/opt/replace/lib:/opt/magic/lib/:/opt/netgen/lib:/opt/qrouter/lib:/opt/openroad/lib \
    C_INCLUDE_PATH=/usr/include:/opt/yosys/include:/opt/replace/include:/opt/magic/include/:/opt/netgen/include:/opt/qrouter/include:/opt/openroad/include \
    REVISION=master

# Still missing: qrouter graywolf ot-shell ntuplace3 ntuplace4h
RUN apk add --no-cache --virtual qflow-build-dependencies \
    git \
    build-base \
    python3-dev &&\
    git clone --depth 1 --branch ${REVISION} git://opencircuitdesign.com/qflow /qflow &&\
    ./configure --prefix=/opt/qflow/ &&\
    make
RUN make install

