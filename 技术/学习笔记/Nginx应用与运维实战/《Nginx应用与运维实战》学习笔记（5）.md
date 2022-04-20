---
name: 《Nginx应用与运维实战》学习笔记（5）
title: 《Nginx应用与运维实战》学习笔记（5）
tags: ["技术","学习笔记","Nginx应用与运维实战"]
categories: 学习笔记
info: "深入设计模式 第3章 Nginx核心配置指令 3.3 HTTP核心配置指令(2) location 指令详解"
time: 2022/4/16
desc: '深入设计模式, 学习笔记, 第3章 Nginx核心配置指令 3.3 HTTP核心配置指令(2)'
keywords: ['Nginx应用与运维实战', '运维', '学习笔记', '第3章 Nginx核心配置指令', '3.3 HTTP核心配置指令(2)']
---

# 《Nginx应用与运维实战》学习笔记（5）

## 第3章 Nginx核心配置指令

### 3.3 HTTP核心配置指令(2)

#### 3.3.3 访问路由location

URI，统一标识资源符，通用的 URI 语法格式如下：

```txt
scheme:[//[user[:password]@]host[:port]][/path][?query][#fragment]
```

- 在 Nginx 的应用场景中，URL 和 URI 并无明确区别。实际上，URL 是 URI 的一个子集。
- scheme 是 URI 请求时遵守的协议，常见的有 HTTP、HTTPPS、FTP
- host[:port] 是主机名与端口号。HTTP 协议的默认端口是 80，HTTPS 协议的默认端口是 443
- [/path]是访问路径与访问文件名
- [?query]是访问参数，参数以 “?” 开始，由多个 "&" 符号连接的 key=value 形式的字符串组成

**1. location URI 匹配规则**

`location`是 Nginx 对 HTTP 请求中的 URI 进行匹配处理的指令，其语法形式如下：

```txt
location [=|~|~*|^~|@] pattern { ... }
```

其中，`[=|~|~*|^~|@]`这一部分称为 location 的修饰语（Modifier），修饰语定义了与 URI 的匹配方式。pattern 为匹配项，可以是字符串或者正则表达式。修饰语详解如下：

1. 无修饰语：完全匹配 URI 中除了访问参数以外的内容，匹配的内容只能是字符串，不能是正则表达式

   ```nginx
   location /images {
     root /data/web;
   }
   ```

2. 修饰语`=`：完全匹配 URI 中除了访问参数以外的内容，Linux 系统下会区分大小写，Windows 系统下则不会。

   ```nginx
   location = /images {
     root /data/web;
   }
   ```

3. 修饰语`~`：完全匹配 URI 中除了访问参数以外的内容，Linux 系统下会区分大小写，Windows 系统下不会。匹配项的内容必须是正则表达式。

   ```nginx
   location ~ /images/.*\.(gif|jpg|png)$ {
     root /data/web;
   }
   ```

4. 修饰语`~*`：完全匹配 URI 中除了访问参数以外的内容，不区分大小写。匹配项的内容必须是正则表达式。

   ```nginx
   location ~* \.(gif|jpg|png)$ {
     root /data/web;
   }
   ```

5. 修饰语`^~`：完全匹配 URI 中除了访问参数以外的内容，匹配项的内容如果不是正则表达式，则不再进行正则表达式测试。

   ```nginx
   location ^~ /images {
     root /data/web;
   }
   ```

6. 修饰语`@`：定义一个只能内部访问的 location 区域，可以被其他内部跳转指令使用，如 try_files 或 error_page。

   ```nginx
   location @images {
     proxy_pass http://images;
   }
   ```

> 个人理解：
>
> `=` : 用于**不含**正则表达式的uri前，要求请求字符串与uri严格匹配，若成功则停止搜索并立即处理该请求
> `~` : 用于表示uri的正则表达式，并且区分大小写
> `~*` : 用于表示uri的正则表达式，并且不区分大小写
> `^~` : 用于**不含**正则表达式的uri前, 找到匹配度最高的location后，立即处理请求，不再做uri中的正则匹配
> 注意：若是uri中包含正则表达式，则必须有~或者~*标识

