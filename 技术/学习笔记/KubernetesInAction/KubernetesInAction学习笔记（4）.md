---
name: KubernetesInAction学习笔记（4）
title: KubernetesInAction学习笔记（4）
tags: ["技术","学习笔记","KubernetesInAction"]
categories: 学习笔记
info: "第4章 副本机制和其他控制器：部署托管的pod"
time: 2021/1/2
desc: 'kubernetes in action, 资料下载, 学习笔记'
keywords: ['kubernetes in action', 'k8s学习', '学习笔记']
---

# KubernetesInAction学习笔记（4）

## 第4章 副本机制和其他控制器：部署托管的pod

在实际的使用中，开发者几乎不会直接创建 pod，而是创建 ReplicationController 或 Deployment 这样的资源，由它们来创建并管理实际的 pod，以达到让部署自动运行、保持健康无虚手动干预的目标。

### 4.1 保持 pod 健康

Kubernetes 中，只要将 pod 调度到某个节点，该节点上的 Kubelet 就会运行 pod 中包含的容器，从此只要该 pod 存在，就会保持运行。如果容器的主进程崩溃，Kubelet 将重启容器。所以即便应用程序本身没做任何特殊的事情，在 Kubernetes 中运行也将自动获得自我修复的能力。

但有时候也会出现应用程序没有崩溃，而是出于某些情况“卡死”了的情况，比如说由于内存泄漏而导致的 Error，应用程序不会停止，但已经停止了响应。为确保在这种情况下应用可以重新启动，必须从外部检查应用的运行状况，而不是依赖于应用的内部检测。

#### 4.1.1 介绍存活探针

存活探针（liveness probe）用于检查容器是否还在运行，可以为 pod 中的每个容器单独指定存活探针。如果探测失败，Kubernetes 将定期执行探针并重启容器。

有以下几种探测容器的机制：

- HTTP GET 探针，针对容器的 IP 地址（你指定的端口和路径）执行 GET 请求，若返回错误码或者没有响应则容器将被重新启动
- TCP 套接字探针，尝试与容器指定端口建立 TCP 连接，若连接不成功则容器重新启动。
- EXEC 探针，在容器内执行任意命令并检查该命令的退出状态码。如果状态码不为 0，则被认为失败。

#### 4.1.2 创建基于 HTTP 的存活探针

创建一个 demo-app-unhealth 文件和对应 Dockerfile，该服务应用将会在第五次请求之后爆出 500 错误，随后在探针的作用下重启容器。

```javascript
// app.js 会把客户端的 IP 打印到标准输出，并返回当前域名
// 前 5 次请求都正常，第 5 次之后将会返回 500 错误
const http = require('http')
const os = require('os')

let errorCount = 0

console.log('server starting')
const handler = function (request, response) {
  console.log(request.connection.remoteAddress)
  if (errorCount++ <= 4) {
    response.writeHead(200, { 'Content-Type': 'text/plain; charset=utf-8' })
    response.end(`客户端部署在${os.hostname()}之上`)
  } else {
    response.writeHead(500, { 'Content-Type': 'text/plain; charset=utf-8' })
    response.end(`服务端内部错误`)
  }
  
}
const www = http.createServer(handler)
www.listen(8080)
```

```dockerfile
# Dockerfile
# docker build -f Dockerfile -t k8s-node-demo-unhealth-image .
FROM node
ADD app-unhealth.js /app.js
ENTRYPOINT ["node", "app.js"]
```

```shell
docker build -t k8s-node-demo-unhealth-image .
```

随后创建一个新的 pod 资源的 yaml 文件，使用 create 命令来创建它。

![4-1.png](./images/4-1.png)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: k8s-node-demo-unhealth-pod
spec:
  containers:
  - image: k8s-node-demo-unhealth-image
    imagePullPolicy: Never
    name: k8s-node-demo-unhealth-container
    livenessProbe:
      httpGet:
        path: /
        port: 8080
```

```shell
# 创建对应 pod
kubectl create -f demo-liveness-probe.yaml
# pod/k8s-node-demo-unhealth-pod created
```

该 pod 的描述文件定义了一个 httpGet 存活探针，会定期在端口 8080 路径上执行 HTTP GET 请求，当请求返回 500 状态码时，K8S 就会认为探测失败并重启容器。

#### 4.1.3 使用存活探针

使用 port-forward 命令绑定上面 k8s-node-demo-unhealth-pod 的 8080 端口并进行访问，多次之后触发 500 告警，此时再使用 get 命令查看，会发现 k8s-node-demo-unhealth-pod 对应的 RESTARTS 列的次数已经增加了。

```shell
kubectl port-forward k8s-node-demo-unhealth-pod 8888:8080
# 多次触发返回 500 后
kubectl get pod
```

![4-1-1.png](./images/4-1-1.png)







> 本次阅读至 P86 4.1.3 使用存活探针 104