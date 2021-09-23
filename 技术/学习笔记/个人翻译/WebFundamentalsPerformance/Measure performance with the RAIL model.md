---
name: Measure performance with the RAIL model
title: 使用 RAIL 模型来测试性能
tags: ["技术","学习笔记", "个人翻译", "WebFundamentalsPerformance", "谷歌开发者文档"]
categories: 学习笔记
info: "使用 RAIL 模型来测试性能"
time: 2021/9/15
desc: '个人翻译, Measure performance with the RAIL model, Web'
keywords: ['Git', '个人翻译', '学习笔记', '个人翻译', 'Measure performance with the RAIL model']
---

# 使用 RAIL 模型来测试性能

该系列为谷歌开发者文档的一些翻译，对应章节目录链接可以[访问这里](https://developers.google.com/web/fundamentals?hl=zh-cn)

> 原文链接：https://web.dev/rail/

RAIL 是一个以用户为中心的性能模型，可以提供一个模板结构用于考量性能。该模型会将用户体验分解成一些关键的操作（比如说，点击，滑动，加载），并且帮助你定义这些关键操作的性能指标。

RAIL 代表了在 web app 的生命周期中，四个不同的方面：响应（Response）、动画（Animation），空闲（Idle）和加载（Load）。因为不同的用户对这些方面都会有不同的期望值，所以 RAIL 的性能目标会基于[对于用户感知延迟的 UX 研究](https://www.nngroup.com/articles/response-times-3-important-limits/)来定义。

![measure-1.png](./images/measure-1.png)

### 聚焦于用户

为了让你的性能优化成为用户眼中的焦点，下面这张表展示了一些关于用户如何感知到性能延迟的关键指标：

- 0 ~ 16ms：一般来说用户都喜欢跟踪页面的动作，也就是说他们不会喜欢页面的动画卡顿。一般来说，用户在画面渲染每秒至少达到 60 帧的时候会认为页面的动画是流畅的。而这样换算下来就是 16 毫秒一帧，这 16 毫秒还包括了浏览器去将画面渲染到屏幕的时间，也就是说留给 app 生成一帧画面的时间只有大约 10 毫秒。
- 0 ~ 100ms：对于用户的动作响应只要在 0~100 ms 以内，用户就会觉得动作的响应的及时的。而一旦超过这个时间，用户在动作和响应之间就会感到卡顿。
- 100 ~ 1000ms：



> 下一段：Within this window, things feel part of a natural and continuous progression of tasks. For most users on the web, loading pages or changing views represents a task.





