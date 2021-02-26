---
name: 一句话解释prefetch和preload.md
title: 一句话解释prefetch和preload.md
tags: ["技术", "瞎折腾"]
categories: 瞎折腾
info: "一句话解释一句话"
time: 2021/2/26
desc: prefetch,preload区别
keywords: ['html', 'prefetch', 'preload']
---

# 一句话解释prefetch和preload.md

> 参考资料：
> [使用 Preload/Prefetch 优化你的应用](https://zhuanlan.zhihu.com/p/48521680)
> 

参考资料中详细阐述了 preload 和 prefetch 的原理，在此不再赘述。一句话总结就是：preload 用于下载**当前页面**需要用到的资源，有点类似不会主动执行的 async，可以对一些不需要依赖上下文的资源加上 preload，这样就算浏览器的渲染线程被阻塞了，这些资源也依然可以在额外的线程优先下载。而 prefetch 用于**下载下个页面**会用到（或是可能会异步加载）的资源，例如异步依赖的 js，组件等等。