**2. 匹配顺序**

1. 先检测非正则表达式修饰语的 location，再检测正则表达式修饰语的 location
2. 如果匹配项内容为正则与非正则都匹配的 location，则按照正则匹配的 location 执行
3. 所有匹配项的内容均为非正则表达式的话，按照匹配项内容完全匹配的内容长短进行匹配，即匹配内容越多的 location 被执行
4. 所有匹配项的内容均为正则表达式的 location，则按照书写的先后顺序进行匹配，先匹配则先执行，不再做后续检测。

**3. 其他事项**

当 location 为正则匹配，且内部有 proxy_pass 指令的时候，proxy_pass 的指令值不能包含无变量的字符。修饰语`^~`不受该规则限制。

```nginx
location ~ /images {
  # 正确
  proxy_pass http://127.0.0.1:8080;
  # 正确
  proxy_pass http://127.0.0.1:8080$request_uri;
  # 正确
  proxy_pass http://127.0.0.1:8080/image$request_uri;
  # 错误
  proxy_pass http://127.0.0.1:8080/;
}
```

**4. 访问路由指令**

1. 指令：merge_slashes 合并空斜线指令

   作用域：http、server、location

   默认值：on

   指令值选项：off 或 on

   说明：当指令值为 on，在访问路径相邻斜线内容为空时进行合并

   配置样例：

   ```nginx
   http {
     merge_slashes off;
   }
   ```

2. 指令：server_name_in_redirect 跳转主机名指令

   作用域：http、server、location

   默认值：off

   说明：默认情况，Nginx 重定向时，会用当前 server 的主机 IP 与 path 拼接成完整的 URL 进行重定向。开启该参数后，Nginx 会先查看当前指令域中 server_name 的第一个主机名，如果没有，会查找请求头中 host 字段的内容。如果再没有则会用 IP 与 path 进行拼接。

   ```nginx
   http {
     server_name_in_redirect on;
   }
   ```

3. 指令：port_in_redirect 跳转端口指令

   作用域：http、server、location

   默认值：on

   说明：Nginx 重定向，会用当前 server 指令域的监听端口与主机拼接成完整的 URL 进行重定向。当指令值为 off 时，则默认用 80 端口。

   ```nginx
   http {
     port_in_redirect on;
   }
   ```
   
4. 指令：subrequest_output_buffer_size 子请求输出缓冲区大小指令

   作用域：http、server、location

   默认值：4k 或 8k

   说明：设置用于存储子请求响应报文的缓冲区大小，默认值与操作系统的内存页大小一致

   ```nginx
   http {
     subrequeset_output_buffer_size 64K;
   }
   ```

5. 指令：absolute_redirect 绝对跳转指令

   作用域：http、server、location

   默认值：on

   指令值选项：off 或 on

   说明：Nginx 发起的重定向使用绝对路径进行跳转，即使用主机名和端口及访问路径的方式。如果关闭，则跳转默认相对当前请求的主机名和端口的访问路径。

   配置样例：

   ```nginx
   http {
     absolute_redirect off;
   }
   ```

6. 指令：msie_refresh 

   作用域：http、server、location

   默认值：on

   指令值选项：on 或 off

   说明：Nginx 处理跳转或刷新的方式通常是返回 3XX 状态码来实现。而该指令能让返回时在 HTML 头部添加如下内容：

   ```html
   <meta http-equiv="Refresh" content="0;" url=*>
   ```

   配置样例：

   ```nginx
   http {
     msie_refresh off;
   }
   ```

#### 3.3.4 访问重写 rewrite

rewrite 模块内置了类似脚本语言的 set、if、break、return 配置指令。通过这些指令，用户在 HTTP 请求处理过程中可以对 URI 进行更灵活的操作控制。rewrite 模块提供的指令可以分为两类：

- 标准配置指令，这部分指令只对指定的操作进行相应的操作控制
- 脚本指令，可以在 HTTP 指令域内以类似脚本变成的形式进行编写

**1. 标准配置指令**

