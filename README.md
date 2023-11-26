# Powergraph更新及HCPD图分区算法的嵌入

使用2023年重新编译的PowerGraph嵌入ICDE'23的图分区工作HCPD算法，复现其论文的实验。

**该仓库更新的目的**

PowerGraph是2012年发表在OSDI会议上的一篇有关于图计算系统的文章。由于其本身包含了多种传统图算法，并且支持分布式计算，因此直到今日依然会成为众多论文的基线对比，或者是通过PG来验证一些算法的效果。

PowerGraph源仓库地址:https://github.com/jegonzal/PowerGraph

在原来仓库中，需要下载多个第三方库，但由于年久失修，很多URL已经失效，导致无法成功完成编译。现在将PG所需要的第三方库均整合到`external_lib`中，并且在Cmakefile中进行修改，使得PG框架可以重新运行。具体操作如下文。

**HCPD图分区算法**

ICDE'23: [Optimizing Graph Partition by Optimal
Vertex-Cut:A Holistic Approach'](https://ieeexplore.ieee.org/document/10184644)

[作者的博士学位论文](https://kns.cnki.net/kcms2/article/abstract?v=aGn3Ey0ZxcDseg83YLj2euksTxAz7EzLolKS0gVmAc3pXK4uP5vWoBc-0Tznqrjr0LbyUGwgLeBH3wJ5F6wtE3dsiTybTP6opCwZd_QnFH6RXJI9YtiGd_KMnlvNS2_xE3OI-pzLcjpXoG8UZleN4Q==&uniplatform=NZKPT&language=CHS)

[开源代码](https://github.com/wenwenQu/HCPD)

## 环境配置需求

+ Ubuntu16.04
+ gcc 5.4
+ g++5.4
+ jdk1.8
+ build-essential
+ Zlib
+ ssh
+ libboost


## 配置流程

```bash
sudo apt-get update
sudo apt-get install gcc g++ build-essential libopenmpi-dev openmpi-bin default-jdk cmake zlib1g-dev git libboost-all-dev ssh
git clone https://github.com/kssamwang/PowerGraph-HCPD.git
cd PowerGraph-HCPD
./configure
cd release/toolkits/graph_analytics
make -j4
```

## 自定义分区结果导入

PowerGraph可以很方便的进行一些传统图计算任务的运行，经常作为论文的基线测试程序，用于测试分区算法的健壮性，因此，为了方便在PG上测试分区算法在实际分布式场景下的表现，我们对PG的代码进行了一些调整，使得PG可以直接接受来自外部的分区结果，以供应用。

#### 分区文件结构需求

以一个graph.txt文件为例，每一行包含三个参数，分别是src,dst,partid，其中partid表明对应的边(src，dst)最后被分配到哪一个分区中。三个参数之间需要用`\t`分隔。

```txt
#SRC\tDST\tpartid
1	2	0
2	3	1
3	0	1
```

#### 文件运行的参数设置

由于我们的导入接口设置在random中，替代了原先的random方法，因此，运行的命令调整为

```bash
./pagerank --graph_opts="ingress=random" --graph /data/in_S5P.txt --format self_tsv

# 其中pagerank通过之前的make命令完成编译，路径在release/toolkits/graph_analytics下
# --graph参数接着的是图的文件路径
# format本意是告诉PG你的图文件结构，self_tsv便是上面提到的三参数文件结构
```

以下是fork的作者[BearBiscuit05](https://github.com/BearBiscuit05)的知乎文章：

~~后面将会更新~~已经更新[基于docker的分布式PG运行办法](https://zhuanlan.zhihu.com/p/661582206)。

本项目build的Docker容器：
```bash
# 这是一个可以直接编译PowerGraph的Ubuntu 16.04基础环境，root密码xya1234
docker pull kssamwang/powergraph:base_env
# 这是一个可以已编译完成本项目的环境，root密码xya1234
docker pull kssamwang/powergraph:hcpd-v0
```
Dockerfile在文件夹[dockerfile.dir](https://github.com/kssamwang/PowerGraph-HCPD/tree/master/dockerfile.dir)

其中Docker子网的搭建，注意网段和网关的选择
```bash
docker network create --driver bridge --subnet 172.67.0.0/16 --gateway 172.67.0.1 pg_network
```

对于HCPD版本的pagerank运行：

```bash
mpiexec --allow-run-as-root -n 2 -hostfile /data/machines ./pagerank --graph_opts="ingress=matrix_block,threshold=200,etheta=2" --graph /data/com-orkut.ungraph.txt --format snap
```
