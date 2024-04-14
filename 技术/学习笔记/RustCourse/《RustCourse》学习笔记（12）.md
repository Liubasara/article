---
name: 《RustCourse》学习笔记（12）
title: 《RustCourse》学习笔记（12）
tags: ["技术","学习笔记","RustCourse"]
categories: 学习笔记
info: "第2章 Rust基本概念 2.11 返回值和错误处理"
time: 2024/4/12
desc: 'RustCourse, 学习笔记'
keywords: ['RustCourse', '学习笔记', 'rust']
---

# 《RustCourse》学习笔记（12）

## 第2章 Rust基本概念

### 2.12 包和模块

> https://course.rs/basic/crate-module/intro.html

Rust 提供了相应概念用于代码的组织管理：

- 项目（Packages）：一个由`Cargo`提供的特性，可以用来构建、测试和分享包。
- 工作空间（WorkSpace）：对于大型项目，可以进一步将多个包（Crate）联合在一起，组织成工作空间
- 包（Crate）：一个由多个模块组成的树形结构，可以作为第三方库进行分发，也可以生成可执行文件进行运行。
- 模块（Module）：可以一个文件多个模块，也可以一个文件一个模块，模块是真实项目中的代码组织单元。

#### 2.12.1 Crate 与 Packages

真实项目中，Package 和 Crate 很容易混淆，但官方其实对两者进行了明确地区分。

**包 Crate**

Crate 是一个独立的可编译单元，在编译后会生成一个可执行文件或者一个库。

在使用时，只需要通过`use`将该包引入到当前项目的作用域中，就可以在项目中使用包的功能。

同一个包中不能有同名的类型，但是在不同包中就可以，只要通过`包::类型名称`的方式就可以。

例如：

```rust

use rand;
// 使用xxx功能
rand::xxx

```

**项目 Package**

Package 是一个项目，它包含独立的 Cargo.toml 文件，以及被组织在一起的一个或多个包。

一个 Package 只能包含一个库（library）类型的包，但可以包含多个二进制可执行类型的包。

**二进制 package**










