---
name: 《RustCourse》学习笔记（7）
title: 《RustCourse》学习笔记（7）
tags: ["技术","学习笔记","RustCourse"]
categories: 学习笔记
info: "第2章 Rust基本概念 2.7 方法 Method 2.8 泛型和特征 2.8.1 泛型 Generics 2.8.2 特征 Trait"
time: 2024/2/27
desc: 'RustCourse, 学习笔记'
keywords: ['RustCourse', '学习笔记', 'rust']
---

# 《RustCourse》学习笔记（7）

## 第2章 Rust基本概念

### 2.7 方法 Method

> https://course.rs/basic/method.html

在其他的语言中，方法一般与`class`一起出现，在 Rust 中也差不多，方法会与对象成对出现。一样是`object.method()`的调用方式，只是定义的方式有些不同。

其它语言中所有定义都在 `class` 中，但是 Rust 的对象定义和方法定义是分离的，这种数据和使用分离的方式，会给予使用者极高的灵活度。

#### 2.7.1 定义方法

Rust 使用`impl`来定义方法，例如：

```rust
#[derive(Debug)]
struct Rectangle {
  width: u32,
  height: u32,
}

impl Rectangle {
  fn area(&self) -> u32 {
    self.width * self.height
  }
}

fn main() {
  let rect1 = Rectangle { width: 30, height: 50 };

  println!(
    "The area of the rectangle is {} square pixels.",
    rect1.area()
  );
}
```

`impl Rectangle {}`表示为 Rectangle 结构体实现方法（impl 是实现 implementation 的缩写），这样的写法表明`impl`语句块中的一切都是与这个类相关联的。

##### 2.7.1.1 self、&self 和 &mut self

为哪个结构体实现方法，那么 `self` 就是指代哪个结构体的实例。

需要注意的是，`self` 依然有所有权的概念：

- `self` 表示 `Rectangle` 的所有权转移到该方法中，这种形式用的较少。

  仅仅通过使用 `self` 作为第一个参数来使方法获取实例的所有权是很少见的，**这种使用方式往往用于把当前的对象转成另外一个对象时使用，转换完后，就不再关注之前的对象，且可以防止对之前对象的误调用**。

- `&self` 表示该方法对 `Rectangle` 的不可变借用，这其实是`self: &Self`的缩写语法糖

- `&mut self` 表示可变借用，这其实是`self: &mut Self`的缩写语法糖

> 使用方法代替函数有以下好处：
>
> - 不用在函数签名中重复书写 `self` 对应的类型
> - 代码的组织性和内聚性更强，对于代码维护和阅读来说，好处巨大

在 Rust 中，允许方法名跟结构体的字段名相同：

```rust
#[derive(Debug)]
struct Rectangle {
  width: u32,
  height: u32,
}

impl Rectangle {
  fn width(&self) -> bool {
    self.width > 0
  }
}

fn main() {
  let rect1 = Rectangle {
    width: 30,
    height: 50,
  };

  if rect1.width() {
    println!("The rectangle has a nonzero width; it is {}", rect1.width);
  }
}
```

当我们使用 `rect1.width()` 时，Rust 知道我们调用的是它的方法，如果使用 `rect1.width`，则是访问它的字段。

方法跟字段同名的这种方式也适用于`getter`访问器，例如：

```rust
pub struct Rectangle {
  width: u32,
  height: u32,
}

impl Rectangle {
  // `Self` 指代的就是被实现方法的结构体 `Rectangle`。
  pub fn new(width: u32, height: u32) -> Self {
    Rectangle { width, height }
  }
  pub fn width(&self) -> u32 {
    return self.width;
  }
}

fn main() {
  let rect1 = Rectangle::new(30, 50);

  println!("{}", rect1.width());
}
```

