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

默认情况下，shell 会有一些预定义的环境变量

![linux-shell-var-1.jpg](./images/linux-shell-var-1.jpg)

要注意的是并不是所有的默认环境变量都必须要有一个值。

### 6.5 设置 PATH 环境变量

`PATH`环境变量定义了用于进行命令和程序查找的目录。使用`echo $PATH`命令可以看到当前的目录，目录之间用冒号分隔。

要定义`PATH`环境变量，你只需要引用原来的`PATH`值，然后再给这个字符串添加新目录就行了。

```shell
PATH=$PATH:/home/christine/Scripts
echo $PATH
#/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/christine/Scripts
```

将目录添加到`PATH`环境变量后，就可以在虚拟目录中的任何位置执行程序。

如果希望在子 shell 中也能执行，记得要把修改后的 PATH 环境变量用`export`命令导出。

### 6.6 定位系统环境变量

接下来的问题是怎样让环境变量的作用持久化。

在你登入Linux系统启动一个bash shell时，默认情况下bash会在几个文件中查找命令。这些文件叫作启动文件或环境文件。

#### 6.6.1 登录 shell

当登录 Linux 系统时，bash shell 会从 5 个不同的启动文件里读取命令：

- /etc/profile
- $HOME/.bash_profile
- $HOME/.bashrc
- $HOME/.bash_login
- $HOME/.profile

其中 /etc/profile 文件是系统上默认的主启动文件。系统上的每个用户登录时都会执行这个启动文件。

另外四个则是针对用户的，可以根据个人需求定制。

**1. /etc/profile 文件**

**以 Ubuntu 和 CentOS 这两个使用最广泛的发行版为例，它们的 /etc/profile 文件都用到了同一个特性：`for`语句，用于迭代 /etc/profile.d 目录下的所有文件**。

这也为 Linux 系统提供了一个放置特定应用程序启动文件的地方，当用户登录时，shell 会执行该目录下的所有 shell 文件。

以下是 CentOS 下的该目录文件。

![linux-cenOS-profileD.jpg](./images/linux-cenOS-profileD.jpg)

> lang.csh和lang.sh文件会尝试去判定系统上所采用的默认语言字符集，然后设置对应的LANG 环境变量。 

**2. $HOME 目录下的启动文件**

剩下的启动文件作用都大同小异，都针对单个用户来定义该用户所用到的环境变量。多数 Linux 发行版只用这个四个启动文件中的一到两个。

shell 会按照下列顺序，运行第一个被找到的文件

- $HOME/.bash_profile
- $HOME/.bash_login
- $HOME/.profile

这个列表中并没有 $HOME/.bashrc 文件，因为该文件通常是通过其他文件运行的。

比如 CentOS 下的 .bash_profile 文件就有下列这段代码去查找并运行该文件。

```shell
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
```

#### 6.6.2 交互式 shell 进程

如果你的 bash shell 不是在登录时启动的，那么你启动的 shell 称为交互式 shell。如果 bash 是作为交互式 shell 启动的，就不会访问 /etc/profile 文件，只会检查用户目录下的 .bashrc 文件。

.bashrc 文件有两个作用，一是查看 /etc 目录下通用的 bashrc 文件，而是为用户提供一个定制别名和私有脚本函数的地方。

#### 6.6.3 非交互式 shell

系统执行 shell 脚本时用的 shell 即称为非交互式交互 shell，这种 shell 进程没有命令行提示符。当 shell 启动一个非交互式 shell 进程时，它会检查`BASH_ENV`这个环境变量来查看要执行的启动文件。在多数发行版中，这个变量都没有被事先设置。

#### 6.6.4 环境变量持久化

>  对全局环境变量来说（Linux系统中所有用户都需要使用的变量），可能更倾向于将新的或修 改过的变量设置放在/etc/profile文件中，但这可不是什么好主意。如果你升级了所用的发行版， 这个文件也会跟着更新，那你所有定制过的变量设置可就都没有了。 
>
> 最好是在/etc/profile.d目录中创建一个以.sh结尾的文件。把所有新的或修改过的全局环境变 量设置放在这个文件中。 
>
> 在大多数发行版中，存储个人用户永久性 bash shell 变量的地方是$HOME/.bashrc文件。这一 点适用于所有类型的shell进程。但如果设置了 BASH_ENV 变量，那么记住，除非它指向的是 $HOME/.bashrc，否则你应该将非交互式 shell 的用户变量放在别的地方。 

### 6.7 数组变量

环境变量可以作为数组来使用，要给某个环境变量设置多个值，可以把值放在括号中，值与值之间用空格分割。在使用的时候用大括号、中括号和索引值来组合使用(默认是数组第一个的值)。

```shell
# example
mytest=(one two three four five)
echo $mytest
# one
echo ${mytest[2]}
# three
```

也可以用星号来显示整个数组变量。

```shell
echo ${mytest[*]}
# one two three four five
```

也可以改变某个索引值位置的值

```shell
mytest[2]=seven
echo ${mytest[*]}
# one two seven four five
```

也可以用`unset`命令来删除整个数组或是某个数组索引上的值，但要注意的是被删除的仅仅是索引，且数组的索引顺序不会随着删除而重新排列。（PS：残废数组？）

```shell
unset mytest[2]
echo ${mytest[*]}
# one two four five
echo ${mytest[2]}
#
echo ${mytest[3]}
# four
unset mytest
echo ${mytest[*]}
#
```

> 有时数组变量会让事情很麻烦，所以在shell脚本编程时并不常用。对其他shell而言，数组变 量的可移植性并不好，如果需要在不同的shell环境下从事大量的脚本编写工作，这会带来很多不 便。有些bash系统环境变量使用了数组（比如BASH_VERSINFO），但总体上不会太频繁用到。 







> 阅读至 P118 133