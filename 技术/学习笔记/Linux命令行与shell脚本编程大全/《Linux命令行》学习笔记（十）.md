---
name: 《Linux命令行》学习笔记（十）
title: 《Linux命令行》学习笔记（十）
tags: ["技术","学习笔记","Linux命令行与shell脚本编程大全"]
categories: 学习笔记
info: "第12章 使用结构化命令"
time: 2020/5/14
desc: 'Linux命令行与shell脚本编程大全, 资料下载, 学习笔记, 第12章 使用结构化命令'
keywords: ['Linux命令行与shell脚本编程大全', 'shell学习', '学习笔记', '第12章 使用结构化命令']
---

# 《Linux命令行》学习笔记（十）

## 第12章 使用结构化命令

> 许多程序要求对shell脚本中的命令施加一些逻辑流程控制。有一类命令会根据条件使脚本跳 过某些命令。这样的命令通常称为结构化命令（structured command）。 
>
> 本章内容：
>
> - if-then 语句
> - 嵌套 if 语句
> - test 命令
> - 复合条件测试
> - 使用双方括号和双括号
> - case 命令

### 12.1 使用 if-then 语句

if-then 语句有以下格式：

```shell
if command
then
	commands
fi
```

bash shell 的 if 语句后面跟的并不是 TRUE 或 FALSE，而是一个命令。

if 语句会运行 if 后面的那个命令。如果该命令的退出状态码是 0（正常结束），那么就会执行 then 后面的语句，而如果是其他的值，就不会被执行。

fi 语句用于表示 if-then 语句到此结束。

```shell
#!/bin/bash
# 成功执行脚本
if pwd
then
	echo "执行"
fi

# 错误脚本
if wrongCommnad
then
	echo "不执行"
fi
```

要注意的是上面的错误脚本依然会运行 if 后面的命令，并且生成的错误消息依然会显示在脚本的输出中。

此外 it-then 还有一种比较美观的写法

```shell
# 通过把分号放在待求值的命令尾部，就可以将then语句放在同一行上了，这样看起来更像其他编程语言中的if-then语句。 
if command; then
  commands
fi
```

### 12.2 if-then-else 语句







> 阅读至P235 250