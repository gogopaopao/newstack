+++
title = 'Markdown图片速查'
date = 2026-03-17T17:38:37+08:00
categories = ["置顶","速查","博客搭建"]
weight = 2

+++

为什么在博客不能显示图片：

图片无法显示的核心原因是：**你使用了本地电脑的绝对路径（`D:\Program Files\...`）**。

Hugo 是一个静态网站生成器，它最终会在浏览器里通过 `http://localhost:1313`（或你的实际域名）来访问。出于安全机制，浏览器是**禁止**网页直接读取用户电脑本地磁盘（如 D 盘、C 盘）上的文件的。因此，你必须使用**相对路径**或**基于网站根目录的路径**。

根据 Hugo 的架构，这里有三种最常用的修复方法。你可以根据你的目录习惯选择一种：

### 使用页面捆绑（Page Bundle）

如果你把图片和文章放在了同一个文件夹下，Hugo 非常推荐使用 Page Bundle（页面捆绑）的模式。

1. **调整目录结构**：确保你的 Markdown 文件名为 `index.md`，并且和 `img` 文件夹在同一个目录（即 `滚动轴承数据集学习` 文件夹）下。

   Plaintext

   ```
   content/
   └── post/
       └── 滚动轴承数据集学习/
           ├── index.md        <-- 你的文章内容放在这里
           └── img/
               └── data_describe.png
   ```

2. **修改 Markdown 路径**：在 `index.md` 中，直接使用相对路径即可：

   Markdown

   ```
   ![img1](img/data_describe.png)
   ```







### Markdown 图片编辑

Markdown 图片
图片能让文档更加生动和易于理解。

Markdown 的图片语法简洁而灵活。

Markdown 图片语法格式如下：

```
![替代文字](图片路径)
![替代文字](图片路径 "图片标题")
```

开头一个感叹号 !
接着一个方括号，里面放上图片的替代文字
接着一个普通括号，里面放上图片的网址，最后还可以用引号包住并加上选择性的 'title' 属性的文字。
相对路径示例：

```
![项目截图](./images/screenshot.png)
![用户界面](../assets/ui-demo.jpg "用户界面演示")
![图标](images/icon.svg "应用图标")
```

绝对路径示例：

```
![本地图片](/Users/username/Documents/image.png)
![系统截图](C:\Users\username\Pictures\screenshot.png)
```

路径使用建议：

推荐使用相对路径，便于项目移植
建议创建专门的图片文件夹（如 images/、assets/）
使用有意义的文件名，便于管理
注意路径分隔符在不同操作系统中的差异
直接引用网络图片：

![RUNOOB 图标](https://static.jyshare.com/images/runoob-logo.png "RUNOOB")

```
![RUNOOB 图标](https://static.jyshare.com/images/runoob-logo.png)
```

