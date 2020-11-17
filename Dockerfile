FROM 0x01be/yosys as yosys
FROM 0x01be/magic as magic

FROM alpine as builder

ENV PATH $PATH:/opt/yosys/bin:/opt/magic/bin/

RUN apk add --no-cache --virtual qflow-build-dependencies \
    git \
    build-base \
    python3-dev

COPY --from=yosys /opt/yosys/ /opt/yosys/
COPY --from=magic /opt/magic/ /opt/magic/
# Still missing: netgen qrouter graywolf ot-shell sta RePlAce ntuplace3 ntuplace4h

ENV REVISION=master
RUN git clone --depth 1 --branch ${REVISION} git://opencircuitdesign.com/qflow /qflow

WORKDIR /qflow

RUN ./configure --prefix=/opt/qflow/ && make

RUN make install

