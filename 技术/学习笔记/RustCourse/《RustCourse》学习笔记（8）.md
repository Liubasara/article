---
name: 《RustCourse》学习笔记（8）
title: 《RustCourse》学习笔记（8）
tags: ["技术","学习笔记","RustCourse"]
categories: 学习笔记
info: "第2章 Rust基本概念 2.7 方法 Method 2.8 泛型和特征 2.8.3 特征对象"
time: 2024/3/9
desc: 'RustCourse, 学习笔记'
keywords: ['RustCourse', '学习笔记', 'rust']
---

# 《RustCourse》学习笔记（8）

## 第2章 Rust基本概念

### 2.8 泛型和特征

#### 2.8.3 特征对象

> https://course.rs/basic/trait/trait-object.html

特征对象相比于会为每一种可能生成一份代码的传统泛型（静态分发），更多用于**确实没办法确认传入参数的具体类型，而只知道它实现了某些接口的情况**。由于 Rust 需要函数返回一个确认的类型，因此在这种情况下，只能使用动态分发来为这些接口生成一个通用的类型来兼容。

```typescript
trait Draw {
    fn draw(&self) -> String;
}

impl Draw for u8 {
    fn draw(&self) -> String {
        format!("u8: {}", *self)
    }
}

impl Draw for f64 {
    fn draw(&self) -> String {
        format!("f64: {}", *self)
    }
}

// 若 T 实现了 Draw 特征， 则调用该函数时传入的 Box<T> 可以被隐式转换成函数参数签名中的 Box<dyn Draw>
fn draw1(x: Box<dyn Draw>) {
    // 由于实现了 Deref 特征，Box 智能指针会自动解引用为它所包裹的值，然后调用该值对应的类型上定义的 `draw` 方法
    x.draw();
}

fn draw2(x: &dyn Draw) {
    x.draw();
}

fn main() {
    let x = 1.1f64;
    // do_something(&x);
    let y = 8u8;

    // x 和 y 的类型 T 都实现了 `Draw` 特征，因为 Box<T> 可以在函数调用时隐式地被转换为特征对象 Box<dyn Draw> 
    // 基于 x 的值创建一个 Box<f64> 类型的智能指针，指针指向的数据被放置在了堆上
    draw1(Box::new(x));
    // 基于 y 的值创建一个 Box<u8> 类型的智能指针
    draw1(Box::new(y));
    draw2(&x);
    draw2(&y);
}
```

> 在动态类型语言中，有一个很重要的概念：**鸭子类型**(*duck typing*)，简单来说，就是只关心值长啥样，而不关心它实际是什么。当一个东西走起来像鸭子，叫起来像鸭子，那么它就是一只鸭子，就算它实际上是一个奥特曼，也不重要，我们就当它是鸭子。

