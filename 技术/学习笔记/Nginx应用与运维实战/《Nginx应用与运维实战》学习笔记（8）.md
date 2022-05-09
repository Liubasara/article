---
name: 《Nginx应用与运维实战》学习笔记（8）
title: 《Nginx应用与运维实战》学习笔记（8）
tags: ["技术","学习笔记","Nginx应用与运维实战"]
categories: 学习笔记
info: "深入设计模式 第4章 Nginx HTTP 模块详解 4.3　数据处理功能模块"
time: 2022/5/6
desc: '深入设计模式, 学习笔记, 第4章 Nginx HTTP 模块详解, 4.3　数据处理功能模块'
keywords: ['Nginx应用与运维实战', '运维', '学习笔记', '第4章 Nginx HTTP 模块详解', '4.3　数据处理功能模块']
---

# 《Nginx应用与运维实战》学习笔记（8）

## 第 4 章 Nginx HTTP 模块详解

### 4.3　数据处理功能模块

当用户请求没有明确指定请求的文件名称时，Nginx 可以根据设定，返回默认数据。实现这一功能的包含以下三个模块：

- ngx_http_index_module
- ngx_http_random_index_module
- ngx_http_autoindex_module

常用指令如下所示：

1. 指令：index 首页指令

   作用域：http、server、location

   默认值：index index.html

   说明：设置 HTTP 服务器的默认首页。当指令值为多个文件时，会按照从左到右的顺序依次查找，找对对应文件后将结束查找。

   配置样例：

   ```nginx
   location / {
     index index.$geo.html index.html;
   }
   ```

2. 指令：random_index 随机首页指令

   作用域：location

   默认值：off

   指令值可选项：on 或 off

   说明：随机读取文件目录下的文件内容作为首页内容。

   - 该指令的执行优先级高于 index 指令
   - 文件目录中的隐藏文件将被忽略

   配置样例：

   ```nginx
   http {
     root /opt/nginx-web/html;
     location / {
       random_index on;
     }
   }
   ```

3. 指令：autoindex 自动首页指令

   作用域：http、server、location

   默认值：off

   指令值可选项：on 或 off

   说明：自动创建目录文件列表为目录首页

4. 指令：autoindex_format 自动首页格式指令

   作用域：http、server、location

   默认值：html

   指令值选项：html 或 xml 或 json 或 jsonp

   说明：设置 HTTP 服务器的自动首页文件格式

5. 指令：autoindex_exact_size 自动首页文件大小指令

   作用域：http、server、location

   默认值：on

   指令值选项：on 或 off

   说明：设置 HTTP 服务器的自动首页显示文件大小。默认文件大小单位为 Byte，当指令值为 off 时，将根据文件大小自动换算为 KB 或者 MB 或者 GB 的单位大小。

6. 指令：autoindex_localtime 自动首页时间指令

   作用域：http、server、location

   默认值：off

   可选值：on 或 off

   说明：按照服务器时间显示文件时间。默认显示的文件时间为 GMT 时间。当指令值为 on 时，显示的文件时间为服务器时间。

配置样例：

```nginx
location / {
  autoindex on;
  autoindex_format html;
  autoindex_exact_size off;
  autoindex_localtime on;
}
```

#### 4.3.2 图片处理

模块名称：ngx_http_image_filter_module

该模块可以对 JPEG、GIF、PNG 或 WebP 格式的图片文件进行动态旋转，比例缩放以及裁剪。该模块的内置指令如下所示：

1. 指令：image_filter 图片处理指令

   作用域：location

   默认值：off

   指令说明：设置图片处理功能是否启用及处理方式

   指令值可用参数：

   ![4-3.png](./images/4-3.png)

2. 指令：image_filter_buffer  图片处理缓冲区指令

   作用域：http、server、location

   默认值：1m

   说明：设置图片处理缓冲区的大小，超过设定值将返回错误代码 415

3. 指令：image_filter_jpeg_quality  JPEG图片质量指令

   作用域：http、server、location

   默认值：75

   说明：设置对 JPEG 图片进行压缩时的质量比例，范围是 1~100，值越小代表图像质量越低，传输数据也越小。官方推荐的最大值为 95。

