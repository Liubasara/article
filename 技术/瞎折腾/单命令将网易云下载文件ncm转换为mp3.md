---
name: 单命令将网易云下载文件ncm转换为mp3
title: "单命令将网易云下载文件ncm转换为mp3"
tags: ["技术", "瞎折腾"]
categories: 瞎折腾
info: "月啖音乐三百首"
time: 2024/8/8
desc: 单命令将网易云下载文件ncm转换为mp3
keywords: ['瞎折腾', '网易云', 'ncm', 'mp3']
---

# 单命令将网易云下载文件ncm转换为mp3

> github 地址：https://github.com/taurusxin/ncmdump

系统要求：MacOS

1. 按照上面 github 要求，使用`brew`安装`ncmdump`工具。

2. 打开命令行，输入`cd /Users/$(whoami)/Music`
3. 执行命令

`mkdir ./target && ncmdump -d ./网易云音乐 && find ./网易云音乐 -type f -name "*.mp3" -print0 | xargs -0 -I {} mv {} ./target`