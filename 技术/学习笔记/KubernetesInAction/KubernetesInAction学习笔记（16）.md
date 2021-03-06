---
name: KubernetesInAction学习笔记（16）
title: KubernetesInAction学习笔记（16）
tags: ["技术","学习笔记","KubernetesInAction"]
categories: 学习笔记
info: "第16章 高级调度"
time: 2021/3/17
desc: 'kubernetes in action, 资料下载, 学习笔记'
keywords: ['kubernetes in action', 'k8s学习', '学习笔记']
---

# KubernetesInAction学习笔记（16）

## 第16章 高级调度

K8S 允许开发者去影响 pod 被调度到哪个节点，而不仅仅是像第三章介绍的那样，只能通过 pod 的`spec.nodeSelector`标签进行节点的选择。本章将介绍这些能够影响部署的规则。

### 16.1 使用污点和容忍度阻止节点调度到特定节点

通过在节点上添加污点信息，就可以在不修改已有 pod 信息的前提下，拒绝 pod 在某些节点上的部署。

#### 16.1.1 介绍污点和容忍度

通过`kubectl describe node`可以查看节点的污点信息。

![code-16-1.png](./images/code-16-1.png)

污点`Taints`包含了一个 key、value，以及一个 effect，表现为`<key>=<value>:<effect>`。如上面的污点信息，包含一个名为`node-role.kubernetes.io/master`的 key，一个空的 value，以及值为 NoSchedule 的 effect。

这个污点将阻止 pod 调度到这个节点上面，除非有 pod 能容忍这个污点。

![16-1.png](./images/16-1.png)

##### 了解污点的效果 effect

每一个污点都可以关联一个效果，该效果包含了以下三种：

- NoSchedule：表示如果 pod 没有容忍这些污点，pod 则不能被调度到包含这个污点的节点上
- PreferNoSchedule：这是 NoSchedule 的一个宽松的版本，表示尽量阻止 pod 被调度到这个节点上，但如果没有其他节点可以调度，pod 依然会被调度到节点上
- NoExecute：不同于前两者只会在调度期间起作用，NoExecute 也会影响正在节点上运行着的 pod。如果在一个节点上添加了 NoExecute 污点，运行着的 pod 如果没有忍受这个污点，就会从这个节点自动去除。

#### 16.1.2 在节点上添加自定义污点

可以使用`kubectl taint`命令来添加污点。

```shell
$ kubectl taint node minikube node-type=production:NoSchedule
node/minikube tainted
$ kubectl delete pod demo-hpa-deployoment-859f7b4c8d-2sncp
pod "demo-hpa-deployoment-859f7b4c8d-2sncp" deleted

$ kubectl get pod
# 新生成的 pod 无法被部署
NAME                                    READY   STATUS    RESTARTS   AGE
demo-hpa-deployoment-859f7b4c8d-b9484   1/1     Running   0          7h59m
demo-hpa-deployoment-859f7b4c8d-kgbr7   1/1     Running   0          7h59m
demo-hpa-deployoment-859f7b4c8d-kvthq   0/1     Pending   0          45s
```

这个命令添加了一个污点（taint），其中 key 为`node-type`，value 为`production`，效果为`NoSchedule`。接下来如果没有在 pod 上添加污点容忍度`Toleration`，就没人能将 pod 部署到该节点上了。

之后可以在这个命令后面加一个 - 号删除这个 taint。

```shell
$ kubectl taint node minikube node-type=production:NoSchedule-
node/minikube untainted

$ kubectl get pod
NAME                                    READY   STATUS    RESTARTS   AGE
demo-hpa-deployoment-859f7b4c8d-b9484   1/1     Running   0          8h
demo-hpa-deployoment-859f7b4c8d-kgbr7   1/1     Running   0          8h
demo-hpa-deployoment-859f7b4c8d-kvthq   1/1     Running   0          6m22s
```

#### 16.1.3 在 pod 上添加污点容忍度

![code-16-4.png](./images/code-16-4.png)

通过在 pod manifest 文件的`spec.tolerations`中添加以下属性就可以添加相应的污点容忍度。

#### 16.1.4 了解污点和污点容忍度的使用场景

污点可以用来组织新 pod 的调度（noSchedule）或者定义非优先调度的节点（PreferNoSchedule），甚至将已有的 pod 从当前节点剔除。

而污点容忍度也可以通过设置 Equal 操作符来指定匹配的 value，或者也可以通过设置 Exists 操作符来匹配污点的 key。

