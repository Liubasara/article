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

模块名称：ngx_http_userid_module

cookie 模块的作用是，为客户端设置 cookie 以标识不同的访问用户。可以通过内部变量 $uid_got 和 $uid_set 记录已接收和设置的 cookie。其内置的命令如下：

1. 指令：userid 用户cookie指令

   作用域：http、server、location

   默认值：off

   指令值可选项：on、off、v1 或 log

   说明：设置关闭或启用用户 cookie 及启用的方式

   - 当指令值为 off 时，关闭用户 cookie 接收和记录工嗯呢该
   - 当指令值为 on 时，启用用户 cookie 接收和记录功能，默认为 v2 版本设置 cookie。设置 cookie 的响应头标识为 Set-Cookie2。
   - 当指令值为 log 时，不设置用户 cookie，但对接收到的 cookie 进行记录。

2. 指令：userid_domain 用户 cookie 域指令

   作用域：http、server、location

   默认值：none

   说明：设置用户 cookie 中的域名，none 标识禁用 cookie 的域设置

3. 指令：userid_expires 用户 cookie 过期指令

   作用域：http、server、location

   默认值：off

   指令值可选项：time 或 max 或 off

   说明：设置用户 cookie 的过期时间，time 标识客户端保存 cookie 的时间，max 标识 cookie 的过期时间，默认为会话结束即过期。

4. 指令：userid_mark 用户 cookie 标识指令

   作用域：http、server、location

   默认值：off

   指令值可选项：letter、digit、=、off

   说明：设置用户 cookie 的标识机制，并设置用作标记的字符。该标识机制用于在保存客户标识符的同时，添加或修改 userid_p3p 及 cookie 的过期时间。

   - 用作标记的指令值可以是任意英文字母（区分大小写）、数字或“=”
   - userid_mark 设置完毕后，将与 cookie 中传送的 Base64 格式的标识的第一个字符进行比较。如果不匹配，则重新发送用户标识、userid_p3p 及 cookie 的过期时间。

5. 指令：userid_name 用户 cookie 名称指令

   作用域：http、server、location

   默认值：uid

   说明：设置 cookie 名称

6. 指令：userid_p3p 用户 p3p 指令

   作用域：http、server、location

   默认值：none

   说明：设置是否将 p3p 头属性字段同 cookie 一同发送。P3P 是 W3C 推荐的隐私保护标准，P3P 头属性字段通常用于解决与支持 P3P 协议的浏览器的跨域访问问题。

7. 指令：userid_path 用户 cookie 路径指令

   作用域：http、server、location

   默认值：-

   说明：设置 cookie 路径

8. 指令：userid_service 用户 cookie 源服务器指令

   作用域：http、server、location

   默认值：-

   说明：设置 cookie 的发布服务器，当 cookie 标识符由多个服务器发出时，为确保用户标识符的唯一性，应该为每个服务器分配编号。cookie 版本 1 时默认为 0，cookie 版本 2 时默认为服务器 IP 地址最后 4 个八位字节组成的数字。

配置样例：

```nginx
server {
  listen 8083;
  server_name example.com;
  root /opt/nginx-web;
  auth_request /auth;
  userid on;
  userid_name uid;
  userid_domain example.com;
  userid_path /;
  userid_expires 1d;
  userid_p3p 'policyref="/w3c/p3p.xml", CP="CUR ADM OUR NOR STA NID"';

  location / {
    index index.html index.htm;
    add_header Set-Cookie "username=$remote_user";
  }

  location /auth {
    proxy_pass_request_body off;
    proxy_set_header Content-Length "";
    proxy_set_header X-Original-URI $request_uri;
    proxy_pass http://192.168.2.145:8080/HttpBasicAuth.php;
  }
}
```

#### 4.2.8 并发连接数限制模块

模块名称：ngx_http_limit_conn_module

该模块对访问连接中含有指定变量，且变量值相同的连接进行计数。

指定的变量可以是客户端 IP 地址或请求的主机名等，当计数值达到 limit_connn 指令设定的值时，会对超出并发连接数的连接请求返回指定的响应状态码（503）。

该模块只会对请求头已经完全读取完毕的请求进行计数统计。由于 Nginx 采用的是多进程的架构，所以可以通过共享内存存储计数状态，以实现多个进程间的计数状态共享。

1. 指令：limit_conn_zone 计数存储区指令

   作用域：http

   默认值：-

   说明：设定用于存储设定变量计数的共享内存区域

2. 指令：limit_conn 连接数设置指令

   作用域：http、server、location

   默认值：-

   说明：设置指定变量的最大并发连接数