1. 指令：rewrite_log      rewrite 日志记录指令

   作用域：http、server、location

   默认值：off

   指令值选项：on 或 off

   说明：当指令值为 on 时，rewrite 的执行结果会以 notice 级别记录到 Nginx 的 error 日志文件中

   配置样例：

   ```nginx
   http {
     rewrite_log off;
   }
   ```

2. 指令：uninitialized_variable_warn 未初始化变量告警日志记录指令

   作用域：http、server、location

   默认值：on

   指令值选项：on 或 off

   说明：指令值为 on 时，会将未初始化的变量告警记录到日志中。

   配置样例：

   ```nginx
   http {
     uninitialized_variable_warn off;
   }
   ```

3. 指令：rewrite 重定向指令

   作用域：server、location

   默认值：on

   指令值选项：on 或 off

   说明：对用户的 URI 用正则表达式的方式进行重写，并跳转到新的 URI。rewrite 访问重写的语法格式如下

   ```txt
   rewrite regex replacement [flag];
   ```

   其中：

   1. regex 是 PCRE 语法格式的正则表达式
   2. replacement 是重写 URI 的改写规则。当改写规则以 http、https 或 $scheme 开头时，Nginx 重写该语句后将停止执行后续任务，并将改写后的 URI 跳转返回客户端
   3. flag 是执行该条重写指令后的操作控制符，控制符有以下 4 种：
      - last：执行完当前重写规则跳转到新的 URI 后，继续执行后续操作
      - break：执行完当前重写规则跳转到新的 URI 后，不再执行后续操作，不影响用户浏览器的 URI 显示
      - redirect：返回响应状态码 302 的临时重定向，返回内容是重定向 URI 的内容，但是浏览器网址仍然是请求时的 URI
      - permanent：返回响应码 301 的永久重定向，返回内容是重定向 URI 的内容，浏览器网址变为重定向的 URI。

   配置样例：

   ```nginx
   http {
     rewrite ^/user/(.*)$ /show?user=$1 last;
   }
   ```

**2. 脚本指令**

常见的脚本指令如下：

1. 指令：set 设置变量指令

   作用域：server、location、if

   说明：set 指令，可以用来定义变量

   配置样例：

   ```nginx
   http {
     server {
       set $test "check";
     }
   }
   ```

   完整样例：

   用 set 指令创建变量后，变量名是 Nginx 配置全局可用的。但变量值只有在该变量赋值操作的 HTTP 处理流程中可用。

   ```nginx
   http {
     server {
       listen 8080;
       location /foo {
         set $a hello;
         rewrite ^ /bar;
       }
       location /bar {
         # 如果这个请求来自 /foo，$a 的值是 hello。如果直接访问 /bar，$a 的值为空
         if ( $a = "hello" ) {
           rewrite ^ /newbar
         }
       }
     }
   }
   ```

   当 set 指令后只有变量名时，系统会自动创建该变量，变量值为空。

   ```nginx
   http {
     server {
       set $test;
     }
   }
   ```

   变量插值如下：

   ```nginx
   http {
     server {
       set $test "check";
       if ( "${test}nginx" = "nginx" ) {
         # ${test}nginx的值为"check nginx"
       }
     }
   }
   ```

2. 指令：if 条件判断指令

   作用域：server、location

   说明：条件判断指令

   - 当判断条件为一个变量时，变量值为空或以 0 开头的字符串都被判断为 false
   - 变量内容字符串比较操作运算符为 “=” 或 “!=”
   - 进行正则表达式比较时，有以下 4 个操作运算符：
     - `~`：区分大小写匹配
     - `~*`：不区分大小写匹配
     - `!~*`：区分大小写不匹配
     - `!~*`：不区分大小写不匹配
   - 进行文件或目录比较时，有以下 4 个操作运算符：
     - `-f`：判断文件是否存在，可在运算符前加`!`表示反向判断，下同。
     - `-d`：判断目录是否存在
     - `-e`：判断文件、目录或连接符号是否存在
     - `-x`：判断文件是否为可执行文件
   
   配置样例：
   
   ```nginx
   http {
     server {
       if ($http_cookie ~* "id=([^;]+)(?:;|$)") {
         set $id $1;
       }
     }
   }
   ```
   
