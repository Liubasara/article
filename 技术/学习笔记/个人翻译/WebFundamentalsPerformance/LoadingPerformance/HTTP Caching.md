---
name: HTTP Caching
title: 页面加载性能-HTTP缓存
tags: ["技术","学习笔记", "个人翻译", "WebFundamentalsPerformance", "谷歌开发者文档"]
categories: 学习笔记
info: "页面加载性能-HTTP缓存"
time: 2021/11/18
desc: '个人翻译, HTTP Caching, Web'
keywords: ['学习笔记', '个人翻译', 'HTTP Caching']
---

# 页面加载性能-HTTP缓存

该系列为谷歌开发者文档的一些翻译，对应章节目录链接可以[访问这里](https://developers.google.com/web/fundamentals?hl=zh-cn)

> 原文链接：https://developers.google.com/web/fundamentals/performance/get-started/httpcaching-6

当一个人访问网站，网站上所需要展示和操作的一切都会需要来自某个地方。一切的文本，图像，CSS 样式，脚本，多媒体等等文件都必须经由浏览器取回后才能显示或执行。而你可以让浏览器选择从哪里取回这些资源，这对页面的加载速度有着巨大的不同。

浏览器第一次加载网络页面的时候，它会将页面资源存储在 HTTP 缓存中（[HTTP Cache](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/http-caching)）。当下次浏览器命中该页面时，它可以在缓存中寻找之前获取的资源并且将它们从磁盘中取回，这种方式通常会比从网络下载要来得快。

虽然 HTTP 缓存是根据《Internet 工程任务组（IETF）规范》（[Internet Engineering Task Force (IETF) specifications](https://tools.ietf.org/html/rfc7234)）来进行标准化的，但浏览器却可能会根据获取方式、存储、内容保留方式的不同而存在多种缓存。你可以从这篇优秀的文章中看到这些缓存各不相同的地方：[四个缓存的故事（A Tale of Four Caches）](https://calendar.perfplanet.com/2016/a-tale-of-four-caches/)。

当然，每个第一次访问你的网页的访问者都不会有关于页面的任何缓存。而且即便是重复的访问者，可能也不会有多少 HTTP 缓存，因为他们可能会人为清楚缓存，又或者浏览器会自动这么做，又或者他们会使用控制键组合来强制刷新页面。尽管如此，还有大量的网站用户依然会在拥有某些组件缓存的前提下重复访问你的网站，而这能在加载时间上起到巨大的影响。最大化缓存的使用率在提高回访率的方面有着重要的帮助。

## 开启缓存

缓存的工作原理是基于网页资源的更改频率，将它们进行分类。举例来说，你的网站 logo 图片也许永远俺不会更换，但你的网络脚本则会每隔几天就更改一次。确定哪些类型的内容是静态的，哪些是动态的，对您和您的用户都有好处。

要记住同样重要的一点是，我们认为的浏览器缓存可能实际发生在客户端与真正的服务器中间的任何节点，比如说代理缓存或 CDN 缓存中。

## 缓存头

两个主要的缓存头类型包括：cache-control 和 exjpires 字段，它们决定了资源缓存的特性。一般来说，cache-control 字段比起 expires 字段，被认为是一个更加现代且更灵活的字段，不过这两个字段也可以被同时使用。

缓存头是在服务器的层面上起作用的。举个例子，Apache 服务上的`.htaccess`文件，被将近一半的活动网站用于设置它们的缓存特性。在识别到对应的资源或是资源类型时——像是图片或者 CSS 文件，缓存就会通过缓存选项来进行开启。

### cache-control

```xml
<filesMatch ".(ico|jpg|jpeg|png|gif)$">
 Header set Cache-Control "max-age=2592000, public"
</filesMatch>
```

要开启 cache-control 字段，你可以在一个逗号分隔的列表里通过不同的属性去设置。这里有一个关于 Apache `.htaccess`配置文件的例子，该配置可以设置不同图片类型的缓存，通过一个扩展名列表去匹配，设置为可以缓存一个月且允许公共访问（除此以外还有一些可用的选项，会在下面介绍）。

```xml
<filesMatch ".(css|js)$">
 Header set Cache-Control "max-age=86400, public"
</filesMatch>
```

而上面的例子为样式文件和脚本文件设置了缓存，这些资源相对于图片来说更容易被改变，所以将缓存设置为一天期限且允许公共访问。

Cache-control 拥有一定数量的选项，这些选项被称为指令，而这些指令可以用来决定缓存请求怎样被响应。一些常见的指令会在下面解释，而你可以在 [Performance Optimization section](http://tinyurl.com/ljgcqp3) 和  [Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cache-Control) 这两篇文章中找到关于这些指令的更多信息。

- no-cache：（该字段）有点用词不当，因为在该指令下，内容是可以被缓存的，但是如果要获取缓存资源，必须要让服务器为客户端提供服务之前，为每个请求进行重新验证。这会强制客户端去重新检查缓存的新鲜度，但是如果缓存资源没有改变的话，该字段可以避免再次下载资源的过程。该字段与 no-store 互斥。
- no-store：表示该内容实质上不能被以任何主要或是中介的方式进行缓存，该字段对于可能包含敏感数据的资源，或是几乎可以肯定会随着访问而变化的资源来说，是一个不错的选择。该字段与 no-cache 互斥。
- public：表示内容可以被浏览器和任何中间缓存（译者注：可能是代理服务器，类似于 cdn 网络）来进行缓存。会覆盖 HTTP 请求的关于认证信息的默认私有设置。该字段与 private 互斥。
- private：表示内容可能由用户浏览器存储，但不能被任何中间缓存进行缓存。通常用于用户特定但不是特别敏感的数据，与 public 互斥。
- max-age：定义最大的内容可缓存时间，超过这个时间以后该内容就必须再次从源服务器中重新下载。这个选项一般用来取代 expires 头（看下面的介绍），并且可以指定一个以秒为单位的值。这个值的最大有效值是一年（31536000 秒）。

## Expires 缓存

你还可以通过为某些类型的文件指定到期年限，或是具体的到期时间来启用缓存。这会告诉浏览器，从服务器请求新副本之前使用缓存资源的时间。expires 头只是设置内容应该过期的未来时间，在那个时间之后，对于内容的请求就必须回到原始的服务器。但是自从有了更新而且宽容度更高的 cache-control 头以后，expires 头通常只会用于后备。

下面有一个如何在 Apache 服务器使用`.htaccess`文件来设置 expires 头字段。

```ini
## EXPIRES CACHING ##
ExpiresActive On
ExpiresByType image/jpg "access plus 1 year"
ExpiresByType image/jpeg "access plus 1 year"
ExpiresByType image/gif "access plus 1 year"
ExpiresByType image/png "access plus 1 year"
ExpiresByType text/css "access plus 1 month"
ExpiresByType application/pdf "access plus 1 month"
ExpiresByType text/x-javascript "access plus 1 month"
ExpiresByType application/x-shockwave-flash "access plus 1 month"
ExpiresByType image/x-icon "access plus 1 year"
ExpiresDefault "access plus 2 days"
## EXPIRES CACHING ##
```

就像你看到的那样，在这个例子中不同类型的文件拥有不同的过期时间：图片资源在访问之后，在一年内不会刷新，但是像脚本，PDF 文件和 CSS 样式文件这种就会在一个月之后过期，而其它没有特别指定的文件，会在两天后过期。这个保留期由你决定，可以根据文件类型以及其更新频率进行选择。例如，如果你会定期更改 CSS，你可能会希望使用更短的过期时间，甚至根本不需要使用，只是让它默认为两天的最小值。相反，如果您链接了一些静态的 PDF 表单且几乎不会更改，你可能会希望为它们设置一个更长的过期时间。

提示：不要使用比一年时间更长的过期时间，该有效期在互联网上相当于永远，正如上面所说，一年也是 cache-control 字段的 `max-age` 允许设定的最大的值。

## 总结

缓存是一种可靠且简单的方式，可以用于提高页面的加载速度，从而提高用户体验。它足够强大到可以兼容特定内容类型的复杂及细微的差别，也足够灵活，可以在站点内容更改时轻松地更新。

对缓存保持自信，不过也要小心如果你在随后更改了一些拥有长保留时间的资源，你可能会无意中阻挡一些重复访问者对于新内容的访问。关于缓存的模板，选项和潜在的陷阱，你可以在  [Caching Best Practices and Max-age Gotchas](https://jakearchibald.com/2016/caching-best-practices/) 这篇文章中看到一些精彩的讨论。

