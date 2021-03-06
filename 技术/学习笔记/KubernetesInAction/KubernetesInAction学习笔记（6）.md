---
name: KubernetesInAction学习笔记（6）
title: KubernetesInAction学习笔记（6）
tags: ["技术","学习笔记","KubernetesInAction"]
categories: 学习笔记
info: "第6章 卷：将磁盘挂载到容器"
time: 2021/1/23
desc: 'kubernetes in action, 资料下载, 学习笔记'
keywords: ['kubernetes in action', 'k8s学习', '学习笔记']
---

# KubernetesInAction学习笔记（6）

## 第6章 卷：将磁盘挂载到容器

 本章介绍 pod 中的容器是如何访问外部磁盘存储的，以及如何在它们之间共享存储空间。

之前介绍过，pod 中的各个容器共享诸如 CPU、RAM、网络接口等资源，**但是，其中并不包括磁盘资源，pod 中的每个容器都有自己的独立的文件系统，因为文件系统来自容器镜像**。

每个新容器都是通过在构建镜像时加入的详细配置文件来启动的，并不会识别前一个容器的状态，但在某些场景下，可能希望新的容器可以在之前容器结束的位置继续运行。

这种情况下并不需要整个文件系统被持久化，但又希望能保存实际数据的目录。这种情况可以通过定义存储卷来满足这个需求，它们被定义为 pod 的一部分，并与 pod 共享相同的生命周期。这意味着在 pod 启动时创建卷，并在删除 pod 时销毁卷。因此，在容器重新启动期间，卷的内容将保持不变，新容器可以识别前一个容器写入卷的所有文件。另外，如果一个 pod 包含多个容器，那么这个卷也可以同时被所有的容器使用。

### 6.1 介绍卷

K8S 中的卷不是一个单独的资源，而是包含在 pod 的规范中。pod 中的所有容器都可以使用卷，但必须先将它挂在在每个需要访问它的容器中，每个容器都可以在其文件系统的任意位置挂载卷。

> 创建 demo 镜像：每 10 秒在一个文件夹中生成包含一句随机谚语的 html 文件镜像，基于 ubuntu。
>
> 对应 Dockerfile 文件：
>
> ```dockerfile
> FROM ubuntu
> RUN apt-get update ; apt-get -y install fortune
> ADD fortuneloop.sh /bin/fortuneloop.sh
> RUN chmod a+x /bin/fortuneloop.sh
> ENTRYPOINT /bin/fortuneloop.sh
> ```
>
> 对应入口文件 fortuneloop.sh ：
>
> ```shell
> #!/bin/bash
> # 可以用 tee 命令生成文件
> # 阻止脚本中断信号
> trap "exit" SIGINT
> mkdir /var/htdocs
> while :
> do
>   echo $(TZ=UTC-8 date) writing fortune to /var/htdocs/index.html
>   echo "$(TZ=UTC-8 date)  $(/usr/games/fortune)" > /var/htdocs/index.html
>   sleep 10
> done
> ```
>
> 构建命令：
>
> ```shell
> $ docker build -f ./Dockerfile -t fortune-demo-image .
> ```
>
> 可通过下列命令查看效果：
>
> ```shell
> $ docker run -dit --name fortune-demo-container fortune-demo-image && docker exec -it fortune-demo-container bash
> root@ede6a2768569:/# cat /var/htdocs/index.html
> ```

#### 6.1.1 卷的应用示例

以下的例子中，将两个卷添加到 pod 中，并在三个容器的适当路径上挂载它们，这样的话三个容器就可以一起工作，数据互通，并发挥作用。

![6-2.png](./images/6-2.png)

一般来讲，卷被绑定到 pod 的生命周期中，只有在 pod 存在时才会存在，但取决于卷的类型，即便在 pod 和卷消失之后，**卷的文件**也有可能保持原样，并可以挂载到新的卷中，这取决于卷的类型。

#### 6.1.2 介绍可用的卷类型

以下是几种可用的卷类型：

- emptyDir：用于存储临时数据的简单空目录
- hostPath：用于将目录从工作节点的文件系统挂载到 pod 中
- gitRepo：通过检出 Git 仓库的内容来初始化的卷
- nfs：挂载到 pod 中的 NFS 共享卷
- gcePersistentDisk（google）、awsElasticBlockStore（亚马逊）、azureDisk（微软）：用于挂载云服务商提供的特定存储类型
- configMap、secret、downwardAPI：用于将 K8S 部分资源和集群信息公开给 pod 的特殊类型的卷
- persistentVolumeClaim：一种使用预置或着动态配置的持久存储类型

单个容器可以同时使用不同类型的多个卷。

### 6.2 通过卷在容器之间共享数据