3. 指令：break  终止指令

   作用域：server、location、if

   说明：终止后续指令的执行

   配置样例：

   ```nginx
   http {
     server {
       if ($slow) {
         limit_rate 10k;
         break;
       }
     }
   }
   ```

4. 指令：return  跳转指令

   作用域：server、location、if

   说明：向客户端返回状态码或执行跳转

   配置样例：

   ```nginx
   http {
     server {
       if ($request_method = POST) {
         return 405;
       }
     }
   }
   ```

   return 的指令值有以下 4 种方式：

   - return code：向客户端返回指定 code 的状态码，当返回非标准的状态码 444 时，Nginx 直接关闭连接，不发送响应头信息。
   - return code text：向客户端发送带有指定 code 状态码和 text 内容的响应信息。因要在客户端显示 text 内容，所以 code 不能是 30x
   - return code URL：这里的 URL 可以是内部跳转或变量 $uri，也可以是有完整 scheme 标识的 URL，将直接返回给客户端执行跳转，code 只能是 30X
   - return URL：此时默认的 code 为 302，URL 必须是有完整 scheme 标识的 URL。

   return 指令也可以用来调试输出 Nginx 的变量

#### 3.3.5 访问控制

HTTP 核心配置指令中提供了基本的控制功能配置，如：禁止访问、传输限速、内部控制访问等等。配置指令如下所示：

1. 指令：limit_expect 请求方法排除限制指令

   作用域：http、server、location

   默认值：-

   说明：对指定方法以外的所有请求方法进行限定

   配置样例：

   ```nginx
   http {
     limit_except GET {
       # 允许 192.168.1.0/24 范围的IP使用非GET的方法
       allow 192.168.1.0/24;
       # 禁止其他所有来源IP的非GET请求
       deny all;
     }
   }
   ```

2. 指令：satisfy 组合授权控制指令

   作用域：http、server、location

   默认值：all

   指令值选项：all 或 any

   说明：默认情况下（指令值为 all 时），在响应客户端请求时，只有当 ngx_http_access_module、ngx_http_auth_basic_module、ngx_http_auth_request_module、ngx_http_auth_jwt_module 模块被限定的访问控制条件**都**符合时，才允许授权访问。当指令值为  any 时，只要符合上述模块的任一一个，则认为可以授权访问。

   配置样例：

   ```nginx
   location / {
     satisfy any;
     allow 192.168.1.0/32;
     deny all;
     
     auth_basic "closed site";
     auth_basic_user_file conf/htpasswd;
   }
   ```

3. 指令：internal 内部访问指令

   作用域：http、server、location

   默认值：-

   说明：限定 location 的访问路径来源为内部访问请求，否则返回响应状态吗 404

   1）Nginx 限定以下几种类型为内部访问：

   - 由 error_page 指令、index 指令、random_index 指令和 try_files 指令发起的重定向请求。
   - 响应头中由属性 X-Accel-Redirect 发起的重定向请求，等同于 X-sendfile，常用于下载文件控制的场景中。
   - ngx_http_ssi_module 模块的 include virtual 指令、ngx_http_addition_module 模块、auth_request 和 mirror 指令的子请求。
   - 用 rewrite 指令对 URL 进行重写的请求。

   2）内部请求的最大访问次数是 10 次，以防错误配置引发内部循环请求。超过限定次数将返回响应状态码 500。

   配置样例：

   ```nginx
   http {
     server {
       error_page 404 /404.html;
       location = /404.html {
         internal;
       }
     }
   }
   
   ```

4. 指令：limit_rate 响应限速指令

   作用域：http、server、location

   默认值：0

   说明：服务端响应请求后，被限定传输速率的大小。速率是以字节/秒为单位指定的，0 值表示禁用速率限制。响应速率也可以在 proxy_pass 的响应头属性 X-Accel-Limit_Rate 字段中设定。可以通过 proxy_ignore_headers、fastcgi_ignore_headers、uwsgi_ignore_headers 和 scgi_ignore_headers 指令禁用此项功能。

   配置样例：

   ```nginx
   server {
     location /flv/ {
       flv;
       # 当传输速率到 500KB/s 时执行限速
       limit_rate_after 500k;
       # 限速速率为 50KB/s
       limit_rate 50k;
       # 在 Nginx 1.17.0 以后的版本中，参数值可以是变量
       map $slow $rate {
         1 4k;
         2 8k;
       }
       limit_rate $rate;
     }
   }
   ```

