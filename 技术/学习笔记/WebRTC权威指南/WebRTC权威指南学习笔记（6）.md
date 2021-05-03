---
name: WebRTC权威指南学习笔记（6）
title: WebRTC权威指南学习笔记（6）
tags: ["技术","学习笔记","WebRTC权威指南"]
categories: 学习笔记
info: "第8章 W3C 文档"
time: 2021/4/29
desc: 'WebRTC权威指南, 资料下载, 学习笔记'
keywords: ['WebRTC权威指南', 'WebRTC', '学习笔记']
---

# WebRTC权威指南学习笔记（6）

## 第 8 章 W3C文档

WebRTC 许多的 API 仍在编写之中，以下几节内容将介绍 W3C WebRTC 标准文档。

### 8.1 WebRTC API 参考

之前介绍过，WebRTC APII 所定义的 API 大致分为两类：

- 关于 getUserMedia 获取媒体的 API，简称 gUM 类
- 关于对等连接 PeerConnection 的 API，简称 PC 类

以下是两种类型的接口摘要。

PS：下面提到的候选项(option)基本可以等同于“设置选项”，也不知道是咋翻译的...

#### gUM 类：

**接口摘要**

- AudioMediaStreamTrack：MediaStreamTrack 的子类，只能用于承载 sourceType 为“音频”的媒体。
- MediaStream：表示 MediaStreamTrack 的集合，目前仅包含音频和视频。
- MediaStreamTrack：表示媒体源的单个轨道。每个轨道可以包含多个通道，例如编码为单个轨道的 6 声道环绕声源。此外，每个轨道只能包含一种媒体，而不论它有多少通道。
- MediaStreamTrackEvent：在添加或删除轨道时返回一个 MediaStreamTrack，由 onaddtrack 或 onremovetrack 处理。
- NavigatorUserMedia：所有 Web 浏览器中预先存在的一个接口
- MediaError：表示调用 NavigatorUserMedia.getUserMedia() 时返回的错误
- MediaErrorEvent: 返回一个 MediaError 对象，如果错误名称为"CONSTRAINT_NOT_SATISFIED"，则还会一并返回未满足的强制性约束。后一种情形可由 onoverconstrained 处理。



#### PC 类：

**接口摘要**

- MediaStreamEvent：返回由远程对等端添加或删除的 MediaStream。由 onaddstream 或 onremovestream 处理。
- Constrainable：添加用于操作约束、功能和设置的方法和属性。由 MediaStreamTrack 实现。
- RTCDataChannel：表示 RTCPeerConnection 上可传输任意应用程序数据的通道。
- RTCDataChannelEvent：当远程对等端创建了 RTCDataChannel 时返回 RTCDataChannel。由 ondatachannel 处理。
- RTCIceCandidate：ICE 候选项的容器

**WebRTC RTCPeerConnection API**

- RTCPeerConnection：表示两个对等端之间的 WebRTC 连接。
- RTCPeerConnectionEvent：当浏览器识别到 RTCIceCandidate 时返回 RTCIceCandidate。由 onicecandidate 处理。
- RTCSessionDescription：SDP 提议、应答或临时应答(pranswer)的容器。
- RTCSDPError：包含`setLocalDescription()`或 `setRemoteDescription()`因给定 RTCSessionDescription 中的问题而失败时所发生的第一个错误的 SDP 行号。
- RTCDTMFSender：用于将 DTMF 插入音轨频道的容器和控制对象。
- RTCDTMFToneChangeEvent：返回刚刚开始发送的 DTMF 提示音，由 ontonechange 处理。
- RTCPeerConnection：接口和构造函数，作为接口时表示两个对等端之间的 WebRTC 连接。作为构造函数时接受一个参数类型为 RTCConfiguration 的对象，使用该对象上的 STUN 和 TURN 服务器信息创建一个 RTCPeerConnection 对象。
- RTCPeerConnection.close()：方法，关闭 RTCPeerConnection，实际上会删除所有附加的流并关闭所有附加的 RTCDataChannel。
- RTCPeerConnectionErrorCallback：回调方法，将错误信息的 DOMString 作为参数，由`RTCPeerConnection.createOffer()`、`RTCPeerConnection.createAnswer()`、`RTCPeerConnection.setLocalDescription()`、`RTCPeerConnection.setRemoteDescription()`和`RTCPeerConnection.getStats()`使用。

**WebRTC SDP 处理 API**

