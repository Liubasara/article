---
name: KubernetesInAction学习笔记（10）
title: KubernetesInAction学习笔记（10）
tags: ["技术","学习笔记","KubernetesInAction"]
categories: 学习笔记
info: "第10章 StatefulSet: 部署有状态的多副本应用"
time: 2021/2/10
desc: 'kubernetes in action, 资料下载, 学习笔记'
keywords: ['kubernetes in action', 'k8s学习', '学习笔记']
---

# KubernetesInAction学习笔记（10）

## 第10章 StatefulSet: 部署有状态的多副本应用

### 10.1 复制有状态 pod

rc 和 rs 都通过一个 pod 模板创建多个 pod 副本。这些副本除了它们的名字和 IP 地址不同外，没有什么区别。如果 pod 模板里描述了一个关联到特定持久卷声明的数据卷，那么 rs 的所有副本都会共享这个持久卷声明。

![10-1.png](./images/10-1.png)

因为是在 pod 模板里关联声明的，又会依据 pod 模板创建多个 pod 副本，则不能对每个副本都指定独立的持久卷声明。所以也无法通过一个 rs 来运行一个每个实例都需要独立存储的分布式数据存储服务。（PS：个人理解就是卷跟 rs 绑定不跟 pod 绑定，所以无法保存每个实例特定的状态）

#### 10.1.1 运行每个实例都有单独存储的多副本

那如何让每个 pod 都有独立的存储卷呢，rs 会根据一个 pod 创建一致的副本，所以不能通过它们来达到目的。

##### 手动创建 pod

可以手动创建多个 pod，每个 pod 都使用一个独立的持久卷声明，但这种情况需要自己手动管理，当有的 pod 消失后就需要去手动创建，因此这不是一个好的选择。

##### 一个 pod 实例对应一个 rs

创建多个 rs 并将每个 rs 的副本数设为 1，做到 pod 和 rs 一一对应，为每个 rs 的 pod 模板关联一个专属的持久卷声明。尽管这样能保证 pod 的自动重新调度创建，但这种方法还是比较笨重的，而且，在这种模式下无法进行自动伸缩扩容。

##### 使用同一数据卷的不同目录

还有一个比较取巧的做法是让每个 pod 在数据卷中使用不同的数据目录。

![10-3.png](./images/10-3.png)

但是由于不能指定一个实例使用哪个特定目录而只能让每个实例自动选择或创建一个别的实例还没有使用的数据目录，所以这种方案会要求实例之间相互协作，其正确性很难保证。同时，共享存储也会成为整个应用的性能瓶颈。

#### 10.1.2 每个 pod 都需要提供稳定的标识

除了上面说的存储需求，集群应用也会要求每一个实例拥有生命周期内的唯一标识。也就是新的 pod 不应该使用旧实例的数据。

**之所以会有这种需求，是因为在能够支持分布式部署的应用中，通常都会要求管理者在每个集群成员的配置文件中列出所有其他集群成员和它们的 IP 地址（或主机名）。但在 K8S 中，每次重新调度一个 pod，其集群成员就会有一个新的主机名和 IP 地址**。

一个比较取巧的做法是：针对集群中的每个成员实例，都创建一个独立的 K8S Service 来提供稳定的网络地址。因为服务 IP 是固定的，可以在配置文件中指定**集群成员对应的服务 IP（而不是 pod IP）**。

这种做法跟之前提到的为每个成员创建一个 ReplicaSet 并配置独立存储是一样的，将这两种方法结合起来就是如下的架构：

![10-4.png](./images/10-4.png)

但这种解决方法其实十分粗糙，最实际的一点就是：每个 pod 无法知道其他特定状态的 pod 所对应的 Service 和 IP。就算使用 headless Service，也会由于其他的 pod 副本的名称中包含随机生成的 hash 值而无法确定准确的域名。

### 10.2 了解 Statefulset

幸运的是，K8S 提供了这类需求的完美解决方案：Statefuleset。

在 Statefulset 中运行的应用每一个实例都是不可替代的个体，都拥有稳定的名字和状态。

#### 10.2.1 对比 Statefulset 和 ReplicaSet

Statefulset（以下简称 ss）又称有状态的应用。和 rs 与 rc 相比，后两者所管理的 pod 都是无状态的，任何时候它们都可以被一个全新的 pod 替换。**而 ss 的实例如果要重建，则必须与被替换的实例拥有相同的名称、网络标识和状态，这就是 ss 管理 pod 的方法**。

