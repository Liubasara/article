---
name: KubernetesInAction学习笔记（12）
title: KubernetesInAction学习笔记（12）
tags: ["技术","学习笔记","KubernetesInAction"]
categories: 学习笔记
info: "第12章 Kubernetes API服务器的安全防护"
time: 2021/2/24
desc: 'kubernetes in action, 资料下载, 学习笔记'
keywords: ['kubernetes in action', 'k8s学习', '学习笔记']
---

# KubernetesInAction学习笔记（12）

## 第12章 Kubernetes API服务器的安全防护

### 12.1 了解认证机制

API 服务器可以配置一个到多个认证的插件，目前有几个认证插件是直接可用的。它们使用下列方法获取客户端的身份认证：

- 客户端证书
- 传入在 HTTP 头中的认证 token
- 基础的 HTTP 认证
- 其他

启动 API 服务器时，通过命令行选项可以开启认证插件。

#### 12.1.1 用户和组











> 本次阅读至P352 12.1.1 用户和组 366