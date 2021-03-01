---
name: KubernetesInAction学习笔记（13）
title: KubernetesInAction学习笔记（13）
tags: ["技术","学习笔记","KubernetesInAction"]
categories: 学习笔记
info: "第13章 保障集群内节点和网络安全"
time: 2021/3/1
desc: 'kubernetes in action, 资料下载, 学习笔记'
keywords: ['kubernetes in action', 'k8s学习', '学习笔记']
---

# KubernetesInAction学习笔记（13）

## 第13章 保障集群内节点和网络安全

本章介绍

- 如何允许 pod 访问所在宿主节点的资源
- 配置集群，定义和限制 pod 对于节点的权限
- 保障 pod 的网络安全

### 13.1 在 pod 中使用宿主节点的 Linux 命名空间

每一个 pod 都拥有自己的网络命名空间、PID 命名空间和 IPC 命名空间。

网络命名空间决定每个 pod 有自己的 IP 和端口空间。

PID 决定每个 pod 拥有自己的进程树。

IPC 命名空间仅允许同一 pod 内的进程通过进程间通信机制进行交流。

#### 13.1.1 在 pod 中使用宿主节点的网络命名空间

某些 pod 可能需要在宿主节点的默认命名空间中运行，用以看到宿主节点上的网络信息，比如宿主节点的网络适配器。

这可以通过将 pod spec 中的`hostNetwork`设置为 true 实现。

在这种情况下，意味着 pod 没有自己的 IP 地址，如果 pod 某一个进程绑定了某个端口，那么该进程将会被绑定到宿主节点的端口上。

![13-1.png](./images/13-1.png)

K8S 控制平面组件通过 pod 部署时，这些 pod 都会使用`hostNetwork`选项，让它们的应用的行为与不在 pod 中运行时相同。

#### 13.1.2 绑定宿主节点上的端口而不使用宿主节点的网络命名空间

可以通过配置 pod 的`spec.containers.ports`字段中某个容器某一端口的`hostPort`属性来实现。对于使用该属性的 pod，到达宿主节点的端口的连接会被直接转发到 pod 对应的端口上。

而在之前介绍的 NodePort 服务中，到达宿主机的端口的连接将被转发到负载均衡随机选取的 pod 上（即便该 pod 可能在其他节点上）。

另外一个区别是，NodePort 类型的服务会在所有的节点上绑定端口，即便这个节点上没有运行对应的 pod 也是。而 hostPort 的 pod 只会对运行了这类 pod 的节点绑定对应的端口。

![13-2.png](./images/13-2.png)

如果想要使用副本（rc、rs、deployment 等）来管理使用了 hostPort 的 pod，要注意它们将永远不会把两个 pod 部署到一个节点上，因为两个相同的进程不能绑定宿主机的同一个端口。同理，如果你只有 3 个节点而要部署 4 个 pod 副本，那将永远只有 3 个副本能部署成功，剩余一个将始终保持 Pending 状态。

**hostPort 功能最初是用于暴露通过 ds（之前介绍过的 DeamonSet）部署在每个节点上的系统服务**。后来也被用于保证一个 pod 的两个副本不被调度到同一节点，但是现在有更好的方法来实现后者这一需求，后面会介绍到。

#### 13.1.3 使用宿主节点的 PID 和 IPC 命名空间

pod spec 中的`hostPID`和`hostIPC`选项与前面的`hostNetwork`类似，当它们被设为 true 时，pod 中的容器会使用宿主节点的 PID 和 IPC 命名空间，这意味着它们能看到宿主机上的全部进程，也能通过 IPC 机制与它们通信。

### 13.2 配置节点的安全上下文











> 本次阅读至P386 13.2 配置节点的安全上下文 400