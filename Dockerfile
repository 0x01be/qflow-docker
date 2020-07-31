FROM 0x01be/yosys as yosys
FROM 0x01be/magic as magic

FROM alpine:3.12.0 as builder

COPY --from=yosys /opt/yosys/ /opt/yosys/

COPY --from=magic /opt/magic/ /opt/magic/

# Still missing: netgen qrouter graywolf ot-shell sta RePlAce ntuplace3 ntuplace4h

ENV PATH $PATH:/opt/yosys/bin:/opt/magic/bin/

RUN apk add --no-cache --virtual build-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    git \
    build-base \
    python3-dev

RUN git clone git://opencircuitdesign.com/qflow /qflow

WORKDIR /qflow

RUN ./configure --prefix=/opt/qflow/ && make

RUN make install

FROM 0x01be/xpra

RUN apk add --no-cache --virtual runtime-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    tcl \
    tk \
    tcsh \
    gtk+3.0 \
    python3-tkinter

COPY --from=builder /opt/qflow/ /opt/qflow/
COPY --from=yosys /opt/yosys/ /opt/yosys/
COPY --from=magic /opt/magic/ /opt/magic/

ENV PATH $PATH:/opt/qflow/bin/:/opt/magic/bin/:/opt/yosys/bin/

EXPOSE 10000

CMD /usr/bin/xpra start --bind-tcp=0.0.0.0:10000 --html=on --start-child="qflow gui" --exit-with-children --daemon=no --xvfb="/usr/bin/Xvfb +extension  Composite -screen 0 1920x1080x24+32 -nolisten tcp -noreset" --pulseaudio=no --notifications=no --bell=no --mdns=no
