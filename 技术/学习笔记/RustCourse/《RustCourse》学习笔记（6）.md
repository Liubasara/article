---
name: 《RustCourse》学习笔记（6）
title: 《RustCourse》学习笔记（6）
tags: ["技术","学习笔记","RustCourse"]
categories: 学习笔记
info: "第2章 Rust基本概念 2.4 复合类型"
time: 2024/2/18
desc: 'RustCourse, 学习笔记'
keywords: ['RustCourse', '学习笔记', 'rust']
---

# 《RustCourse》学习笔记（6）

## 第2章 Rust基本概念

### 2.4 复合类型

> https://course.rs/basic/compound-type/array.html

#### 2.4.5 数组

在 Rust 中，最常用的数组有两种，第一种是速度很快但是长度固定的 `array`，第二种是可动态增长的但是有性能损耗的 `Vector`，在本书中，我们称 `array` 为数组，`Vector` 为动态数组。

两个数组的关系跟`$str`与`String`的关系很像。

对于 array 数组，有三要素：

- 长度固定
- 元素必须有相同的类型
- 依次线性排列

> 注意：**我们这里说的数组是 Rust 的基本类型，是固定长度的，这点与其他编程语言不同，其它编程语言的数组往往是可变长度的，与 Rust 中的动态数组 `Vector` 类似**

创建数组：

```rust
fn main() {
  let a = [1, 2, 3, 4, 5];
}
```

数组 Array 存储在栈上，与此对应动态数组`Vector`是存储在堆上的。

