当你的部分节点提供了某种特殊硬件，并且只有部分 pod 需要使用到这些硬件的时候，就可以通过设置污点和容忍度来实现这一需求。

##### 配置节点失效之后的 pod 重新调度最长等待时间

通过`pod.spec.tolerations.tolerationSeconds`可以设置 pod 的容忍度信息，当 pod 运行在这个节点中，状态变为 unready 或者 unreachable 状态时，该属性代表该 pod 会被调度到其他节点的最长等待时间。超过这个时间，这个 pod 就会被调度到其他节点。

![code-16-6.png](./images/code-16-6.png)

### 16.2 使用节点亲缘性将 pod 调度到特定节点上

污点可以用于让 pod 远离节点，而节点亲缘性（node affinity）则是节点选择器（nodeSelector）的上位替代，用于将 pod 调度到某个一批特定的节点上面。

##### 对比节点亲缘性和节点选择器

节点选择器虽然也可以将 pod 和特定的节点配对，但并不能满足所有的需求，使用节点亲缘性规则允许你指定节点的硬性限制或者偏好，进行 pod 的部署。

##### 检查默认的节点标签

使用`kubectl describe`可以查看节点默认的标签。

![code-16-7.png](./images/code-16-7.png)

上图的最后三个标签涉及了节点亲缘性和 pod 亲缘性，含义如下：

- failure-domian.beta.kubernetes.io/region 表示该节点所在的地理区域
- failure-domian.beta.kubernetes.io/zone 表示该节点所在的可用性区域
- kubernetes.io/hostname 该节点的主机名

#### 16.2.1 指定强制性节点亲缘性规则

在第三章时学习到的节点选择器是这样的，使用了`nodeSelector`字段。

![code-16-8.png](./images/code-16-8.png)

而使用节点亲缘性规则需要使用`spec.affnity`字段。

![code-16-9.png](./images/code-16-9.png)

虽然这种写法比简单的节点选择器要复杂的多，可是却拥有更强的表达能力（使用起来有点像规则引擎，可以参考[json-rules-engine](https://github.com/CacheControl/json-rules-engine)）。

- requiredDuringScheduling...：表明调度时节点必须包含的标签
- preferredDuringScheduling...：表明调度时节点优先考虑的标签
- ...IgnoredDuringExecution：表明该字段下定义的规则不会影响已经在节点上运行着的 pod。
- nodeSelectorTerms、matchExpressions：定义了节点的标签必须满足哪一种表达式，才能满足 pod 调度的条件。

#### 16.2.2 调度 pod 时优先考虑某些节点

通过使用`kubectl label node`给节点加上标签，然后就可以根据节点亲缘性对 pod 的部署进行节点的选择了。

### 16.3 使用 pod 亲缘性与非亲缘性对 pod 进行协同部署

亲缘性不仅可以用于联系 pod 和节点之间的关系，还可以用于调节 pod 和 pod 之间部署的关系，比如说前端 pod、后端 pod、数据库 pod，通过亲缘性将这些 pod 尽可能部署在同一个节点上，可以有效提升性能。

#### 16.3.1 使用 pod 间亲缘性将多个 pod 部署在同一个节点上

![code-16-13.png](./images/code-16-13.png)

上面 Deployment 创建的 pod 会根据亲缘性要求被调度到其他包含 app=backend 标签的 pod 所在的相同节点上（通过 topologyKey 字段指定）

![16-4.png](./images/16-4.png)

PS：除了使用简单的 matchLabels 字段，也可以使用表达能力更强的 matchExpressions 字段。

当调度的时候，调度器会首先找出所有匹配 pod 的 podAffinity 配置中的 labelSelector 的 pod，之后将这个 pod 调度到相同的节点上。

#### 16.3.2 将 pod 部署在同一机柜、可用性区域或者地理区域

有时候 pod 不一定需要在同一个节点，但需要在同一片区域（或至少同一个数据中心）。亲缘性同样可以做到这一点，只需要将 topologyKey 属性设置为 failure-domain.beta.kubernetes.io/zone。

#### 16.3.4 利用 pod 的非亲缘性分开调度 pod

亲缘性还可以让 pod 远离彼此，只要将 podAffinity 字段换成 podAntiAffinity，调度器便将永远不会选择那些包含标签的 pod 所在的节点。

![code-16-18.png](./images/code-16-18.png)

