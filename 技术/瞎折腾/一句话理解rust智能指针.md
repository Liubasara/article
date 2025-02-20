---
name: 一句话理解rust智能指针
title: 一句话理解rust智能指针
tags: ["技术", "瞎折腾"]
categories: 瞎折腾
info: "你有张良计，我有过墙梯"
time: 2025/2/20
desc: 一句话理解rust智能指针
keywords: [rust', 'Box', 'Rec', 'Arc', 'Cell','RefCell', '智能指针']
---

# 一句话理解rust智能指针

>
> - [Rust 中几个智能指针的异同与使用场景](https://rustcc.cn/article?id=ac75148b-6eb0-4249-b36d-0a14875b736e)
>

1. Box 普通指针，将数据放到堆上，通过`*`即可访问
2. Rc 允许通过 clone 将多个指针变量映射到同一个堆数据上，但只能是不可变的变量（是变量而不是引用哦）
3. Arc Rc 的多线程版
4. Cell 允许通过 set 方法来改变数据，这让不可变引用也能修改数据了
5. RefCell Cell的多线程版，但在使用时需要用另外的 borrow_mut 方法进行检查而不是直接使用 set
6. Arc 和 Refcell 结合使用，则既可以实现一个堆数据既允许多个所有权，又能通过不可变引用来修改数据，完全无视规则，官方外挂，不服不行。