---
name: 《RustCourse》学习笔记（10）
title: 《RustCourse》学习笔记（10）
tags: ["技术","学习笔记","RustCourse"]
categories: 学习笔记
info: "第2章 Rust基本概念 2.10 KV 存储 HashMap 2.10 认识生命周期"
time: 2024/3/26
desc: 'RustCourse, 学习笔记'
keywords: ['RustCourse', '学习笔记', 'rust']
---

# 《RustCourse》学习笔记（10）

## 第2章 Rust基本概念

### 2.10 KV 存储 HashMap

> https://course.rs/basic/collections/hashmap.html

Rust 中哈希类型为`HashMap<K, V>`。

跟其它集合类型一致，`HashMap` 也是内聚性的，即所有的 `K` 必须拥有同样的类型，`V` 也是如此。

#### 2.10.1 使用 new 新建 HashMap

```rust
use std::collections::HashMap;

// 创建一个HashMap，用于存储宝石种类和对应的数量
let mut my_gems = HashMap::new();

// 将宝石类型和对应的数量写入表中
my_gems.insert("红宝石", 1);
my_gems.insert("蓝宝石", 2);
my_gems.insert("河边捡的误以为是宝石的破石头", 18);
```

> 跟 `Vec` 一样，如果预先知道要存储的 `KV` 对个数，可以使用 `HashMap::with_capacity(capacity)` 创建指定大小的 `HashMap`，避免频繁的内存分配和拷贝，提升性能。

##### 2.10.2 使用迭代器和 collect 方法创建

如何将`Vec`快速写入到`HashMap`中？一个笨方法是用循环手动塞进去：

```rust
fn main() {
    use std::collections::HashMap;

    let teams_list = vec![
        ("中国队".to_string(), 100),
        ("美国队".to_string(), 10),
        ("日本队".to_string(), 50),
    ];

    let mut teams_map = HashMap::new();
    for team in &teams_list {
        teams_map.insert(&team.0, team.1);
    }

    println!("{:?}",teams_map)
}
```

而聪明的方法是：先将 `Vec` 转为迭代器，接着通过 `collect` 方法，将迭代器中的元素收集后，转成 `HashMap`。

```rust
fn main() {
    use std::collections::HashMap;

    let teams_list = vec![
        ("中国队".to_string(), 100),
        ("美国队".to_string(), 10),
        ("日本队".to_string(), 50),
    ];

    let teams_map: HashMap<_,_> = teams_list.into_iter().collect();
    
    println!("{:?}",teams_map)
}
```

> 代码很简单，`into_iter` 方法将列表转为迭代器，接着通过 `collect` 进行收集，不过需要注意的是，`collect` 方法在内部实际上支持生成多种类型的目标集合，因此我们需要通过类型标注 `HashMap<_,_>` 来告诉编译器：请帮我们收集为 `HashMap` 集合类型，具体的 `KV` 类型，麻烦编译器您老人家帮我们推导。

如果不指定类型，Rust 编译器会报错：

```txt
error[E0282]: type annotations needed // 需要类型标注
  --> src/main.rs:10:9
   |
10 |     let teams_map = teams_list.into_iter().collect();
   |         ^^^^^^^^^ consider giving `teams_map` a type // 给予 `teams_map` 一个具体的类型
```

##### 2.10.3 所有权转移

所有权规则跟其它的类型一样：

- 如果类型实现了`Copy`特征，给类型会被复制进`HashMap`，因此无所谓所有权
- 若没实现`Copy`特征，所有权被转移给`HashMap`中

如果将引用类型放入到 HashMap 中，则需要确保该引用的生命周期至少跟 HashMap 活得一样久。

##### 2.10.4 查询/更新 HashMap

通过`get`方法获取元素：

```rust
use std::collections::HashMap;

let mut scores = HashMap::new();

scores.insert(String::from("Blue"), 10);
scores.insert(String::from("Yellow"), 50);

let team_name = String::from("Blue");
let score: Option<&i32> = scores.get(&team_name);
```

如果 get 方法获取不到，会返回 None。如果不使用借用`&32`，可能会发生所有权的转移。



使用如下方法进行值的更新：

