---
name: 《C#高级编程》学习笔记（16）
title: 《C#高级编程》学习笔记（16）
tags: ["技术","学习笔记","C#高级编程"]
categories: 学习笔记
info: "C#高级编程 第 21 章 任务和并行编程"
time: 2023/8/25
desc: 'C#高级编程, 学习笔记, 第 21 章 任务和并行编程'
keywords: ['学习笔记', 'C#', 'C#高级编程', '第 21 章 任务和并行编程']

---

#  《C#高级编程》学习笔记（16）

## 第 21 章 任务和并行编程

![21-1.png](./images/21-1.png)

### 21.1 概述

多线程用于将所有需要等待的 CPU 密集型任务分割到不同的线程上，一个进程的多个线程可以同时运行在不同的 CPU 上，或者多核 CPU 的不同内核上。

必须注意的是，多线程可以同时运行，但如果线程访问相同的数据，就很容易出问题，所以必须实现其同步机制。

本章首先介绍 Parallel 类，它提供了非常简单的并行性，如果需要更多的控制，比如说需要管理任务之间的关系，或定义返回任务的方法，就要使用 Task 类。若需要更多地控制并行性，如设置优先级，就需要使用 Thread 类。

![21-2.png](./images/21-2.png)

### 21.2 Parallel 类

> ChatGPT：
>
> 在 C# 中，`Parallel` 类是用于支持并行编程的一个重要工具。它提供了一种简化并行任务执行的方式，可以有效地利用多核处理器来提高应用程序的性能。`Parallel` 类包含了一系列方法，可以用于执行循环、迭代和任务并行操作。下面我会详细介绍一些常用的 `Parallel` 类的使用方法和使用场景，并附带示例和注释。
>
> **注意：并行编程涉及多线程操作，需要注意线程安全性和性能问题。确保在实际应用中进行适当的测试和优化。**
>
> ### 1. 并行循环 - `Parallel.For` 和 `Parallel.ForEach`
>
> `Parallel.For` 和 `Parallel.ForEach` 方法可以用于在一个范围内执行循环或迭代任务。这在需要对一个大型数据集或迭代集合进行操作时特别有用。
>
> **使用场景：** 处理大型数组、列表或集合，计算密集型任务。
>
> ```csharp
> using System;
> using System.Threading.Tasks;
> 
> class Program
> {
>     static void Main()
>     {
>         int[] data = new int[10000];
> 
>         // 使用 Parallel.For 处理数组
>         Parallel.For(0, data.Length, (int i, ParalleLoopState pls) =>
>         {
>             data[i] = i * i;
>           	if (i > 12)
>             {
>               // 提前中断 For 方法而不是完成所有迭代
>               pls.Break();
>             }
>         });
> 
>         // 使用 Parallel.ForEach 处理集合
>         string[] names = { "Alice", "Bob", "Charlie" };
>         Parallel.ForEach(names, name =>
>         {
>             Console.WriteLine($"Hello, {name}!");
>         });
>     }
> }
> ```
>
> ### 2. 并行任务 - `Parallel.Invoke`
>
> `Parallel.Invoke` 方法允许同时调用多个方法，这些方法可以在不同的线程中并行执行。
>
> **使用场景：** 并行地执行多个独立的方法，适用于并行启动多个任务。
>
> ```csharp
> using System;
> using System.Threading.Tasks;
> 
> class Program
> {
>     static void Main()
>     {
>         // 并行调用多个方法
>         Parallel.Invoke(
>             () => DoWork("Task 1"),
>             () => DoWork("Task 2"),
>             () => DoWork("Task 3")
>         );
>     }
> 
>     static void DoWork(string taskName)
>     {
>         Console.WriteLine($"Starting {taskName}");
>         // 模拟耗时操作
>         Task.Delay(1000).Wait();
>         Console.WriteLine($"Completed {taskName}");
>     }
> }
> ```
>
> ### 3. 数据聚合 - `Parallel.Aggregate` 和 `ParallelReduce`
>
> `Parallel.Aggregate` 和 `ParallelReduce` 方法用于将并行执行的结果聚合为一个最终结果，这在需要合并多个部分结果的情况下非常有用。
>
> **使用场景：** 将部分结果聚合成一个总体结果，例如累积和、最大/最小值等。
>
> ```csharp
> using System;
> using System.Linq;
> using System.Threading.Tasks;
> 
> class Program
> {
>     static void Main()
>     {
>         int[] numbers = Enumerable.Range(1, 1000).ToArray();
> 
>         // 使用 Parallel.Aggregate 计算累积和
>         int sum = Parallel.Aggregate(
>             numbers,
>             0, // 初始值
>             (localTotal, chunk) => localTotal + chunk, // 部分结果的聚合
>             (total, localTotal) => total + localTotal // 最终聚合
>         );
> 
>         Console.WriteLine($"Sum: {sum}");
>     }
> }
> ```
>
> ### 4. 数据分区 - `ParallelPartitioner`
>
> `ParallelPartitioner` 可以用于自定义数据分区策略，使并行操作更加灵活。
>
> **使用场景：** 在某些情况下，需要自定义数据的分割方式以获得更好的性能。
>
> ```csharp
> using System;
> using System.Linq;
> using System.Threading.Tasks;
> 
> class Program
> {
>     static void Main()
>     {
>         int[] data = Enumerable.Range(1, 1000).ToArray();
> 
>         // 使用自定义分区策略
>         var partitioner = Partitioner.Create(data, loadBalance: true);
>         Parallel.ForEach(partitioner, chunk =>
>         {
>             foreach (var item in chunk)
>             {
>                 Console.WriteLine(item);
>             }
>         });
>     }
> }
> ```
>
> 这些示例涵盖了 `Parallel` 类的一些常见用法和使用场景。请注意，在实际应用中，要根据问题的性质和数据量选择合适的并行策略，并进行性能测试和调优，以确保获得最佳的并行处理效果。

### 21.3 任务 Task

使用 System.Threading.Tasks 中的 Task 类，可以以同步的方式启动一个任务，但也可以让并行操作在单独的线程中运行。

任务不仅可以获得一个抽象层，还可以对底层线程进行很多的控制。

> Task 类之前已经介绍过，详情可见 [《C# 高级编程》学习笔记（12）](https://blog.liubasara.site/#/blog/post/%E3%80%8AC%23%E9%AB%98%E7%BA%A7%E7%BC%96%E7%A8%8B%E3%80%8B%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0%EF%BC%8812%EF%BC%89)

### 21.4 取消架构

允许以标准方式取消长时间运行的任务。















> 本次阅读至 P505  21.4 取消架构  下次阅读应至 P520 有用的一共也就17章