与 rs 类似，ss 也会指定期望的副本数，决定同一时间内运行的副本数量，同样也是根据指定的 pod 模板创建 pod。**但不同的是**，ss 创建的 pod 副本并不是完全一样的。**每个 pod 都可以拥有一组独立的数据卷（持久化状态），此外，每个 pod 副本的名字都是固定的**。

一个 ss 创建的每个 pod 都有一个从零开始的顺序索引，这些会体现在 pod 的名称和主机名还有对应的固定存储上。这些 pod 的名称是可以预知的，由 ss 的名称加上该实例的顺序索引值所组成。

![10-5.png](./images/10-5.png)

#### 10.2.2 提供稳定的网络标识

让 pod 拥有可预知的名称和主机名并不是全部，如上一节所说，有状态的 pod 需要通过其主机名来定位，在操作时也希望操作的是其中处于特定状态的某一个。

基于这种原因，一个 ss 通常会要求你创建一个用来记录每个 pod 网络标记的 headless Service（前面介绍过，详情见第 5 章）。

> 简单来讲，headless 服务就是一种能够让 pod 通过服务访问特定的 pod 的服务，而不是像一般的服务那样通过服务代理的负载均衡来随机选择一个 pod。

通过 headless Service，每个 pod 将拥有独立的 DNS 记录，这样就方便集群里它的伙伴或客户端可以通过主机名方便的找到它。比如说，default 命名空间中名为 foo 的控制服务有一个 pod 的名称为 A-0，那么其完整域名即为`a-0.foo.default.svc.cluster.local`。

此外，在后面的章节中会介绍到，还可以通过域名查找所有的 SRV 记录来获取一个 ss 中所有 pod 的名称。

##### 替换消失的副本

当一个 ss 管理的一个 pod 实例消失了以后（pod 所在节点发生故障，或是有人手动删除了 pod）。ss 会重启一个新的 pod 实例替换它，与 rs 和 rc 不同的是，新的 pod 会拥有与之前的 pod 完全一样的主机名。

![10-6.png](./images/10-6.png)

但有一点与无状态 pod 相同，新的 pod 并不一定会调度到相同的节点上，对于有状态的 pod 来说也是这样。

##### 扩缩容 Statefulset

有状态的 pod 缩容将会最先删除最高索引值的实例，缩容的结果是可预知的。

![10-7.png](./images/10-7.png)

要注意，ss 的缩容在任何时候都只会操作一个 pod 实例，所以有状态应用的缩容不会很迅速。原因是如果同时有两个实例下线，一份数据记录就会丢失。如果缩容是线性的，分布式存储就有时间把丢失的副本复制到其他节点，保证数据不会丢失。

基于以上原因，ss 在有实例不健康的情况下是不容许做缩容操作的。

#### 10.2.3 为每个有状态的实例提供稳定的专属存储

有状态的 pod 的存储必须是持久的，并且与 pod 解耦。通过在 pod 模板中添加卷声明模板，可以让 ss 依据 pod 的个数创建相同数量的持久卷量。

##### 在 pod 模板中添加卷声明模板

一个 ss 可以拥有一个或多个卷声明模板，这些持久卷声明会在创建 pod 前创建出来，绑定到一个 pod 实例上。

![10-8.png](./images/10-8.png)

##### 持久卷的创建和删除

当 ss 进行扩容的时候，会创建一个 pod + 与之关联的一个或多个持久卷声明。但缩容的时候则只会删除一个 pod。

只有手动删除声明，与 pod 实例绑定的持久卷才会被回收或删除。

也正因如此，新的 pod 实例能够运行到与之前完全一致的状态，如果因为误操作而缩容了一个 ss，马上就可以做一次扩容来弥补自己的过失。

![10-9.png](./images/10-9.png)

#### 10.2.4 Statefulset 的保障

ss 不仅拥有稳定的标记和独立的存储，它的 pod 还有其他的一些保障。

K8S 必须保证两个拥有相同标记和绑定相同持久卷声明的有状态的 pod 实例不会同时运行。**一个 ss 必须保证有状态的 pod 实例的 at-most-one 语义**。也就是说 ss 必须在准确确认一个 pod 不再运行后，才会去创建它的替换 pod。

### 10.3 使用 Statefulset

接下来实际创建一个 ss，看看它是如何工作的。

#### 10.3.1 创建应用和容器镜像

首先创建一个**根据挂载卷中是否存在某文件来返回相应不同返回的 node 服务**镜像。

![code-10-1.png](./images/code-10-1.png)

