---
name: 《RustCourse》学习笔记（11）
title: 《RustCourse》学习笔记（11）
tags: ["技术","学习笔记","RustCourse"]
categories: 学习笔记
info: "第2章 Rust基本概念 2.11 返回值和错误处理"
time: 2024/3/30
desc: 'RustCourse, 学习笔记'
keywords: ['RustCourse', '学习笔记', 'rust']
---

# 《RustCourse》学习笔记（11）

## 第2章 Rust基本概念

### 2.11 返回值和错误处理

> https://course.rs/basic/result-error/intro.html

Rust 中的错误主要分为两类：

- **可恢复错误**，通常用于从系统全局角度来看可以接受的错误，例如处理用户的访问、操作等错误，这些错误只会影响某个用户自身的操作进程，而不会对系统的全局稳定性产生影响
- **不可恢复错误**，刚好相反，该错误通常是全局性或者系统性的错误，例如数组越界访问，系统启动时发生了影响启动流程的错误等等，这些错误的影响往往对于系统来说是致命的

很多编程语言，并不会区分这些错误，而是直接采用异常的方式去处理。Rust 没有异常，但是 Rust 也有自己的卧龙凤雏：`Result<T, E>` 用于可恢复错误，`panic!` 用于不可恢复错误。

#### 2.11.1 panic 深入剖析

> https://course.rs/basic/result-error/panic.html

对于严重到影响程序运行的错误，比如数组访问越界，触发 `panic` 是很好的解决方式。在 Rust 中触发 `panic` 有两种方式：被动触发和主动调用.

- 被动触发，如数组的越界访问

- 主动调用，开发者主动抛出一个异常，可以使用`panic!`来做到

  ```rust
  fn main() {
      panic!("crash and burn");
  }
  /*
  thread 'main' panicked at 'crash and burn', src/main.rs:2:5
  note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
  
  	以上信息包含了两条重要信息：
  
    main 函数所在的线程崩溃了，发生的代码位置是 src/main.rs 中的第 2 行第 5 个字符（包含该行前面的空字符）
    在使用时加上一个环境变量可以获取更详细的栈展开信息：
    Linux/macOS 等 UNIX 系统： RUST_BACKTRACE=1 cargo run
    Windows 系统（PowerShell）： $env:RUST_BACKTRACE=1 ; cargo run
  */
  ```

  > 切记，一定是不可恢复的错误，才调用 `panic!` 处理，你总不想系统仅仅因为用户随便传入一个非法参数就崩溃吧？所以，**只有当你不知道该如何处理时，再去调用 panic!**.

##### 2.11.1.1 backtrace 栈展开

在真实场景中，错误往往涉及到很长的调用链甚至会深入第三方库，如果没有栈展开技术，错误将难以跟踪处理。在发生错误时，使用如下命令润兴程序就能捕获到出错的详细调用栈：

```shell
RUST_BACKTRACE=1 cargo run
# or
$env:RUST_BACKTRACE=1 ; cargo run
```

要获取到栈回溯信息，你还需要开启 `debug` 标志，该标志在使用 `cargo run` 或者 `cargo build` 时自动开启（这两个操作默认是 `Debug` 运行方式）。同时，栈展开信息在不同操作系统或者 Rust 版本上也有所不同。

##### 2.11.1.2 panic 时的两种终止方式

当出现 `panic!` 时，程序提供了两种方式来处理终止流程：**栈展开**和**直接终止**。

默认的方式是栈展开。这意味着 Rust 会回溯栈上的数据和函数调用。而直接终止则是不清理数据就直接退出。

当你关心最终编译出的二进制文件可执行文件的大小时，可以尝试使用直接终止的方式。

修改`Cargo.toml`文件即可实现在 release 模式下遇到 `panic` 直接终止：

```rust
[profile.release]
panic = 'abort'
```

线程 panic 后，如果是 main 线程，程序会直接终止。如果是其它子线程，该线程会终止，但是不会影响 main 线程。

##### 2.11.1.3 何时该使用 panic!

- 不想处理错误的时候，直接使用`upwrap`或`expect`来对 Result 类型进行解析拿到Ok里的值，如果拿不到就直接 panic，程序中断

  ```rust
  enum Result<T, E> {
      Ok(T),
      Err(E),
  }
  
  use std::net::IpAddr;
  let home: IpAddr = "127.0.0.1".parse().unwrap();
  ```

  因此 `unwrap` 简而言之：成功则返回值，失败则 `panic`，总之不进行任何错误处理。

  > 示例、原型、测试的这几个场景下，需要快速地搭建代码，错误处理会拖慢编码的速度，也不是特别有必要，因此通过 `unwrap`、`expect` 等方法来处理是最快的。
  >
  > 同时，当我们回头准备做错误处理时，可以全局搜索这些方法，不遗漏地进行替换。

