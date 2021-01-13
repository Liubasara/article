---
name: KubernetesInAction学习笔记（5）
title: KubernetesInAction学习笔记（5）
tags: ["技术","学习笔记","KubernetesInAction"]
categories: 学习笔记
info: "第5章 服务：让客户端发现pod并与之通信"
time: 2021/1/10 23:00
desc: 'kubernetes in action, 资料下载, 学习笔记'
keywords: ['kubernetes in action', 'k8s学习', '学习笔记']
---

# KubernetesInAction学习笔记（5）

## 第5章 服务：让客户端发现pod并与之通信

在没有 K8S 的世界，运维需要明确指出服务的精确的 IP 地址或者主机名，来为每个客户端应用配置，但在 K8S 中，提供了一种专门的资源类型 —— 服务（service）来解决这一场景。主要原因有几点：

- pod 是短暂的——它们会随时启动或关闭或异常
- Kubernetes 在 pod 启动前会给已经调度到节点上的 pod 分配 IP 地址——因此客户端并不能提前知道提供服务的 pod 的 IP 地址。
- 水平伸缩意味着多个 pod 可能会提供相同的服务，而对于客户端来说它们无需关心 pod 的数量以及他们的 ip 地址，相反，所有的 pod 应该都通过一个单一的 IP 地址进行负载平衡式的访问。

### 5.1 介绍服务

Service 能够通过标签 Selector，为一组功能相同的 pod 提供单一不变的接入点资源。当服务存在时，它的 IP 地址和端口就不会改变。

通过创建服务，能够让前端的 pod 通过环境变量或 DNS 以及服务名来访问后端服务。

![5-1.png](./images/5-1.png)

#### 5.1.1 创建服务

创建服务最简单的办法是通过`kubectl expose`，但想要准确定义哪些 pod 属于服务哪些不属于，最好还是通过 yaml 文件启动服务。

![5-2.png](./images/5-2.png)

##### 通过 YAML 描述文件创建服务

![5-1-1.png](./images/5-1-1.png)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: demo-service
spec:
  selector:
    app: k8s-node-demo-replication-controller-label
  ports:
  - port: 80
    targetPort: 8080
```

```shell
$ kubectl create -f demo-service.yaml
# service/demo-service create
$ kubectl get svc
# NAME            TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
# demo-service    ClusterIP      10.98.191.226   <none>        80/TCP           71s
# kubernetes      ClusterIP      10.96.0.1       <none>        443/TCP          18d
```

如上列表显示分配给服务的 IP 地址是 10.98.191.226，**因为只是集群的 IP 地址，只是在集群内部可以被访问**。

服务的主要目标就是使集群内部的其他 pod 可以访问当前这组 pod，但通常也希望向外暴露服务，该部分可以在之后讲解。

##### 从内部集群测试服务

可以通过以下几种方法向服务发送请求：

- 创建一个 pod，将请求发送到服务的集群 IP 并记录响应
- 使用 ssh 远程登录到其中一个 K8S 节点上，然后使用 curl 命令
- 通过`kubectl exec`命令在一个已有的 pod 中执行 curl 命令

此处使用第三种方法，顺带介绍`exec`命令。

##### 在运行的容器中远程执行命令

```shell
$ kubectl exec k8s-node-demo-replication-controller-42nkj -- curl -s http://10.98.191.226
# 客户端部署在k8s-node-demo-replication-controller-zjv22之上

# or
$ kubectl exec k8s-node-demo-replication-controller-42nkj -- curl -s http://demo-service
# 客户端部署在k8s-node-demo-replication-controller-zjv22之上
```

> 为什么是双横杠？
>
> 双横杠（--）代表着 kubectl 命令项的结束，两个横杠之后的内容指的是在容器内部需要执行的命令（如果 pod 中有多个容器，可以在双横杠之前使用`-c`参数进行指定容器，如果没有，则不需要指定）。
>
> 但双横杠也不是必须的，如果在容器内需要执行的命令并没有以横杠开始的参数，那么这条命令就可以不加。

上面 exec 命令的访问过程如下图：

![5-3.png](./images/5-3.png)

由于服务天生是负载均衡的，所以如果多次调用上面的命令，会发现每次返回的响应都执行在不同的 pod 上。**如果希望特定客户端产生的请求每次都指向同一个 pod，可以设置服务的 sessionAffinity 属性为 ClientIP**（而不是None，None 是默认值）

```yaml
apiVersion: v1
kind: Service
metadata:
  name: demo-service
spec:
  sessionAffinity: ClientIP
  ...
```

这种方式将会让服务代理将来自同一个 IP 的所有请求转发到同一个 Pod 上。

K8S 仅支持两种形式的会话亲和性（？？啥翻译）服务：Clinet 和 ClientIP，由于并不是在 HTTP 层面工作而是直接处理 TCP 和 UDP 包，并不关心其荷载的内容，所以并不支持基于 cookie 的会话亲和性选项。

##### 同一个服务暴露多个端口/使用命名的端口

创建的服务可以暴露一个端口，也可以暴露多个端口（**在创建一个有多个端口的服务的时候，必须给每个端口指定 name 字段**）。此外，还可以通过在 pod 的模板中通过命名来指定端口，将端口的控制权反转，交还给 Pod。

```yaml
# 使用多个端口
...
ports:
  - name: http
    port: 80
    targetPort: http
  - name: https
    port: 443
    targetPort: https
