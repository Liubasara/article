---
name: 《Nginx应用与运维实战》学习笔记（6）
title: 《Nginx应用与运维实战》学习笔记（6）
tags: ["技术","学习笔记","Nginx应用与运维实战"]
categories: 学习笔记
info: "深入设计模式 第3章 Nginx核心配置指令 3.3 HTTP核心配置指令(3) 关闭连接 第4章 Nginx HTTP 模块详解"
time: 2022/4/20
desc: '深入设计模式, 学习笔记, 第3章 Nginx核心配置指令 3.3 HTTP核心配置指令(3) 第4章 Nginx HTTP 模块详解'
keywords: ['Nginx应用与运维实战', '运维', '学习笔记', '第3章 Nginx核心配置指令', '3.3 HTTP核心配置指令(3)', '第4章 Nginx HTTP 模块详解']
---

# 《Nginx应用与运维实战》学习笔记（6）

## 第3章 Nginx核心配置指令

### 3.3 HTTP核心配置指令(3)

#### 3.3.7 关闭连接

延迟关闭控制指令如下：

1. 指令：lingering_close  延迟关闭控制指令

   作用域：http、server、location

   默认值：on

   选项：on 或 off 或 always

   说明：设置 Nginx 关闭客户端连接时是否对客户端发送的额外数据进行处理（接收并忽略）

   - on：在可预知客户端仍将有数据发送时，等待并处理（接收并忽略）客户端发来的额外数据。
   - always：一直等待并处理客户端发来的外数据
   - off：强制关闭连接

   配置样例：

   ```nginx
   http {
     lingering_close always;
   }
   ```

2. 指令：lingering_time 延迟关闭处理时间指令

   作用域：http、server、location

   默认值：30s

   说明：在 ingering_close 指令有效时，Nginx 处理客户端额外数据的最大时间，超过最大设定时间将强制关闭连接。

   配置样例：

   ```nginx
   http {
     lingering_time 60s;
   }
   ```

3. 指令：lingering_timeout 延迟关闭超时指令

   作用域：http、server、location

   默认值：5s

   说明：在 lingering_close 有效时，用于设置客户端额外数据到达 Nginx 的最大超时时间，超过设定时间则关闭连接，否则直到总处理时间超过该设定的时间才关闭连接。

   配置样例：

   ```nginx
   http {
     lingering_timeout 10s;
   }
   ```

4. 指令：reset_timeout_connection 重置超时连接指令

   作用域：http、server、location

   默认值：on

   选项：on 或 off

   说明：当 Nginx 正常发起主动关闭连接请求时，为避免无效的内存占用，Nginx 会在连接超时的时候，通过设置 setsockopt 函数的参数 SO_LINGER 为 0 来关闭这个连接。

#### 3.3.8 日志记录

日志记录指令如下所示：

1. 指令：log_not_found

   作用域：http、server、location

   默认值：on

   选项：on 或 off

   说明：用于设定如果文件不存在是否写入日志

   配置样例：

   ```nginx
   http {
     log_not_found on;
   }
   ```

2. 指令：log_subrequest

   作用域：http、server、location

   默认值：on

   选项：on 或 off

   说明：用于设定子请求的访问记录是否写入日志

   ```nginx
   http {
     log_subrequest on;
   }
   ```

#### 3.3.9 HTTP 核心配置样例

为了方便读者理解 HTTP 配置指令的功能和使用方法，下面列举了一批常用的详细配置（切勿将其直接用于实际生产环境）

> PS： 原版的排版一塌糊涂

