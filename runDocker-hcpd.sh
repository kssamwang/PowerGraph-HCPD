#!/bin/bash
set -e
# 参数设置
cluster_size=32
base_hostname="PG_hcpd_cluster_"
network_name="hcpd_network"
start_ip="172.67.0."  # 起始IP地址i
image_name="kssamwang/powergraph:hcpd-v0"
beg_ip=8

# 创建 Docker 网络

for i in $(seq 1 "$cluster_size"); do
    hostname="$base_hostname$i"
    ip_octet=$(($beg_ip+i))
    ip="$start_ip$ip_octet"
    custom_hosts_params+=" --add-host $hostname:$ip"
done

# 循环创建集群容器

for i in $(seq 1 "$cluster_size"); do
    hostname="$base_hostname$i"
    ip_octet=$(($beg_ip+i))
    ip="$start_ip$ip_octet"

    if docker ps -a | grep -q "$hostname"; then
        echo "Container '$hostname' exists."
        docker stop $hostname
        docker rm $hostname
    fi

   # 创建容器，并指定主机名和自定义主机映射
    docker run -d -it --name "$hostname" --ulimit nofile=65535 --hostname "$hostname" -v /home/wsy/HCPD/dataset:/data  --net $network_name --ip $ip $image_name /bin/bash -c "service ssh restart && /bin/bash"
    echo "Container pg_$i created with hostname $hostname with IP:$ip"
done

