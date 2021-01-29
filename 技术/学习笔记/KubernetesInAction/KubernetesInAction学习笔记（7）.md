---
name: KubernetesInAction学习笔记（7）
title: KubernetesInAction学习笔记（7）
tags: ["技术","学习笔记","KubernetesInAction"]
categories: 学习笔记
info: "第7章 configMap 和 Secret：配置应用程序"
time: 2021/1/28
desc: 'kubernetes in action, 资料下载, 学习笔记'
keywords: ['kubernetes in action', 'k8s学习', '学习笔记']
---

# KubernetesInAction学习笔记（7）

## 第7章 configMap 和 Secret：配置应用程序

几乎所有的应用都需要配置信息，比如不同部署示例间的区分设置，访问外部系统的证书等等。这些配置数据不应该被嵌入应用本身，K8S 允许传递配置给运行在 K8S 上的应用程序。

### 7.1 配置容器化应用程序

用于存储配置数据的 K8S 资源被称为 ConfigMap，但无论是否使用 ConfigMap 存储，以下方法均可以被用作配置你的应用程序：

- 向容器传递命令行参数
- 为每个容器设置自定义环境变量
- 通过特殊类型的卷将配置文件挂载到容器中

### 7.2 向容器传递命令行参数

##### 了解 Dockerfile 中的 ENTRYPOINT 与 CMD

- ENTRYPOINT：定义容器启动时（即`docker run`时）被调用的可执行程序
- CMD：用于指定传递给 ENTRYPOINT 的参数

尽管可以直接使用 CMD 指令指定镜像运行时想要执行的命令，但正确的用法依然是使用 ENTRYPOINT 指定命令，用 CMD 指定所需的默认参数，这样就可以通过`docker run`直接运行默认的指令，也可以通过传入不同的 CMD 参数来覆盖默认参数值。

```shell
# 以默认的 CMD 参数运行 ENTRYPOINT 中指定的命令
$ docker run <image>
# 添加一些参数，使用这些参数覆盖默认的 CMD 来运行 ENTRYPOINT 中指定的命令
$ docker run <image> <arguments>
```

##### 了解 shell 与 exec 形式的区别

Dockerfile 中，ENTRYPOINT 与 CMD 都接受以下两种写法：

- shell 形式的写法，如：`ENTRYPOINT node app.js`
- exec 形式的写法，如：`ENTRYPOINT ["node", "app.js"]`

两种形式的区别是，exec 的形式会直接运行 node 进程，而并非在 shell 中执行。也就是说 shell 形式下的主进程是 shell 进程而非 node 进程。

通常情况下，shell 进程往往是多余的，因此通常可以直接采用 exec 形式的 ENTRYPOINT 指令。

#### 7.2.2 在 K8S 中覆盖命令和参数

在 K8S 中定义容器时，镜像的 ENTRYPOINT 和 CMD 均可以被覆盖，只需要在容器中设置属性 command 和 args 的值即可。

![7-1.png](./images/7-1.png)

![7-3.png](./images/7-3.png)

一般来说 command 字段很少被覆盖，被覆盖的一般都是 args 字段，除非是像 busybox 那样没有指定 ENTRYPOINT 的镜像。

要注意的是，command 和 args 字段在 pod 创建后无法被修改。

##### 用自定义间隔值运行 fortune pod

首先对之前 fortune image 进行一些修改，准备一个根据输入参数，输出不同结果的 image。

```shell
#!/bin/bash
# 可以用 tee 命令生成文件
# 阻止脚本中断信号
trap "exit" SIGINT
INTERVAL=$1
echo "every $INTERVAL seconds to generate new fortune"
mkdir /var/htdocs
while :
do
  echo $(TZ=UTC-8 date) writing fortune to /var/htdocs/index.html
  echo "$(TZ=UTC-8 date)  $(/usr/games/fortune)" > /var/htdocs/index.html
  sleep $INTERVAL
done
```

```dockerfile
FROM ubuntu
RUN apt-get update ; apt-get -y install fortune
ADD fortuneloop.sh /bin/fortuneloop.sh
RUN chmod a+x /bin/fortuneloop.sh
ENTRYPOINT ["/bin/fortuneloop.sh"]
CMD ["10"]
```

```shell
$ docker build -t fortune-input-demo-image .
[+] Building 42.7s (9/9) FINISHED
$ docker run --name test-fortune-input fortune-input-demo-image 2
every 2 seconds to generate new fortune
Thu Jan 28 06:01:42 UTC 2021 writing fortune to /var/htdocs/index.html
Thu Jan 28 06:01:44 UTC 2021 writing fortune to /var/htdocs/index.html
Thu Jan 28 06:01:46 UTC 2021 writing fortune to /var/htdocs/index.html
$ docker rm test-fortune-input
```

然后就可以使用该镜像进行 pod 的创建了。

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: demo-fortune-input-pod
spec:
  containers:
  - image: fortune-input-demo-image
    imagePullPolicy: Never
    name: html-generator
    # 覆盖参数为 2s
    args: ["2"]
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
  volumes:
  - name: html
    emptyDir: {}
```

```shell
$ kubectl create -f demo-fortune-input-pod.yaml
pod/demo-fortune-input-pod created
$ kubectl port-forward demo-fortune-input-pod 8080:80
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
```

此后使用浏览器访问，表现为 2s 刷新一次不同的 fortune，覆盖验证成功。

### 7.3 为容器设置环境变量











> 本次阅读至 P200 7.3 为容器设置环境变量 215