```

![5-4-5.png](./images/5-4-5.png)

```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: k8s-node-demo-replication-controller
spec:
  replicas: 3
  selector:
    app: k8s-node-demo-replication-controller-label
  template:
    metadata:
      name: k8s-node-demo-replication-controller-pod
      labels:
        app: k8s-node-demo-replication-controller-label
    spec:
      containers:
      - name: k8s-node-demo-replication-controller-container
        image: k8s-node-demo-image
        imagePullPolicy: Never
        ports:
        - name: http
          containerPort: 8080
        - name: https
          containerPort: 8443
```

```yaml
apiVersion: v1
kind: Service
metadata:
  name: demo-service
spec:
  # 同一个 IP 的客户端发起的请求将会被转发到同一个 pod
  sessionAffinity: ClientIP
  selector:
    app: k8s-node-demo-replication-controller-label
  ports:
  - name: http
    port: 80
    targetPort: http
  - name: https
    port: 443
    targetPort: https
```



> PS：标签选择器（selector）应用于整个服务，不能对每个端口做单独的配置，如果不同的 pod 有不同的端口映射，则需要创建两个服务。

为什么要命名端口？最大的好处就是即使更换端口号也无须更改服务的 spec，假如现在的 pod 的 http 服务用的是 80 端口，想要切换到其他端口，只要通过修改 pod 模板就可以了。

#### 5.1.2 服务发现

虽然在客户端外部可以通过`kubectl get svc`来查看服务所获得的内部 ip 地址和端口，但在 pod 内部要如何知道这些信息呢？为解决这个问题，K8S 为 pod 内部提供了发现服务的 IP 和端口的方式。

##### 通过环境变量发现服务

当 pod 开始运行，K8S 会初始化一系列环境变量指向存在的服务，当新的服务被创建，新的环境变量也会被注入到现有的 pod 中。

可以在 pod 的容器中运行`env`命令来查看当前的环境变量。

![5-6.png](./images/5-6.png)

```shell
$ kubectl exec -it k8s-node-demo-replication-controller-2fb2d -- bash
root@k8s-node-demo-replication-controller-2fb2d:/# env
# ...
# HOSTNAME=k8s-node-demo-replication-controller-2fb2d
# DEMO_SERVICE_SERVICE_HOST=10.105.106.251
# KUBERNETES_SERVICE_HOST=10.96.0.1
```

当 pod 需要访问服务时，可以通过`服务名称大写_SERVICE_HOST`和`服务名称大写_SERVICE_PORT`去获取 IP 地址和端口信息。

> 对于注入的服务环境变量，服务名称中的横杠会被转换为下划线，且所有字母都是大写

##### 通过 DNS 发现服务

除了环境变量，还可以通过 DNS 来发现服务的 IP 地址和端口。

在 kube-system 命名空间中，有一个用于管理 dns 的 pod（coredns-xxxxxx），这个 pod 会将集群中的其他 pod 都配置成使用 coredns 来作为 dns 查询的服务。（Kubernetes 通过修改每个容器的 /etc/resolv.conf 文件实现这个功能）。所有运行在 pod 上的进程的 DNS 查询都会被 Kubernetes 自身的 DNS 服务器响应。

> PS：pod 是否使用内部的 DNS 服务器是根据 pod 中 dpec 的 dnsPolicy 属性来决定的

每个服务会从内部的 DNS 服务器中获得一个 DNS 条目，pod 在知道服务名称的情况下可以通过全限定域名（FQDN）来访问，而不是诉诸于环境变量。

##### 通过 FQDN 连接服务

```shell
$ kubectl exec -it k8s-node-demo-replication-controller-k6rdr -- bash
root@k8s-node-demo-replication-controller-k6rdr:/# curl -s http://demo-service.default.svc.cluster.local
# 客户端部署在k8s-node-demo-replication-controller-t7xn2之上
```

FQDN 的格式为：demo-service.default.svc.cluster.local，其中：

- demo-service 对应服务名称
- default 代表服务在其中定义的命名空间
- svc.cluster.local 是所有集群本地服务名称中使用的可配置集群的后缀

连接一个服务可能比这更简单，如果要连接的服务的 pod 和发起请求的 pod 在同一个命名空间下，甚至可以省略`svc.cluster.local`的后缀和命名空间，也就是说只需要 demo-service 这个服务名称就可以。

造成这个的原因是由于 pod 容器的 DNS 解析配置的方式，可以将这些省略掉。

```shell
root@k8s-node-demo-replication-controller-k6rdr:/# cat /etc/resolv.conf
# nameserver 10.96.0.10
# search default.svc.cluster.local svc.cluster.local cluster.local
# options ndots:5
```

```shell
root@k8s-node-demo-replication-controller-k6rdr:/# curl -s http://demo-service
# 客户端部署在k8s-node-demo-replication-controller-t7xn2之上
```

> 客户端仍然必须知道服务的端口号，上面的命令只是因为 http 的默认端口刚好是服务暴露出来的 80 端口。如果并不是标准端口，则还是需要从环境变量中获取端口号。

##### 无法 ping 通服务 IP 的原因

服务的集群 IP 是一个虚拟 IP，并且只有在与服务端口结合时才有意义，因此会出现明明可以 curl 访问却无法 ping 通的情况，因为 pod 容器并没有对应 ping 功能的服务。这个现象是正常的。

### 5.2 连接集群外部的服务











> 本次阅读至 P132 5.2 连接集群外部的服务 149