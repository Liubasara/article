---
name: JavaScript高级程序设计（第4版）学习笔记（十五）
title: JavaScript高级程序设计（第4版）学习笔记（十五）
tags: ["技术","学习笔记","JavaScript高级程序设计第四版"]
categories: 学习笔记
info: "十年磨一剑，红宝书：21. 错误处理与调试 22. 处理 XML"
time: 2020/11/29
desc: 'javascirpt高级程序设计, 红宝书, 学习笔记'
keywords: ['javascirpt高级程序设计第四版', '前端', '红宝书第四版', '学习笔记']
---

# JavaScript高级程序设计（第4版）学习笔记（十五）

## 第 21 章 错误处理与调试

第三版冷饭。

ECMA-262 定义了以下 8 种错误类型：

- Error
- InternalError：JavaScript 内部错误，比如说递归过多导致的栈溢出
- EvalError：在使用 eval 函数发生异常时抛出，基本上只要不把 eval() 当成函数调用（比如说用 new 函数来调用）就会报告该错误
- RangeError：在数值越界时抛出
- ReferenceError：在找不到对象时发生，经常由于访问不存在的变量而导致
- SyntaxError：在 JavaScript 包含语法错误时发生
- TypeError：当访问不存在的方法或传入变量不是预期类型时发生
- URIError：只会在使用`encodeURI()`或`decodeURI()`但传入了错误的 URI 时发生。

### 21.3 调试技术

#### 21.3.1 把消息记录到控制台

多数浏览器支持通过`console`对象直接把 JavaScript 消息写入控制台，该对象包含如下方法：

- error(message)：记录错误消息，包含一个红叉图标
- info(msg)：记录信息性内容
- log(msg)：记录常规消息
- warn(msg)：记录警告消息，包含一个黄色叹号图标

## 第 22 章 处理 XML













> 本次阅读至 P694 719 第 22 章 处理 XML