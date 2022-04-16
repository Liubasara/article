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
> #注意：若是uri中包含正则表达式，则必须有~或者~*标识

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














> 本次阅读至 232 下次阅读应至 P252