```javascript
// app.js
// app.js 会把客户端的 IP 打印到标准输出，并返回当前域名
const http = require('http')
const os = require('os')
const fs = require('fs')

// 挂载目录所在位置的数据文件
const dataFile = '/var/data/test.txt'

console.log('server starting')
const handler = function (request, response) {
  if (request.method === 'POST') {
    let file = fs.createWriteStream(dataFile)
    file.on('open', function (fd) {
      request.pipe(file)
      console.log('post 请求的数据已存储至挂载卷对应文件中')
      response.writeHead(200, { 'Content-Type': 'text/plain; charset=utf-8' })
      response.end('post 所传输数据已被存储至 pod ' + os.hostname() + '\n')
    })
  } else {
    let data = fs.existsSync(dataFile) ? fs.readFileSync(dataFile, 'utf8') : '还没有任何数据被存储至后台文件系统'
    response.writeHead(200, { 'Content-Type': 'text/plain; charset=utf-8' })
    response.write('访问 pod 为: ' + os.hostname() + '\n')
    response.end('获得数据为: ' + data + '\n')
  }
}
const www = http.createServer(handler)
www.listen(8080)
```

上述后台应用会将 post 输入的数据存储在某个目录文件中，然后在接受到 GET 请求以后将文件的内容返回。

```shell
# 测试
$ curl -X POST -d 'lalalala' http://127.0.0.1:8080
post 所传输数据已被存储至 pod MacBook-Pro.local
$ curl http://127.0.0.1:8080                                                                                
访问 pod 为: LHWdeMacBook-Pro.local
获得数据为: lalalala
$ cat /tmp/test.txt
lalalala
```

接下来通过`docker build -f Dockerfile -t demo-statefulset-node-image .`构建镜像后，就可以通过 ss 部署应用了。

#### 10.3.2 通过 Statefulset 部署应用

为了部署你的应用，需要创建两个（或三个）不同类型的资源：

- 存储数据文件的持久卷
- Statefulset 必需的一个控制服务（headless Service）
- Statefulset 本身

对于每一个 pod 实例，ss 都会创建一个绑定到一个持久卷上的持久卷声明。因此第一步是先创建持久卷。

> 由于这里使用的是 minikube，所以使用 hostpath 来创建持久卷（PersistentVolume）

##### 创建持久化存储卷

为接下来调度 ss 创建三个副本做准备，这里需要创建三个持久卷。

![code-10-3.png](./images/code-10-3.png)

```yaml
kind: List
apiVersion: v1
items:
- apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: pv-a
  spec:
    capacity:
      storage: 1Mi
    accessModes:
      - ReadWriteOnce
    persistentVolumeReclaimPolicy: Recycle
    hostPath:
      path: /tmp/pv-a
- apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: pv-b
  spec:
    capacity:
      storage: 1Mi
    accessModes:
      - ReadWriteOnce
    persistentVolumeReclaimPolicy: Recycle
    hostPath:
      path: /tmp/pv-b
- apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: pv-c
  spec:
    capacity:
      storage: 1Mi
    accessModes:
      - ReadWriteOnce
    persistentVolumeReclaimPolicy: Recycle
    hostPath:
      path: /tmp/pv-c
```

```shell
$ kubectl create -f demo-statefulset-persistent-volume.yaml
persistentvolume/pv-a created
persistentvolume/pv-b created
persistentvolume/pv-c created
```

##### 创建控制服务（headless service）

在部署一个 ss 之前，还需要创建一个用于在有状态的 pod 之间提供网络标识的 headless Service。

![code-10-4.png](./images/code-10-4.png)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: demo-statefulset-headless-service
spec:
  clusterIP: None
  selector:
    app: demo-statefulset-pod-label
  ports:
  - name: http
    port: 80
```

```shell
$ kubectl create -f demo-statefulset-headless-service.yaml
service/demo-statefulset-headless-service created
```

##### 创建 Statefulset 详单

最后就可以创建 Statefulset。

> 拓展阅读：[Statefulset详细解析](https://www.cnblogs.com/yxh168/p/12327404.html)
>
> 定义 Stateful 的对象中有一个 serviceName 字段来告诉 Stateful 控制器使用具体的service来解析它所管理的 Pod 的 IP 地址。

![code-10-5.png](./images/code-10-5.png)

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: demo-statefulset
spec:
  # 定义 Stateful 的对象中有一个 serviceName 字段来告诉 Stateful 控制器使用具体的 service 来解析它所管理的Pod的IP地址
  # 指定用于查询 pod dns IP 地址的 headless service 
  serviceName: demo-statefulset-headless-service
  replicas: 2
  selector:
    matchLabels:
      app: demo-statefulset-pod-label
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      resources:
        requests:
          storage: 1Mi
      accessModes:
      - ReadWriteOnce
  template:
    metadata:
      labels:
        app: demo-statefulset-pod-label
    spec:
      containers:
      - name: demo-statefulset-pod
        imagePullPolicy: Never
        image: demo-statefulset-node-image
        ports:
        - name: http
          containerPort: 8080
        volumeMounts:
        - name: data
          mountPath: /var/data
```

