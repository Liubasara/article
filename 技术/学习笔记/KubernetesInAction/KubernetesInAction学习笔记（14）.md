---
name: KubernetesInAction学习笔记（14）
title: KubernetesInAction学习笔记（14）
tags: ["技术","学习笔记","KubernetesInAction"]
categories: 学习笔记
info: "第14章 计算资源管理"
time: 2021/3/4
desc: 'kubernetes in action, 资料下载, 学习笔记'
keywords: ['kubernetes in action', 'k8s学习', '学习笔记']
---

# KubernetesInAction学习笔记（14）

## 第14章 计算资源管理

在本章会学习如何为 pod 配置资源预期的 CPU 和内存使用量，以确保 pod 可以公平地使用 K8S 集群资源，同时也影响整个集群 pod 的调度方式。

### 14.1 为 pod 中的容器申请资源

使用`pod.spec.containers.resources.requests`字段可以为其指定 CPU 和内存的资源请求量。

![code-14-1.png](./images/code-14-1.png)

上面我们声明了一个容器需要 1/5 核（200 毫核）的 CPU 才能正常运行。换句话说，五个同样的 pod（或容器）可以足够快地运行在一个 CPU 核上。

此外还为容器申请了 10MB 的内存，说明期望容器内的进程最大消耗 10MB 的 RAM。

#### 14.1.2 资源 requests 如何影响调度

通过设置资源 requests 我们指定了 pod 对资源需求的最小值，调度器会在调度的过程中用到该信息，只考虑那些未分配资源量满足 pod 需求量的节点。如果节点的未分配资源量小于 pod 需求量，K8S 就不会将该 pod 调度到这个节点。

##### 调度器如何判断一个 pod 是否适合调度到某个节点

比较意外的是，调度器在调度的时候**并不会关注各类资源在当前时刻的实际使用量**，而只会关心**节点上部署的所有 pod 资源申请量之和**。

![14-1.png](./images/14-1.png)

##### 调度器如何利用 pod requests 为其选择最佳节点

在调度时调度器会先排除那些不满足需求的节点，然后使用优先级函数对其余节点进行排序，在 K8S 中有两种基于资源请求量的优先级排序：

- LeastRequestedPriority：优先将 pod 调度到请求量少的节点上
- MostRequestedPriority：优先将 pod 调度到请求量多的节点上

使用 LeastRequestedPriority 可以理解，但是 MostRequestedPriority 会在什么时候使用。答案是当使用第三方的云服务时，需要为每个 pod 提供足量 CPU/内存资源的同时，确保 K8S 使用尽可能少的节点（节省开销～）。

##### 查看节点资源总量

使用 describe 命令可以查看节点的资源。

![code-14-3.png](./images/code-14-3.png)

#### 14.1.3 CPU requests 如何影响 CPU 时间分配

CPU requests 不仅仅在调度时起作用，它还决定着剩余的 CPU 时间如何在 pod 之间分配。如果说一个 pod 请求了 200 毫核，另一个请求了 1000 毫核。所以未使用的 CPU 将按照 1:5 的比例来分给这两个 pod。

![14-2.png](./images/14-2.png)

#### 14.1.4 定义和申请自定义资源

K8S 允许用户添加属于自己的自定义资源，并在 spec 的 resource.requests 字段下来指定创建 pod 的申请量。

### 14.2 限制容器的可用资源

再来看看如何限制容器可以消耗资源的最大量。

#### 14.2.1 设置容器可使用资源量的硬限制

内存是一种不可压缩资源，在被占用的进程主动释放之前都无法被回收，如果不对内存进行限制，工作节点上的容器（或者 pod）可能会吃掉所有的可用内存甚至导致整个节点不可用，所以势必需要限制容器的最大内存分配量。

##### 创建一个带有资源 limits 的 pod

















> 本次阅读至P419 创建一个带有资源 limits 的 pod 433