```nginx
http {
  # 全局域名解析服务器为192.168.2.11，30s更新一次DNS缓存
  resolver 192.168.2.11 valid=30s;

  # 域名解析超时时间为10s
  resolver_timeout 10s;
  # Nginx变量的hash表的大小为1024字节
  variables_hash_max_size 1024;
  # Nginx变量的hash表的哈希桶的大小是64字节
  variables_hash_bucket_size 64;
  # MIME类型映射表哈希表的大小为1024字节
  types_hash_max_size 1024;
  # MIME类型映射表哈希桶的大小是64字节
  types_hash_bucket_size 64;

  # 请求解析，HTTP全局有效

  # 忽略请求头中无效的属性名
  ignore_invalid_headers on;
  # 允许请求头的属性名中有下划线“_”
  underscores_in_headers on;
  # 客户请求头缓冲区大小为2KB
  client_header_buffer_size 2k;


  # 超大客户请求头缓冲区大小为64KB
  large_client_header_buffers 4 16k;
  # 读取客户请求头的超时时间是30s
  client_header_timeout 30s;
  # 请求池的大小是4K
  request_pool_size 4k;
  # 当URI中有连续的斜线时做合并处理
  merge_slashes on;
  # 当返回错误信息时，不显示Nginx服务的版本号信息
  server_tokens off;
  # 当客户端请求出错时，在响应数据中添加注释
  msie_padding on;
  # 子请求响应报文缓冲区大小为8KB
  subrequest_output_buffer_size 8k;
  # Nginx主动关闭连接时启用延迟关闭
  lingering_close on;
  # 延迟关闭的处理数据的最长时间是60s
  lingering_time 60s;
  # 延迟关闭的超时时间是5s
  lingering_timeout 5s;
  # 当Nginx主动关闭连接而客户端无响应时，在连接超时后进行关闭
  reset_timedout_connection on;
  # 将未找到文件的错误信息记录到日志中
  log_not_found on;
  # 将子请求的访问日志记录到访问日志中
  log_subrequest on;
  # 所有请求的404状态码返回404
  error_page 404 /404.html;.html文件的数据
  # 所有请求的500、502、503、504状态码返回50×.html文件的数据
  error_page 500 502 503 504 /50x.html;

  server {
    # 监听本机的8000端口，当前服务是http指令域的主服务，开启fastopen功能并限定最大队列数是 30
    # 拒绝空数据连接，Nginx工作进程共享socket监听端口，当请求阻塞时挂起队列数是1024
    # 个，当socket为保持连接时，开启状态检测功能
    listen *:8000 default_server fastopen=30 deferred reuseport backlog=1024 so_keepalive=on;
    server_name a.nginxbar.com b.nginxtest.net c.nginxbar.com a.nginxbar.com;
    # 服务主机名哈希表大小为1024字节
    server_names_hash_max_size 1024;
    # 服务主机名哈希桶大小为128字节
    server_names_hash_bucket_size 128;


    # 保持链接配置
    # 对MSIE6版本的客户端关闭保持连接机制
    keepalive_disable msie6;
    # 保持连接可复用的HTTP连接为1000个
    keepalive_requests 1000;
    # 保持连接空置超时时间为60s
    keepalive_timeout 60s;
    # 当处于保持连接状态时，以最快的方式发送数据包
    tcp_nodelay on;


    # 本地文件相关配置
    # 当前服务对应本地文件访问的根目录是/data/website
    root /data/website;
    # 对本地文件路径中的符号链接不做检测
    disable_symlinks off;


    # 静态文件场景
    location / {
      # 在重定向时，拼接服务主机名
      server_name_in_redirect on;
      # 在重定向时，拼接服务主机端口
      port_in_redirect on;

      # 当请求头中有if_modified_since属性时， 与被请求的本地文件修改时间做精确匹配处理
      if_modified_since exact;

      #启用etag功能
      etag on;
      # 当客户端是msie时，以添加HTML头信息的方式执行跳转
      msie_refresh on;
      # 对被打开文件启用缓存支持，缓存元素数最大为1000个，不活跃的缓存元素保存20s
      open_file_cache max=1000 inactive=20s;


      #对无法找到文件的错误元素也进行缓存
      open_file_cache_errors on;
      #缓存中的元素至少要被访问两次才为活跃
      open_file_cache_min_uses 2;
      #每60s对缓存元素与本地文件进行一次检查
      open_file_cache_valid 60s
    }
    # 上传接口的场景应用
    location /upload {
      # 将upload的请求重定位到目录/data/upload
      alias /data/upload
      limit_except GET {
        # 允许192.168.100.1执行所有请求方法
        allow 192.168.100.1;
        #其他IP只允许执行GET方法
        deny all;
      }
      # 允许上传的最大文件大小是200MB
      client_max_body_size 200m;
      # 上传缓冲区的大小是16KB
      client_body_buffer_size 16k;
      # 上传文件完整地保存在临时文件中
      client_body_in_single_buffer on;
      # 不禁用上传缓冲区
      client_body_in_file_only off;
      # 设置请求体临时文件存储目录
      client_body_temp_path /tmp/upload 12;
      # 请求体接收超时时间为120s
      client_body_timeout 120s;

    }

    # 下载场景应用
    location /download {
      #将download的请求重定位到目录/data/upload
      alias /data/upload
      # 设置当前目录所有文件默认MIME类型为
      types {
      }
      default_type application/octetstream;


      # application/octet-stream
      #当文件不存在时，跳转到location @nofile
      try_files $uri @nofile;
      #开启零复制文件传输功能
      sendfile on;
      #每个sendfile调用的最大传输量为1MB
      sendfile_max_chunk 1M;
      #启用最小传输限制功能
      tcp_nopush on;
      # 启用异步传输
      aio on; #

      #当文件大于5MB时以直接读取磁盘方式读取文件
      directio 5M;
      #与磁盘的文件系统对齐
      directio_alignment 4096;
      #文件输出的缓冲区为128KB
      output_buffers 4 32k;
      #限制下载速度为1MB
      limit_rate 1m;
      #当客户端下载速度达到2MB时，进入限速模式
      limit_rate_after 2m;
      #客户端执行范围读取的最大值是4096B
      max_ranges 4096;
      #客户端引发传输超时时间为20s
      send_timeout 20s;
      #当缓冲区的数据达到2048B时再向客户端发送
      postpone_output 2048;
      #启用分块传输标识
      chunked_transfer_encoding on
    }
    location @nofile {
      index nofile.html
    }
    location = /404.html {
      internal;
    }
    location = /50x.html {
      internal;
    }
  }
}
```

