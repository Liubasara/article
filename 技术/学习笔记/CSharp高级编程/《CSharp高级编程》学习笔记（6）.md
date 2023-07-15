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

typeof 运算符返回一个表示特定类型的 System.Type 类型，比如，`typeof(string)`的返回表示 System.String 类型的 Type 对象，在使用反射技术动态查找对象的相关信息时，这个运算符很有用。

#### 6.2.1-6 nameof 运算符

该运算符接受一个符号、属性或者方法、并返回其名称。

> chatGPT：
>
> Q：C# 中的 nameof 关键字如何使用？详细解释并举个例子
>
> A：
>
> 在C#中，`nameof`关键字用于获取指定标识符的名称作为字符串。它可以用于获取变量、类型、成员等的名称，这样可以避免硬编码字符串，提高代码的可维护性。
>
> 下面是一个示例，展示了如何使用`nameof`关键字：
>
> ```csharp
> using System;
> 
> public class Program
> {
>     public static void Main()
>     {
>         string name = "John";
>         Console.WriteLine(nameof(name)); // 输出：name，获取变量name的名称作为字符串
> 
>         Console.WriteLine(nameof(Console)); // 输出：Console，获取类型Console的名称作为字符串
> 
>         Console.WriteLine(nameof(Console.WriteLine)); // 输出：WriteLine，获取方法WriteLine的名称作为字符串
> 
>         Console.WriteLine(nameof(Program)); // 输出：Program，获取类Program的名称作为字符串
> 
>         Console.WriteLine(nameof(Program.Main)); // 输出：Main，获取方法Main的名称作为字符串
> 
>         // 注意：nameof关键字在编译时求值，所以它是类型安全的，不会引发运行时异常
>     }
> }
> ```
>
> 在上面的示例中，我们使用`nameof`关键字获取了变量`name`、类型`Console`、方法`WriteLine`、类`Program`以及方法`Main`的名称，并将结果输出到控制台。
>
> 请注意，`nameof`关键字在编译时求值，所以它是类型安全的，不会引发运行时异常。这意味着，如果您更改了标识符的名称，`nameof`关键字会自动更新为新的名称，而不需要手动修改字符串。这可以减少因为重构代码而导致的错误。

#### 6.2.1-7 index 运算符

使用索引运算符可以访问数组对应的元素。

```csharp
int arr1 = {1, 2, 3, 4};
int x = arr1[2]; // x == 3

var dict = new Dictionary<string, int>();
dict["first"] = 1;
int x = dict["first"];
```

索引运算符的表现也可以在类中自己进行自定义。

#### 6.2.1-8 可空类型和运算符

值类型和引用类型的一个主要区别是引用类型可以为空，而且垃圾收集器（GC）需要处理引用类型，如果用引用类型来映射可空的数据值，会影响性能。

所以在当下的 C# 版本中，支持了可空类型的值类型，其开销只是使用一个额外的布尔值来检查或设置空值。每个结构都可以定义为可空类型。

```csharp
int i1 = 1;
int? i2 = 2;
int? i3 = null;

long? l1 = null;
DateTime? d1 = null;
```

如果在程序中使用可空类型，就必须考虑 null 值在与各种运算符一起使用时的影响。

```csharp
int? a = null;
int? b = a + 4; // b = null
int? c = a * 5; // c = null

a >= b; // false
a < b; // false
```

![6-8.png](./images/6-8.png)

#### 6.2.1-9 空合并运算符

空合并运算符（??），可以用于处理可空类型。

```csharp
int? a = null;
int b;
b = a ?? 10; // b is 10
a = 3;
b = a ?? 10; // a is 3
```

空合并运算符也可以用于引用类型：

![6-9.png](./images/6-9.png)

#### 6.2.1-10 空值条件运算符

空值条件运算符（`?`）可以用于检测这个值是否为 null。

```csharp
int[] arr = null;
int x1 = arr?[0] ?? 0;
```

#### 6.2.2 运算符的优先级和关联性

![6-10.png](./images/6-10.png)

### 6.3 使用二进制运算符

原书的例子一坨...

> chatGPT：
>
> Q：C# 中如何进行二进制计算，举个例子
>
> A：在C#中进行二进制计算可以使用位运算符。以下是一些常用的二进制计算操作和示例：
>
> 1. 与运算（&）：对两个二进制数的每一位进行与操作，结果中的每一位都是两个数对应位上的值相与的结果。
> ```csharp
> int result = 5 & 3; // 二进制：101 & 011，结果为 001，即 1
> ```
>
> 2. 或运算（|）：对两个二进制数的每一位进行或操作，结果中的每一位都是两个数对应位上的值相或的结果。
> ```csharp
> int result = 5 | 3; // 二进制：101 | 011，结果为 111，即 7
> ```
>
> 3. 异或运算（^）：对两个二进制数的每一位进行异或操作，结果中的每一位都是两个数对应位上的值相异或的结果。
> ```csharp
> int result = 5 ^ 3; // 二进制：101 ^ 011，结果为 110，即 6
> ```
>
> 4. 左移运算（<<）：将一个二进制数向左移动指定的位数，右侧用零填充。
> ```csharp
> int result = 5 << 2; // 二进制：101 左移 2 位，结果为 10100，即 20
> ```
>
> 5. 右移运算（>>）：将一个二进制数向右移动指定的位数，左侧用符号位填充（对于正数，用零填充）。
> ```csharp
> int result = 10 >> 2; // 二进制：1010 右移 2 位，结果为 10，即 2
> ```
>
> 请注意，这些示例中的二进制数都是以十进制形式表示的。您可以根据需要将十进制数转换为二进制数进行计算，或者使用二进制字面量（以0b开头）直接表示二进制数。

### 6.4 类型的安全性

C# 语言会编译成中间语言（IL），而 C# 也是强类型，这说明数据类型并不总是可以无缝呼唤。

![6-11.png](./images/6-11.png)

#### 6.4.1 类型转换

```csharp
byte value1 = 10;
byte value2 = 23;
byte total;
total = value1 + value2; // error
```

两个 byte 类型数据加在一起时，会返回 int 类型（返回 byte 类型很可能溢出 8 位字符），因此上面这种代码会报错，如果要把结果存储在一个 byte 变量中，就必须把它转换为 byte 类型。

C# 支持两种转换方式：隐式转换和显示转换。

1. 隐式转换

   只要能保证值不会发生任何变化，类型转换就可以自动进行，比如说，只要将上面代码的 byte 类型换成 long 类型，代码就不会有问题（因为 long 类型变量包含的字节比 btype 类型多）

   下面是 C# 默认支持的隐式类型转换。

   ![6-12.png](./images/6-12.png)

2. 显式转换

   以下场合不能隐式转换：

   ![6-13.png](./images/6-13.png)

   但是，可以使用类型强制转换（cast）显式地执行这些转换。

   ```csharp
   long val = 30000;
   int i = (int)val;
   
   int? a = null;
   int b = (int)a; // throw exception
   ```

   这种强制类型转换是一种比较危险的操作，很可能会出现运行时错误。所以可以使用 try 语句和 catch 语句引入结构化异常处理。

   就值类型来说，**只能在数字、char类型和enum类型之间进行强制转换**，不能直接把布尔类型强制转换为其他类型，也不能把其他类型强制转换为布尔型。

#### 6.4.2 装箱和拆箱









> 本次阅读至 P168  typeof 运算符 下次阅读应至 P183