最简单的类型就是 emptyDir 卷，这种类型对于在同一个 pod 中几个容器之间共享文件特别有用，也可以被单个容器用于将数据写入磁盘。（数据也可以写入容器的文件系统本身，但有时候容器的文件系统甚至是不可写的，所以使用挂载卷成为了另一种选择）

在下面的例子中，将使用 nginx 镜像搭配上面构建的 fortune 镜像，构建一个基于共同的卷返回一个随机内容的 html 文件的 pod。

##### 在 pod 中使用 emptyDir 卷&&创建 pod

![6-1.png](./images/6-1.png)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: demo-fortune-pod
spec:
	volumes:
  - name: html
    emptyDir: {}
  containers:
  - image: fortune-demo-image
    imagePullPolicy: Never
    name: html-generator
    volumeMounts:
    - name: html
      mountPath: /var/htdocs
  - image: nginx:alpine
    imagePullPolicy: Never
    name: web-server
    volumeMounts:
    - name: html
      mountPath: /usr/share/nginx/html
      readOnly: true
    ports:
    - name: http
      containerPort: 80
      protocol: TCP
```

该 pod 包含两个容器和一个挂载在两个容器中的公用的卷，但却挂载在不同的容器内路径上。达成的效果就是由 html-generator 在 mountPath 生成的 html 文件会通过卷，更新在 web-server 的 mountPath 路径中。

```shell
$ kubectl create -f demo-fortune-pod.yaml
pod/demo-fortune-pod created
# 通过 port-forward 进行端口映射，随后可以使用浏览器访问节点端口测试
$ kubectl port-forward demo-fortune-pod 8080:80
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
```

##### 指定用于 EMPTYDIR 的介质

作为卷来使用的 emptyDir，是在 pod 所在的工作节点的实际磁盘上创建的，因此卷的性能也就取决于节点的磁盘性能。但也可以通知 K8S 在内存而不在硬盘上创建 emptyDir，只要设置 medinum 项为 Memory 就可以。

![6-3.png](./images/6-3.png)

emptyDir 卷是最简单的卷类型，其他类型的卷都是在它的基础上预填充数据构建的。

#### 6.2.2 使用 Git 仓库作为存储卷

gitRepo 卷基本上也是一个 emptyDir 卷，但会通过克隆 Git 仓库并在 pod 启动时检出特定版本来填充数据。

![6-3-1.png](./images/6-3-1.png)

![6-2-1.png](./images/6-2-1.png)

上面的配置中，值得注意的是 directory 被设置为 .（句号），它代表存储库将会被克隆到根目录中，而不是另起一个文件夹存储仓库的数据。

但要注意的是，**gitRepo 卷不支持私有仓库**，正确来说，应该是卷不支持任何通过 SSH 协议克隆私有仓库的方法。想要实现私有仓库同步这个目标，应该使用一个额外的容器（比如说 gitsync sidecar 这类镜像）来保持同步，而不是使用 gitRepo 卷。

### 6.3 访问工作节点文件系统上的文件

大多数 pod 应该忽略它们的主机节点，也不应该访问节点文件系统傻姑娘的任何文件，但是某些系统级别的 pod （通常由 DaemonSet 管理）会有这个需求，K8S 通过 hostPath 卷实现了这一点。

#### 6.3.1 介绍 hostPath 卷

hostPath 卷指向节点的文件系统上的特定文件或目录。

![6-4.png](./images/6-4.png)

hostPath 是一种持久性存储，不像 gitRepo 和 emptyDir 的内容会在 pod 删除时同时删除，hostPath 卷的内容指向主机上的一个路径，如果一个 pod 被删除了，下一个被创建的相同的 pod 会发现上一个 pod 留下的数据（前提是新的 pod 被调度到了相同的节点上）

但是无论如何，常规的 pod 都不应该使用 hostPath 卷作为存储数据的目录，因为当 pod 被安排在另一个节点时，会找不到数据。（PS：除非你用 nodeSelector 通过标签把节点和 pod 强绑定）

### 6.4 使用持久化存储

当 pod 需要将数据保存到磁盘上，且要求即使该 pod 重新调度到一个新节点也依然能使用相同的数据时，此时就不能使用迄今为止提到的任何卷类型。数据必须存储在某种类型的网络存储（NAS）中。

![6-4-1.png](./images/6-4-1.png)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: demo-persistent-volume-pod
spec:
  volumes:
  - name: demo-persistent-volume-pod-mongodb-data
    hostPath:
      path: /tmp/demo-persistent-volume-pod-mongodb
  containers:
  - image: mongo
    imagePullPolicy: Never
    name: demo-persistent-volume-pod-container
    volumeMounts:
    - name: demo-persistent-volume-pod-mongodb-data
      mountPath: /data/db
    ports:
    - containerPort: 27017
      protocol: TCP
```

