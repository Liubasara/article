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










> 本次阅读至 260 下次阅读应至 P280