4. 指令：image_filter_webp_quality WebP图片质量指令

   默认值：80，其余上同

5. 指令：image_filter_transparency  图片背景指令

   作用域：http、server、location

   默认值：on

   可选项：on、off、always

   说明：设置 GIF 或 PNG-8 格式的图片处理时，是否保持背景的透明度。PNG 图片中的 alpha 通道的透明背景不受影响。

6. 指令：image_filter_sharpen 图片锐化指令

   作用域：http、server、location

   默认值：0

   说明：设置是否对图片进行锐化处理，指令值可以超过 100

7. 指令：image_filter_interlace

   作用域：http、server、location

   默认值：off

   可选值：on 或 off

   说明：将图片转换为交错格式输出。对于 JPEG 图片将转换为渐进式格式。

8. 指令：empty_gif  空图片指令

   作用域：location

   默认值：-

   说明：返回一个单像素的 GIF 透明图片。ngx_http_empty_gif_module 模块将在内存中创建一个单像素的 GIF 透明图片。

配置样例：

```nginx
http {
  upstream img1 {
    server 192.168.2.145:8080;
  }
  server {
    listen 8083;
    server_name image.nginxtest.org;
    index index.html index.htm index.php;
    # 设置图片处理缓冲区大小为20MB
    image_filter_buffer 20M;
    # 对图片进行150%的锐化处理
    image_filter_sharpen 150;
    # JPEG图片的压缩比为70%
    image_filter_jpeg_quality 70;
    # 对GIF及PNG图片去掉透明背景
    image_filter_transparency off;
    # 将输出图片转换为交错格式
    image_filter_interlace on;

    location / {
      root /opt/nginx-web;
    }

    # 比例缩放图片尺寸file_100x100.jpg
    location ~* .*_(\d+)x(\d+)\.(JPG|jpg|gif|png|PNG)$ {
      # 缩放图片的宽
      set $img_width $1;
      # 缩放图片的高
      set $img_height $2;
      rewrite ^(.*)_\d+x\d+.(JPG|jpg|gif|png|PNG)$ /images$1.$2 break;
      image_filter resize $img_width $img_height;
      proxy_pass http://img1;
    }

    # 比例缩放图片尺寸并压缩file_100x100_80.jpg
    location ~* .*_(\d+)x(\d+)_(\d+)\.(JPG|jpg|gif|png|PNG)$ {
      # 缩放图片的宽
      set $img_width $1;
      # 缩放图片的高
      set $img_height $2;
      # 图片的质量
      set $img_quality $3;
      rewrite ^(.*)_\d+x\d+_\d+.(JPG|jpg|gif|png|PNG)$ /images$1.$2 break;
      image_filter resize $img_width$img_height;
      image_filter_jpeg_quality $img_quality;
      proxy_pass http://img1;
    }
    # 比例缩放图片尺寸并旋转file_100x100__90.jpg
    location ~* .*_(\d+)x(\d+)__(\d+)\.(JPG|jpg|gif|png|PNG)$ {
      # 缩放图片的宽
      set $img_width $1;
      # 缩放图片的高
      set $img_height $2;
      # 旋转参数
      set $img_rotate $3;
      rewrite ^(.*)_\d+x\d+__\d+.(JPG|jpg|gif|png|PNG)$ /images$1.$2 break;
      image_filter resize $img_width $img_height ;
      image_filter rotate $img_rotate ;
      proxy_pass http://img1;
    }

    # 裁剪图片尺寸file_100x100_crop.jpg
    location ~* .*_(\d+)x(\d+)_crop\.(JPG|jpg|gif|png|PNG)$ {
      # 裁剪图片的宽
      set $img_width $1;
      # 裁剪图片的高
      set $img_height $2;
      rewrite ^(.*)_\d+x\d+_crop.(JPG|jpg|gif|png|PNG)$ /images$1.$2 break;
      image_filter crop $img_width
      $img_height;
      proxy_pass http://img1;
    }

    location = /_.gif {
      empty_gif;
    }
  }
}
```

#### 4.3.3 响应处理







> 本次阅读至 360 下次阅读应至 P370