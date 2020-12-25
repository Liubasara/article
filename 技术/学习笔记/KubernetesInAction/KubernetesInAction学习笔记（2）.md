---
name: KubernetesInAction学习笔记（2）
title: KubernetesInAction学习笔记（2）
tags: ["技术","学习笔记","KubernetesInAction"]
categories: 学习笔记
info: "第2章 开始使用Kubernetes和Docker"
time: 2020/12/23
desc: 'kubernetes in action, 资料下载, 学习笔记'
keywords: ['kubernetes in action', 'k8s学习', '学习笔记']
---

# KubernetesInAction学习笔记（2）

## 第2章 开始使用Kubernetes和Docker

本章学习如何创建一个简单的应用，将其打包成镜像并在远端的 Kubernetes 集群或本地单节点集群中运行。

Mac 开发环境下，首先通过 homebrew 安装一个 docker，然后跑一个简单的镜像。

```shell
brew cask install docker
docker run busybox echo "Hello world"
# Hello world
```

busybox 是一个简单的镜像，可以用于运行最简单的命令，上面的命令会自动拉取 busybox 镜像，并启动一个执行 echo 命令的容器。

![2-1.png](./images/2-1.png)

此外，还可以基于 Dockerfile 构建一个新的容器镜像。

![2-2.png](./images/2-2.png)

##### 镜像是如何构建的

构建过程并不是由 Docker 客户端进行的，而是将整个目录的文件上传到 Docker 守护进程并在那里运行的（Docker 客户端和守护进程不要求在同一台机器上）。如果你在一台非 Linux 操作系统中使用 Docker，那么客户端就运行在你的宿主操作系统中，**但守护进程运行在一个虚拟机内**。

#### 2.1.6 探索运行容器的内部

1. 使用 run 命令可以拉起一个容器：
   
   ```shell
   docker run --name container-name -p 8080:8080 -d image-name
   ```
   
   上面的命令参数为：
   
   - --name，容器名称
   - -p，端口映射，宿主端口:容器端口
   - -d，代表容器与命令行分离，意味着在后台运行
   
2. 使用 ps 命令和 inspect 命令可以看到容器的基础信息。

   ```shell
   docker ps
   docker inspect container-name
   ```

3. 使用 exec 命令可以在包含 shell 的容器内运行 shell 命令行。

   ```shell
   docker exec -it container-name bash
   ```

   上面的 -it 选项是下面两个选项的简写：

   - -i：确保标准输入流保持开放，需要在 shell 中输入命令
   - -t：分配一个伪终端（TTY）

   如果希望像平常一样使用 shell，需要同时使用这两个选项（如果缺少`-i`选项就无法输入任何命令。如果缺少`-t`选项，那么命令提示符不会显示，并且一些命令会提示 TERM 变量没有设置）

4. 进入容器后，使用`exit`命令来退出容器返回宿主机

5. 可以通过告知 Docker 停止容器来停止应用，并使用相关命令删除容器。

   ```shell
   docker stop container-name
   docker ps -a
   docker rm container-name
   ```

6. 要向 Docker Hub 推送镜像，需要先使用 login 命令使用自己的用户 ID 登录，在登录之后可以使用 tag 命令来对镜像进行命名，然后使用 push 命令向 Docker Hub 推送。

   ```shell
   docker login -u username
   # 将 image-name 镜像添加一个 user/image-name 的 tag
   docker tag image-name username/image-name
   docker push username/image-name
   ```

### 2.2 配置 Kubernetes 集群

现如今被打包在容器镜像中的应用，可以将它部署到 Kubernetes 集群中，而不是直接在 Docker 中运行。要达成这一目标，需要先设置集群。

一个适当的 Kubernetes 安装需要包含多个物理或虚拟机，并需要正确地设置网络，以便 Kubernetes 集群内运行的所有容器都可以在相同的扁平网络环境内相互连通。

在本章中介绍两种简单的方法构建可运行的 Kubernetes 集群，用于运行单节点的 Kubernetes，以及如何访问运行在 Google Kubernetes Engine（GKE）上面的托管集群。

此外还有别的选择：使用`kubeadm`工具安装一个三节点的 Kubernetes 集群，或是直接在亚马逊的 AWS 上安装 Kubernetes。

### 2.2.1 用 Minikube 运行一个本地单节点 Kubernetes 集群

Minikube 是运行 Kubernetes 集群最简单、最快捷的途径，Minikube 是一个构建单节点集群的工具。在本书中，本节点集群足以探索本书中讨论的大多数主题。

**安装 Minikube**

```shell
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.23.0/minikube-darwin-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
```

此外，在 Mac 上，也可以通过`brew`来安装。

```shell
brew install minikube
```

安装完以后可以立即使用`start`命令启动 Kubernetes 集群。

```shell
minikube start
# 使用 --image-repository 可以用于指定镜像仓库
# 下面的命令使用阿里云的镜像
minikube start --image-repository='registry.cn-hangzhou.aliyuncs.com/google_containers'
```

![2-3.png](./images/2-3.png)

如提示所示，要注意先开启 Docker Desktop 并为其分配两个以上的内核，并且最好有 2.25GB 以上的内存，然后才能对 Kubernetes 集群进行操作。

安装成功后，可以使用下列命令：

- minikube status：查看命令状态
- minikube stop：停止 minikube
- minikube delete：删除 minikube 集群

**安装 Kubernetes 客户端（kubectl）**

要与 Kubernetes 进行交互，还需要安装 kubectl CLI 客户端。

```shell
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/local/bin/
```

或者使用`brew`安装。

```shell
brew install kubernetes-cli
# 或者
brew install kubectl
```

要验证集群是否正常工作，可以使用`kubectl cluster-info`命令。

```shell
kubectl cluster-info
# Kubernetes master is running at https://192.168.64.2:8443
# KubeDNS is running at https://192.168.64.2:8443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

# To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

#### 2.2.2 使用 Google Kubernetes Engine 托管 Kubernetes 集群

使用 Google Kubernetes Engine 可以无需手动设置所有的集群节点和网络，可以方便的创造出一个三节点的 Kubernetes 集群。

```shell
# 在 gcloud 安装 kubectl 命令行工具
gcloud components install kubectl
# 创建一个三节点 Kubernetes 集群
gcloud container clusters create kubia --num-nodes 3 --machine-type f1-micro
```

![2-4.png](./images/2-4.png)

可以使用`kubectl get nodes`命令来列出各种 Kubernetes 对象。可以看到这些节点的基本信息。

```shell
kubectl get nodes
```

使用`kubectl describe node xxx`可以获得关于对象的更详细信息。

```shell
kubectl describe node minikube
```

#### 2.2.3 为 kubectl 配置别名和命令行补齐

```shell
# 在 ~/.bashrc 等文件中可以配置命令别名
alias k=kubectl
```

> 如果已经在用 gcloud 配置集群，就已经有可执行文件 k 了。

即便使用别名，kubectl 这个命令天生也是不带自动补全的，如需要这个功能，需要先安装一个叫 bashcompletion 的包来启用 bash 的 tab 命令补全，然后在类似 ~/.bashrc 的文件中加入：

```shell
source <(kubectl completion bash)
```

> PS: 如果是 zsh 的话，则需要安装 zsh-completions，并且用 source <(kubectl completion zsh) 命令来激活。
>
> 此外，对于 minikube 也可以使用 source <(minikube completion zsh) 来进行命令补全。

### 2.3 在 Kubernetes 上运行第一个应用







> 本次阅读至 P40