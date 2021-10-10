---
name: Loading Performance-Overview
title: 页面加载性能-简介
tags: ["技术","学习笔记", "个人翻译", "WebFundamentalsPerformance", "谷歌开发者文档"]
categories: 学习笔记
info: "页面加载性能优化简介"
time: 2021/10/7
desc: '个人翻译, Measure performance with the RAIL model, Web'
keywords: ['Git', '个人翻译', '学习笔记', '个人翻译', 'Loading Performance-Overview']
---

# 页面加载性能-简介

该系列为谷歌开发者文档的一些翻译，对应章节目录链接可以[访问这里](https://developers.google.com/web/fundamentals?hl=zh-cn)

> 原文链接：https://developers.google.com/web/fundamentals/performance/get-started?hl=zh-cn

随着 Web 网页进化成了一个基于浏览器的应用平台，我们的 app 大多都从性能强，网络快且稳定的桌面设备，转移到了性能较差，网络连接缓慢且不稳定的移动设备上。因此，无论在什么平台、网络或设备下，更快的 app 始终是更好的 app。只要我们编写加载和运行速度更快的页面，获益的将会是所有人，包括桌面的用户。

幸运的是，存在很多有效技术用于提升页面速度。虽然有很多前沿的革新只能将加载的时间缩短 9 毫秒，但也有很多直接，高级的方法能实现显著的性能提升，而这也是本文档聚焦的地方。

以前我们用来构建部署性能强劲，功能丰富网站的过程，现在只能构建一个使用和加载都很缓慢的网页页面（特别是在移动设备上访问的时候）。加载缓慢的网页会让无法/不会使用网站的用户感到沮丧，同时也对失去了这些用户的开发者不利。举个例子，有各种各样的研究揭示了这个通常的趋势：

- 加载时间是页面是否被放弃和忠诚度的主要因素；53% 的用户反馈道当页面加载超过 3s 的时候，他们会放弃网页。（[来源](https://soasta.com/blog/google-mobile-web-performance-study/)）
- 相比于缓慢的网站，用户会倾向于在加载快速的网站上去进行更多地访问，更长时间的停留，以及更频繁地购物。一家公司发现在略微提高了 0.85s 的加载速度以后，用户的转化率提高了 7%。（来源： [WPO Stats](https://wpostats.com/)）
- 缓慢的加载对于搜索引擎结果优化（SEO）是有害的，因为它会降低你的网页排名，并进而影响到一些访问量、阅读量和转化率。在 2018 年，Google 将会实施在移动搜索里，将网页速度作为一个排行指标。（来源：[Search Engine Land](https://searchengineland.com/google-speed-update-page-speed-will-become-ranking-factor-mobile-search-289904)）

Google 已经发布了一些关于性能对于用户参与度的影响的扩展研究，其中也包括移动端的速度问题（[Mobile Speed Matters](https://www.doubleclickbygoogle.com/articles/mobile-speed-matters/)）。在 WPOStats 和 PWAStats 等独立站点上，还提供了大量的 Web 性能统计数据和案例研究。

### 目标

开发者经常会谈到一些性能测量的概念，比如 TTL（Time To Interactivity，完全达到可交互状态时间点） 和 FMP（First Meaningful Paint，主要内容绘制到屏幕上的时间）。这些都是为了能够量化一个重要且包罗万象的指标，让用户能够在第一次和频繁访问的时候，页面能够尽可能加载的越快越好而存在的。特别是在频繁访问的时候，让用户能够在更早的时候访问到页面的内容和行为。

如果你是第一次听说页面性能指标而且想学习更多相关知识的话，可以查看谷歌的简介文章（[Leveraging the Performance Metrics that Most Affect User Experience](https://web.dev/user-centric-performance-metrics/)（PS：已翻译））

这篇文档包括并侧重于一些低成本，高回报性能优化的解释，例子和建议。这些内容是渐进式的而不是累积的。也就是说，你不必使用所有建议的技术，也不必按任何特定顺序使用它们。只是说你越频繁地将你这些手段应用于你的网页，这些页面的性能表现就会越好。













