---
name: 回调vs协程
title: 回调vs协程
tags: ["技术","学习笔记","个人翻译"]
categories: 学习笔记
info: "加油啊不愿意同步的大哥哥！"
time: 2021/11/9
desc: '个人翻译, Callbacks vs Coroutines'
keywords: ['Git', '个人翻译', '学习笔记', 'Callbacks vs Coroutines']
---

# 回调vs协程

> 原文链接：[Callbacks vs Coroutines](https://medium.com/@tjholowaychuk/callbacks-vs-coroutines-174f1fe66127)

最近一段时间，出现了很多有关于 Google V8 引擎提供的 ES6 generators（生成器）补丁的争论，这是由一篇名为[《关于使用 JavaScript 生成器来解决回调问题的研究》](http://jlongster.com/A-Study-on-Solving-Callbacks-with-JavaScript-Generators)的文章引起的。虽然生成器这个特性依旧还藏在`--harmony`或者`--harmony-generators`标志的后面，但已经能让我们学习到很多经验了！在这片文章里面，笔者想通过自己的一些有关于协程的经验来解释，为什么笔者个人认为这是一个非常好的工具。

## 回调 vs 生成器

在我们进入协程与生成器的区分之前，让我们先来看看在 Node.js 或是浏览器这类被回调统治的生态系统里面，是什么让生成器变得有用的。

> 下一段：First off generators are *complementary* to callbacks, some form of callback is required to “feed” the generators. 



