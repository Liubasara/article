---
name: 一句话解释koa-mount和koa-router的区别
title: "一句话解释 koa-mount 和 koa-router 的区别"
tags: ["技术", "瞎折腾"]
categories: 瞎折腾
info: "两句话解释一句话"
time: 2023/3/11
desc: koa-mount 和 koa-router 的区别
keywords: ['nodeJs', 'koa-router', 'koa-mount']
---

# 一句话解释 koa-mount 和 koa-router 的区别

koa-mount 用于将多个 koa 实例（可能有不同中间件）基于路由进行分发，接受的参数是 koa 实例；

而 koa-router 基本只针对单实例的路由（中间件都是相同的），接受参数是一个中间件函数。