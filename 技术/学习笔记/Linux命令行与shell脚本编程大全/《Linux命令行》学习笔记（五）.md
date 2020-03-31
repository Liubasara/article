---
name: 《Linux命令行》学习笔记（五）
title: 《Linux命令行》学习笔记（五）
tags: ["技术","学习笔记","Linux命令行与shell脚本编程大全"]
categories: 学习笔记
info: "第6章 使用Linux环境变量"
time: 2020/3/30
desc: 'Linux命令行与shell脚本编程大全, 资料下载, 学习笔记, 第6章 使用Linux环境变量'
keywords: ['Linux命令行与shell脚本编程大全', 'shell学习', '学习笔记', '第6章 使用Linux环境变量']
---

# 《Linux命令行》学习笔记（五）

## 第6章 使用Linux环境变量

> 本章内容
>
> -  什么是环境变量 
> -  创建自己的局部变量 
> -  删除环境变量 
> -  默认shell环境变量
> -  设置PATH环境变量 
> -  定位环境文件 
> -  数组变量

### 6.1 什么是环境变量

环境变量分为两类：

- 全局变量
- 局部变量

#### 6.1.1 全局环境变量

查看全局环境变量命令：

- `env`：显示所有环境变量
- `pringenv`：可以用于显示个别环境变量
- `echo $环境变量名字`：在变量前面加一个 dollar 符号用于引用某个变量的值

#### 6.1.2 局部环境变量

Linux 并没有一个只显示局部环境变量的命令。使用`set`命令会显示某个特定进程设置的所有环境变量，即包括局部、全局和用户定义变量。

### 6.2 设置用户定义变量

#### 6.2.1 设置局部用户定义变量

通过等号可以直接给环境变量赋值，注意如果值有空格，需要加上引号。

```shell
my_variable=Hello
echo $my_variable
# Hello
my_variable="Hello World" 
echo $my_variable
# Hello World
```

局部环境变量只能在当前 shell 中使用，即便是子 shell 也无法共享父 shell 的环境变量。

#### 6.2.2 设置全局变量

通过`export`命令可以将一个已经在局部变量中的环境变量导出到全局环境中。

```shell
my_variable=Hello
export my_variable
```

`export`的环境变量名前不需要加 $ 号。

子 shell 中能够读取到父 shell 中全局变量的值，但在子 shell 中修改全局变量是不会影响父 shell 中该变量的值的。

### 6.3 删除环境变量

使用`unset`命令可以用于删除已经存在的环境变量。

```shell
echo $my_variable
# Hello
unset my_variable
#
```

同样，在子shell中删除全局变量无法将效果反映到父shell中。 

### 6.4 默认的 shell 环境变量



> 阅读至 P110 125