```shell
$ kubectl exec -it demo-persistent-volume-pod mongo
```

![6-5-1.png](./images/6-5-1.png)

```shell
> db.foo.find()
{ "_id" : ObjectId("60118d315a02120a9a8c81b3"), "name" : "foo" }
```

随后可以删除 pod 再创建，执行同样的 find 操作，看数据是否还存在。

```shell
{ "_id" : ObjectId("60118d315a02120a9a8c81b3"), "name" : "foo" }
```

```shell
$ kubectl delete pod demo-persistent-volume-pod
pod "demo-persistent-volume-pod" deleted

$ kubectl create -f demo-persistent-volume-pod.yaml
pod/demo-persistent-volume-pod created

$ kubectl exec -it demo-persistent-volume-pod mongo

> use mystore
switched to db mystore
> db.foo.find()
{ "_id" : ObjectId("60118d315a02120a9a8c81b3"), "name" : "foo" }
```

验证成功。

#### 6.4.2 通过底层持久化存储

上述的例子是运行在 GCE 上的，如果使用的是其他云服务商提供的云服务，比如亚马逊，就要使用其提供的对应的卷来为 pod 提供持久化存储。这就是上面介绍的 gcePersistentDisk（google）、awsElasticBlockStore（亚马逊）、azureDisk（微软）这些卷存在的意义。

##### 使用其他存储技术

如果你已经熟悉了一种特定的存储技术（比如说 iscsi、flexVolume、cinder、flocker 等），那么就可以使用`kubectl explain`来了解 K8S 是否支持该存储技术并进行挂载在 pod 中使用。

但是开发人员一般是不了解这些运维知识的，让研发人员来指定 NFS 服务器是一件不太好的事。而且将涉及物理基础设施类型的信息放到 pod 的设置中，会让 pod 的设置与特定的云服务商 K8S 集群有很大的耦合度，配置文件就不再是通用的了。

所以在下一节，需要将存储技术和 pod 配置进行解耦。

### 6.5 从底层存储技术解耦 pod

Kubernetes 的基本理念旨在向应用程序以及开发人员隐藏真实的基础设施，使他们不需要关心物理层面基础设施的具体状态。理想情况下，开发人员不需要知道底层用的是哪种存储技术和哪种类型的物理服务器来运行 pod，当开发人员需要一定数量的持久化存储时，可以向 K8S 请求资源，就像请求 CPU、内存等其他资源一样。

#### 6.5.1 介绍持久卷和持久卷声明

PersistentVolume（持久卷，简称PV）和持久卷声明是两种新的资源。研发人员无须向他们的 pod 中添加特定技术的卷，而是由集群管理员设置好底层的存储，然后创建持久卷并注册，指定其大小和所支持的访问模式。

持久卷声明可以当作 pod 中的一个卷来使用，K8S 将自动找到可匹配的持久卷并绑定到持久卷声明中，其他用户不能使用相同的持久卷，除非先通过删除持久卷声明绑定来释放。

![6-6.png](./images/6-6.png)

#### 6.5.2 创建持久卷

![6-9.png](./images/6-9.png)

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mongodb-pv
spec:
  capacity: 
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
    - ReadOnlyMany
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: /tmp/mongodb
```

```shell
$ kubectl create -f demo-persistent-volume.yaml
persistentvolume/mongodb-pv created
$ kubectl get pv
NAME         CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   REASON   AGE
mongodb-pv   1Gi        RWO,ROX        Retain           Available                                   21s
```

持久卷显示为可用。

> 注意：持久卷不属于任何命名空间，而是集群层面的资源

![6-7.png](./images/6-7.png)

#### 6.5.3 通过创建持久卷声明来获取持久卷

pod 不能直接使用持久卷（PS：不然跟直接在 pod 里面声明有啥区别呢..），而是需要先声明一个，声明持久卷和创建 pod 是两个独立的过程。

##### 创建持久卷声明

![6-11.png](./images/6-11.png)

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mongodb-pvc
spec:
  resources:
    requests:
      storage: 1Gi
  accessModes:
  - ReadWriteOnce
  storageClassName: ""
```

```shell
$ kubectl create -f demo-persistent-volume-claim.yaml
persistentvolumeclaim/mongodb-pvc created
$ kubectl get pvc
NAME          STATUS   VOLUME       CAPACITY   ACCESS MODES   STORAGECLASS   AGE
mongodb-pvc   Bound    mongodb-pv   1Gi        RWO,ROX                       72s
$ kubectl get pv
NAME         CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                 STORAGECLASS   REASON   AGE
mongodb-pv   1Gi        RWO,ROX        Retain           Bound    default/mongodb-pvc                           21m
```

