---
name: KubernetesInAction学习笔记（8）
title: KubernetesInAction学习笔记（8）
tags: ["技术","学习笔记","KubernetesInAction"]
categories: 学习笔记
info: "第8章 从应用访问 pod 元数据以及其他资源"
time: 2021/2/2
desc: 'kubernetes in action, 资料下载, 学习笔记'
keywords: ['kubernetes in action', 'k8s学习', '学习笔记']
---

# KubernetesInAction学习笔记（8）

## 第8章 从应用访问 pod 元数据以及其他资源

本章将介绍特定的 pod 和容器元数据如何被传递到容器，了解其中的应用如何便捷地与 K8S API 服务器进行交互。

### 8.1 通过 Downward API 传递元数据

通过 Kubernetes Downward API，可以允许通过环境变量或文件（在 downwardAPI 卷中）传递 pod 的元数据，比如说 pod 的 ip、主机名等等。

![8-1.png](./images/8-1.png)

#### 8.1.1 了解可用的元数据

以下 pod 的元数据可以传递容器：

- pod 名称
- pod 的 IP
- pod 所在的命名空间
- pod 运行节点的名称
- pod 运行所归属的服务账号的名称
- 每个容器请求的 CPU 和内存的使用量
- 每个容器可以使用的 CPU 和内存的限制
- pod 的标签
- pod 的注解

#### 8.1.2 通过环境变量暴露元数据

![code-8-1](./images/code-8-1.png)

![8-2.png](./images/8-2.png)

像这样，pod 的 yaml 配置文件的数据就可以在容器创建的时候被反向传递到容器中去了。

#### 8.1.3 通过 downwardAPI 卷来传递元数据

创建一个 downwardAPI 卷并挂载到容器中，可以使用文件的方式而不是环境变量的方式暴露元数据。

![code-8-3.png](./images/code-8-3.png)

![8-3.png](./images/8-3.png)

将 pod 信息作为文件挂载的好处是，**当 pod 的元信息被修改后，K8S 会更新存有相关信息的文件，从而使 pod 可以获取最新的数据**。

通过 Downward API 的方式获取的元数据还是相当有限的，如果需要获取更多的元数据，需要使用直接访问 K8S API 服务器的方式。

### 8.2 与 K8S API 服务器交互

#### 8.2.1 探究 Kubernetes REST API

通过`kubectl cluster-info`命令来得到服务器的 URL。然后执行`kubectl proxy`命令通过代理与服务器交互。

```shell
$ kubectl cluster-info
Kubernetes master is running at https://192.168.64.2:8443
KubeDNS is running at https://192.168.64.2:8443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

##### 通过 kubectl proxy 访问 API 服务器

proxy 命令会启动一个代理服务来接受来自本机的 HTTP 连接并转发至转发至 API 服务器。

```shell
$ kubectl proxy
Starting to serve on 127.0.0.1:8001
```

这样就可以通过本地的 8001 端口来访问 API 服务器了。

```shell
$ curl localhost:8001
{
  "paths": [
    "/api",
    "/api/v1",
    "/apis",
    "/apis/",
    ...
```

##### 通过 Kubectl proxy 研究 Kubernetes API













> 本次阅读至 P239 通过 Kubectl proxy 研究 Kubernetes API 254

