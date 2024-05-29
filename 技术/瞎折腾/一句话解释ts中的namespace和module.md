---
name: 一句话解释ts中的namespace和module
title: 一句话解释ts中的namespace和module
tags: ["技术", "瞎折腾"]
categories: 瞎折腾
info: "伟大的向后兼容"
time: 2024/5/29
desc: namespace和module区别
keywords: ['html', 'typescript', 'namespace', 'module']
---

# 一句话解释ts中的namespace和module

> 参考资料：
> [在TypeScript中使用namespace封装数据](https://pengfeixc.com/blogs/javascript/typescript-namespace)

- 命名空间 namespace 会被编译成l立即执行的闭包函数，是`import`和`class`出现之前的产物（这俩对应的是 ts 里的 module）
- namespace 和 enum 类似，都是同样可以用来作为值和类型的存在。namespace 用来描述类似 class 一样的结构。其唯一的区别就是引用方式。
- module 作为值时，可以使用`import A from 'aaa'`来引入，而 namespace 作为值时，除了同样支持 module 的语法以外，还支持通过`import API_Types = MyLibA.Types; `的方式引入，这是一种用于兼容的语法糖，现在已经很少用了。
- module 作为类型时，可以用`import type A from 'aaa'`的方式引入，而 namespace 由于天生同时是值和类型，所以也能这样用。但在 @types 的全局声明 dts 文件中，不能使用 import 语法，因为会使得该 dts 文件被识别成模块。所以这个时候可以使用`/// <reference path="./b.ts" />`的方式，将 namespace 作为单纯的类型引入。





伟大的向后兼容！！