- 可能导致全局有害状态时

  例如解析器接收到格式错误的数据，与其让它继续执行下去，还不如直接让程序报错，然后退出，这样在 debug 的时候定位反而能更准确。

##### 2.11.1.4 panic 原理剖析

`panic!`是一个宏，当调用它时，会做这些事情：

1. 格式化错误信息，然后将该信息作为参数调用`std::panic::panic_any()`函数
2. 触发 panic hook
3. 将当前线程进行栈展开，回溯整个栈
4. 一旦线程展开被终止或者完成，最终将输出结果，对于 main 线程，将调用操作系统的终止能力`core::intrinsics::abort()`，如果是子线程，则会在简单的终止过后将信息通过`std::thread::join`来收集

#### 2.11.2 返回值 Result 和 ?

> https://course.rs/basic/result-error/result.html

`Result<T, E>` 是一个枚举类型：

```typescript
enum Result<T, E> {
  Ok(T),
    Err(E),
}
```

泛型参数 `T` 代表成功时存入的正确值的类型，存放方式是 `Ok(T)`，`E` 代表错误时存入的错误值，存放方式是 `Err(E)`。

使用匹配可以对 Result 枚举对应的类型进行取值和处理：

```rust
use std::fs::File;

fn main() {
  let f = File::open("hello.txt");
  /**
  如果是成功，则将 Ok(file) 中存放的的文件句柄 file 赋值给 f，如果失败，则将 Err(error) 中存放的错误信息 error 使用 panic 抛出来，进而结束程序，这非常符合上文提到过的 panic 使用场景。
  */
  let f = match f {
    Ok(file) => file,
    Err(error) => {
      panic!("Problem opening the file: {:?}", error)
    },
  };
}
```

##### 2.11.2.1 对返回的错误进行处理

```rust
use std::fs::File;
use std::io::ErrorKind;

fn main() {
  let f = File::open("hello.txt");

  let f = match f {
    Ok(file) => file,
    Err(error) => match error.kind() {
      ErrorKind::NotFound => match File::create("hello.txt") {
        Ok(fc) => fc,
        Err(e) => panic!("Problem creating the file: {:?}", e),
      },
      other_error => panic!("Problem opening the file: {:?}", other_error),
    },
  };
}
```

上面代码在匹配出 `error` 后，又对 `error` 进行了详细的匹配解析，对其中的一些错误进行处理，另一些错误一律`panic`

##### 2.11.2.2 失败就 panic: upwrap 和 expect

在不需要处理错误的场景，可以使用`upwrap`和`expect`这两个 api，如果无法解析成功，程序就会直接崩溃。

`expect`相比`unwrap`能提供更精确的错误消息，虽然直接崩溃，但是会带上自定义的错误提示信息，相当于重载了错误打印的函数。

```rust
use std::fs::File;

fn main() {
    let f = File::open("hello.txt").unwrap();
}

// or

use std::fs::File;

fn main() {
    let f = File::open("hello.txt").expect("Failed to open hello.txt");
}
```

##### 2.11.2.3 传播错误

当函数嵌套调用时，可能需要将错误向外抛出，给外部处理。

```rust
use std::fs::File;
use std::io::{self, Read};

fn read_username_from_file() -> Result<String, io::Error> {
  // 打开文件，f是`Result<文件句柄,io::Error>`
  let f = File::open("hello.txt");

  let mut f = match f {
    // 打开文件成功，将file句柄赋值给f
    Ok(file) => file,
    // 打开文件失败，将错误返回(向上传播)
    Err(e) => return Err(e),
  };
  // 创建动态字符串s
  let mut s = String::new();
  // 从f文件句柄读取数据并写入s中
  match f.read_to_string(&mut s) {
    // 读取成功，返回Ok封装的字符串
    Ok(_) => Ok(s),
    // 将错误向上传播
    Err(e) => Err(e),
  }
}
```

##### 2.11.2.4 ? 宏函数

上面的代码可以用`?`宏操作符进行简化，`?`宏操作符在遇到错误时，会立即让当前的函数 return 该错误：

```rust
use std::fs::File;
use std::io;
use std::io::Read;

fn read_username_from_file() -> Result<String, io::Error> {
    let mut f = File::open("hello.txt")?;
    let mut s = String::new();
    f.read_to_string(&mut s)?;
    Ok(s)
}
```