- RTCSessionDescription：接口或构造函数，作为接口时作为 SDP 提议、应答或临时应答（pranswer）的容器。作为构造函数时，会创建一个新的 RTCSessionDescription 对象，接收一个名为 descriptionInitDict 的参数。descriptionInitDict 参数类型为 RTCSessionDescriptionInitDict。
- RTCSessionDescription.type：指示会话描述是提议、应答还是临时应答。
- RTCSessionDescription.sdp：一个字符串，表示会话描述的 SDP。
- RTCSessionDescriptionInit：会话描述的容器，用于初始化 RTCSessionDescription 对象。
- RTCSessionDescriptionInit.type：指示会话描述是提议、应答还是临时应答
- RTCSessionDescriptionInit.sdp：一个字符串，表示会话描述的 SDP。
- RTCSessionDescriptionCallback：可由应用程序设置为一个函数/方法，该函数/方法接受 RTCSessionDescription 作为参数。由 RTCPeerConnection.createOffer() 和 RTCPeerConnection.createAnswer() 使用。
- RTCSDPError：接口，包含 setLocalDescription() 或 setRemoteDescription() 因给定 RTCSessionDescription 中的问题而失败时所发生的第一个错误。
- RTCSDPError.sdpLineNumber：第一个错误的 SDP 行号
- RTCIceCandidate.sdpMid：与此候选项相关联的 m 行的媒体流标识符
- RTCIceCandidate.sdpMLineIndex：与此候选项相关联的 m 行的索引。
- RTCPeerConnection.createOffer()：方法，使用表示一套相应的可用本地媒体流，编解码器选项、ICE 候选项等的 SDP，为提议创建 RTCSessionDescription。
- RTCPeerConnection.createAnswer()：方法，使用表示一套相应的可用本地媒体流，编解码器选项、ICE 候选项等的 SDP，为应答创建 RTCSessionDescription。
- RTCPeerConnection.setLocalDescription()：将给定的 RTCSessionDescription 对象记录为当前本地描述，如果该对象为最终应答，则媒体将开始流动/更改。
- RTCPeerConnection.setRemoteDescription()：将给定的 RTCSessionDescription 对象记录为当前远程描述。
- RTCPeerConnection.localDescription：表示当前活动的本地描述（SDP）的 RTCSessionDescription。
- RTCPeerConnection.remoteDescription：表示当前活动的远程描述（SDP）的 RTCSessionDescription。
- RTCPeerConnection.signalingState：承载 RTCPeerConnection 上 SDP 交换的状态：stable、have-local-offer、have-remote-offer、have-local-pranswer、have-remote-pranswer 和 closed。
- RTCPeerConnection.onnegotiationneeded：每当 RTCPeerConnection 的本地端或远程端更改将导致需要重新协商的 SDP 更改时，都调用该函数/方法。
- RTCPeerConnection.onsignalingstatechange：每当 RTCPeerConnection.signalingState 发生更改时，都调用该函数/方法。

**WebRTC ICE 处理 API**

- RTCIceCandidate：接口或构造函数。作为接口时是 ICE 候选项的容器。作为构造函数时接收一个类型为 RTCIceCandidateInit 类型的参数，返回一个新的 RTCIceCandidate 对象
- RTCIceCandidate.candidate：一个字符串，表示 ICE 候选项
- RTCIceCandidate.sdpMLineIndex：与此候选项关联的 m 行的索引（从零开始）
- RTCIceCandidateInit：用于初始化 RTCIceCandidate 对象的 ICE 服务器 URL 的容器。
- RTCIceCandidateInit.candidate：字符串，表示 ICE 候选项
- RTCIceCandidateInit.sdpMid：与此候选项相关联的 m 行的媒体流标识符
- RTCIceCandidateInit.sdpMLineIndex：与此候选项相关联的 m 行的索引（从零开始）
- RTCIceServer：ICE 服务器 URL 的容器
- RTCIceServer.urls：STUN 和/或 TURN 服务器的一个或多个 URL
- RTCIceServer.username：当 RTCIceServer.urls 为 TURN 服务器时，所使用的用户名
- RTCIceServer.credential：RTCIceServer.urls 为 TURN 服务器时所使用的凭据（例如密码）
- RTCConfiguration：字典，包含 ICE 服务器对象的数组。
- RTCConfiguration.iceServers：RTCIceServer 对象的数组。
- RTCConfiguration.iceTransports：指示要使用的 ICE 传输方式：none（无 ICE 处理）、relay（仅 TURN 服务）或 all（可接受 STUN 和 TURN），默认值为 all。
- RTCPeerConnection.updateIce()：使浏览器 ICE 代理重新启动或更新其本地设置和远程设置的集合，具体取决于指定的参数。
- RTCPeerConnection.addIceCandidate()：向浏览器 ICE 代理提供远程候选项。
- RTCPeerConnection.getConfiguration()：返回当前的 RTCConfiguration。
- RTCPeerConnection.iceGatheringState：承载 ICE 代理当前在收集候选项地址方面的状态：new、gathering 和 complete。
- RTCPeerConnection.iceConnectionState：承载 ICE 代理当前在连接两个对等端方面的状态：new、checking、connected、completed、failed、disconnceted 和 closed。
- RTCPeerConnection.oniceconnectionstatechange：每当 RTCPeerConnection.RTCPeerConnectionState 发生更改时，调用该监听方法。
- RTCPeerConnectionIceEvent：每当浏览器识别到 RTCIceCandidate 时返回 RTCIceCandidate。由 onicecandidate 处理。
- RTCPeerConnectionIceEvent.candidate：浏览器识别的 RTCIceCandidate

**WebRTC 数据通道 API**