## 第 4 章 Nginx HTTP 模块详解

Nginx 的主要功能模块是 HTTP 功能模块，HTTP 功能模块的扩展功能可以让用户很方便地应对各种复杂的应用场景。这些功能模块可以进行如下分类：

- 动态赋值：可根据 HTTP 请求的而变化，动态地进行变量赋值的功能模块。
- 访问控制：对外部访问请求做认证、数量限制等工嗯呢该模块。
- 数据处理：对用户的相应数据进行过滤或修改的功能模块。
- 协议客户端：可与其他应用协议服务连接的客户端模块。
- 协议服务：可运行相关应用协议服务、提供其他客户端访问的功能模块。
- 代理负载：对后端服务器实现代理负载的功能模块。
- 缓存功能：对相应数据内容实现缓存的功能模块。
- 日志管理：对请求的日志进行管理配置的功能模块
- 监控管理：对 Nginx 自身状态进行监控的功能模块

本章介绍动态赋值、访问控制和数据处理这三个功能模块的内容。

### 4.1 动态赋值功能模块

Nginx 在核心模块以及其他模块都提供了内置变量，用户可以根据需要灵活调用。Nginx 除了提供 rewrite 指令以方便用户对变量进行静态赋值以外，还提供了根据请求内容的变化，为变量动态赋值的功能。

#### 4.1.1 根据浏览器动态赋值

模块名称：ngx_http_browser_module

该模块的功能是根据客户端 HTTP 请求头中的属性字段 User-Agent 的值，按照用户的指令配置设置变量`$modern_browser`和`$ancient_browser`的值。用户可以根据这两个变量的值对客户端浏览器进行区分，并对 HTTP 请求进行不同的处理。

配置指令如下：

1. 指令：ancient_browser 旧浏览器标识指令

   作用域：http、server、location

   默认值：-

   说明：当客户端的 HTTP 请求头中的 User-Agent 的值包含了指令值中的字符串时，设置变量`$ancient_browser`为 1。`$ancient_browser`被设定时，默认为 1。

   配置样例：

   ```nginx
   http {
     ancient_browser 'UCWEB';
   }
   ```

2. 指令：ancient_browser_value 设置旧浏览器变量值指令

   作用域：http、server、location

   默认值：1

   说明：将变量`$ancient_browser`的值设置为指定的字符串

   配置样例：

   ```nginx
   http {
     ancient_browser 'UCWEB';
     ancient_browser_value oldweb;
     server {
       if ($ancient_browser) {
         # 重定向到oldweb.html
         rewrite ^ /${ancient_browser}.html;
       }
     }
   }
   ```

