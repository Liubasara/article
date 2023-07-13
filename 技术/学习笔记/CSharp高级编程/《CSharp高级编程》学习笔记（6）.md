---
name: 《C#高级编程》学习笔记（6）
title: 《C#高级编程》学习笔记（6）
tags: ["技术","学习笔记","C#高级编程"]
categories: 学习笔记
info: "C#高级编程  第6章 运算符和类型强制转换"
time: 2023/7/12
desc: 'C#高级编程, 学习笔记, 第6章 运算符和类型强制转换'
keywords: ['学习笔记', 'C#', 'C#高级编程', '第6章 运算符和类型强制转换']

---

#  《C#高级编程》学习笔记（6）

## 第6章 运算符和类型强制转换

### 6.1 运算符和类型转换

本章将讨论运算符的内容，后面还会讨论运算符的重载，以及如何使用运算符实现定制的功能。

### 6.2 运算符

![6-1.png](./images/6-1.png)

![6-2.png](./images/6-2.png)

![6-3.png](./images/6-3.png)

#### 6.2.1-1 checked 和 unchecked 运算符

byte 数据类型只能包含 0~255 的数，对于超过 255 的二进制数，如果再往上递增，则会导致溢出，得到 0。

为此 C# 提供了 checked 和 unchecked 运算符，如果把一个代码块标记为 checked，编译器会执行溢出检查，如果发现溢出，就抛出 OverflowException 异常。如下：

```csharp
byte b = 255;
checked
{
  b++;
}
Console.WriteLine(b);
```

![6-4.png](./images/6-4.png)

反之如果要禁止溢出检查，则可以把代码标记为 unchecked：

```csharp
byte b = 255;
unchecked
{
  b++;
}
Console.WriteLine(b); // b 的值是 0
```

![6-5.png](./images/6-5.png)

#### 6.2.1-2 is 运算符

is 运算符可以检查对象是否与特定的类型兼容。如下：

```csharp
// 检查变量是否与 object 类型兼容
int i = 10;
if (i is object)
{
  Console.WriteLine("i is an object");
}
// C# 7 以后，is 可以用来检查常量，类型和 var
if (i is 42)
{
  Console.WriteLine("i has the value 42");
}
if (i is null)
{
  Console.WriteLine("i has the value null");
}

// 可以在类型的右边声明变量，如果 is 运算符返回 true，则该变量通过对该类型的对象引用来填充
// 然后可以在这个 if 块语句范围内使用该变量
public class Person
{
  string word;
}
if (i is Person p)
{
   Console.WriteLine(p.word);
}
```

#### 6.2.1-3 as 运算符

`as`运算符用于执行引用类型的显示类型转换。**如果要转换的类型与指定的类型兼容，转换就会成功。如果类型不兼容，as 运算符就会返回 null 值**。as 运算符允许在一步中进行安全的类型转换，不需要先使用 is 运算符测试类型后再转换。

```csharp
object o1 = "Some String";
object o2 = 5;
string s1 = o1 as string; // s1 = "Some String"
string s2 = o2 as string; // s2 = null
```

![6-6.png](./images/6-6.png)

#### 6.2.1-4 sizeof 运算符

使用 sizeof 运算符可以确定栈中值类型需要的长度（单位是字节），如果结构体只包含值类型，也可以使用 sizeof 运算符。

**注意，类不能使用 sizeof 运算符**。

如果对复杂类型使用 sizeof 运算符，需要把代码放入 unsafe 块中，如下：

```csharp
public struct Point
{
  public int X { get; }
  public int Y { get; }
  public Point(int x, int y)
  {
    X = x;
    Y = y;
  }
}
unsafe
{
  Console.WriteLine(sizeof(Point));
}
```

> ChatGPT：
>
> Q：C# 运算符中的sizeof运算符的作用是什么？举个例子
>
> A：在C#中，`sizeof`运算符用于获取指定类型的大小（以字节为单位）。它可以用于计算值类型（如`int`、`float`、`char`等）的大小，以及结构体的大小。
>
> 下面是一个示例，展示了如何使用`sizeof`运算符获取类型的大小：
>
> ```csharp
> using System;
> 
> public class Program
> {
>  public static void Main()
>  {
>      Console.WriteLine(sizeof(int)); // 输出：4，int类型的大小为4字节
>      Console.WriteLine(sizeof(float)); // 输出：4，float类型的大小为4字节
>      Console.WriteLine(sizeof(char)); // 输出：2，char类型的大小为2字节
> 
>      struct MyStruct
>      {
>          public int x;
>          public bool y;
>      }
> 
>      Console.WriteLine(sizeof(MyStruct)); // 输出：8，MyStruct结构体的大小为8字节（int和bool各占4字节）
> 
>      // 注意：sizeof运算符只能用于值类型和结构体，不能用于引用类型（如类、接口、委托等）
>  }
> }
> ```
>
> 在上面的示例中，我们使用`sizeof`运算符获取了`int`、`float`和`char`类型的大小，并将结果输出到控制台。然后，我们定义了一个名为`MyStruct`的结构体，其中包含一个`int`类型和一个`bool`类型的字段。我们使用`sizeof`运算符获取了`MyStruct`结构体的大小，并将结果输出到控制台。
>
> 请注意，`sizeof`运算符只能用于值类型和结构体，不能用于引用类型（如类、接口、委托等）。此外，`sizeof`运算符返回的是类型的大小，而不是变量的大小。

![6-7.png](./images/6-7.png)

#### 6.2.1-5 typeof 运算符



> 本次阅读至 P157  typeof 运算符 下次阅读应至 P172

