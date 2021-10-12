---
name: Leveraging the Performance Metrics that Most Affect User Experience
title: 以用户为中心的性能指标
tags: ["技术","学习笔记", "WebFundamentalsPerformance", "谷歌开发者文档"]
categories: 学习笔记
info: "页面加载性能优化简介"
time: 2021/10/10
desc: '个人翻译, Leveraging the Performance Metrics that Most Affect User Experience, Web'
keywords: ['Git', '个人翻译', '学习笔记', 'Leveraging the Performance Metrics that Most Affect User Experience']
---

# 以用户为中心的性能指标

该系列为谷歌开发者文档的一些学习笔记，对应章节目录链接可以[访问这里](https://developers.google.com/web/fundamentals?hl=zh-cn)

> 原文链接：
>
> [Leveraging the Performance Metrics that Most Affect User Experience](https://web.dev/user-centric-performance-metrics/)

在讨论性能时，重要的是做到精确，并且根据能够进行定量测量的客观标准来讨论性能。而这些标准就是指标。

## 定义指标

长久以来，网络性能都是通过 load 事件进行测量的。然而这并不准确，例如服务器可以立即“加载”一个小页面来进行响应，然后延迟获取（懒加载）内容并在页面上延迟显示内容。这样虽然 load 事件的加载时间很快，但是跟用户的实际体验并不相符。

标准化的 API 和指标围绕几个关键的问题：

- 是否正在发生：导航是否成功？服务器有相应吗？
- 是否有用：是否渲染了足够的内容让用户可以深入其中
- 是否可用：页面是否繁忙，用户是否可以与页面进行交互
- 是否令人愉快：交互是否流畅自然，没有延迟和卡顿

## 如何对指标进行测量

性能指标一般通过以下两种方式来进行测量：

- 在稳定、受控的环境中模拟页面加载
- 基于真实用户的实际页面加载与页面交互

> 要想真正了解您的网站为用户呈现的性能表现，唯一的方法就是在这些用户进行页面加载和页面交互时对页面性能进行实测。这种类型的测量通常被称为[真实用户监控](https://en.wikipedia.org/wiki/Real_user_monitoring)，或简称为 RUM。

## 指标类型

- 感知加载速度（Perceived load speed）：页面在屏幕上并渲染出所有视觉元素的速度
- 加载响应度（Load responsiveness）：为了对用户的交互进行快速响应，所需的组件中 JavaScript 代码执行的速度
- 运行时响应度（Runtime responsiveness）：页面在加载后，对用户交互的响应速度
- 视觉稳定性（Visual stability）：页面上的元素是否会出现令人感到意外的，对用户造成干扰的偏移
- 平滑度（Smoothness）：过渡和动画在页面状态切换的过程中的帧速是否稳定和顺滑

## 需要测量的重要指标

- [First contentful paint 首次内容绘制 (FCP)](https://web.dev/fcp/)：测量页面从开始加载到页面内容的任何部分在屏幕上完成渲染的时间
- [Largest contentful paint 最大内容绘制 (LCP)](https://web.dev/lcp/)：测量页面从开始加载到最大文本块或图像元素在屏幕上完成的渲染的时间。
- [First input delay 首次输入延迟 (FID)](https://web.dev/fid/)：测量用户第一次与网站交互直到浏览器实际能够对交互作出响应所经过的时间。
- [Time to Interactive 可交互时间 (TTI)](https://web.dev/tti/)：测量页面从开始加载，到视觉上完成渲染、初始脚本完成加载、并能够快速、可靠地响应用户输入所需的时间。
- [Total blocking time 总阻塞时间 (TBT)](https://web.dev/tbt/)：测量 FCP 与 TTL 之间的总时间，这期间，主线程被阻塞的时间过长，无法作出输入响应。
- [Cumulative layout shift 累积布局偏移 (CLS)](https://web.dev/cls/)：测量页面在开始加载和其生命周期状态变为隐藏期间所有的意外布局便宜的累积分数。（简单来说就是点击了一下之后元素忽然换位置或被顶下去了）

## 自定义指标

Web 性能工作组还推出了一些列较低级别的标准化 API，可以用来实现自定义指标：

- [用户计时 API](https://w3c.github.io/user-timing/)
- [长任务 API](https://w3c.github.io/longtasks/)
- [元素计时 API](https://wicg.github.io/element-timing/)
- [导航计时API](https://w3c.github.io/navigation-timing/)
- [资源计时 API](https://w3c.github.io/resource-timing/)
- [服务器计时](https://w3c.github.io/server-timing/)