> `Box<T>` 在后面章节会[详细讲解](https://course.rs/advance/smart-pointer/box.html)，大家现在把它当成一个引用即可，只不过它包裹的值会被强制分配在堆上。

##### 2.8.3.1 特征对象的动态分发

动态分发的本质是使用了两个指针。一个指针`ptr`指向了细线了特征的具体类型的实例，而另一个指针`vptr`指向一个虚表`vtalbe`，这个表中保存了不同类中关于这个特征中的方法的实现。在使用时，就可以根据传入的类型，从表中找到对应的实现进行调用。

> **也就是说，`btn` 是哪个特征对象的实例，它的 `vtable` 中就包含了该特征的方法。**

##### 2.8.3.2 Self 与 self

在 Rust 中有两个`self`，一个指代当前的实例对象，一个指代特征或者方法类型的别名。

```rust
trait Draw {
    fn draw(&self) -> Self;
}

#[derive(Clone)]
struct Button;
impl Draw for Button {
    fn draw(&self) -> Self {
        return self.clone()
    }
}

fn main() {
    let button = Button;
    let newb = button.draw();
}
```

##### 2.8.3.3 特征对象的限制

不是所有特征都能拥有特征对象，只有“对象安全”的特征才可以。

当一个特征的所有方法都满足这些条件，它的对象才是安全的：

- 方法的返回类型不能是`Self`（因为当函数使用特征对象的时候，意味着它会忘记真正的类型，那这个时候就没有人知道这个 Self 代表哪个具体的类了）
- 方法没有任何泛型参数。（当使用特征对象的时候，意味着传入的参数跟泛型没有任何关系，而是特征对象的一部分，所以也无法得知放入的泛型参数类型是什么）

比如说上面的 Clone 方法，其实就是违反了特征对象安全规则的，如果违反了对象安全的规则，编译器会提示你：

```rust
pub struct Screen {
    pub components: Vec<Box<dyn Clone>>,
}
```

```txt
error[E0038]: the trait `std::clone::Clone` cannot be made into an object
 --> src/lib.rs:2:5
  |
2 |     pub components: Vec<Box<dyn Clone>>,
  |     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ the trait `std::clone::Clone`
  cannot be made into an object
  |
  = note: the trait cannot require that `Self : Sized`
```

#### 2.8.4 进一步深入了解特征

##### 2.8.4.1 关联类型

在特征中，`Self`用来指代当前调用者的具体类型，那么`Self::Item`就用来指代该类型实现中定义的`Item`类型，这就是关联类型。

```rust
trait Container{
    type A;
    type B;
    fn contains(&self, a: &Self::A, b: &Self::B) -> bool;
}

fn difference<C: Container>(container: &C) {}
```

同样的代码如果要使用泛型来实现，将要麻烦的多（个人理解：为了要实现 Container，连带着其他方法都要把 Container 的参数都定义一遍）：

```rust
trait Container<A,B> {
    fn contains(&self,a: A,b: B) -> bool;
}

fn difference<A,B,C>(container: &C) -> i32
  where
    C : Container<A,B> {...}
```

##### 2.8.4.2 默认泛型类型参数

当使用泛型类型参数时，可以为其指定一个默认的具体类型。

例如标准库中的 `std::ops::Add` 特征：

```rust
trait Add<RHS=Self> {
  type Output;
  fn add(self, rhs: RHS) -> Self::Output;
}
```

> 默认类型参数主要用于两个方面：
>
> 1. 减少实现的样板代码
> 2. 扩展类型但是无需大幅修改现有的代码

##### 2.8.4.3 调用同名的方法

```rust
trait Pilot {
    fn fly(&self);
}

trait Wizard {
    fn fly(&self);
}

struct Human;

impl Pilot for Human {
    fn fly(&self) {
        println!("This is your captain speaking.");
    }
}

impl Wizard for Human {
    fn fly(&self) {
        println!("Up!");
    }
}

impl Human {
    fn fly(&self) {
        println!("*waving arms furiously*");
    }
}
```

当两个特征，或者两个类型上有同名方法的时候，遵循以下优先级：

- 优先调用类型上的方法

- 特征上的方法需要显式调用

  ```rust
  fn main() {
      let person = Human;
      Pilot::fly(&person); // 调用Pilot特征上的方法
      Wizard::fly(&person); // 调用Wizard特征上的方法
      person.fly(); // 调用Human类型自身的方法
  }
  
  /*
  
  This is your captain speaking.
  Up!
  *waving arms furiously*
  
  */
  ```

- 如果是没有`&self`参数的同名方法，即[关联函数](https://course.rs/basic/method.html#关联函数)，则需要使用**完全限定语法**，这是调用函数最明确的方式。

  ```rust
  <Type as Trait>::function(receiver_if_method, next_arg, ...);
  ```

  > 完全限定语法可以用于任何函数或方法调用，那么我们为何很少用到这个语法？原因是 Rust 编译器能根据上下文自动推导出调用的路径，因此大多数时候，我们都无需使用完全限定语法。只有当存在多个同名函数或方法，且 Rust 无法区分出你想调用的目标函数时，该用法才能真正有用武之地。

##### 2.8.4.4 特征定义中的特征约束

如果需要让某个特征 A 在实现了特征 B 以后才能够被使用的话（类似于类型约束），可以这样写：

```rust
use std::fmt::Display;

trait OutlinePrint: Display {
    fn outline_print(&self) {
        let output = self.to_string();
        let len = output.len();
        println!("{}", "*".repeat(len + 4));
        println!("*{}*", " ".repeat(len + 2));
        println!("* {} *", output);
        println!("*{}*", " ".repeat(len + 2));
        println!("{}", "*".repeat(len + 4));
    }
}
```

上面的定义中，如果有类型要`impl`OutlinePrint 这个特征，就必须先实现`Display`特征，否则会报错。

```rust
use std::fmt;

// 前置条件
impl fmt::Display for Point {
  fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
    write!(f, "({}, {})", self.x, self.y)
  }
}

struct Point {
  x: i32,
  y: i32,
}

impl OutlinePrint for Point {}
```

##### 2.8.4.5 在外部类型上实现外部特征（newtype）

Rust 中的孤儿规则：特征或者类型必须至少有一个是本地的，才能在此类型上定义特征。

但是，可以通过定义一个外部类型（Wrapper），将所要定义的特征包裹住，然后为这个外部类型实现特征，从而绕过这个孤儿原则。

例如：

```rust
use std::fmt;

struct Wrapper(Vec<String>);

impl fmt::Display for Wrapper {
  fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
    write!(f, "[{}]", self.0.join(", "))
  }
}

fn main() {
  let w = Wrapper(vec![String::from("hello"), String::from("world")]);
  println!("w = {}", w);
}
```

其中，`struct Wrapper(Vec<String>)` 是一个元组结构体，它定义了一个新类型 `Wrapper`，将需要实现新特征的类型包裹住了。

> 既然 `new type` 有这么多好处，它有没有不好的地方呢？答案是肯定的。注意到我们怎么访问里面的数组吗？`self.0.join(", ")`，是的，很啰嗦，因为需要先从 `Wrapper` 中取出数组: `self.0`，然后才能执行 `join` 方法。
>
> 类似的，任何数组上的方法，你都无法直接调用，需要先用 `self.0` 取出数组，然后再进行调用。
>
> 当然，解决办法还是有的，要不怎么说 Rust 是极其强大灵活的编程语言！Rust 提供了一个特征叫 [`Deref`](https://course.rs/advance/smart-pointer/deref.html)，实现该特征后，可以自动做一层类似类型转换的操作，可以将 `Wrapper` 变成 `Vec<String>` 来使用。这样就会像直接使用数组那样去使用 `Wrapper`，而无需为每一个操作都添加上 `self.0`。
>
> 同时，如果不想 `Wrapper` 暴露底层数组的所有方法，我们还可以为 `Wrapper` 去重载这些方法，实现隐藏的目的。


























