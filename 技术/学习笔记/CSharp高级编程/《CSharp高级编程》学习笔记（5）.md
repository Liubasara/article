---
name: 《C#高级编程》学习笔记（5）
title: 《C#高级编程》学习笔记（5）
tags: ["技术","学习笔记","C#高级编程"]
categories: 学习笔记
info: "C#高级编程  第5章 泛型"
time: 2023/7/2
desc: 'C#高级编程, 学习笔记, 第5章 泛型'
keywords: ['学习笔记', 'C#', 'C#高级编程', '第5章 泛型']

---

#  《C#高级编程》学习笔记（5）

## 第5 章 泛型

### 5.1 泛型概述

泛型让开发者不必给不同的类型编写功能相同的许多方法或类，只创建一个方法或类即可。

另一个减少代码的选项是使用 Object 类，但是用派生自 Object 类的类型进行传递不是类型安全的。

泛型不仅限于类，本章还将介绍用于接口和方法的泛型。

泛型不仅存在于 C# 中，C++ 的模板就与泛型相似。

> chatGPT
>
> Q：C# 的泛型和 C++ 的模板有什么区别？
>
> A：
>
> C#的泛型和C++的模板都是用于实现通用编程的特性，但它们在语法和实现上有一些区别。
>
> 1. 语法差异：
>    - C#的泛型使用尖括号（<>）来指定类型参数，如`List<T>`。
>    - C++的模板使用尖括号（<>）或双尖括号（<<>>)来指定模板参数，如`vector<T>`或`map<Key, Value>`。
>
> 2. 编译时和运行时：
>    - **C#的泛型是在编译时进行类型检查和实例化的，生成的IL代码只包含一份通用代码，可以在运行时根据需要生成具体的类型**。
>    - **C++的模板是在编译时进行代码生成的，每个具体的模板参数都会生成一份对应的代码**。
>
> 3. 实现方式：
>    - **C#的泛型是通过类型擦除实现的，编译器在编译时将泛型类型替换为实际的类型，并进行类型检查**。
>    - **C++的模板是通过代码生成实现的，编译器会根据模板参数生成对应的代码，每个具体的参数都会生成一份独立的代码**。
>
> 下面是一个简单的示例来说明它们的区别：
>
> C#泛型示例：
>
> ```csharp
> public class MyGenericClass<T>
> {
>     private T data;
> 
>     public MyGenericClass(T value)
>     {
>         data = value;
>     }
> 
>     public T GetData()
>     {
>         return data;
>     }
> }
> 
> // 使用泛型类
> MyGenericClass<int> intObj = new MyGenericClass<int>(10);
> int value = intObj.GetData(); // 获取int类型的数据
> ```
>
> C++模板示例：
>
> ```cpp
> template <typename T>
> class MyTemplateClass
> {
> private:
>     T data;
> 
> public:
>     MyTemplateClass(T value)
>     {
>         data = value;
>     }
> 
>     T GetData()
>     {
>         return data;
>     }
> };
> 
> // 使用模板类
> MyTemplateClass<int> intObj(10);
> int value = intObj.GetData(); // 获取int类型的数据
> ```
>
> 在这个示例中，我们定义了一个泛型类（C#）和一个模板类（C++），它们都可以存储和返回一个特定类型的数据。通过在实例化时指定类型参数，我们可以创建具体类型的对象并使用它们。
>
> 总结起来，C#的泛型和C++的模板都是用于实现通用编程的特性，但它们在语法和实现上有所不同。C#的泛型是通过类型擦除实现的，而C++的模板是通过代码生成实现的。

#### 5.1.1 性能

泛型的一个主要优点是性能。不需要进行过多的强制类型转换操作。

> chatGPT：
>
> 当涉及到性能优化时，使用泛型的 List 类比 ArrayList 类更好，因为 List 类是泛型的，可以在编译时执行类型检查，避免了装箱和拆箱操作，从而提高了性能。下面是一个使用泛型的 List 和 ArrayList 的例子：
>
> ```csharp
> using System;
> using System.Collections;
> 
> public class Program
> {
>     public static void Main(string[] args)
>     {
>         // 使用泛型的 List
>         List<int> numbersList = new List<int>();
>         numbersList.Add(1);
>         numbersList.Add(2);
>         numbersList.Add(3);
> 
>         // 使用 ArrayList
>         ArrayList numbersArrayList = new ArrayList();
>         numbersArrayList.Add(1);
>         numbersArrayList.Add(2);
>         numbersArrayList.Add(3);
> 
>         // 遍历 List（每个元素本身就是 int，无需转换）
>         foreach (int number in numbersList)
>         {
>             Console.WriteLine(number);
>         }
> 
>         // 遍历 ArrayList（每个元素都要经历从 object 到 int 的强制类型转换）
>         foreach (int number in numbersArrayList)
>         {
>             Console.WriteLine(number);
>         }
>     }
> }
> ```
>
> 在上面的例子中，我们创建了一个泛型的 List<int> 和一个非泛型的 ArrayList，然后向它们中添加了一些整数。最后，我们使用 foreach 循环遍历这两个集合并打印出每个元素。
>
> 使用泛型的 List 可以直接指定元素的类型，而 ArrayList 存储的是 object 类型，需要进行装箱和拆箱操作。因此，使用泛型的 List 在性能方面更优。

#### 5.1.2 类型安全

跟上面的例子一样，如果在 ArrayList 中添加一个对象，最后在遍历的时候会由于无法转换成 int 而出现一个运行时错误。而在泛型类 List\<T\> ，由于只能添加 int 类型，若添加类型到 List 中，编译器会提前报错。

#### 5.1.3 二进制代码的重用

反省允许更好地重用二进制代码，不需要像 C++ 那样访问源代码，泛型类型可以在一种语言中定义，然后在其他任何`.NET`语言中使用。

#### 5.1.4 代码的扩展

编译器会把泛型类编译为本地代码，由于泛型类只定义一次且为引用类型，而包含具体值类型的类则需要定义多次且为值类型，所以能够节省编译后的占用空间。

#### 5.1.5 命名约定

![4-9.png](./images/4-9.png)

### 5.2 创建泛型类









> 本次阅读至 P138  5.2 创建泛型类 下次阅读应至 P153