```shell
$ kubectl create -f demo-statefulset.yaml
statefulset.apps/demo-statefulset created

$ kubectl get statefulsets
NAME               READY   AGE
demo-statefulset   2/2     2m1s

$ kubectl get pod
NAME                 READY   STATUS    RESTARTS   AGE
demo-statefulset-0   1/1     Running   0          2m7s
demo-statefulset-1   1/1     Running   0          2m4s
```

可以看到，ss 会按顺序一个一个创建并启动 pod。

#### 10.3.3 使用 ss 创建的 pod

现在可以开始使用这些 pod 了。但要注意因为是有状态的 pod，所以无法通过会自动负载均衡的 service 来访问指定的 pod。

可以借助另一个 pod 然后在里面运行 curl 命令访问特定的 pod 来达到访问指定 pod 的目的，但接下来介绍另外一种做法：通过 API 服务器作为代理。

##### 通过 API 服务器与 pod 通信

通信可以通过如下 URL 来访问指定的 pod：

`<apiServerHost>:<port>/api/v1/namespaces/default/pods/<pod-name>/proxy/<path>`

因为还可以借助`kubectl proxy`来跳过 API 服务器的 https 认证，最后访问的 URL 则应该是：

```shell
$ kubectl proxy
Starting to serve on 127.0.0.1:8001

$ curl http://127.0.0.1:8001/api/v1/namespaces/default/pods/demo-statefulset-0/proxy/
访问 pod 为: demo-statefulset-0
获得数据为: 还没有任何数据被存储至后台文件系统

$ curl -X POST -d 'lalalala' http://127.0.0.1:8001/api/v1/namespaces/default/pods/demo-statefulset-0/proxy/
post 所传输数据已被存储至 pod demo-statefulset-0

$ curl http://127.0.0.1:8001/api/v1/namespaces/default/pods/demo-statefulset-0/proxy/
访问 pod 为: demo-statefulset-0
获得数据为: lalalala
```

如上能够返回正确的请求，证明确实到达了指定的 pod。

##### 验证删除一个有状态 pod 来检查重新调度的 pod 是否关联了相同的存储

![10-11.png](./images/10-11.png)

```shell
$ kubectl delete pod demo-statefulset-0
pod "demo-statefulset-0" deleted

$ kubectl get pod
NAME                 READY   STATUS        RESTARTS   AGE
demo-statefulset-0   1/1     Terminating   0          51m
demo-statefulset-1   1/1     Running       0          51m

$ curl http://127.0.0.1:8001/api/v1/namespaces/default/pods/demo-statefulset-0/proxy/
访问 pod 为: demo-statefulset-0
获得数据为: lalalala
```

验证成功。

##### 通过一个普通的非 headless 的 Service 暴露 Statefulset 的 pod

![code-10-7.png](./images/code-10-7.png)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: demo-statefulset-service
spec:
  selector:
    app: demo-statefulset-pod-label
  ports:
  - name: http
    port: 80
    targetPort: 8080
```

```shell
$ kubectl create -f demo-statefulset-service.yaml
service/demo-statefulset-service created
```

这是一个普通的负载均衡服务，并不会对外部暴露端口，其作用是让集群内的 pod 通过 service 访问 ss 中的 pod。**当然，访问服务的每个请求都会随机获取一个 pod 上的数据**。

### 10.4 在 Statefulset 中发现伙伴节点

除了向 K8S API 服务器发送请求以外，ss 中的 pod 还可以通过  DNS 记录里面的 SRV 记录来与集群中的其他 pod 通信。

##### 介绍 SRV 记录

SRV 用于指向提供服务的服务器的主机名和端口号，K8S 通过一个 headless service 创建 SRV 记录来指向 pod 的主机名。

可以通过在一个 pod 中通过 dig 命令查看 headless 服务的 SRV 记录。

```shell
$ kubectl exec -it dnsutils -- bash
root@dnsutils:/# dig SRV demo-statefulset-headless-service.default.svc.cluster.local