> 用这种方式，我们可以把 `Rectangle` 的字段设置为私有属性，只需把它的 `new` 和 `width` 方法设置为公开可见，那么用户就可以创建一个矩形，同时通过访问器 `rect1.width()` 方法来获取矩形的宽度，因为 `width` 字段是私有的，当用户访问 `rect1.width` 字段时，就会报错。



> **`->` 运算符到哪去了？**
>
> 在 C/C++ 语言中，有两个不同的运算符来调用方法：`.` 直接在对象上调用方法，而 `->` 在一个对象的指针上调用方法，这时需要先解引用指针。换句话说，如果 `object` 是一个指针，那么 `object->something()` 和 `(*object).something()` 是一样的。
>
> Rust 并没有一个与 `->` 等效的运算符；相反，Rust 有一个叫 **自动引用和解引用**的功能。方法调用是 Rust 中少数几个拥有这种行为的地方。
>
> 他是这样工作的：当使用 `object.something()` 调用方法时，Rust 会自动为 `object` 添加 `&`、`&mut` 或 `*` 以便使 `object` 与方法签名匹配。也就是说，这些代码是等价的：
>
> ```rust
> p1.distance(&p2);
> (&p1).distance(&p2);
> ```
>
> 第一行看起来简洁的多。这种自动引用的行为之所以有效，是因为方法有一个明确的接收者———— `self` 的类型。在给出接收者和方法名的前提下，Rust 可以明确地计算出方法是仅仅读取（`&self`），做出修改（`&mut self`）或者是获取所有权（`self`）。事实上，Rust 对方法接收者的隐式借用让所有权在实践中更友好。

（个人理解：上面这段话的意思是，在`rust`中，针对指针的调用和针对对象的调用可以是同一种形式，也就是无论是直接在结构体 x 上调用 a 方法，还是在指向结构体 x 的引用 x:&X 上调用 a 方法，最终的写法都是`x.a()`）

#### 2.7.2 带有多个参数的方法

方法和函数一样可以使用多个参数：

```rust
impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.height
    }

    fn can_hold(&self, other: &Rectangle) -> bool {
        self.width > other.width && self.height > other.height
    }
}

fn main() {
    let rect1 = Rectangle { width: 30, height: 50 };
    let rect2 = Rectangle { width: 10, height: 40 };
    let rect3 = Rectangle { width: 60, height: 45 };

    println!("Can rect1 hold rect2? {}", rect1.can_hold(&rect2));
    println!("Can rect1 hold rect3? {}", rect1.can_hold(&rect3));
}
```

#### 2.7.3 关联函数

定义在 `impl` 中且没有 `self` 的函数被称之为**关联函数**： 因为它没有 `self`，不能用 `f.read()` 的形式调用，因此它是一个函数而不是方法，它又在 `impl` 中，与结构体紧密关联，因此称为关联函数。

因为是函数，所以不能用 `.` 的方式来调用，我们需要用 `::` 来调用，例如 `let sq = Rectangle::new(3, 3);`。这个方法位于结构体的命名空间中：`::` 语法用于关联函数和模块创建的命名空间。

```rust
impl Rectangle {
    fn new(w: u32, h: u32) -> Rectangle {
        Rectangle { width: w, height: h }
    }
}
let rect = Rectangle::new(1, 2);
```

> Rust 中有一个约定俗成的规则，使用 `new` 来作为构造器的名称，出于设计上的考虑，Rust 特地没有用 `new` 作为关键字。

#### 2.7.4 多个 impl 定义

允许为同一个结构体定义多个`impl`块，提供更多的灵活性和代码组织性。

```rust
impl Rectangle {
  fn area(&self) -> u32 {
    self.width * self.height
  }
}

impl Rectangle {
  fn can_hold(&self, other: &Rectangle) -> bool {
    self.width > other.width && self.height > other.height
  }
}
```

#### 2.7.5 为枚举实现方法

可以像结构体一样，为枚举实现方法。除了结构体和枚举，以后还会学到为特征(trait)实现方法。