```rust
fn main() {
    use std::collections::HashMap;

    let mut scores = HashMap::new();

    scores.insert("Blue", 10);

    // 覆盖已有的值
    let old = scores.insert("Blue", 20);
    assert_eq!(old, Some(10));

    // 查询新插入的值
    let new = scores.get("Blue");
    assert_eq!(new, Some(&20));

    // 查询Yellow对应的值，若不存在则插入新值
    let v = scores.entry("Yellow").or_insert(5);
    assert_eq!(*v, 5); // 不存在，插入5

    // 查询Yellow对应的值，若不存在则插入新值
    let v = scores.entry("Yellow").or_insert(50);
    assert_eq!(*v, 5); // 已经存在，因此50没有插入
  
  let text = "hello world wonderful world";

  let mut map = HashMap::new();
  // 根据空格来切分字符串(英文单词都是通过空格切分)
  for word in text.split_whitespace() {
      let count = map.entry(word).or_insert(0);
      *count += 1;
  }

  println!("{:?}", map);
}
```

> 有两点值得注意：
>
> - `or_insert` 返回了 `&mut v` 引用，因此可以通过该可变引用直接修改 `map` 中对应的值
> - 使用 `count` 引用时，需要先进行解引用 `*count`，否则会出现类型不匹配

##### 2.10.5 哈希函数

一个类型能否作为`key`的关键就是能否进行相等比较，或者说该类型是否实现了`std::cmp::Eq`特征。换言之，就是使用一个密码学函数对不同的`key`进行加密后生成不同的结果。

> f32 和 f64 浮点数，没有实现 `std::cmp::Eq` 特征，因此不可以用作 `HashMap` 的 `Key`。

##### 2.10.6 高性能三方库

如果性能测试显示当前默认的哈希函数不能满足性能需求，则需要去`Crates.io`上去寻找其他的哈希函数实现：

```rust
use std::hash::BuildHasherDefault;
use std::collections::HashMap;
// 引入第三方的哈希函数
use twox_hash::XxHash64;

// 指定HashMap使用第三方的哈希函数XxHash64
let mut hash: HashMap<_, _, BuildHasherDefault<XxHash64>> = Default::default();
hash.insert(42, "the answer");
assert_eq!(hash.get(&42), Some(&"the answer"));
```

