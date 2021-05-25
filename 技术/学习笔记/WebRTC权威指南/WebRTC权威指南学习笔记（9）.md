---
name: WebRTC权威指南学习笔记（9）
title: WebRTC权威指南学习笔记（9）
tags: ["技术","学习笔记","WebRTC权威指南"]
categories: 学习笔记
info: "第11章 IETF文档 第 12 章 与 IETF 相关的 RFC 文档 第 13 章 安全和隐私"
time: 2021/5/23
desc: 'WebRTC权威指南, 资料下载, 学习笔记'
keywords: ['WebRTC权威指南', 'WebRTC', '学习笔记']
---

# WebRTC权威指南学习笔记（9）

## 第 11 章 IETF 文档

目前，有些 Internet 草案的 IETF 工作文档尚未最终发布，仍在不断调整和制定之中，还有一些已经以意见征求书（Request for Comments，RFC）的形式发布，成为 IETF 的标准文档。

### 11.2 Internet 草案

IETF Internet 草案是 IETF 正在制定的文档，在最终发布为 RFC 之前，这些文档会经常变更。

Internet 草案又分为工作组文档或个人提交的文档，后者发生调整的幅度可能最大，甚至就连文档名称也很有可能修改。

### 11.3 RTCWEB 工作组 Internet 草案

![table-11-1](./images/table-11-1.png)

#### 11.3.7 "WebRTC 数据通道建立协议"[draft-ietfrtcweb-data-protocol]

下图显示了建立数据通道的整个步骤序列，请注意如果同时开通媒体会话，则 DTLS-SRTP 将使用 DTLS 连接为并行建立的 SRTP 媒体会话生成密钥。

![11-7.png](./images/11-7.png)

### 11.5 其他工作组的 RTCWEB 文档

#### 11.5.1 “缓慢性 ICE：逐步为交互式连接建立协议增加候选项的配置”

缓慢型 ICE 是对 ICE 的优化，旨在缩短完成 ICE 所需的时间。

![11-10.png](./images/11-10.png)

缓慢型 ICE 不需要等到所有候选项都收集完毕后才开始 ICE，而是只要有一个至少一个候选项可用，便开始进行 ICE 处理。这样能确保能够以最快的速度收集主机候选项，因为不需要发送任何 STUN 或 TURN 消息，而是随后可并行添加或“缓慢加入”来自 STUN 服务器的服务器反射地址。如果主机或反射候选项都不能正常工作，则还可以获取中继候选项并缓慢加入处理过程。

## 第 12 章 与 IETF 相关的 RFC 文档

WebRTC 采用了纳入 RFC 的多项 IETF 标准和协议。而这些 RFC 并非专为 WebRTC 开发或使用。

该文档定义了如下 RFC：

- 实时传输协议
- 会话描述协议
- NAT 遍历 RFC
- 编解码器
- 信令

## 第 13 章 安全和隐私















> 本次阅读至 P214 第 13 章 安全和隐私 233