...
;; ANSWER SECTION:
demo-statefulset-headless-service.default.svc.cluster.local. 30	IN SRV 0 50 80 demo-statefulset-1.demo-statefulset-headless-service.default.svc.cluster.local.
demo-statefulset-headless-service.default.svc.cluster.local. 30	IN SRV 0 50 80 demo-statefulset-0.demo-statefulset-headless-service.default.svc.cluster.local.

;; ADDITIONAL SECTION:
demo-statefulset-1.demo-statefulset-headless-service.default.svc.cluster.local.	30 IN A	172.17.0.3
demo-statefulset-0.demo-statefulset-headless-service.default.svc.cluster.local.	30 IN A	172.17.0.5
...
```

> PS：返回的 SRV 记录顺序是随机的，也就是 demo-statefulset-0 不一定会在 demo-statefulset-1 的前面，它们拥有一样的优先级，需要自己进行排序

#### 10.4.1 通过 DNS 实现伙伴间彼此发现

可以看到 SRV DNS 查询会返回每个 pod 独自拥有的 IP 记录。开发者可以在自己的应用中通过触发 SRV DNS 查询来获取这个列表。

```javascript
// eg. 在 Node.js 中的查询命令为
dns.resolveSrv('demo-statefulset-headless-service.default.svc.cluster.local', callbackFunction)
```


![10-12.png](./images/10-12.png)

上图展示了一个 GET 请求到达一个简易的 node 分布式数据存储后台的返回流程。通过触发 headless 服务的 SRV 记录查询然后发送 GET 请求到服务背后的每一个 pod，然后返回所有节点和它们存储的数据。

![code-10-9.png](./images/code-10-9.png)

PS：镜像略微有点复杂，不复现，理解意思就好～

#### 10.4.2 更新 Statefulset

跟 rs 一样，ss 的修改也可以使用`kubectl edit`等命令（`kubectl edit statefulset demo-statefulset`）。同样，因为不是 deployment 资源，所以模板被修改后，原有的 pod 不会重启更新。

> 除了`kubectl edit`命令以外，还有之前介绍过的`kubectl patch`、`kubectl apply`、`kubectl replace`、`kubectl set image`几个命令。

#### 10.4.3 尝试集群数据存储

除了像之前介绍的直接通过 proxy 向 pod 存储数据，还可以向 service 中存储数据。

```shell
$ curl -X POST -d 'wawawa' http://127.0.0.1:8001/api/v1/namespaces/default/services/demo-statefulset-service/proxy/
post 所传输数据已被存储至 pod demo-statefulset-0
```

> PS： 虽然原理应该没有错，但由于不明原因，笔者上面的命令只能收获一个 503 错误...但 endpoints 却是正常的，尚未清楚问题出在哪里，猜测可能又是 minikube 的某些特性导致。
>
> ```shell
> $ curl http://127.0.0.1:8001/api/v1/namespaces/default/services/demo-statefulset-service/proxy/
> {
>   "kind": "Status",
>   "apiVersion": "v1",
>   "metadata": {
> 
>   },
>   "status": "Failure",
>   "message": "no endpoints available for service \"demo-statefulset-service\"",
>   "reason": "ServiceUnavailable",
>   "code": 503
> }
> $ kubectl get endpoints demo-statefulset-service
> NAME                       ENDPOINTS                         AGE
> demo-statefulset-service   172.17.0.3:8080,172.17.0.5:8080   53m
> ```

#### 10.5.2 手动删除 pod

被 ss 管理的 pod 被删除后会自动创建，但在一些极端情况下（比如说 node 节点忽然断网），该 pod 会陷入 unknown 状态，此时就**无法使用`kubectl delete pod`命令来删除 pod 让 ss 重新部署**，因为 kubectl 工具需要节点返回响应才会完成释放 pod 的步骤，而断掉的节点显然无法完成这一响应。此时就需要**强制删除**了。

##### 强制删除 pod

```shell
$ kubectl delete pod demo-statefulset-0 --force --grace-period 0
warning: Immediate deletion does not wait for confirmation that the running resource has been terminated. The resource may continue to run on the cluster indefinitely.
pod "demo-statefulset-0" force deleted
```

注意要同时使用`--force`和`--grace-period 0`选项，之后 pod 会被立即强制删除，从而让 ss 触发重新创建流程。