```rust
#![allow(unused)]
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(i32, i32, i32),
}

impl Message {
    fn call(&self) {
        // 在这里定义方法体
    }
}

fn main() {
    let m = Message::Write(String::from("hello"));
    m.call();
}
```

### 2.8 泛型和特征

#### 2.8.1 泛型 Generics

> https://course.rs/basic/trait/generic.html

```rust
// 错误的示范：
fn add<T>(a:T, b:T) -> T {
    a + b
}

fn main() {
    println!("add i8: {}", add(2i8, 3i8));
    println!("add i32: {}", add(20, 30));
    println!("add f64: {}", add(1.23, 1.23));
}

/*
Compiling playground v0.0.1 (/playground)
error[E0369]: cannot add `T` to `T`
 --> src/main.rs:2:7
  |
2 |     a + b
  |     - ^ - T
  |     |
  |     T
  |
help: consider restricting type parameter `T`
  |
1 | fn add<T: std::ops::Add<Output = T>>(a:T, b:T) -> T {
  |         +++++++++++++++++++++++++++

For more information about this error, try `rustc --explain E0369`.
error: could not compile `playground` (bin "playground") due to 1 previous error
*/
```

报错的原因是并非所有的类型都可以进行相加，需要对泛型T进行限制。

```rust
// 正确的例子
fn add<T: std::ops::Add<Output = T>>(a:T, b:T) -> T {
    a + b
}
```

##### 2.8.1.1 结构体中使用泛型

```rust
struct Point<T, U> {
  x: T,
  y: T,
  z: U
}

fn main() {
    let p = Point{x: 1, y : 2, z: 1.1};
}
```

##### 2.8.1.2 枚举中使用泛型

```rust
enum Option<T> {
    Some(T),
    None,
}

enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

`Result`枚举是跟`Option`同样重要的枚举，主要关注值的正确性，其中 T 是正确类型，而 E 是错误类型。

> 例如打开一个文件：如果成功打开文件，则返回 `Ok(std::fs::File)`，因此 `T` 对应的是 `std::fs::File` 类型；而当打开文件时出现问题时，返回 `Err(std::io::Error)`，`E` 对应的就是 `std::io::Error` 类型。

##### 2.8.1.3 方法中使用泛型

```rust
struct Point<T, U> {
    x: T,
    y: U,
}

impl<T, U> Point<T, U> {
    fn mixup<V, W>(self, other: Point<V, W>) -> Point<T, W> {
        Point {
            x: self.x,
            y: other.y,
        }
    }
}

fn main() {
    let p1 = Point { x: 5, y: 10.4 };
    let p2 = Point { x: "Hello", y: 'c'};

    let p3 = p1.mixup(p2);

    println!("p3.x = {}, p3.y = {}", p3.x, p3.y);
}
```

除了结构体中的泛型参数，我们还能在该结构体的方法中定义额外的泛型参数，就跟泛型函数一样。

此外，不仅能定义基于 T 的方法，还能针对特定的具体类型，进行方法定义：

```rust
impl Point<f32> {
    fn distance_from_origin(&self) -> f32 {
        (self.x.powi(2) + self.y.powi(2)).sqrt()
    }
}
```

这样我们就能针对特定的泛型类型实现某个特定的方法，对于其它泛型类型则没有定义该方法。

##### 2.8.1.4 const 泛型（Rust 1.51 版本以后特性）

const 泛型是一种针对值的泛型。（个人理解：跟 Typescript 里面的`as const`关键字差不多）

> 你们知道为什么以前 Rust 的一些数组库，在使用的时候都限定长度不超过 32 吗？因为它们会为每个长度都单独实现一个函数，简直。。。毫无人性。难道没有什么办法可以解决这个问题吗？
>
> 好在，现在咱们有了 const 泛型，也就是针对值的泛型，正好可以用于处理数组长度的问题

```rust
fn display_array<T: std::fmt::Debug, const N: usize>(arr: [T; N]) {
    println!("{:?}", arr);
}
fn main() {
    let arr: [i32; 3] = [1, 2, 3];
    display_array(arr);

    let arr: [i32; 2] = [1, 2];
    display_array(arr);
}
```

其中，`std::fmt::Debug`限制是为了让 T 类型能够被 "{:?}" 打印出来。

const 泛型表达式：个人理解，就是借助值的泛型来进行类型体操。

比如说限制函数参数的内存大小：

```rust
// 目前只能在nightly版本下使用
#![allow(incomplete_features)]
#![feature(generic_const_exprs)]