3. 指令：modern_browser 新浏览器标识指令

   作用域：http、server、location

   默认值：-

   说明：当客户端浏览器被 Nginx 识别为内置的浏览器类型，且 HTTP 请求头中的属性字段 User-Agent 的值中的版本号高于指令值的版本号，则设置变量`$modren_browser`的值为 1。

   - 内置浏览器类型有 msie、gecko、opera、safari、konqueror
   - 当指令值为 unlisted，Nginx 在 HTTP 请求头中 User-Agent 的值为空或者是无法识别的浏览器类型时，也设置变量`$modren_browser`的值为 1。

   配置样例：

   ```nginx
   http {
     modern_browser msie 5.5;
   }
   ```

   ```nginx
   http {
     modern_browser msie 5.5;
     modern_browser unlisted;
   }
   ```

4. 指令：modern_browser_value 设置新浏览器变量值指令

   作用域：http、server、location

   默认值：1

   说明：将变量`$modern_browser`的值设置为指定的字符串

   配置样例：

   ```nginx
   http {
     modern_browser msie 5.5;
     modern_browser_value newweb;
     server {
       if ($modern_browser) {
         rewrite ^ /${modern_browser}.html;
       }
     }
   }
   ```

四个指令组合的配置样例如下：

```nginx
http {
  # 必须使用单引号
  ancient_browser 'UCWEB';
  # 设置$ancient_browser的值为oldweb
  ancient_browser_value oldweb;
  # 设置$ancient_browser的值为newweb
  modern_browser_value newweb;
  # 设置$modern_browser的值为1，$ancient_browser的值为0
  modern_browser unlisted;

  root /opt/nginx-web;
  server {
    listen 8080;
    if ($ancient_browser) {
      # 重定向到oldweb.html
      rewrite ^ /${ancient_browser}.html;
    }
    if ($modern_browser) {
      # 重定向到newweb.html
      rewrite ^ /${modern_browser}.html; 
    }
  }
}
```

#### 4.1.2 根据 IP 动态赋值

模块名称：ngx_http_geo_module

该模块的功能是从源变量获取 IP 地址，并根据设定的 IP 与对应值的列表对新变量进行赋值。该模块只有一个 geo 指令，格式如下：

```nginx
geo [源变量]新变量{}
```

- geo 指令的默认源变量是`$remote_addr`，新变量默认值为空
- geo 指令的作用域只能是 http

geo 指令的指令值参数如下：

- delete：删除配置已经存在的相同 IP 地址的设定
- default：如果从源变量获取的 IP 无法匹配任何一个 IP，通过该参数的参数值为新变量赋值
- include：引入一个包含 IP 与对应值的外部文件
- proxy：指定上层代理 IP。当源变量的 IP 为该参数指定的 IP 时，Nginx 将从 X-Forwarded-For 头中获取 IP
- proxy_recursive：开启代理递归查询，当 X-Forwarded-For 头中有多个 IP，Nginx 会将 X-Forwarded-For 头中的最后一个 IP 定义为源变量的 IP；启用该参数后，Nginx 会将 X-Forwarded-For 头中的最后一个 IP 与所有不属于 proxy 参数定义的 IP 定义为源变量的 IP。
- ranges：使用以地址段的形式定义的 IP 地址时，该参数必须放在最上面。

配置样例：

```nginx
http {
  geo $country {
    # 启用代理递归查询
    proxy_recursive;
    # 默认值为ZZ
    default ZZ;
    # 引入外部列表文件
    include conf/geo.conf;
    # 上层代理地址为192.168.100.0/24的IP
    proxy 192.168.100.0/24;
    # 上层代理地址为2001:0db8::/32的IP
    proxy 2001:0db8::/32;
    # 赋值US
    127.0.0.0/16 US;
    # 赋值RU
    127.0.0.1/32 RU;
    # 赋值RU
    10.1.0.0/16 RU;
    # 赋值UK
    192.168.1.0/24 UK;
  }
}
```

为了加速加载 IP 来设定变量表，IP 地址应按升序填写。

外部文件 geo.conf 的内容格式如下：

```nginx
10.2.0.0/16 RU;
192.168.2.0/24 RU;
```

以地址形式定义的 IP 地址中 ranges 参数的配置样例如下：

```nginx
http {
  geo $country {
    # 使用以地址段的形式定义的IP地址
    ranges; 
    default ZZ;
    10.1.0.0-10.1.255.255 RU;
    192.168.1.0-192.168.1.255 UK;
  }}
}
```

