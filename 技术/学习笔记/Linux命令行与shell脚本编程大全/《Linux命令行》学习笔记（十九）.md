---
name: 《Linux命令行》学习笔记（十九）
title: 《Linux命令行》学习笔记（十九）
tags: ["技术","学习笔记","Linux命令行与shell脚本编程大全"]
categories: 学习笔记
info: "第26章 一些小有意思的脚本"
time: 2020/7/7
desc: 'Linux命令行与shell脚本编程大全, 资料下载, 学习笔记, 第26章 一些小有意思的脚本'
keywords: ['Linux命令行与shell脚本编程大全', 'shell学习', '学习笔记', '第26章 一些小有意思的脚本']
---

# 《Linux命令行》学习笔记（十九）

## 第26章 一些小有意思的脚本

> 本章内容：
>
> - 发送信息
> - 获取灵感
> - 发送文本

### 26.1 发送消息

该脚本用于将消息直接发送到同伴系统的用户终端上。

1. 首先要通过`mesg`工具查看是否允许发送消息。

   ```shell
   mesg
   # is y
   ```

   以上代表允许发送（若不允许会为 n）

   如不允许，可以使用`mesg y`命令来打开当前用户的接受信息状态

2. 随后使用`who -T`来查看当前有哪些终端在线。

   ```shell
   who -T
   #root  + pts/0        2020-07-07 19:23 (192.168.3.50)
   #wow  - pts/2        2020-07-06 16:15 (192.168.3.185)
   #hey  + pts/3        2020-07-06 10:28 (192.168.3.6)
   ```

   用户名后面的破折号（-）表示这些用户的消息功能已经关闭。如果启用的话，你看到的会是加号（+）

3. 现在就可以向其他用户发送消息了，主要使用到的是`write`命令。

   ```shell
   write hey pts/3
   ```

   使用上述命令就会出现一个聊天界面，可以进行消息传输。如果你输入 CTRL+C 终止会话，则对方的终端会出现 EOF 字样代表会话结束。

### 26.2 获取格言

有一些不错的网站可以获得每日格言，可以使用一些工具来下载这些对应的 Web 网页。

**1. 学习 wget**

`wget`是一款非常灵活的，可以将 Web 网页下载到本地 Linux 系统中。

```shell
wget www.quotationspage.com/qotd.html
```

此后网站的信息就被下载到当前文件夹下的 qotd.html 文件中了。

使用`-o`参数可以将输出保存在日志文件中。

**2. 测试 Web 地址**

使用`wget`命令的`--spider`选项可以用于测试 Web 地址的状态。

**3. 解析出需要的信息**

将网页下载下来之后我们需要对网页进行解析，提取出需要的信息。对于简单的脚本处理，sed 命令和 gawk 命令就足以完成任务。

```shell
# 删除所有的 HTML 标签
sed 's/<[^>]*//g' /tmp/quote.html
# grep 命令经过格式化的当前日期来匹配格言页面中的日期。找到日期文本之后，使用 -A2 选项提取出另外两行文本。
# grep 命令的输出被管接到sed工具中，后者用来移除>符号。 
sed 's/<[^>]*//g' /tmp/quote.html | grep "$(date +%B' '%-d,' '%Y)" -A2 | sed 's/>//g'
```

### 26.3 编造接口

该小节介绍如何用脚本发送短信（SMS），可以通过系统给的电子邮件使用 SMS 服务，也可以使用`curl`工具。

**1. 学习 curl**

使用`curl`与`wget`类似，不同之处在于`curl`还可以用它向 Web 服务器发送数据。

除了`curl`工具还需要一个能够免费提供 SMS 的消息发送服务网站。如 http://textbelt.com/text，允许每天免费发送最多 75 条短信。

```shell
curl http://textbelt.com/text \
-d number=138xxxxxx31
-d "message=Your Text Message"
# { "success": true } 代表发送成功

```

`-d`选项告诉`curl`向网站发送指定的数据，包括手机号码和短信信息。

> 如果你的手机运营商不在美国，http://textbelt.com/text 可能没法工作。要是手机运营商在 加拿大的话，你不妨试试 http://textbelt.com/Canada 。假如是在其他地区的话，可以换用 http://textbell.com/intl 看看。更多的帮助，请访问 http://textbelt.com

此外还可以通过电子邮件来发送短信，前提是运行商使用了 SMS 网关。

> 你通常可以使用因特网找出手机运营商的SMS网关。有一个很棒的网站， http://martinfitzpatrick.name/list-of-email-to-sms-gateways/，上面列出了各种SMS网关以及使用技巧。如果在上面没有找到你的运营商，那就使用搜索引擎搜索吧。 
>
> 如果你的手机服务提供商屏蔽了来自系统的SMS消息，可以使用基于云的电子邮件服务 提供商作为SMS中继。使用你惯用的浏览器搜索关键字SMS relay your_favorite_ cloud_email，查看搜索到的网站。

```shell
# 通过电子邮件发送短信的基本语法发送格式
mail -s "your text message" your_phone_number@your_sms_gateway 
```

> 如果 mail 命令在你的 Linux 系统上无法使用，就需要安装 mailutils 包。请阅读本书第 9 章查看如何安装软件包



**全书完**

