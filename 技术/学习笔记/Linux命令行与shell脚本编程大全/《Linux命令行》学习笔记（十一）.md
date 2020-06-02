---
name: 《Linux命令行》学习笔记（十一）
title: 《Linux命令行》学习笔记（十一）
tags: ["技术","学习笔记","Linux命令行与shell脚本编程大全"]
categories: 学习笔记
info: "第13章 更多的结构化命令"
time: 2020/5/20
desc: 'Linux命令行与shell脚本编程大全, 资料下载, 学习笔记, 第13章 更多的结构化命令'
keywords: ['Linux命令行与shell脚本编程大全', 'shell学习', '学习笔记', '第13章 更多的结构化命令']
---

# 《Linux命令行》学习笔记（十一）

## 第13章 更多的结构化命令

### 13.1 for 命令

bash shell 的`for`命令允许你创建一个遍历一系列值的循环。每次迭代都使用其中一个值来执行已定义好的一组命令。

```shell
#!/bin/bash
for var in hi wow now yo
do
  echo $var haha
done
```

在 do 和 done 语句之间输入的命令可以是一条或多条标准的 bash shell 命令。在这些命令中， $var 变量包含着这次迭代对应的当前列表项中的值。

#### 13.1.1 读取列表中的值

每次`for`命令遍历值列表，它都会将列表的下个值赋予定义好的变量。变量可以像`for`命令语句中的其它脚本变量一样使用。在后一次迭代后，变量的值会在 shell 脚本的剩余 部分一直保持有效。它会一直保持后一次迭代的值。

#### 13.1.2 读取列表中的复杂值

对一些带空格或是带引号的字符值，需要将他们用转义字符和双引号包裹起来。

```shell
#!/bin/bash
for test in you don\'t really want "Mr Liubasara"
do
	echo "word:$test"
done
```

#### 13.1.3/4 从变量读取列表、从命令读取值

```shell
#!/bin/bash
list="dada ksasl fddsnfew e"
for state in $list
do
	echo "$list"
done
```



```shell
#!/bin/bash
file="states"
for state in $(cat $file)
do
	echo "Visit $state"
done
```

#### 13.1.5 更改文段分隔符

`IFS`环境变量又称为`内部字段分隔符`，定义了用作字段分隔的一系列字符，默认情况下有三种：

- 空格
- 制表符
- 换行符

可以在 shell 脚本中临时更改`IFS`环境变量的值来限制被 bash shell 当做分隔符的字段。

```shell
#!/bin/bash
file=states
# 以换行符为分隔，告诉bash shell在数据值中忽略空格和制表符。
IFS=$'\n'
for state in $(cat $file)
do
	echo "Visit $state"
done
```

现在， shell 脚本旧能够使用列表中含有空格的值了。

> 在处理代码量较大的脚本时，可能在一个地方需要修改IFS的值，然后忽略这次修改，在
> 脚本的其他地方继续沿用IFS的默认值。一个可参考的安全实践是在改变IFS之前保存原
> 来的IFS值，之后再恢复它。
> 这种技术可以这样实现： 
>
> ```shell
> IFS.OLD=$IFS
> IFS=$'\n'
> # .... 新 IFS 对应代码
> IFS=$IFS.OLD
> ```

此外，还有一些额外的用法，如果要指定多个 IFS 字符，只要将它们在赋值行串起来就行，如何使用 IFS 字符解析没有任何限制。

```shell
# 以冒号作为分隔符
IFS=:
# 以换行符、冒号、分号和双引号作为字段分隔符
IFS=$'\n':;"
```

#### 13.1.6 通配符读取目录

```shell
#!/bin/bash
# 遍历 /home 目录下的文件夹
for file in /home/*
do
	if [ -d "$file" ]
	then
		echo "$file 是一个目录"
     elif [ -f "$file" ]
     then
     	echo "$file 是一个文件"
     fi
done
```

### 13.2 C 语言风格的 for 命令

> shell开发人员创建了这种格式以更贴切地模仿C语言风格的for命令。这虽然对C语言程序员
> 来说很好，但也会把专家级的shell程序员弄得一头雾水。在脚本中使用C语言风格的for循环时
> 要小心。 

```shell
#!/bin/bash
for (( i=1; i <= 10; i++ ))
do
	echo "text number is $i"
done
```

#### 13.2.2 使用多个变量

