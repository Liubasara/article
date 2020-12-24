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









> 本次阅读至 P33 53 2.2 配置 Kubernetes 集群