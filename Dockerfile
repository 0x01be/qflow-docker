FROM 0x01be/yosys as yosys
FROM 0x01be/magic as magic

FROM alpine:3.12.0 as builder

COPY --from=yosys /opt/yosys/ /opt/yosys/

COPY --from=magic /opt/magic/ /opt/magic/

# Still missing: netgen qrouter graywolf ot-shell sta RePlAce ntuplace3 ntuplace4h

ENV PATH $PATH:/opt/yosys/bin:/opt/magic/bin/

RUN apk add --no-cache --virtual build-dependencies \
    git \
    build-base \
    python3-dev

RUN git clone git://opencircuitdesign.com/qflow /qflow

WORKDIR /qflow

RUN ./configure --prefix=/opt/qflow/ && make

RUN make install

FROM alpine:3.12.0

RUN apk add --no-cache --virtual runtime-dependencies \
    tcl \
    tk \
    xf86-video-dummy \
    xorg-server \
    tcsh

COPY ./xorg.conf /xorg.conf
#Xorg -noreset +extension GLX +extension RANDR +extension RENDER -logfile ./0.log -config ./xorg.conf :0
#ENV DISPLAY :0

COPY --from=builder /opt/qflow/ /opt/qflow/

ENV PATH /opt/qflow/bin/:$PATH