3. 指令：limit_conn_log_level 连接数日志级别指令

   作用域：http、server、location

   默认值：error

   指令值可选项：info、notice、warn、error

   说明：当指定变量的并发连接数达到最大值，输出日志的级别

4. 指令：limit_conn_status 连接数状态指令

   作用域：http、server、location

   默认值：503

   说明：当指定变量的并发连接数达到最大值，请求返回的状态码

配置样例：

```nginx
http {
  # 对用户IP进行并发计数，将计数内存区命名为addr，设置计数内存区大小为10MB
  limit_conn_zone $binary_remote_addr zone=addr:10m;
  server {
    location /web1/ {
      # 限制用户的并发连接数为1
      limit_conn addr 1;
    }
  }
}
```

- limit_conn_zone 的格式为`limit_conn_zone key zone=name:size`
- limit_conn_zone 的 key 可以是文本、变量或文本与变量的组合
- $binary_remote_addr 为 IPv4 时占用 4B，为 IPv6 时占用 16B。
- limit_conn_zone 中 1MB 的内存空间可以存储 32000 个 32B 或 16000 个 64B 的变量计数状态。
- 变量技术状态在 32 位系统平台占用 32B 或 64B，在 64 位系统平台占用 64B。
- 并发连接数同样支持多个变量的同时统计

配置样例如下：

```nginx
http {
  limit_conn_zone $binary_remote_addr zone=perip:10m;
  limit_conn_zone $server_name zone=perserver:10m;
  server {
    limit_conn perip 10;
    limit_conn perserver 100;
  }
}
```

#### 4.2.9 请求频率限制模块

模块名称：ngx_http_limit_req_module

该模块会对指定变量的请求次数进行技术，当该变量在单位时间内的请求次数进行计数，当请求次数超过设定的数值时，后续的请求会被延时处理。

当被延时处理的请求数超过指定的队列数时，将返回指定的状态码（默认状态码为 503）。

通常该模块被用于限定同一 IP 客户端单位时间内请求的次数。

详细配置指令如下：

1. 指令：limit_req_zone 计数存储区指令

   作用域：http

   默认值：-

   说明：设定用于存储变量请求技术的共享内存区域

2. 指令：limit_req 请求限制设置指令

   作用域：http、server、location

   默认值：-

   指令说明：启用请求限制并进行请求限制的相关配置

3. 指令：limit_req_log_level 请求限制日志级别指令

   作用域：http、server、location

   默认值：error

   指令值可选项：info、notice、warn、error

   说明：当指定变量的并发连接数达到最大值时，输出日志的级别

4. 指令：limit_req_status 请求限制状态指令

   作用域：http、server、location

   默认值：503

   说明：当指定变量的并发连接数达到最大时，请求返回的状态码

配置样例如下：

```nginx
http {
  # 限制访问当前站点的请求数，对站点请求计数，将计数内存区命名为 addr，设置计数内存区大小为10MB，请求限制为 1 秒 1 次
  limit_req_zone $server_name zone=addr:10m rate=1r/s;
  server {
    location /search/ {
      # 同一秒只接收一个请求，其余的立即返回状态码503，直到第2秒才接收新的请求
      limit_req zone=one;
      # 同一秒接收6个请求，其余的返回状态码 503，只处理一个请求，其余5个请求进入队列，每秒向Nginx释放一个请求进行处理，同时允许接收一个新的请求进入队列
      limit_req zone=one burst=5;
      # 同一秒接收6个请求，其余的返回状态码 503，同时处理6个请求，6秒后再接收新的请求
      limit_req zone=one burst=5 nodelay;
    }
  }
}
```

- limit_req_zone 的 rate 参数的作用是对请求频率进行限制，有 r/s（每秒的请求次数）和 r/m（每分钟的请求次数）两个频率单位，1MB 内存大小大约可以存储 16000 个 IP 地址的状态信息
- limit_req 的 burst 参数相当于一个缓冲容器，该容器可以容纳 burst 所设置的数量的请求，没有 nodelay 参数时，将会匀速向 Nginx 释放需要处理的请求。而未进入 burst 容器队列的请求将被返回状态码 503 或由 limit_req_status 指定状态码
- limit_req 的 nodelay 参数是指对于请求队列中的请求立即进行处理
- 请求品率同样支持多个变量的同时计数以及叠加，配置样例如下：

```nginx
http {
  limit_req_zone $binary_remote_addr zone=perip:10m rate=1r/s;
  limit_req_zone $server_name zone=perserver:10m rate=10r/s;

  server {
    limit_req zone=perip burst=5 nodelay;
    limit_req zone=perserver burst=10;
  }
}
```