# Image build : docker build -t kssamwang/powergraph:exp1 .
FROM kssamwang/powergraph:base_env as base
FROM base as base-amd64

RUN echo "root:xya1234" | chpasswd

ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive

RUN git clone https://github.com/kssamwang/PowerGraph-HCPD.git -b exp /root/PowerGraph-HCPD
WORKDIR /root/PowerGraph-HCPD
RUN cd /root/PowerGraph-HCPD
RUN ./configure
WORKDIR /root/PowerGraph-HCPD/release/toolkits/graph_analytics
RUN cd /root/PowerGraph-HCPD/release/toolkits/graph_analytics
RUN make -j4