fn something<T>(val: T)
where
    Assert<{ core::mem::size_of::<T>() < 768 }>: IsTrue,
    //       ^-----------------------------^ 这里是一个 const 表达式，换成其它的 const 表达式也可以
{
    //
}

fn main() {
    something([0u8; 0]); // ok
    something([0u8; 512]); // ok
    something([0u8; 1024]); // 编译错误，数组长度是1024字节，超过了768字节的参数长度限制
}

// ---

pub enum Assert<const CHECK: bool> {
    //
}

pub trait IsTrue {
    //
}

impl IsTrue for Assert<true> {
    //
}
```



性能：在 Rust 中泛型是零成本的抽象（静态分发，区别于特征对象的**动态分发**），这意味着在使用泛型时，完全不用担心运行时的性能问题。与之相对应的，会损失一些编译速度和增大了最终生成文件的大小。

#### 2.8.2 特征 Trait

特征跟其他语言的接口概念很类似，特征定义了**一组可以被共享的行为，只要实现了特征，你就能使用这组行为**。

```rust
// 为类型实现特征
pub trait Summary {
  fn summarize(&self) -> String;
}
pub struct Post {
  pub title: String, // 标题
  pub author: String, // 作者
  pub content: String, // 内容
}

impl Summary for Post {
  fn summarize(&self) -> String {
    format!("文章{}, 作者是{}", self.title, self.author)
  }
}

pub struct Weibo {
  pub username: String,
  pub content: String
}

impl Summary for Weibo {
  fn summarize(&self) -> String {
    format!("{}发表了微博{}", self.username, self.content)
  }
}
```

> **孤儿原则**
>
> **如果你想要为类型** `A` **实现特征** `T`**，那么** `A` **或者** `T` **至少有一个是在当前作用域中定义的！**
>
> 例如我们可以为上面的 `Post` 类型实现标准库中的 `Display` 特征，这是因为 `Post` 类型定义在当前的作用域中。同时，我们也可以在当前包中为 `String` 类型实现 `Summary` 特征，因为 `Summary` 定义在当前作用域中。
>
> 但是你无法在当前作用域中，为 `String` 类型实现 `Display` 特征，因为它们俩都定义在标准库中，其定义所在的位置都不在当前作用域，跟你半毛钱关系都没有，看看就行了。
>
> 该规则被称为**孤儿规则**，可以确保其它人编写的代码不会破坏你的代码，也确保了你不会莫名其妙就破坏了风马牛不相及的代码。

##### 2.8.2.1 默认实现

可以在特征定义中定义默认实现的方法。同时该默认实现的方法也可以调用其他未实现的方法。只要在最后的`impl`中实现这些不具有默认实现的方法就可以了。

```rust
pub trait Summary {
  fn summarize_author(&self) -> String;
  fn summarize(&self) -> String {
    format!("(Read more from {}...)", self.summarize_author())
  }
}

impl Summary for Post {
  fn summarize_author(&self) -> String {
    format!("@{}", self.username)
  }
}

impl Summary for Weibo {
  fn summarize_author(&self) -> String {
    format!("@{}", self.username)
  }
  fn summarize(&self) -> String {
    format!("{}发表了微博{}", self.username, self.content)
  }
}

