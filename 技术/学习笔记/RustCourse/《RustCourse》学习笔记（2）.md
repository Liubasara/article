---
name: 《RustCourse》学习笔记（2）
title: 《RustCourse》学习笔记（2）
tags: ["技术","学习笔记","RustCourse"]
categories: 学习笔记
info: "第2章 Rust基本概念"
time: 2024/1/28
desc: 'RustCourse, 学习笔记'
keywords: ['RustCourse', '学习笔记', 'rust']
---

# 《RustCourse》学习笔记（2）

## 第2章 Rust基本概念

Rust 中有许多之前没有听过的概念：

- 所有权、借用、生命周期
- 宏编程
- 模式匹配

通过一段代码简单浏览 Rust 的语法：

```rust
// Rust 程序入口函数，跟其它语言一样，都是 main，该函数目前无返回值
fn main() {
    // 使用let来声明变量，进行绑定，a是不可变的
    // 此处没有指定a的类型，编译器会默认根据a的值为a推断类型：i32，有符号32位整数
    // 语句的末尾必须以分号结尾
    let a = 10;
    // 主动指定b的类型为i32
    let b: i32 = 20;
    // 这里有两点值得注意：
    // 1. 可以在数值中带上类型:30i32表示数值是30，类型是i32
    // 2. c是可变的，mut是mutable的缩写
    let mut c = 30i32;
    // 还能在数值和类型中间添加一个下划线，让可读性更好
    let d = 30_i32;
    // 跟其它语言一样，可以使用一个函数的返回值来作为另一个函数的参数
    let e = add(add(a, b), add(c, d));

    // println!是宏调用，看起来像是函数但是它返回的是宏定义的代码块
    // 该函数将指定的格式化字符串输出到标准输出中(控制台)
    // {}是占位符，在具体执行过程中，会把e的值代入进来
    println!("( a + b ) + ( c + d ) = {}", e);
}

// 定义一个函数，输入两个i32类型的32位有符号整数，返回它们的和
fn add(i: i32, j: i32) -> i32 {
    // 返回相加值，这里可以省略return
    i + j
}
```

