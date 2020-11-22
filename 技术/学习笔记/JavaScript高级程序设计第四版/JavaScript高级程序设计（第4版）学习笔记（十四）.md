---
name: JavaScript高级程序设计（第4版）学习笔记（十四）
title: JavaScript高级程序设计（第4版）学习笔记（十四）
tags: ["技术","学习笔记","JavaScript高级程序设计第四版"]
categories: 学习笔记
info: "十年磨一剑，红宝书：19. 表单脚本 20. JavaScript API"
time: 2020/11/20
desc: 'javascirpt高级程序设计, 红宝书, 学习笔记'
keywords: ['javascirpt高级程序设计第四版', '前端', '红宝书第四版', '学习笔记']

---

# JavaScript高级程序设计（第4版）学习笔记（十四）

## 第 19 章 表单脚本

第三版冷饭。

## 第 20 章 JavaScript API

### 20.1 Atomics 与 SharedArrayBuffer

多个上下文访问`SharedArrayBuffer`时，如果同时对缓冲区执行操作，可能出现资源争用问题。Atomics API 通过强制同一时刻只能对缓冲区执行一个操作，可以让多个上下文安全地读写一个 SharedArrayBuffer。

> **来大家来欣赏一段非人类翻译**：
>
> 仔细研究会发现 Atomics API 非常像一个简化版的指令集架构(ISA)，这并非意外。原子操作的本质会排斥操作系统或计算机硬件通常会自动执行的优化(比如指令重新排序)。原子操作也让并发访问内存变得不可能，如果应用不当就可能导致程序执行变慢。为此，Atomics API 的设计初衷是在最少但很稳定的原子行为基础之上，构建复杂的多线程 JavaScript 程序。
>
> **这就是这本书的平均翻译水平，无力吐槽，能看懂多少看多少吧...**

#### 20.1.1 SharedArrayBuffer

SharedArrayBuffer 与 ArrayBuffer 具有相同的 API。二者的主要区别是 ArrayBuffer 必须在不同执行上下文之间切换，SharedArrayBuffer 则可以被任意多个执行上下文同时使用。

在多个执行上下文间共享内存意味着并发线程成为了可能。传统 JavaScript 操作对于并发内存访问到值的资源争用并没有提供保护。

Atomics API 可以保证 SharedArrayBuffer 上的 JavScript 操作时线程安全的。

### 20.2 跨上下文消息

介绍 postMessage() API 与其他窗口通信



> 阅读至 P616 20.2 跨上下文消息 641