> 循环会单独处理每个变量，你可以为每个变量定义不同的迭代过程。尽管可以使用多个变量，但你只能在for循环中定义一种条件 。

```shell
for (( a=1, b=10; a <= 10; a++, b-- ))
do
	echo "$a 与 $b"
done
```

### 13.3 while 命令

命令格式：

```shell
while test command
do
	other commands
done
```

其中 test 部分的命令与 if-then 中的一模一样，也同样可以被替换为中括号。

while 允许有多个条件，但只有最后一个测试命令的退出状态码为 0 时才会结束循环，而且在结束循环之前，条件命令都会被执行一次。

```shell
#!/bin/bash
var1=10
while echo $var1
	   [ $var1 -ge 0 ]
do
	echo "This is inside the loop"
	var1=$[ $var1 - 1 ]
done
```

上面的程序会在最后在屏幕上输出一个 -1 作为结束，足以说明在结束循环之前所有的条件命令都会被执行。

### 13.4 until 命令

`until`命令和`while`命令的工作方式完全相反。`until`命令只要测试命令的退出状态码**不为0**，bash shell 就会执行循环中列出的命令。而一旦测试命令返回了退出状态码 0，循环就结束了。

```shell
until test commands
do
	commands
done
```

跟`while`类似，shell 会执行指定的多个测试命令，而只有在最后一个命令成立时才停止。

### 13.5 嵌套循环

你可以在一个循环中嵌套另外一个循环，`for`、`until`、`while`三种方式可以混合使用。

### 13.6 循环处理文件数据

遍历存储在文件中的数据要求结合已经讲过的两种技术方法：

- 使用嵌套循环
- 修改 IFS 环境变量

通过修改 IFS 环境变量，就能强制`for`命令将文件中的每行都当成单独的一个条目进行处理。

一旦从文件中提取出了单独的行，则可能需要在此利用循环来提取行中的数据。

比如下面这一段遍历 /etc/passwd 文件的代码：

```shell
#!/bin/bash
IFS.OLD=$IFS
IFS=$'\n'
for entry in $(cat /etc/passwd)
do
	echo "$entry 的值为 - "
	IFS=:
	for value in $entry
	do
		echo "   $value"
	done
done
```

上面的代码使用了两个不同的 IFS 值来解析数据。第一个以换行符作为分隔符，后一个以冒号为分割，输出 /etc/passwd 中的值。

> 这种方法在处理外部导入电子表格所采用的 逗号分隔的数据时也很方便

### 13.7 控制循环

`break`命令和`continue`命令能够帮我们跳出当前的循环流程，它们的基本使用方法与其他语言相通。

与其他语言不同的时候，`break`命令可以接受单个命令行的参数值，能够在内部循环中停止外部循环。

```shell
break n
continue n
```

默认情况下，n 为 1，如果将 n 设为 2，`break`和`continue`命令就会停止上一级的外部循环。

```shell
#!/bin/bash
for (( a = 1; a < 4; a++ ))
do
	echo "外层循环：$a"
	for (( b = 1; b < 100; b++ ))
	do
		if [ $b -gt 4 ]
		then
			# 跳出外部循环
			break 2
		fi
		echo "内部循环: $b"
	done
done

# 外层循环：1
# 内部循环: 1
# 内部循环: 2
# 内部循环: 3
# 内部循环: 4
```

### 13.8 处理循环的输出

在 shell 脚本中，你可以对循环的输出使用管道或者进行重定向，这可以通过在`done`命令之后添加一个处理命令来实现。

```shell
for file in /home/rich/*
do
	if [ -d "$file" ]
	then
		echo "$file is a directory"
	elif
		echo "$file is a file"
	fi
done > output.txt
```

上面的代码下，shell 会将 for 命令的结果重定向到文件 output.txt 中，而不会显示到屏幕上。

同样上面的`> output.txt`也可以替换为管道符合其他命令，如`| sort`这样的后缀，可以将脚本进行排序后再输出。

### 13.9 实例

#### 13.9.1 运用所学知识查找环境变量下的可执行文件

```shell
#!/bin/bash
# 修改分隔符
IFS=:
for folder in $PATH
do
	echo "$folder:"
	# 遍历文件
	for file in $folder/*
	do
		# 执行权限
		if [ -x $file ]
		then
			echo "$file"
		fi
	done
done
```

这样就可以输出当前环境变量下有多少可执行的命令了。

#### 13.9.2 创建多个用户账户







> 本次阅读至 P284  299