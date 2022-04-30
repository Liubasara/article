---
name: 《Nginx应用与运维实战》学习笔记（7）
title: 《Nginx应用与运维实战》学习笔记（7）
tags: ["技术","学习笔记","Nginx应用与运维实战"]
categories: 学习笔记
info: "深入设计模式 第4章 Nginx HTTP 模块详解 4.2　访问控制功能模块"
time: 2022/4/26
desc: '深入设计模式, 学习笔记, 第4章 Nginx HTTP 模块详解, 4.2　访问控制功能模块'
keywords: ['Nginx应用与运维实战', '运维', '学习笔记', '第4章 Nginx HTTP 模块详解', '4.2　访问控制功能模块']
---

# 《Nginx应用与运维实战》学习笔记（7）

## 第 4 章 Nginx HTTP 模块详解

### 4.2　访问控制功能模块

#### 4.2.1　访问镜像模块

模块名称：ngx_http_mirror_module

该模块的功能是将用户的访问请求复制到指定的 URI，通过 location 的 URI 匹配，将流量发送到指定的服务器。

镜像请求与实际请求是异步处理的，用户请求的实际请求会直接返回给客户端，而镜像服务器的请求响应则会被 Nginx 服务器丢弃。（个人理解：就是在接收到请求以后，nginx 会额外复制发起一个请求到别的服务器）

1. 指令：mirror 访问镜像指令

   作用域：http、server、location

   默认值：off

   说明：将用户的访问请求镜像到指定的 URI，同级支持多个 URI

   配置样例：

   ```nginx
   http {
     server {
       listen 8080;
       root /opt/nginx-web/www;
       location / {
         mirror /benchmark;
         index index.html;
       }
       location = /benchmark {
         internal;
         proxy_pass http://192.168.2.145$request_uri;
       }
     }
   }
   ```

2. 指令：mirror_request_body  镜像请求体指令

   作用域：http、server、location

   默认值：on

   指令值可选项：on 或 off

   说明：将用户的访问请求体同步镜像到指定的 URI，当启用该指令时，创建镜像子请求前会优先读取并缓存客户端的请求体内容。同时 proxy_request_buffering、fastcgi_request、buffering、segi_request_buffering 和 uwsgi_request_buffering 等指令的不缓存设置将被关闭。如果指令值为 off，则不同步请求体。访问镜像模块可以将用户请求同步到指定的服务器，同时还可以对用户的流量进行放大，通常可以用于压力测试。

   配置样例：

   ```nginx
   server {
     listen 8080;
     server_name localhost;
     root /opt/nginx-web/www;
     mirror_request_body off;
     location / {
       index index.html;
       mirror /accesslog;
     }
     location = /accesslog {
       internal;
       proxy_pass http://192.168.2.145/accesslog/${server_name}_$server_port$request_uri;
     }
   }
   ```

   流量放大配置样例：

   ```nginx
   server {
     listen 8080;
     server_name localhost;
     root /opt/nginx-web/www;
     location / {
       index index.html;
       # 镜像用户请求
       mirror /benchmark;
       mirror /benchmark;
       mirror /benchmark;
     }
     location = /benchmark {
       internal;
       proxy_pass http://192.168.2.145/accesslog/${server_name}_$server_port$request_uri;
     }
   }
   ```

#### 4.2.2 referer 请求头控制模块

模块名称：ngx_http_referer_module

referer 请求头控制模块，可以通过设置请求头中的 Referer 字段来控制访问的拒绝与允许。

Referer 字段用来表示当前请求的跳转来源，虽然通过 Referer 字段进行来源控制并不十分可靠（伪造该字段的内容非常容易），但用在防盗链的场景中还是基本可以满足需求的。该模块的内置配置指令如下所示：

1. 指令：referer_hash_max_size referer 哈希表大小指令

   作用域：server、location

   默认值：2048

   说明：referer 指令中，存储变量的哈希值大小

2. 指令：referer_hash_bucket_size 哈希桶大小指令

   作用域：server、location

   默认值：64

   说明：referer 指令中，存储变量的哈希桶的大小

3. 指令：valid_referers 有效 referer 值指令

   作用域：server、location

   默认值：-

   说明：当 HTTP 头的属性字段 Referer 的值符合指令值的检测时，设置变量 $invalid_referer 为空。$invalid_referer 的值默认为 1，当 Referer 的值与指令值的内容匹配时，$invalid_referer 的值为空。当指令值为正则表达式时，必须以 ~ 开头。

   参数中的选项可以是（以多个值之间以空格进行间隔）：

   - none：Referer 的值为空（表示无Referer值的情况）
   - blocked：代理服务器或防火墙过滤后的 Referer 值，这些值不会以 http:// 或 https:// 开头（表示Referer值被防火墙进行伪装）
   - server_names：Referer 的值包含一个服务器名（表示一个或多个主机名称）

   配置样例：

   ```nginx
   http {
     server {
       listen 8080;
       server_name nginxtest.org;
       root /opt/nginx-web/www;
       # 当Referer为空，或内容不包含主机名为“*.nginxtest.org”时允许访问
       valid_referers none blocked *.nginxtest.org;
       if ($invalid_referer) {
         return 403;
       }
     }
   }
   ```

   #### 4.2.3 连接校验模块

   









> 本次阅读至 314 下次阅读应至 P325