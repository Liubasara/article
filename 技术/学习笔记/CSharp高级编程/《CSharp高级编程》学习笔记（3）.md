---
name: 《C#高级编程》学习笔记（3）
title: 《C#高级编程》学习笔记（3）
tags: ["技术","学习笔记","C#高级编程"]
categories: 学习笔记
info: "C#高级编程 第3章 对象和类型"
time: 2023/5/24
desc: 'C#高级编程, 学习笔记, 第3章 对象和类型'
keywords: ['学习笔记', 'C#', 'C#高级编程', '第3章 对象和类型']

---

#  《C#高级编程》学习笔记（3）

## 第 3 章 对象和类型

![3-1.png](./images/3-1.png)

### 3.1 创建及使用类

本章将讨论与类相关的基本语法，第 4 章将介绍继承以及与继承相关的特性。

### 3.2 类和结构

类和结构实际上都是创建对象的模板，每个对象都包含数据，并提供了处理和访问数据的方法。

结构不同于类的是，它们不需要在堆上分配空间（类是引用类型，总是存储在堆上），而结构是值类型，通常存储在栈上，且结构也不支持继承。

较小的数据类型可以使用结构，以提高性能。在堆栈上存储值类型可以避免垃圾收集。

>类的对象是存储在堆空间中，结构存储在栈中。堆空间大，但访问速度较慢，栈空间小，访问速度相对更快。故而，当我们描述一个轻量级对象的时候，结构可提高效率，成本更低。当然，这也得从需求出发，假如我们在传值的时候希望传递的是对象的引用地址而不是对象的拷贝，就应该使用类了。

对于类和结构，都是用`new`来声明实例，在下面的例子中，类和结构的字段值都默认为0：

```c#
var myCustomer = new PhoneCustomer(); // works for a class
var myCustomer2 = new PhoneCustomerStruct(); // works for a struct
```

在大多数情况下，类要比结构常用得多，但类的对象通过引用传递，而结构类型的对象按值传递，除非特别说明，否则就可以假定用于类的代码也适用于结构。

### 3.3 类

类包含成员，成员可以是静态成员或是实例成员。

静态成员属于类，而实例成员属于对象。

![3-2.png](./images/3-2.png)

```c#
class PhoneCustomer
{
  /**
  可以使用 const 关键字声明常量，声明 public，就可以在类的外部访问它
  const 会被编译器识别并优化，在使用的地方将其取代成该常量
  */
  public const string DayofSendingBill = "Monday";
  /**
  readonly 保证对象的字段不能改变，与 const 修饰符不同的是，只读字段不会被编译器识别并替换
  也就是说，只是保证它可变，但并不会被硬编码到编译后的代码中。
  */
  private static readonly unit s_maxDocuments;
}
var customer1 = new PhoneCustomer();
customer1.FirstName = "Simon";
```

#### 3.3.3 属性

属性（property）的概念是，它是一个方法或是一对方法，但在客户端代码看来，它们确是一个字段。

```c#
class PhoneCustomer
{
  private string _firstName;
  // FirstName 就是一个属性，包含 get 和 set 访问器，来检索和设置支持字段的值
  public string FirstName
  {
    // get 访问器不带任何参数，且必须返回字段所声明类型的值
    get
    {
      return _firstName;
    }
    // set 访问器没有任何显式参数，但编译器假定它带一个 value 参数，类型与声明相同
    set
    {
      _firstName = value;
    }
  }
  
  // 在 C# 7 中，还支持使用 => 编写
  public string theFirstName
  {
    get => _firstName;
    set => _firstName = value;
  }
  
  // 如果属性的 set 和 get 访问器中没有任何逻辑，可以使用自动实现的属性，自动实现的属性可以使用属性初始化器来初始化
  public int Age { get; set; } = 42
}
```





> 本次阅读至 P99  3.属性访问的修饰符 下次阅读应至 P110

