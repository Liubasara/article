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

一个 Package 只能包含一个库（library）（PS：个人理解把它理解成 application 可能更好点...）类型的包，但可以包含多个二进制可执行类型的包。

**二进制 package**

创建二进制`Package`：

```shell
$ cargo new my-project
     Created binary (application) `my-project` package
$ ls my-project
Cargo.toml
src
$ ls my-project/src
main.rs
```

库类型的`Package`只能作为三方库被其它项目引用，而不能独立运行

如果一个 `Package` 包含有 `src/lib.rs`，意味它包含有一个库类型的同名包 `my-lib`，该包的根文件是 `src/lib.rs`。

**易混淆的 Package 和包（Crate）**

用 `cargo new` 创建的 `Package` 和它其中包含的包（Crate）是同名的！

但是，`Package` 是一个项目工程，而包只是一个编译单元，基本上也就不会混淆这个两个概念了：`src/main.rs` 和 `src/lib.rs` 都是编译单元，因此它们都是包（Crate）。



> Q: 本来不觉得混乱，看完摸不着头脑了，如果一个 Package 同时拥有 src/main.rs 和 src/lib.rs，那就意味着它包含两个包：库包和二进制包，这两个包名也都是 my-project —— 都与 Package 同名。
>
> 这两个包名，不是一个main.rs , 一个lib.rs吗，怎么都是my-project ，my-project怎么又与Package同名了？
>
> A：
>
> - src/main.rs
>   - binary crate的crate root
>   - crate名与package名相同
> - src/lib.rs
>   - package包含一个library crate
>   - library crate的crate root
>   - crate名与package名相同
> - Cargo把Crate root文件交给rustc构建library或binary
> - 一个Package可以同时包含src/main.rs和src/lib.rs
>   - 这就说明上面这个例子包含一个binary crate，一个library crate
>   - 名称与package名相同
> - 一个package可以有多个binary crate：
>   - 文件放在src/bin
>   - 每个文件是单独的binary crate

**典型的 Package 结构**

一个真实项目中典型的 `Package`，会包含多个二进制包，这些包文件被放在 `src/bin` 目录下，每一个文件都是独立的二进制包，同时也会包含一个库包，该包只能存在一个 `src/lib.rs`：

```txt
.
├── Cargo.toml
├── Cargo.lock
├── src
│   ├── main.rs
│   ├── lib.rs
│   └── bin
│       └── main1.rs
│       └── main2.rs
├── tests
│   └── some_integration_tests.rs
├── benches
│   └── simple_bench.rs
└── examples
    └── simple_example.rs
```

- 唯一库包：`src/lib.rs`
- 默认二进制包：`src/main.rs`，编译后生成的可执行文件与 `Package` 同名
- 其余二进制包：`src/bin/main1.rs` 和 `src/bin/main2.rs`，它们会分别生成一个文件同名的二进制可执行文件
- 集成测试文件：`tests` 目录下
- 基准性能测试 `benchmark` 文件：`benches` 目录下
- 项目示例：`examples` 目录下

这种目录结构基本上是 Rust 的标准目录结构，在 `GitHub` 的大多数项目上，你都将看到它的身影。

#### 2.12.2 模块 Module

> https://course.rs/basic/crate-module/module.html

模块可以将包中的代码按照功能性进行重组。

在 rust 中，可以使用路径引用模块，也可以从当前模块开始，以`self`，`super`或当前模块的标识符作为开头。

比如有这样一颗模块树：

```txt
crate
 └── eat_at_restaurant
 └── front_of_house
     ├── hosting
     │   ├── add_to_waitlist
     │   └── seat_at_table
     └── serving
         ├── take_order
         ├── serve_order
         └── take_payment
```