> 注意 在上面的 `add` 函数中，不要为 `i+j` 添加 `;`，这会改变语法导致函数返回 `()` 而不是 `i32`，具体参见[语句和表达式](https://course.rs/basic/base-type/statement-expression.html)。

要注意：

- 字符串使用双引号`""`而不是单引号`''`，Rust 中的单引号是留给`char`单字符类型使用的
- Rust 使用 `{}` 来作为格式化输出占位符。由于`println!`会自动推导出具体的类型，因此无需手动指定。

### 2.1 变量绑定与解构

> https://course.rs/basic/variable.html

#### 为何要手动设置变量的可变性？

Rust 可以手动设置变量的可变性，可以避免一些多余的 runtime 检查，会使得运行性能有所提升，但也意味着 Rust 语言底层代码的实现复杂度大幅提升。

#### 变量绑定

其他语言都是把赋值的过程称为**变量赋值**，为什么 rust 跟其他语言不一样要称为**变量绑定**呢？

这涉及到了 Rust 最核心的原则——所有权，在 Rust 中任何内存对象都是有主人的，绑定就是把这个对象绑定给一个变量，让这个变量成为它的主人。

#### 变量可变性

Rust 的变量在默认情况下是不可变的。当然也可以通过`mut`关键字让变量变为可变的。

#### 变量解构及赋值

```rust
fn main() {
    let (a, mut b): (bool,bool) = (true, false);
    // a = true,不可变; b = false，可变
    println!("a = {:?}, b = {:?}", a, b);

    b = true;
    assert_eq!(a, b);
}
```

```rust
struct Struct {
    e: i32
}

fn main() {
    let (a, b, c, d, e);

    (a, b) = (1, 2);
    // _ 代表匹配一个值，但是我们不关心具体的值是什么，因此没有使用一个变量名而是使用了 _
    [c, .., d, _] = [1, 2, 3, 4, 5];
    Struct { e, .. } = Struct { e: 5 };

    assert_eq!([1, 2, 1, 4, 5], [a, b, c, d, e]);
}
```

#### 变量和常量之间的差异

常量使用`const`关键字而不是`let`关键字来声明，而且值得类型**必须标注**。

#### 变量遮蔽

Rust 允许声明相同的变量名，且后面声明的变量会遮蔽掉前面声明的。

```rust
fn main() {
    let x = 5;
    // 在main函数的作用域内对之前的x进行遮蔽
    let x = x + 1;

    {
        // 在当前的花括号作用域内，对之前的x进行遮蔽
        let x = x * 2;
        println!("The value of x in the inner scope is: {}", x);
    }

    println!("The value of x is: {}", x);
}
```

> 这和 `mut` 变量的使用是不同的，第二个 `let` 生成了完全不同的新变量，两个变量只是恰好拥有同样的名称，涉及一次内存对象的再分配 ，而 `mut` 声明的变量，可以修改同一个内存地址上的值，并不会发生内存对象的再分配，性能要更好。

### 2.2 基本类型

> https://course.rs/basic/base-type/index.html

Rust 每个值都有其确切的数据类型，可分为两类：基本类型和复合类型。

基本类型意味着它们时一个最小化的原子类型，无法结构为其他类型，由以下组成：

- 数值类型：符号整数（i8，i16，i32，i64，isize）、无符号整数（u8、u16、u32、u64、usize）、浮点数（f32、f64）、以及有理数、复数
- 字符串：字符串字面量和字符串切片`&str`
- 布尔类型：表示单个 Unicode 字符，存储为 4 个字节
- 单元类型：即`()`，其唯一的值也是`()`

#### 类型推导与标注

Rust 虽然是一门静态类型语言，所有变量的类型都必须在编译器确认，但 Rust 编译器可以根据变量的值和上下文的使用方式自动推导出变量的类型，所以并不需要为每个变量都指定类型。

在某些情况下，编译器可能无法推导出我们想要的类型，此时就应该手动指定类型，如：

```rust
let guess = "42".parse().expect("Not a number!");
```

上面的代码会报错，因为编译器无法判断 parse 函数应该输出什么值，所以应该改为：

```rust
let guess: i32 = "42".parse().expect("Not a number!");
```

或者改为：

```rust
let guess = "42".parse::<i32>().expect("Not a number!");
```

> expect 方法类似于 try catch，如果传入的数值不是 parse 中传入的类型，rust 会在运行时报出 expect 中的错误，例如：
>
> ```rust
> fn main() {
>     let guess = "sfsf".parse::<i32>().expect("Not a number!");
>     println!("guess: {}", guess)
> }
> ```
>
> ```txt
> root@3aa4eb51aa66:/app/data/helloWorld# cargo run --release
>     Finished release [optimized] target(s) in 0.03s
>      Running `target/release/hello-world`
> thread 'main' panicked at 'Not a number!: ParseIntError { kind: InvalidDigit }', src/main.rs:2:39
> note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
> ```

#### 2.2.1 数值类型

> https://course.rs/basic/base-type/numbers.html

**整数类型**

整数是没有小数部分的数字，使用`i`代表有符号的类型，使用`u`则代表无符号的类型。例如`i32`代表有符号的 32 位整数，`u32`代表无符号的 32 位整数。Rust 整型默认使用 `i32`

其中无符号数表示数字只能取正数和 0，而有符号则表示数字可以取正数、负数还有 0。

> 每个有符号类型规定的数字范围是 -(2n - 1) ~ 2n - 1 - 1，其中 `n` 是该定义形式的位长度。因此 `i8` 可存储数字范围是 -(27) ~ 27 - 1，即 -128 ~ 127。无符号类型可以存储的数字范围是 0 ~ 2n - 1，所以 `u8` 能够存储的数字为 0 ~ 28 - 1，即 0 ~ 255。

**整型溢出**

当给一个类型存放了范围之外的值，就会出现**整形溢出**的问题。关于这类问题，当处于 debug 模式编译时，Rust 会检查整型溢出，也就是编译时就会崩溃。

但是如果使用`--release`参数进行构建时，Rust 不会检测溢出，相反，Rust 会按照`补码循环溢出（*two’s complement wrapping*）`的规则处理。简而言之，大于该类型最大的数值会被补码转换成该类型能够支持的对应数字的最小值。比如说，在`u8`下，256 会变成 0，257 会变成 1。但这也就意味着，后续的代码都不会按照开发者的预期进行工作。

> 在 debug 模式下要显式处理可能的溢出，可以使用标准库针对原始数字类型提供的这些方法：
>
> - 使用 `wrapping_*` 方法在所有模式下都按照补码循环溢出规则处理，例如 `wrapping_add`
> - 如果使用 `checked_*` 方法时发生溢出，则返回 `None` 值
> - 使用 `overflowing_*` 方法返回该值和一个指示是否存在溢出的布尔值
> - 使用 `saturating_*` 方法，可以限定计算后的结果不超过目标类型的最大值或低于最小值，例如:
>
> ```rust
> assert_eq!(100u8.saturating_add(1), 101);
> assert_eq!(u8::MAX.saturating_add(127), u8::MAX);
> ```
>
> 下面是一个演示`wrapping_*`方法的示例：
>
> ```rust
> fn main() {
>     let a : u8 = 255;
>     let b = a.wrapping_add(20);
>     println!("{}", b);  // 19
> }
> ```

**浮点类型**

在 Rust 中浮点类型数字也有两种基本类型：`f32`和`f64`。默认浮点类型`f64`





