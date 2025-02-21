---
name: 一句话理解rust智能指针
title: 一句话理解rust智能指针
tags: ["技术", "瞎折腾"]
categories: 瞎折腾
info: "你有张良计，我有过墙梯"
time: 2025/2/21
desc: 一句话理解rust智能指针
keywords: [rust', 'Box', 'Rec', 'Arc', 'Cell','RefCell', '智能指针']
---

# 一句话理解rust智能指针

>
> - [Rust 中几个智能指针的异同与使用场景](https://rustcc.cn/article?id=ac75148b-6eb0-4249-b36d-0a14875b736e)
> - [Rust智能指针——Cow学习笔记](https://zhuanlan.zhihu.com/p/19825428904?utm_campaign=shareopn&utm_medium=social&utm_psn=1876273633053245442&utm_source=wechat_session)
>

1. Box 普通指针，将数据放到堆上，通过`*`即可访问
2. Rc 允许通过 clone 将多个指针变量映射到同一个堆数据上，但只能是不可变的变量（是包含了【所有权的变量】而不是引用哦）
3. Arc Rc 的多线程版
4. Cell 允许通过 set 方法来改变数据，这让不可变引用也能修改数据了
5. RefCell Cell的多线程版，但在使用时需要用另外的 borrow_mut 方法进行检查而不是直接使用 set
6. Arc 和 Refcell 结合使用，则既可以实现一个堆数据既允许多个所有权，又能通过不可变引用来修改数据，完全无视规则，官方外挂，不服不行。
7. Cow 指针是 Copy On Write 的简写，无论你传入的是一个引用还是一个【所有权变量】，都会在进行赋值的时候调用 clone 复制一遍原有的东西，然后给一个新的【所有权变量】出来

---

关于智能指针结构体，有一个共同点就是，所有结构体都实现了 Deref 特性。

AI扩展阅读：

> Q: rust 中的 deref 特性是什么？
>
> A：在 Rust 中，Deref 特性（trait）允许你通过解引用操作符（*）访问智能指针或其他类型的底层数据。实现 Deref 特性的类型可以像普通引用一样使用，从而提供更自然和简洁的语法。
>
> ```rust
> pub trait Deref {
>   /*
>    * ?Sized 是 Rust 中的一个内置特性（trait），它表示类型可以是不定大小类型（dynamically sized type）。默认情况下，Rust 中的类型是定大小的（sized），即编译时可以确定其大小。
>    * 但是，有些类型的大小在编译时是未知的，例如切片 [T] 和特性对象 dyn Trait。?Sized 特性允许这些类型作为泛型参数。
>    **/
>    type Target: ?Sized;
>
>    fn deref(&self) -> &Self::Target;
> }
> ```
> 
> 总之，Deref 特性使得智能指针和其他类型能够像普通引用一样使用，从而提供更自然和简洁的语法，并支持自动解引用机制。
> 
> Q：如何手动实现一个 defer 特性？
> 
> A：
>
> ```rust
> 
> use std::ops::Deref;
>
> struct MyBox<T>(T);
> 
> impl<T> Deref for MyBox<T> {
>     type Target = T;
> 
>     fn deref(&self) -> &T {
>         &self.0
>     }
> }
> 
> fn main() {
>     let x = 5;
>     let y = MyBox(x);
> 
>     assert_eq!(5, x);
>     assert_eq!(5, *y); // 使用解引用操作符访问 MyBox 内部的数据
> }
> ```
>
> 具体来说：
>
> MyBox 是结构体的名称。
> <T> 表示 MyBox 是一个泛型结构体，它可以包含任何类型 T 的数据。
> (T) 表示 MyBox 是一个元组结构体，它包含一个类型为 T 的元素。
> 元组结构体是一种特殊的结构体，它的字段没有名称，只有类型。你可以通过索引来访问元组结构体的字段。对于 MyBox 结构体，你可以通过 .0 来访问其内部的数据。
> 