println!("{}",post.summarize());
println!("{}",weibo.summarize());
```

##### 2.8.2.2 使用特征作为函数参数

```rust
pub fn notify(item: &impl Summary) {
  println!("Breaking news! {}", item.summarize());
}
```

> 你可以使用任何实现了 `Summary` 特征的类型作为该函数的参数，同时在函数体内，还可以调用该特征的方法，例如 `summarize` 方法。具体的说，可以传递 `Post` 或 `Weibo` 的实例来作为参数，而其它类如 `String` 或者 `i32` 的类型则不能用做该函数的参数，因为它们没有实现 `Summary` 特征。

虽然 `impl Trait` 这种语法非常好理解，但是实际上它只是一个语法糖：

```rust
pub fn notify<T: Summary>(item: &T) {
  println!("Breaking news! {}", item.summarize());
}
```

形如 `T: Summary` 被称为**特征约束**。`&impl`作为语法糖只能约束某个参数具有某特征，但如果需要限制两个参数必须是同一个类型，则还是需要这样写：

```rust
// 泛型类型 T 说明了 item1 和 item2 必须拥有同样的类型，同时 T: Summary 说明了 T 必须实现 Summary 特征。
pub fn notify<T: Summary>(item1: &T, item2: &T) {}
```

特征约束可以让函数拥有更强大的灵活性和语法表现能力。

除了单个约束条件，还可以指定多个约束条件，比如：

```rust
/*
要求参数同时实现 Summary 和 Display 两个特征，就既可以使用 Summary 里的方法，又可以通过 println!("{}", item) 来格式化输出 item。
*/

pub fn notify(item: &(impl Summary + Display)) {}
// or
pub fn notify<T: Summary + Display>(item: &T) {}
```

当特征约束变得很多时，可以用`Where`关键字来换一种方式写函数签名：

```rust
fn some_function<T: Display + Clone, U: Clone + Debug>(t: &T, u: &U) -> i32 {}
// 等同于
fn some_function<T, U>(t: &T, u: &U) -> i32
    where T: Display + Clone,
          U: Clone + Debug
{}
```



此外，作为函数参数，特征可以使用`指定类型+指定特征`的方式混用，例如：

```rust
use std::fmt::Display;

struct Pair<T> {
  x: T,
  y: T,
}

impl<T> Pair<T> {
  fn new(x: T, y: T) -> Self {
    Self {
      x,
      y,
    }
  }
}


impl<T: Display + PartialOrd> Pair<T> {
  /*
  cmp_display 方法，并不是所有的 Pair<T> 结构体对象都可以拥有，只有 T 同时实现了 Display + PartialOrd 的 Pair<T> 才可以拥有此方法。 该函数可读性会更好，因为泛型参数、参数、返回值都在一起，可以快速的阅读，同时每个泛型参数的特征也在新的代码行中通过特征约束进行了约束。
  */
  fn cmp_display(&self) {
    if self.x >= self.y {
      println!("The largest member is x = {}", self.x);
    } else {
      println!("The largest member is y = {}", self.y);
    }
  }
}
```

**也可以有条件地实现特征**, 例如，标准库为任何实现了 `Display` 特征的类型实现了 `ToString` 特征：

```rust
impl<T: Display> ToString for T {
    // --snip--
}
// 我们可以对任何实现了 Display 特征的类型调用由 ToString 定义的 to_string 方法。例如，可以将整型转换为对应的 String 值，因为整型实现了 Display 特征
let s = 3.to_string();
```

##### 2.8.2.3  函数返回中的 impl Trait

```rust
fn returns_summarizable() -> impl Summary {
    Weibo {
        username: String::from("sunface"),
        content: String::from(
            "m1 max太厉害了，电脑再也不会卡",
        )
    }
}
```

> 这种 `impl Trait` 形式的返回值，在一种场景下非常非常有用，那就是返回的真实类型非常复杂，你不知道该怎么声明时(毕竟 Rust 要求你必须标出所有的类型)，此时就可以用 `impl Trait` 的方式简单返回。例如，闭包和迭代器就是很复杂，只有编译器才知道那玩意的真实类型，如果让你写出来它们的具体类型，估计内心有一万只草泥马奔腾，好在你可以用 `impl Iterator` 来告诉调用者，返回了一个迭代器，因为所有迭代器都会实现 `Iterator` 特征。

但是这种返回值的方式有一个很大的限制，只能有一个具体的类型，如果一个函数通过`if else`反悔了两种不同的结构体，就会报错：

```rust
fn returns_summarizable(switch: bool) -> impl Summary {
  if switch {
    Post {
      title: String::from(
        "Penguins win the Stanley Cup Championship!",
      ),
      author: String::from("Iceburgh"),
      content: String::from(
        "The Pittsburgh Penguins once again are the best \
        hockey team in the NHL.",
      ),
    }
  } else {
    Weibo {
      username: String::from("horse_ebooks"),
      content: String::from(
        "of course, as you probably already know, people",
      ),
    }
  }
}