自定义源变量配置样例：

```nginx
http {
  geo $arg_ip $address {
    # 设置请求参数IP为源变量
    default CN;
    127.0.0.0/24 US;
    127.0.0.10/32 RU;
    10.1.0.0/16 RU;
    # 删除127.0.0.10/32的设定
    delete 127.0.0.10/32; 
  }
  server {
    listen 8081;
    server_name localhost;
    charset utf-8;
    root /opt/nginx-web;
    default_type text/xml;
    location / {
      # 重定向到$address.html
      rewrite ^ /${address}.html break;
    }
  }
}
```

#### 4.1.3 根据 IP 动态获取城市信息

模块名称：ngx_http_geoip_module

该模块的功能可以将客户端的 IP 地址与 MaxMind 数据库中的城市地址信息进行对比。然后将对应的城市地址信息赋值给内置变量。指令如表所示：

1. 指令：geoip_country 国家信息数据库指令

   作用域：http

   默认值：1

   说明：指定国家信息的 MaxMind 数据库文件路径

2. 指令：geoip_city 城市信息数据库指令

   作用域：http

   默认值：1

   说明：指定城市信息的 MaxMind 数据库文件路径

3. 指令：geoip_org  上层代理 IP 指令

   作用域：http

   默认值：1

   说明：指令机构信息的 MaxMind 数据库文件路径

4. 指令：geoip_proxy 上层代理IP指令

   作用域：http

   默认值：-

   说明：指定上层代理 IP。当源变量的 IP 为该参数指定的 IP 时，Nginx 将从 X-Forwarded-For 头中获取 IP

5. 指令：geoip_proxy_recursive 代理递归查询IP指令

   作用域：http

   默认值：off

   指令值可选：on 或 off

   说明：开启代理递归查询，当 X-Forwarded-For 头中有多个 IP，Nginx 会将 X-Forwarded-For 头中的最后一个 IP 定义为源变量的 IP；启用该参数后，Nginx 会将 X-Forwarded-For 头中的最后一个 IP 与所有不属于 proxy 参数定义的 IP 定义为源变量的 IP。

geo 内置变量如图所示：

![4-1.png](./images/4-1.png)

配置样例：

```nginx
http {
  geoip_country /usr/share/GeoIP/GeoIP.dat;
  geoip_city /usr/share/GeoIP/GeoIPCity.dat;
  geoip_org /usr/share/GeoIP/GeoIPASNum.dat;
  geoip_proxy 192.168.2.145;
  geoip_proxy_recursive on;

  server {
    listen 8081;
    server_name localhost;
    charset utf-8;
    root /opt/nginx-web;
    default_type text/xml;
    location / {
      if ( $geoip_country_code ) {
        # 重定向到$geoip_country_cod目录
        rewrite ^ /$geoip_country_code/ break;
      }
    }
  }
}
```

#### 4.1.4 比例分配赋值

模块名称：ngx_http_split_clients_module

该模块会按照配置指令将一个 0~232 之间的数值，根据设定的比例分割为多个数值范围。每个数值安慰会被设定一个对应的给定值。用户每次请求，指定的字符串会被计算出一个数值，该模块会将该数值所在范围对应的给定赋值给配置中定义的变量。

该功能常用于按照用户的来源 IP 进行访问流量分流，其语法格式如下：

```nginx
split_clients 字符串 新变量{}
```

配置样例如下：

```nginx
http {
  #"${remote_addr}AAA"会被计算出一个数值
  split_clients "${remote_addr}AAA" $source {
    # 数值在0～21474835之间，$source被赋值".one"
    0.5% .one;
    # 数值在21474836～3435973836之间，$source被赋值".two"
    80.0% .two;
    # 数值在3435973837～4294967295，$source被赋值""
    * ""; 
  }
  server {
    location / {
      index index${source}.html;
    }
  }
}
```

- 该指令会将一个 2 的 32 次幂计算的值（数值范围 0～4294967295）按照指令域中的比例进行分割
- 客户端每次请求时，会将指定字符串使用 MurmurHash2 算法计算出一个0～232（0～4 294 967 295）之间的数值，该模块会将该数值所在范围对应的 给定值赋值给配置中定义的变量。
- 指定的字符串可以是Nginx内置变量。

#### 4.1.5 变量映射赋值






> 本次阅读至 298 下次阅读应至 P308