5. 指令：limit_rate_after 响应最大值后限速指令

   作用域：http、server、location

   默认值：0

   说明：服务端响应请求后，当向客户端的传输速率达到指定值时，按照响应限速指令进行限速。

   配置样例：

   ```nginx
   location /flv/ {
     flv;
     limit_rate_after 500k;
     limit_rate 50k;
   }
   ```

#### 3.3.6 数据处理

数据处理指令包括：对本地文件的位置进行配置，读写并返回执行结果的操作。

**1. 文件位置**

1. 指令：root 根目录指令

   作用域：http、server、location

   默认值：on

   说明：设定请求 URL 的本地文件根目录。

   - 当 root 指令在 location 指令域时，root 设置的时 location 匹配访问路径的上一层目录，如下样例中，被请求文件的实际本地路径为：/data/web/flv/
   - location 中的路径是否带 “/”，对本地路径的访问无任何影响

   配置样例：

   ```nginx
   location /flv/ {
     root /data/web;
   }
   ```

2. 指令：alias 访问路径别名指令

   作用域：location

   默认值：-

   说明：默认情况下，本地文件的路径是 root 指令设定根目录的相对路径。通过 alias 指令可以将匹配的访问路径重新指定为新定义的文件路径。

   - alias 指定的目录是 location 路径的实际目录
   - 其所在的 location 的 rewrite 指令不能使用 break 参数

   配置样例：

   ```nginx
   server {
     listen 8080;
     server_name www.nginxtest.org;
     root /opt/nginx-web/www;
     location /flv/ {
       alias /opt/nginx-web/flv/;
     }
     location /js {
       alias /opt/nginx-web/js;
     }
     location /img {
       alias /opt/nginx-web/img/;
     }
   }
   ```

3. 指令：try_files 文件判断指令

   作用域：server、location

   默认值：-

   说明：用于顺序检查指定文件是否存在，如果不存在，就按照最后一个指定 URI 做内部跳转。

   配置样例：

   ```nginx
   http {
     server {
       location /images/ {
         # $uri 存在则执行代理的上游服务器操作，否则就跳转到 default.gif 的 location
         try_files $uri /images/default.gif;
       }
       location = /images/default.gif {
         expires 30s;
       }
     }
   }
   ```

   跳转的目标也可以是一个 location 区域，脚本如下：

   ```nginx
   http {
     server {
       location / {
         try_files /system/maintenance.html $uri $uri/index.html $uri.html @mongrel;
       }
       location @mongrel {
         proxy_pass http://mongrel;
       }
     }
   }
   ```

4. 指令：disable_symlinks 禁止符号链接文件指令

   作用域：http、server、location

   默认值：off

   说明：用于设置当读取的本地文件是符号链接文件时的处理方式。

   - 当指令值为 off 时，允许本地路径中出现符号链接文件。
   - 当指令值为 on 时，若本地路径中出现符号链接文件，则拒绝访问
   - 当指令值为 if_not_owner 时，若本地路径中出现符号链接文件，且符号链接文件和源文件的所有者不同，则拒绝访问。
   - 当指令值是 on 或 if_not_owner 时，可通过参数 from=part 设定检查符号链接的起始路径，但不会检查指定的路径本身。

   配置样例：

   ```nginx
   http {
     disable_symlinks off;
   }
   ```

**2. 数据读写及返回**

1. 指令：read_ahead 预读文件大小指令

   作用域：http、server、location

   默认值：0

   说明：该指令只在特定系统下有效（在 Linux 系统中无效），开启下会按照算法将文件从硬盘读取到内核缓冲区中。

   配置样例：

   ```nginx
   http {
     read_ahead 32k;
   }
   ```

