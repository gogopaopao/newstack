+++
title = 'HUGO博客维护指令速查'
date = 2026-03-03T00:41:24+08:00
categories = ["置顶","速查","博客搭建"]
weight = 1

+++

调试命令：hugo server -D

创建文章：hugo new content post/要创建的文章目录/index.md	（用中文命名不影响）

删除文章：在 Hugo 中，**没有专门的命令**（比如 `hugo delete`）用来删除文章。

​		要删除一篇文章，你只需要**在你的文件系统中把对应的文件或文件夹直接删掉**就可以了。

GitHub自动上传  （cmd中）

```bash
git init
git add .
git commit -m "%date% %time%"
git branch -M main
git remote add origin {你的github仓库地址}
git push -u origin main
```



git remote add origin {你的github仓库地址}只要使用过一回就不用再配置了



关于自动生成的两个+++号间的内容，如何配置，如下：

# 📝 Hugo + Stack 主题文章配置完全笔记

## 一、 核心概念：Front Matter

在使用 `hugo new` 命令创建文章时，文件顶部被 `+++` (TOML格式) 或 `---` (YAML格式) 包裹的区域称为 **Front Matter**。它不属于正文，专门用于告诉 Hugo 和主题如何解析、渲染和配置这篇文章。

## 二、 文章的基本操作 (创建与删除)

- **创建文章：** `hugo new content post/你的文件夹名/index.md` (这会创建一个 Page Bundle，方便把文章配图和 markdown 放在同级目录)。
- **删除文章：** Hugo 没有删除命令。直接在文件管理器中**删除对应的文件夹** (例如 `content/post/你的文件夹名`) 即可彻底删除。
- **草稿预览：** 本地测试时，需使用 `hugo server -D` 或 `hugo server --buildDrafts` 才能在浏览器中看到 `draft = true` 的文章。

## 三、 Front Matter 属性大全 (TOML 格式)

### 1. 基础与排版 (必填/常用)

```
title = '基于QT的脊柱侧弯监测系统开发'  # 文章显示的标题
date = 2026-03-03T00:25:55+08:00       # 创建或发布时间 (决定时间轴排序)
lastmod = 2026-03-05T10:00:00+08:00    # 最后修改时间
draft = true                           # 草稿状态 (true为隐藏，false为发布)
weight = 1                             # 权重，数字越小在列表越靠前 (常用于置顶)
```

### 2. 内容组织 (Taxonomies)

```
categories = ["嵌入式开发", "项目复盘"] # 文章分类，建议体系化
tags = ["STM32", "C语言", "机械臂"]    # 文章标签，可设置多个，便于检索关联
```

### 3. 展示与 SEO (Stack 主题视觉核心)

```
description = "记录了在准备研究生复试期间，梳理数据结构核心考点的过程。" # 文章摘要，显示在标题下方及供搜索引擎读取
summary = "同上，Hugo原生摘要字段，通常与 description 二选一"
image = "cover.jpg" # 封面特色图。直接将图片保存在 index.md 同级目录并填入文件名即可
```

### 4. Stack 主题专属高级开关

```
math = true                 # 开启数学公式渲染 (KaTeX/MathJax)，包含复杂推导时设为 true
comments = false            # 单独关闭本文的评论区
license = "CC BY-NC-ND 4.0" # 在文章底部声明特定的版权协议
hidden = true               # 隐藏文章 (不在首页和归档列表中显示，但知道链接可直接访问)
color = "#ff5733"           # 自定义文章在主页卡片上的主题色 (不填则自动从封面图提取)
```

### 5. 外部链接卡片

在文章末尾自动渲染出漂亮的外部链接卡片，适合指向代码仓库或参考资料：

```
[[links]]
  title = "GitHub 源码"
  description = "包含 PyTorch 模型训练代码与数据集整理脚本"
  website = "https://github.com/..."
  image = "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png"
```

## 四、 进阶技巧：自定义默认模板 (Archetypes)

如果不想每次新建文章都手动敲这些属性，可以修改博客根目录下的 **`archetypes/default.md`** 文件。将其内容替换为你最常用的组合，例如：

```
+++
title = '{{ replace .Name "-" " " | title }}'
date = {{ .Date }}
draft = true
description = ''
image = ''
categories = ['']
tags = ['']
math = false
+++
```

## 📝 开发问题记录与避坑指南

### 一、 Git 提交信息如何包含系统时间？