> 目前，`HashMap` 使用的哈希函数是 `SipHash`，它的性能不是很高，但是安全性很高。`SipHash` 在中等大小的 `Key` 上，性能相当不错，但是对于小型的 `Key` （例如整数）或者大型 `Key` （例如字符串）来说，性能还是不够好。若你需要极致性能，例如实现算法，可以考虑这个库：[ahash](https://github.com/tkaitchuck/ahash)。
>
> PS：不过安全性和准确性就没有那么好了。（即可能会出现哈希冲突）

### 2.10 认识生命周期

> https://course.rs/basic/lifetime.html

生命周期，简而言之就是引用的有效作用域，在很多时候，编译器可以自动推导变量的生命周期。但是当多个生命周期或者多种类型存在时，往往就需要我们手动标明生命周期。

#### 2.10.1 悬垂指针和生命周期

生命周期的主要作用是避免程序引用不该引用的数据，也就是避免悬垂引用。

```rust
{
  let r;

  {
    let x = 5;
    r = &x;
  }

  println!("r: {}", r);
}
```

上面这段代码的变量`r`就是悬垂指针，引用了提前被释放的变量`x`。当`x`被释放后，`r`所引用的值就不再是合法的，所以编译器会直接报错：

```txt
error[E0597]: `x` does not live long enough // `x` 活得不够久
  --> src/main.rs:7:17
   |
7  |             r = &x;
   |                 ^^ borrowed value does not live long enough // 被借用的 `x` 活得不够久
8  |         }
   |         - `x` dropped here while still borrowed // `x` 在这里被丢弃，但是它依然还在被借用
9  |
10 |         println!("r: {}", r);
   |                           - borrow later used here // 对 `x` 的借用在此处被使用
```

#### 2.10.2 借用检查

Rust 使用借用检查来保证所有权和借用的准确性。

```rust
{
    let r;                // ---------+-- 'a
                          //          |
    {                     //          |
        let x = 5;        // -+-- 'b  |
        r = &x;           //  |       |
    }                     // -+       |
                          //          |
    println!("r: {}", r); //          |
}                         // ---------+

```

上图可以看出，b 的生命周期比 a 要短，编译器就会认为该程序存在风险。

想要编译通过，就要确保`'b`生命周期比`'a`活得久。只有这样才能让变量 r 引用 x 而不存在风险。

```rust
{
    let x = 5;            // ----------+-- 'b
                          //           |
    let r = &x;           // --+-- 'a  |
                          //   |       |
    println!("r: {}", r); //   |       |
                          // --+       |
}  
```

#### 2.10.3 函数中的生命周期

如下例子，返回字符串切片中较长的那个：

```rust
fn main() {
  let string1 = String::from("abcd");
  let string2 = "xyz";

  let result = longest(string1.as_str(), string2);
  println!("The longest string is {}", result);
}

fn longest(x: &str, y: &str) -> &str {
  if x.len() > y.len() {
    x
  } else {
    y
  }
}
```

这段代码会报错：

```txt
error[E0106]: missing lifetime specifier
 --> src/main.rs:9:33
  |
9 | fn longest(x: &str, y: &str) -> &str {
  |               ----     ----     ^ expected named lifetime parameter // 参数需要一个生命周期
  |
  = help: this function's return type contains a borrowed value, but the signature does not say whether it is
  borrowed from `x` or `y`
  = 帮助： 该函数的返回值是一个引用类型，但是函数签名无法说明，该引用是借用自 `x` 还是 `y`
help: consider introducing a named lifetime parameter // 考虑引入一个生命周期
  |
9 | fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
  |           ^^^^    ^^^^^^^     ^^^^^^^     ^^^
```

这是因为编译器无法知道该函数的返回值到底是引用`x`还是`y`，从而无法自动推断出函数返回的生命周期。此时就需要人为去标注生命周期。

```rust
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
  if x.len() > y.len() {
    x
  } else {
    y
  }
}
```

#### 2.10.4 生命周期标注语法

生命周期的语法也颇为与众不同，以 `'` 开头，名称往往是一个单独的小写字母，大多数人都用 `'a` 来作为生命周期的名称。 如果是引用类型的参数，那么生命周期会位于引用符号 `&` 之后，并用一个空格来将生命周期和引用参数分隔开:

```rust
&i32        // 一个引用
&'a i32     // 具有显式生命周期的引用
&'a mut i32 // 具有显式生命周期的可变引用
```

一个生命周期标注，它自身并不具有什么意义，因为生命周期的作用就是告诉编译器多个引用之间的关系。例如，有一个函数，它的第一个参数 `first` 是一个指向 `i32` 类型的引用，具有生命周期 `'a`，该函数还有另一个参数 `second`，它也是指向 `i32` 类型的引用，并且同样具有生命周期 `'a`。此处生命周期标注仅仅说明，**这两个参数 `first` 和 `second` 至少活得和'a 一样久，至于到底活多久或者哪个活得更久，抱歉我们都无法得知**：

```rust
fn useless<'a>(first: &'a i32, second: &'a i32) {}
```

##### 2.10.4.1 函数签名中的生命周期标注

和泛型一样，使用生命周期参数，需要先声明 `<'a>`。

实际上，**这意味着返回值的生命周期与参数生命周期中的较小值一致**：虽然两个参数的生命周期都是标注了 `'a`，但是实际上这两个参数的真实生命周期可能是不一样的(生命周期 `'a` 不代表生命周期等于 `'a`，而是大于等于 `'a`)。

**我们并没有改变传入引用或者返回引用的真实生命周期，而是告诉编译器当不满足此约束条件时，就拒绝编译通过**

##### 2.10.4.2 深入思考生命周期标注

**函数的返回值如果是一个引用类型，那么它的生命周期只会来源于**：

- 函数参数的生命周期
- 函数体中某个新建引用的生命周期

如果是第二种情况，在函数的结束后，如果对该引用仍在继续，在这种情况下，就会出现`悬垂引用`的情况。而 Rust 通过报错，让这种情况不会通过编译。

所以遇到这种情况，最好的办法就是返回内部引用的所有权，把所有权转移给调用者：

```rust
// 会报错：result.as_str() 是引用，无法确定生命周期
fn longest<'a>(x: &str, y: &str) -> &'a str {
    let result = String::from("really long string");
    result.as_str()
}
```

```rust
// 不报错，把所有权转移给调用者
fn longest<'a>(_x: &str, _y: &str) -> String {
  String::from("really long string")
}

fn main() {
  let s = longest("not", "important");
}
```

> 至此，可以对生命周期进行下总结：生命周期语法用来将函数的多个引用参数和返回值的作用域关联到一起，一旦关联到一起后，Rust 就拥有充分的信息来确保我们的操作是内存安全的。

#### 2.10.5 结构体中的生命周期

之前为什么不在结构体中使用字符串字面量或者字符串切片，而是统一使用 `String` 类型？原因很简单，后者在结构体初始化时，只要转移所有权即可，而**前者则只是引用，需要标注生命周期**。

```rust
struct ImportantExcerpt<'a> {
    part: &'a str,
}

fn main() {
    let novel = String::from("Call me Ishmael. Some years ago...");
    let first_sentence = novel.split('.').next().expect("Could not find a '.'");
    let i = ImportantExcerpt {
        part: first_sentence,
    };
}
```











