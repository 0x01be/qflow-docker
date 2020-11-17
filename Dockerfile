FROM 0x01be/yosys as yosys
FROM 0x01be/magic:build as magic
FROM 0x01be/qflow:build as build

FROM 0x01be/xpra

RUN apk add --no-cache --virtual qflow-runtime-dependencies \
    tcl \
    tk \
    tcsh \
    gtk+3.0 \
    python3-tkinter

COPY --from=build /opt/qflow/ /opt/qflow/
COPY --from=yosys /opt/yosys/ /opt/yosys/
COPY --from=magic /opt/magic/ /opt/magic/

USER ${USER}
ENV PATH=${PATH}:/opt/qflow/bin/:/opt/magic/bin/:/opt/yosys/bin/ \
    COMMAND="qflow gui"