2. 指令：open_file_cache 打开文件缓存指令

   作用域：http、server、location

   默认值：off

   说明：用于配置文件缓存，默认为关闭文件缓存

   - 开启缓存时，可以缓存打开文件的描述符、大小和修改时间，目录的查询结果，文件查找时的错误结果
   - 参数 max 用于设定缓存中的元素的最大数量，当缓存溢出，使用 LRU 算法删除缓存中的元素
   - 参数 inactive 用于设定在一段时间内元素没有被访问，将被从缓存中删除，默认为 60s

   配置样例：

   ```nginx
   http {
     open_file_cache max=1000 inactive=20s;
   }
   ```

3. 指令：open_file_cache_errors 打开文件查找错误缓存指令

   作用域：http、server、location

   默认值：off

   指令值可选项：off 或 on

   说明：用于设定在开启 open_file_cache 时，是否对文件查找错误的结果进行缓存

   配置样例：

   ```nginx
   http {
     open_file_cache max=1000 inactive=20s;
     open_file_cache_errors on;
   }
   ```

4. 指令：open_file_cache_min_uses 打开文件缓存最小访问次数指令

   作用域：http、server、location

   默认值：1

   说明：用于设定在被打开文件的缓存中，处于打开状态的文件在 inactive 时间段内，被访问的最小次数。

   配置样例：

   ```nginx
   http {
     open_file_cache max=1000 inactive=20s;
     open_file_cache_errors on;
     open_file_cache_min_uses 2;
   }
   ```

5. 指令：open_file_cache_valid  打开文件缓存有效性检查指令

   作用域：http、server、location

   默认值：60s

   说明：在设定的时间后对缓存的源文件进行一次检查，确认是否被修改

   配置样例：

   ```nginx
   http {
     open_file_cache max=1000 inactive=20s;
     open_file_cache_errors on;
     open_file_cache_min_uses 2;
     open_file_cache_valid 30s;
   }
   ```

6. 指令：sendfile  零复制指令

   作用域：http、server、location

   默认值：off

   指令值选项：on 或 off

   说明：启用 sendfile，这是读取本地文件后，向网络连接发送文件内容的文件传输机制。零复制技术利用内核提供的机制，减少了文件的读写次数，提升了本地文件的网络传输速度。内核缓冲区的默认大小为 4096 B。

   配置样例：

   ```nginx
   http {
     sendfile on;
   }
   ```

7. 指令：sendfile_max_chunk  零复制最大传输限制指令

   作用域：http、server、location

   默认值：0

   说明：当零复制技术因为数据量太大而占用了 Nginx 工作进程的全部资源，可以通过该指令限制复制过程中每个连接的最大传输量。

   配置样例：

   ```nginx
   http {
     sendfile on;
     sendfile_max_chunk 1m;
   }
   ```

8. 指令：tcp_nopush  零复制最小传输限制指令

   作用域：http、server、location
   
   默认值：off
   
   指令值选项：on 或 off
   
   说明：当数据包太小时进行网络发送会相对消耗过多的网络资源，通过该指令，可以限定只有当数据包大于最大报文长度（Maximum Segment Size，MSS）时才执行网络发送操作，从而提升利用率。MSS 的默认大小为 MTU 的最小值减去 40B（IP 和 TCP 首部固定长度），通常为 1460B。
   
   配置样例：
   
   ```nginx
   http {
     sendfile on;
     sendfile_max_chunk 1m;
     tcp_nopush on;
   }
   ```
   
9. 指令：directio 直接I/O读取指令

   作用域：http、server、location

   默认值：off

   指令值选项：size 或 off

   说明：开启该指令，任何大于或等于指令值大小的文件都将采用直接 IO 的方式进行读取，也就是可以跳过内核的文件缓存机制，直接从硬盘读取数据，缓存到 Nginx 的文件缓冲区。从而更好利用 CPU 资源并提高缓存效率，适合大文件读取场景。

   配置样例：

   ```nginx
   http {
     directio 5m;
   }
   ```

