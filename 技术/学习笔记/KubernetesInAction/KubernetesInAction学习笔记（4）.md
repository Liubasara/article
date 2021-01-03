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

> 当容器重启后，使用`kubectl logs`命令只会显示当前容器的日志，如果想要知道前一个容器为什么终止时，可以通过添加`kubectl logs k8s-node-demo-unhealth-pod --previous`

可以通过查看`kubectl describe`的内容来了解为什么必须重启容器。

```shell
$ kubectl describe pod k8s-node-demo-unhealth-pod
```

```txt
Name:         k8s-node-demo-unhealth-pod
Namespace:    default
Priority:     0
Node:         minikube/192.168.64.2
Start Time:   Sat, 02 Jan 2021 04:25:55 +0800
Labels:       <none>
Annotations:  <none>
Status:       Running
IP:           172.17.0.2
IPs:
  IP:  172.17.0.2
Containers:
  k8s-node-demo-unhealth-container:
    Container ID:   docker://dbed127f2f9759e007135aab8567980497e37727ac6b03e12f1348b25af02c41
    Image:          k8s-node-demo-unhealth-image
    Image ID:       docker://sha256:d6749622b58457ebab44f26791230e4963a765c7589a3f62a5942de216884eed
    Port:           <none>
    Host Port:      <none>
    State:          Waiting
      Reason:       CrashLoopBackOff
    Last State:     Terminated
      Reason:       Error
      Exit Code:    137
      Started:      Sat, 02 Jan 2021 04:57:31 +0800
      Finished:     Sat, 02 Jan 2021 04:59:20 +0800
    Ready:          False
    Restart Count:  11
    Liveness:       http-get http://:8080/ delay=0s timeout=1s period=10s #success=1 #failure=3
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-rv7d4 (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             False
  ContainersReady   False
  PodScheduled      True
Volumes:
  default-token-rv7d4:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-rv7d4
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type     Reason     Age                 From               Message
  ----     ------     ----                ----               -------
  Normal   Scheduled  <unknown>                              Successfully assigned default/k8s-node-demo-unhealth-pod to minikube
  Normal   Killing    40h (x3 over 40h)   kubelet, minikube  Container k8s-node-demo-unhealth-container failed liveness probe, will be restarted
  Normal   Pulled     40h (x4 over 40h)   kubelet, minikube  Container image "k8s-node-demo-unhealth-image" already present on machine
  Normal   Created    40h (x4 over 40h)   kubelet, minikube  Created container k8s-node-demo-unhealth-container
  Normal   Started    40h (x4 over 40h)   kubelet, minikube  Started container k8s-node-demo-unhealth-container
  Warning  Unhealthy  39h (x31 over 40h)  kubelet, minikube  Liveness probe failed: HTTP probe failed with statuscode: 500
  Warning  BackOff    39h (x74 over 40h)  kubelet, minikube  Back-off restarting failed container
```

可以看到容器的退出代码为 137，该代码有特殊的含义——表示该进程由外部信号终止。

137 是两个数字的总和：128 + x，其中 x 是终止进程的信号编号，在这个例子中，x 等于 9，这是 SIGKILL 的信号编号，意味着这个进程被强行终止。

在底部列出的事件也显示了容器为什么终止。

> 当容器被强行终止时，会创建一个全新的容器——而不是重启原来的容器。

#### 4.1.4 配置存活探针的附加属性

在 describe 中可以看到这一行：`Liveness: http-get http://:8080/ delay=0s timeout=1s period=10s #success=1 #failure=3`，除了明确指定的存活探针选项，还可以看到其他属性，例如 delay、timeout、period 等。定义探针时可以自定义下面这些属性：

- delay：在容器启动后多少秒开始探测，delay=0s 则表示立即开始探测
- timeout：发出探测后，容器必须在多少秒内进行响应，比如说 timeout=1 则发出探测后若 1s 后没有响应则记为探测关系。
- period：每多少秒进行一次探测。
- failure：在多少次探测失败后重启容器。

例如要设置初始延迟，请将`initialDelaySeconds`属性Tina驾到存活探针的配置中，如下所示：

```yaml
livenessProbe:
  httpGet:
    path: /
    port: 8080
  # Kubernetes 会在第一次探测前等待 15 秒
  initialDelaySeconds: 15
```

如果没有设置初始延迟，探针将在启动时立即开始探测容器，对于一些复杂的容器来说很可能会失败，这样就可能会导致容器陷入无限循环重启的过程中，所以在设置了探针时，一定要设置好初始延迟。

#### 4.1.5 创建有效的存活探针

创建探针可以遵循以下几点：

- 存活探针应该检查什么

  可以为探针配置为特定的 URL 路径（例如，/health），并让应用从内部运行的所有重要组件执行状态检查，以确保它们都没有终止或停止响应。

- 保持探针轻量

  存活探针不应该消耗太多计算资源，而且运行不应该花太长时间，默认情况下，如果探测器执行频率相对高，就必须在一秒之内执行完毕。

  > 如果你在容器中运行 JAVA 应用程序，请确保一定要使用 HTTP GET 存活探针。而不是启动全新 JVM 以获取存活信息的 Exec 探针，因为 JVM 的启动需要消耗大量的计算资源。

- 无须在探针中实现重试循环

### 1.2 了解 ReplicationController

ReplicationController 是一种 Kubernetes 资源，可确保它的 pod 始终保持运行状态。如果 pod 因任何原因消失，则会创建替代的 pod。

![4-1-2.png](./images/4-1-2.png)

#### 4.2.1 ReplicationController 的操作

ReplicationController 会持续监控正在运行的 pod 列表，并保证相应“类型”（其实就是是否匹配某个标签 label 选择器）的 pod 的树木与期望相符。

如果 pod 太少，将会根据模板创建新的副本，如果 pod 太多，将会删除多余的副本。

![4-2.png](./images/4-2.png)

##### 了解 ReplicationController 的三部分

- label selector（标签选择器），用于确定 ReplicationController 作用域中有哪些 pod
- replica count（副本个数），指定应运行的 pod 数量
- pod template（pod 模板），用于创建新的 pod 副本

![4-3.png](./images/4-3.png)

如果更改标签选择器和 pod 模板，对现有的 pod 运行没有影响，但会使他们脱离 ReplicationController 的范围，因此控制器会停止关注它们。

##### 使用 ReplicationController 的好处

ReplicationController 提供了以下的功能：

- 确保一个 pod 持续运行
- 集群节点发生故障时，可以为故障节点上运行的所有的受 ReplicationController 控制的 pod 创建替代副本
- 轻松实现 pod 的水平伸缩——手动和自动都可以

#### 4.2.2 创建一个 ReplicationController

可以通过上传 JSON 或 YAML 描述文件来创建 ReplicationController。

![4-4.png](./images/4-4.png)





> 本次阅读至 P93 4.2.2 创建一个 ReplicationController 111