在不同终端（Shell）下，获取系统时间的语法不同。如果语法写错，Git 会把代码直接当成普通文本。

| **终端环境 (Terminal)** | **提交命令示例**                                            | **备注**                    |
| ----------------------- | ----------------------------------------------------------- | --------------------------- |
| **CMD (Windows)**       | `git commit -m "%date% %time%"`                             | 格式受 Windows 区域设置影响 |
| **PowerShell**          | `git commit -m "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"` | 推荐，格式最整齐            |
| **Git Bash / Linux**    | `git commit -m "$(date '+%Y-%m-%d %H:%M:%S')"`              | 标准 Linux 语法             |

### 二、 Hugo 图片本地显示、线上不显示

这种情况通常是因为 Windows（本地）和 Linux（GitHub Pages/服务器）对文件路径的处理差异造成的。

#### 1. 路径分隔符错误 (最核心原因)

- **错误**：`img\picture.jpg` (Windows 风格反斜杠)
- **正确**：`img/picture.jpg` (Web 标准正斜杠)
- **原理**：线上服务器只识别 `/`，反斜杠会被当作无效路径。

#### 2. 静态资源路径逻辑

- Hugo 的图片通常放在 `static/img/`。
- 在 Markdown 或配置文件中引用时，**必须省略** `static` 这一层级。
- 正确引用：`/img/picture.jpg`。

#### 3. 大小写敏感性

- 本地 Windows 不区分 `Image.jpg` 和 `image.jpg`。
- 线上 Linux 严格区分。如果文件名是大写但代码里写的小写，图片会 404。

#### 4. 最佳实践建议

- **文件名禁止中文**：建议改用英文和连字符（如 `score-plot.jpg`），避免 URL 编码乱码。
- **统一小写**：文件名和代码全部使用小写。

### 三、为什么大标题不显示

- **层级问题**：默认目录从 `##` (H2) 开始抓取。如果你的标题是用 `#` (H1) 写的，它不会出现在目录里。
- **解决方法**：将正文第一个大标题改为 `##` 开头。

### 四、Git SSH 部署全攻略：从配置到实战

在使用 Git 部署项目（如 Hugo 博客）时，HTTPS 经常会遇到网络超时或反复要求输入密码的问题。切换到 **SSH 方式** 是最稳定且“一劳永逸”的解决方案。

#### 1. 核心流程：SSH 的工作原理

SSH（Secure Shell）通过一对“密钥”来验证身份：

- **私钥 (Private Key)**：放在你本地电脑，绝对不能泄露。
- **公钥 (Public Key)**：上传到 GitHub。 当你推送代码时，GitHub 会用公钥和你本地的私钥进行匹配，匹配成功即可通行。

------

#### 2. 配置步骤

##### 第一步：生成 SSH 密钥

如果你本地还没有密钥，打开终端输入：

```Bash
ssh-keygen -t ed25519 -C "你的邮箱@example.com"
```

- **提示：** 一路按下 **回车** 即可（无需设置密码短语）。
- **位置：** 密钥默认保存在 `C:\Users\用户名\.ssh\` 下。

##### 第二步：将公钥添加到 GitHub

1. 找到 `.ssh` 文件夹下的 `id_ed25519.pub` 文件，用记事本打开并**全选复制**。
2. 登录 GitHub -> **Settings** -> **SSH and GPG keys** -> **New SSH key**。
3. **Title** 随便填（如 `y9000p`），**Key** 粘贴刚才复制的内容。

##### 第三步：修改仓库远程地址

这是最关键的一步。你需要把仓库的连接方式从 HTTPS 改为 SSH：

```Bash
# 查看当前地址
git remote -v

# 修改为 SSH 地址（格式为 git@github.com:用户名/仓库名.git）
git remote set-url origin git@github.com:gogopaopao/gogopaopao.github.io.git
```

##### 第四步：测试连接

```Bash
ssh -T git@github.com
```

看到 `Hi gogopaopao! You've successfully authenticated...` 就说明连接彻底通了。

------

#### 3. 常用上传命令清单

整理好配置后，日常开发只需三步走：

1. **添加改动：** `git add .`
2. **提交描述：** `git commit -m "update: 部署新博文"`
3. **推送远程：** `git push -u origin main`

##### 特殊情况处理：

- **强制推送（慎用）：** 如果远程仓库有冲突且你确定以本地为准，可以使用 `git push -u origin main -f`。

- **解决中文文件名乱码：**

  ```Bash
  git config --global core.quotepath false
  ```