/*
  报错：`if` and `else` have incompatible types
  expected struct `Post`, found struct `Weibo`
*/
```

如果想要实现返回不同的类型，则需要使用**特征对象**（`&dyn Summary`）

##### 2.8.2.4  通过 derive 派生特征

像是`#[drive(Debug)]`这样的代码，其实是一种特征的派生语法。被`derive`标记的对象会自动实现对应的默认特征代码并继承相应的功能。例如 `Debug` 特征，它有一套自动实现的默认代码，当你给一个结构体标记后，就可以使用 `println!("{:?}", s)` 的形式打印该结构体的对象。

> 详细的 `derive` 列表参见[附录-派生特征](https://course.rs/appendix/derive.html)。

一个实际例子，为自定义类型实现 Display 特征：

```rust
#![allow(dead_code)]

use std::fmt;
use std::fmt::{Display};

#[derive(Debug,PartialEq)]
enum FileState {
  Open,
  Closed,
}

#[derive(Debug)]
struct File {
  name: String,
  data: Vec<u8>,
  state: FileState,
}

impl Display for FileState {
   fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
     match *self {
         FileState::Open => write!(f, "OPEN"),
         FileState::Closed => write!(f, "CLOSED"),
     }
   }
}

impl Display for File {
   fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
      write!(f, "<{} ({})>",
             self.name, self.state)
   }
}

impl File {
  fn new(name: &str) -> File {
    File {
        name: String::from(name),
        data: Vec::new(),
        state: FileState::Closed,
    }
  }
}

fn main() {
  let f6 = File::new("f6.txt");
  //...
  println!("{:?}", f6);
  println!("{}", f6);
}
```

> ChatGPT：
>
> Q：rust 中的 #![allow(dead_code)] 是什么意思？#[derive(Debug,PartialEq)] 又是什么意思？
>
> A：在 Rust 中，`#![allow(dead_code)]` 是一个属性，用于关闭编译器的一个警告。这个警告通常会在你定义了一些函数或变量，但没有在任何地方使用它们时触发。通过在代码文件的顶部添加 `#![allow(dead_code)]`，你可以告诉编译器你知道这些代码没有被使用，但你仍然想要保留它们，编译器就不会因此发出警告。
>
> `#[derive(Debug,PartialEq)]` 是一个派生（derive）属性，用于自动实现 `Debug` 和 `PartialEq` 这两个 trait。`Debug` trait 使得你可以打印出结构体或枚举的值，这对于调试非常有用。`PartialEq` trait 则允许你对两个相同类型的值进行比较，看它们是否相等。通过使用 `#[derive(Debug,PartialEq)]`，你可以让 Rust 自动为你的结构体或枚举实现这两个 trait，而不需要你手动实现它们。

































