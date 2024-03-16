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




