10. 指令：directio_alignment 直接I/O读取块大小指令

    作用域：http、server、location

    默认值：512

    指令值选项：size 或 off

    说明：Nginx 直接以 IO 方式读取大文件时，最佳的硬盘直接读取效率是每次可以读取磁盘的一整块（block）大小，也就是所谓的“对齐”。默认的 512 字节可以覆盖多数文件系统的块大小，在 XFS 登文件系统下，则需要调整为 4096 字节。

    - CentOS 系统下查看当前磁盘的文件系统指令如下：

      ```shell
      df -T
      ```

    - CentOS 系统下可以通过如下命令查看当前系统的块大小（block  size）：

      ```shell
      tune2fs -l /dev/sda1|grep Block # Ext文件系统
      xfs_info /dev/sda1 # XFS文件系统
      ```

    配置样例：

    ```nginx
    http {
      directio_alignment 4096;
    }
    ```

11. 指令：output_buffers 输出文件缓冲区大小指令

    作用域：http、server、location

    默认值：2 32k

    说明：Nginx 在将磁盘文件读取到内存并发送至客户端的过程中，为了避免由读文件与网络发送速度之间的差异引起的阻塞，增加了一个输出文件缓冲区。该缓冲区默认是由 2 个 32 K 的缓冲区，构成的 64K 缓冲区组。指令值的两个参数分别为：缓冲区的数量，缓冲区的大小。多用于大文件传输的输出场景。

12. 指令：aio

    作用域：http、server、location

    默认值：off

    指令值选项：on 或 off 或 threads[=pool]

    说明：启用或关闭异步文件 IO 指令，Liunx 版本下必须配合 directio 指令使用。

    - 异步文件传输是通过直接读取硬盘文件的方式实现的，对于大文件的传输速度有明显提升，但对于小文件，仍然建议使用零复制方式实现文件传输。
    - 当指令值为 threads 时，不指定 pool 表示使用默认线程池，也可以使用自定义线程池。

    配置样例：

    ```nginx
    http {
      # 启用异步 IO
      aio on;
      # 当文件大小小于 2M，启用直接读取模式
      directio 2m;
      # 与当前文件系统对齐
      directio_alignment 4096;
      # 输出缓冲区为 384K
      output_buffers 3 128k;
      # 小于 2M 的文件用零复制方式处理
      sendfile on;
      # 零复制时最大传输大小为 1M
      sendfile_max_chunk 1m;
      # 零复制时启用最小传输限制功能
      tcp_nopush on;
    }
    ```

    自定义线程池：

    ```nginx
    http {
      thread_pool pool_1 threads=16;
      aio threads=pool_1;
      directio 2m;
    }
    ```

13. 指令：aio_write 异步文件 IO 写指令

    作用域：http、server、location

    默认值：off

    指令值选项：on 或 off

    说明：在启用 aio 指令时是否支持异步写操作。目前仅在使用 aio 线程，且仅限于被代理服务接收到的数据写入到临时文件的场景。

    配置样例：

    ```nginx
    http {
      aio on;
      aio_write on;
    }
    ```

14. 指令：send_timeout 发送超时指令

    作用域：http、server、location

    默认值：60s

    说明：Nginx 在向客户端发送数据时，从缓存快读取数据并向网络接口执行写出（发送也是一种写操作），如果连续两次写操作的时间超出该指令的指令值，则认为发送超时。

    配置样例：

    ```nginx
    http {
      send_timeout 20s;
    }
    ```

15. 指令：postpone_output 推迟发送指令

    作用域：http、server、location
    
    默认值：1460
    
    说明：只有当需要发送到客户端的数据达到设定值时才会发送数据。指令值为 0 时，表示关闭推迟发送功能。
    
    配置样例：
    
    ```nginx
    http {
      postpone_output 2048;
    }
    ```
    
16. 指令：chenked_transfer_encoding 分块传输编码指令

    作用域：http、server、location

    默认值：on

    选项：on 或 off

    说明：该指令会在响应头中增加 Transfer-Encoding: chunked 字段，用以告知客户端分块接收响应体数据。该指令关闭后，客户端会根据响应头中 Content-length 属性的值获知响应体的大小，并以此判断数据是否接收完毕。

    配置样例：

    ```nginx
    http {
      chunked_transfer_encoding off;
    }
    ```

