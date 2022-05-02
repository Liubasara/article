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

   模块名称：ngx_http_secure_link_module

   该模块的功能是实际 HTTP 应用程序（PHP 或 JAVA）相结合，实现对用户的访问连接做校验和过期验证功能。常用于访问及文件下载的防盗链实现。

   该模块的功能实现原理如下：

   - HTTP 应用程序计算出唯一的 MD5 字符串和过期时间
   - HTTP 应用程序把计算出的 MD5 字符串和过期时间，以参数的形式与被限制的真实连接组成新的访问连接。
   - 用户单击有 MD5 字符串和过期时间参数的连接后，请求 Nginx 服务器。
   - Nginx 通过 secure_link 指令获取用户访问连接中的 MD5 字符串和过期时间。
   - Nginx 校验过期时间是否过期，当被判断为过期时，设置模块内置参数 $secure_link 的值为 0
   - Nginx 把 MD5 字符串与 secure_link_md5 指令指定格式生成的 MD5 值进行对比，在过期时间内，MD5 被判断为一致时，设置模块内置参数 $secure_link 的值为 1。
   - 模块内置参数 $secure_link 的值默认为空。

   该模块指令实现如下：

   1. 指令：secure_link

      作用域：http、server、location

      默认值：-

      说明：配置访问连接中，用于校验的 MD5 及过期时间的参数名

   2. 指令：secure_link_md5 连接校验 MD5 指令

      作用域：http、server、location

      默认值：-

      说明：配置访问连接中生成的 MD5 格式。

   Nginx 配置样例：

   ```nginx
   http {
     server {
       listen 8083;
       root /opt/nginx-web/phpweb;
       location ~ \.php(.*)$ {
         fastcgi_pass 127.0.0.1:9000;
         fastcgi_index index.php;
         fastcgi_split_path_info ^(.+\.php)(.*)$;
         fastcgi_param PATH_INFO $fastcgi_path_info;
         include fastcgi.conf;
       }
       location /download/ {
         alias /opt/nginx-web/files/;
         # 设置MD5及过期时间的参数为valid和time
         secure_link $arg_valid,$arg_time;
         # MD5计算格式
         secure_link_md5 nginxtest$uri$arg_time;
         if ( $secure_link = "" ) {
           return 403;
         }
         if ( $secure_link = "0" ) {
           return 405;
         }
       }
     }
   }
   ```

#### 4.2.4 源 IP 访问控制模块

模块名称：ngx_http_access_module

该模块可以对客户端的源 IP 地址进行允许或拒接访问控制。该模块的内置配置指令如下：

1. 指令：allow 允许访问指令

   作用域：http、server、location、limit_except

   默认值：-

   说明：允许指定源 IP 的客户端请求访问

2. 指令：deny 拒绝访问指令

   作用域：http、server、location、limit_except

   默认值：-

   说明：拒绝指定源 IP 的客户端请求访问

Nginx 会按照自上而下的顺序进行匹配。

```nginx
http {
  server {
    location / {
      # 禁止 192.168.1.1
      deny 192.168.1.1;
      # 允许 192.168.0.0/24 的 IP 访问
      allow 192.168.0.0/24;
      # 允许 10.1.1.0/16 的 IP 访问
      allow 10.1.1.0/16;
      allow 2001:0db8::/32;
      deny all;
    }
  }
}
```

#### 4.2.5 基本认证模块

模块名称：ngx_http_auth_basic_module

该模块允许使用基于“HTTP 基本认证”协议的用户名和密码对客户端访问请求进行控制。该模块的内置配置指令如下所示：

1. 指令：auth_basic 基本认证指令

   作用域：http、server、location、limit_except

   默认值：off

   说明：启用基本认证功能，并设置基本认证提示信息

2. 指令：auth_basic_user_file 基本认证用户文件指令

   作用域：http、server、location、limit_except

   默认值：-

   说明：指定用于保存基本认证用户的账号及密码文件


当 auth_basic 的指令值为 off 时，可以对当前指令域取消来自上一层指令域的 auth_basic 配置。用户密码可以用 Apache 中的 htpasswd 命令生成。

密码文件格式如下：

```txt
# comment
name1:password1
name2:password2:comment
name3:password3
```

配置样例：

```nginx
location / {
  # 认证提示
  auth_basic "closed site";
  # 认证密码文件 conf.d/htpasswd
  auth_basic_user_file conf.d/htpasswd;
}
```

#### 4.2.6 认证转发模块

模块名称：ngx_http_auth_request_module

认证转发模块允许将认证请求转发给指定的服务器进行处理。启用认证转发后，会将认证需求以子请求的方式转发给指定的服务器。并通过子请求的返回结果判断客户端的认证授权。

如果子请求返回响应码 2XX，则允许授权访问；若访问响应码 401 或 403，则拒绝访问。

auth_request 启用时，需要指定一个内部子请求的 URI。

1. 指令：auth_request 认证转发指令

   作用域：http、server、location

   默认值：off

   说明：启用认证转发功能，并设置转发的目标地址

2. 指令：auth_request_set 认证请求变量设置指令

   作用域：http、server、location

   默认值：off

   说明：完成认证请求后，将认证请求的变量赋值给一个新变量

auth_request 启用时，需要指定一个内部子请求的 URI。

配置样例如下：

```nginx
upstream member_server {
	server 172.16.1.13:8080;
}

server {
  listen       8080;
  server_name  localhost;
  
  location / {
    root   /opt/nginx-web;
    index  index.html index.htm;
	}
  
  location /member {
    # 启用认证转发到 /auth
    auth_request /auth;
    # 认证若返回状态码401，则跳转到 @error401
    error_page 401 = @error401;
    # 将用户名赋予变量 $user
    # auth_request_set $user $upstream_http_x_forwarded_user;

    # 将用户名传递给应用服务
    # proxy_set_header X-Forwarded-User $user;

    # 代理转发到会员服务
    proxy_pass http://member_server;
  }
  
  location /auth {
    internal;
    proxy_set_header Host $host;
    proxy_pass_request_body off;
    proxy_set_header Content-Length "";
    # 将认证信息转发到http://172.16.10.14/auth
    proxy_pass http://172.16.10.14/auth;
  }
  
  location @error401 {
    # 认证失败跳转到登录页
    return 302 http://172.16.10.14/login;
  }
}
```

认证请求变量设置指令同样支持基本认证的转发。当客户端发起请求时，Nginx 会将具有 WWW-Authenticate 的子请求头响应信息转发给客户端，提示用户输入账号、密码。

用户的用户名和密码信息，通过 Base64 编码后写在子请求的请求头中发送给认证请求的服务器。由认证服务器解码后返回相应的响应状态码，配置样例如下：

```nginx
http {
  server {
    listen 8083;
    server_name localhost;
    root /opt/nginx-web;
    auth_request /auth;
    location / {
      index index.html index.htm;
    }
    location /auth {
      proxy_pass_request_body off;
      proxy_set_header Content-Length "";
      proxy_set_header X-Original-URI $request_uri;
      proxy_pass http://192.168.2.145:8080/HttpBasicAuth.php;
    }
  }
}
```

#### 4.2.7 用户 cookie 模块











> 本次阅读至 329 下次阅读应至 P339