可以看到 pv 和 pvc 的状态都是 Bound 已绑定了。

创建好声明后，K8S 就会去找到适当的持久卷并将其绑定到声明，查找按照几个条件：

- 容量足够大以满足声明的需求
- 卷的访问模式必须包含声明中指定的访问模式

其中 PVC 的 ACESS MODES 可能有以下的值：

- RWO——ReadWriteOnce——仅允许单个节点挂载读写
- ROX——ReadOnlyMany——允许多个节点挂载只读
- RWX——ReadWriteMany——允许多个节点挂载读写这个卷

在该例子中，声明会请求 1G 的存储空间和 ReadWriteOne 访问模式，与之前创建的 pv 所匹配。

#### 6.5.4 在 pod 中使用持久卷声明

要在 pod 中使用持久卷，需要在 pod 的卷中引用持久卷声明名称。

![6-12.png](./images/6-12.png)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: demo-persistent-volume-claim-pod
spec:
  volumes:
  - name: mongodb-data
    persistentVolumeClaim:
      claimName: mongodb-pvc
  containers:
  - image: mongo
    imagePullPolicy: Never
    name: demo-persistent-volume-claim-pod-container
    volumeMounts:
    - name: mongodb-data
      mountPath: /data/db
    ports:
    - containerPort: 27017
      protocol: TCP
```

```shell
$ kubectl create -f demo-persistent-volume-claim-pod.yaml
pod/demo-persistent-volume-claim-pod created
```

```shell
# 验证
$ kubectl exec -it demo-persistent-volume-claim-pod -- mongo
> use mystore
switched to db mystore
> db.foo.find()
> db.foo.insert({name: 'foo'})
WriteResult({ "nInserted" : 1 })
> db.foo.find()
{ "_id" : ObjectId("60119b423c6a4cda6f170faf"), "name" : "foo" }
> exit
bye

$ kubectl delete pod demo-persistent-volume-claim-pod
pod "demo-persistent-volume-claim-pod" deleted
$ kubectl create -f demo-persistent-volume-claim-pod.yaml
pod/demo-persistent-volume-claim-pod created
$ kubectl exec -it demo-persistent-volume-claim-pod -- mongo
> use mystore
switched to db mystore
> db.foo.find()
{ "_id" : ObjectId("60119b423c6a4cda6f170faf"), "name" : "foo" }
# 验证成功
```

##### 6.5.5 了解使用持久卷和持久卷声明的好处

![6-8.png](./images/6-8.png)

使用 pv 和 pvc 这种间接方法从基础设施获取存储，对于开发人员来说更加简单，虽然需要额外的步骤来创建 pv 和 pvc，但这样让研发人员从底层的存储技术解放了出来，也可以在许多不同的 K8S 集群上使用相同的 pod 和持久卷声明清单。声明说：“我需要 x 存储量，并且我需要能够支持一个客户端同时读取和写入。”然后 pod 会通过一个卷的名称来引用声明。

#### 6.5.6 回收持久卷

pvc 被删除以后，其绑定的 pv 状态会显示为 Released，不像之前那样是 Available。原因在于之前已经使用过这个卷，所以它可能包含前一个声明人的数据，因此只要管理员没有清理，就不会将这个卷绑定到全新的声明中。

手动回收持久卷并使其恢复可用的唯一方法是删除和重新创建持久卷资源，当这样操作时，你将决定如何处理底层存储中的文件：可以删除，也可以闲置不用——以便在下一个 pod 中复用。

##### 自动回收持久卷

存在两种其他可行的回收策略：Recycle 和 Delete。第一种删除卷的内容并使卷可用于再次声明，通过这种方式，持久卷可以被不同的持久卷声明和 pod 反复使用。

![6-9-1.png](./images/6-9-1.png)

而 Delete 策略会彻底删除底层存储。

> PS：要注意不同的磁盘格式支持的策略种类不一定相同，比如 GCE 持久磁盘就不支持 Recycle 选项而只支持 Retain 和 Delete 策略。

### 6.6 持久卷的动态卷配置

K8S 允许动态配置持久卷，集群管理员可以创建一个持久卷配置，定义一个或多个 StorageClass 对象，从而让用户选择他们想要的持久卷类型而不仅仅只是创建持久卷。用户可以在持久卷声明中通过 storageClassName 来配置 StorageClass。

> PS：感觉太细化了没啥用，本节具体实践跳过

### 6.7 本章小结

总而言之，将持久化存储附加到一个容器的最佳方法是仅创建 PVC（如果需要，可以使用明确指定的 storageClassName）和容器 Pod（通过名称引用 PVC），其他所有内容都由动态持久卷置备程序处理。

![6-10.png](./images/6-10.png)