`?`宏操作符还能实现链式调用，遇到错误就返回，没有错误就将 Ok 中的值取出来用于下一个方法的调用。

```rust
use std::fs::File;
use std::io;
use std::io::Read;

fn read_username_from_file() -> Result<String, io::Error> {
    let mut s = String::new();

    File::open("hello.txt")?.read_to_string(&mut s)?;

    Ok(s)
}
```

> 上面代码中 `File::open` 报错时返回的错误是 `std::io::Error` 类型，但是 `open_file` 函数返回的错误类型是 `std::error::Error` 的特征对象，可以看到一个错误类型通过 `?` 返回后，变成了另一个错误类型，这就是 `?` 的神奇之处。
>
> 根本原因是在于标准库中定义的 `From` 特征，该特征有一个方法 `from`，用于把一个类型转成另外一个类型，`?` 可以自动调用该方法，然后进行隐式类型转换。**因此只要函数返回的错误 `ReturnError` 实现了 `From<OtherError>` 特征，那么 `?` 就会自动把 `OtherError` 转换为 `ReturnError`**。
>
> 这种转换非常好用，意味着你可以用一个大而全的 `ReturnError` 来覆盖所有错误类型，只需要为各种子错误类型实现这种转换即可。

上面的代码还能进一步简化，但是跟错误处理就没什么关系了：

```rust
use std::fs;
use std::io;

fn read_username_from_file() -> Result<String, io::Error> {
    // read_to_string是定义在std::io中的方法，因此需要在上面进行引用
    fs::read_to_string("hello.txt")
}
```

此外，`?`还能用于进行 Option 的返回：

```rust
pub enum Option<T> {
  Some(T),
  None
}
fn first(arr: &[i32]) -> Option<&i32> {
  let v = arr.get(0)?;
  Some(v)
}
```

`?`操作符需要一个变量来承载正确的值，且只有错误的值能直接返回，正确的值不行，因此无法直接进行返回一个 Option，只能返回 Some 或者 None 类型，所以下面的代码会报错：

```rust
fn first(arr: &[i32]) -> Option<&i32> {
   arr.get(0)?
}
```

**带返回值的 main 函数**

正常来说 main 函数逇返回是`()`，如果在 main 函数中使用`?`，很容易会无法编译。

```rust
use std::fs::File;

fn main() {
    let f = File::open("hello.txt")?;
}

/*
$ cargo run
   ...
   the `?` operator can only be used in a function that returns `Result` or `Option` (or another type that implements `FromResidual`)
 --> src/main.rs:4:48
  |
3 | fn main() {
  | --------- this function should return `Result` or `Option` to accept `?`
4 |     let greeting_file = File::open("hello.txt")?;
  |                                                ^ cannot use the `?` operator in a function that returns `()`
  |
  = help: the trait `FromResidual<Result<Infallible, std::io::Error>>` is not implemented for `()`

*/
```

要解决这个问题，需要用 Rust 另一种形式的 main 函数：

```rust
use std::error::Error;
use std::fs::File;

fn main() -> Result<(), Box<dyn Error>> {
    let f = File::open("hello.txt")?;

    Ok(())
}
```

> 这样就能使用 `?` 提前返回了，同时我们又一次看到了`Box<dyn Error>` 特征对象，因为 `std::error:Error` 是 Rust 中抽象层次最高的错误，其它标准库中的错误都实现了该特征，因此我们可以用该特征对象代表一切错误，就算 `main` 函数中调用任何标准库函数发生错误，都可以通过 `Box<dyn Error>` 这个特征对象进行返回。
>
> 至于 `main` 函数可以有多种返回值，那是因为实现了 [std::process::Termination](https://doc.rust-lang.org/std/process/trait.Termination.html) 特征，目前为止该特征还没进入稳定版 Rust 中，也许未来你可以为自己的类型实现该特征！

##### 2.11.2.5 try!

在 Rust 1.13 的版本之前并没有`?`宏函数，一般使用`try!`宏来处理错误：

```rust
macro_rules! try {
    ($e:expr) => (match $e {
        Ok(val) => val,
        Err(err) => return Err(::std::convert::From::from(err)),
    });
}
```

与`?`的使用对比：

```rust
//  `?`
let x = function_with_error()?; // 若返回 Err, 则立刻返回；若返回 Ok(255)，则将 x 的值设置为 255

// `try!()`
let x = try!(function_with_error());
```

相比起来，`?`的使用显然更加方便，还可以做链式调用。