- RTCPeerConnection.createDataChannel()：在 RTCPeerConnection 之上，创建新的数据通道
- RTCPeerConnection.ondatachannel：每当创建 RTCDataChannel 时，都会调用该函数/方法。
- RTCDataChannelInit：包含用于创建数据通道的配置参数。
- RTCDataChannel：接口，表示 RTCPeerConnection 上可传输任意应用程序数据的通道。
- RTCDataChannel.label：此数据通道的字符串标签，由应用程序在数据通道创建时设置。
- RTCDataChannel.ordered：布尔值，由应用程序在此通道创建时设置，指示是否必须按数序传输消息。如果需要按顺序传输，则可能需要延迟传输某些消息。
- RTCDataChannel.maxRetransmitTime：对于不可靠的数据通道，该值制定浏览器尝试重新传输数据的最大次数。请注意该属性和 RTCDataChannel.maxRetransmits 不可同时设置，否则将导致错误。
- RTCDataChannel.maxRetransmits：对于不可靠的数据通道，此属性承载浏览器尝试重新传输数据的最大次数。跟上面一样，不能与 RTCDataChannel.maxRetransmitTime 同时设置。
- RTCDataChannel.negotiated：一个布尔值，指示是否自动协商此数据通道（即不进行显式 SDP 交换）。
- RTCDataChannel.id：创建数据通道时为通道设定的数据。除非在通道创建时的配置中提供了该值，否则它由浏览器自动确定。
- RTCDataChannel.readyState：RTCDataChannel 的状态。其值为下列选项之一：connecting、open、closing 和 closed。
- RTCDataChannel.bufferedAmount：尚未传输切排队等待发送（由 RTCDataChannel.send() 发送）的字节数
- RTCDataChannel.onopen：当数据通道准备好传输数据时，调用该函数
- RTCDataChannel.onerror：当数据通道的功能发生错误时，调用该函数
- RTCDataChannel.onclose：当数据通道关闭时，将调用该函数
- RTCDataChannel.close()：关闭数据通道
- RTCDataChannel.onmessage：当数据通道中收到消息（数据）时，将调用该函数
- RTCDataChannel.binaryType：一个字符串，指示如何将二进制数据公开给应用程序。默认值为 "blob"
- RTCDataChannel.send()：通过数据通道将参数发送给远程端。参数可采取多种格式，但最常用的两种格式是字符串和 blob。
- RTCDataChannelEvent：当远程对等创建了 RTCDataChannel 时返回该对象，由 ondatachannel 处理
- RTCDataChannelEvent.channel：由远程对等端创建的 RTCDataChannel。

**WebRTC DTMF 处理 API**

- RTCPeerConnection.createDTMFSender()：对于指定为输入的 MediaStreamTrack，该方法会创建一个 RTCDTMFSender 对象，用于将 DTMF 提示音注入 RTCPeerConnection 的轨道表示形式。
- RTCDTMFSender：用于将 DTMF 插入音频轨道的容器和控制对象。
- RTCDTMFSender.canInsertDTMF：此布尔值指示关联的轨道是否能够插入 DTMF。此值通常为 true；如果轨道或对等连接存在问题，此值可能会变为 false
- RTCDTMFSender.track：与此对象关联的 MediaStreamTrack
- RTCDTMFSender.ontonechange：当数据通道收到消息时，将调用该函数/方法。
- RTCDTMFSender.toneBuffer：包含将要播放的其他提示音
- RTCDTMFSender.duration：每个提示音应持续播放的毫秒数。默认值为 100 毫秒。
- RTCDTMFSender.interToneGap：一个提示音节数与下一个提示音开始之间间隔的毫秒数，默认值为 50 毫秒。
- RTCDTMFSenderToneChangeEvent：返回刚刚开始发送的 DTMF 提示音，由 ontonechange 处理。
- RTCDTMFSenderToneChangeEvent.tone：刚刚开始发送的 DTMF 提示音

**WebRTC 统计数据处理 API**

- RTCPeerConnection.getStats()：对于指定为输入的 MediaStreamTrack，此方法将通过 RTCStatsCallback 处理程序收集并返回与轨道有关的传输统计数据。
- RTCStatsCallback：该函数采用 RTCStatsReport 作为参数，由 RTCPeerConnection.getStats() 使用
- RTCStats：一个特定对象的基类，该对象包含有关单个 RTP 对象类型的统计数据。此基类包含时间戳、ID 和类型。RTCRTPStreamStats 继承自此类。
- RTCRTPStreamStats：继承自 RTCStats，一个特定对象的父类，包含有关单个 RTP 流的统计数据。此类包含流的另一端 ID 以及 RTP 流的 SSRC。
- RTCInboundRTPStreamStats：继承自 RTCRTPStreamStats，包含单个入站 RTP 流，自开始在对等连接上传输数据以来，收到的数据包总数和字节总数。
- RTCOutboundRTPStreamStats：继承自 RTCRTPStreamStats，包含单个出站 RTP 流的自开始在对等连接上传输数据以来，发出的数据包总数和字节总数。

**WebRTC 身份处理 API**









> 本地阅读至 P136 表8.8 WebRTC 身份处理 API 155