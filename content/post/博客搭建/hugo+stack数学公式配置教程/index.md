+++
title = 'Hugo+stack数学公式配置教程'
date = 2026-03-21T16:50:43+08:00
categories = ["置顶","速查","博客搭建"]
weight = 3
+++

# Hugo +Stack 博客数学公式配置指南

## 一、KaTeX 引擎全局引入配置

**1. 创建自定义头部文件** 在博客根目录按以下路径新建文件（如果对应文件夹不存在请手动创建）： `layouts/partials/head/custom.html`

**2. 注入 KaTeX 核心代码** 将以下代码完整复制并粘贴到 `custom.html` 中并保存：

```html
{{ if or .Params.math .Site.Params.math }}
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.10/dist/katex.min.css" crossorigin="anonymous">

<script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.10/dist/katex.min.js" crossorigin="anonymous"></script>

<script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.10/dist/contrib/auto-render.min.js" crossorigin="anonymous"></script>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        renderMathInElement(document.body, {
            delimiters: [
                {left: '$$', right: '$$', display: true},
                {left: '$', right: '$', display: false},
                {left: '\\(', right: '\\)', display: false},
                {left: '\\[', right: '\\]', display: true}
            ],
            throwOnError : false
        });
    });
</script>
{{ end }}
```

**3. 生效机制** 保存后，配合文章 Front Matter 里的 `math = true`，该脚本会自动在需要的页面加载并接管公式渲染。

## 二、配置 Goldmark 解析器透传（核心避坑）

- **问题现象**：Hugo 默认的 Markdown 解析器会吞掉反斜杠，导致从 PDF 提取的公式定界符 `\(` 和 `\[` 在网页上变成纯文本 `(` 和 `[`，公式无法渲染。

- **解决办法**：打开主配置文件 `hugo.yaml`（或 `config.yaml`），在 `markup` 层级下添加 `passthrough` 白名单。

**注意**：YAML 格式**对缩进极其严格**，且特殊符号加单引号(不加也不影响)，一直失效的原因就是缩进有问题

```yaml
markup:
    goldmark:
        extensions:
            passthrough:
                enable: true
                delimiters:
                    block:
                        - - '\['
                          - '\]'
                        - - '$$'
                          - '$$'
                    inline:
                        - - '\('
                          - '\)'
                        - - '$'
                          - '$'
```

## 三、 单篇文章开启公式支持

在需要写公式的 Markdown 文件顶部的 Front Matter 中，加上 `math = true`：

```
+++
title = '你的文章标题'
date = 2026-03-17T16:36:33+08:00
math = true
+++
```

## 常用的 Markdown/LaTeX 数学公式语法

### **1. 公式分类**

- **行内公式**：夹在文字中间，使用单个 `$` 包裹。代码：`$x+y=z$`。 或者 `\(`，`\)`

- **块级公式**：单独占一行并居中，使用双 `$$`  (`\[`,`\]`)包裹。代码：

  代码段

  ```
  $$
  x+y=z
  $$
  ```

### **2. 上下标**

- **上标**：使用 `^`。代码：`$x^2$` -> $x^2$
- **下标**：使用 `_`。代码：`$A_i$` -> $A_i$
- **提示**：如果上下标包含多个字符，需要用 `{}` 括起来，如 `$A_{i+1}$`。	$A_{i+1}$

### **3. 分数与根号**

- **分数**：使用 `\frac{分子}{分母}`。代码：`$\frac{1}{2}$` 	$\frac{1}{2}$
- **根号**：使用 `\sqrt{表达式}`。代码：`$\sqrt{x^2+y^2}$`->$\sqrt{x^2+y^2}$

### **4. 常用数学符号**

- **乘号与除号**：乘号 `\times` ($\times$)，除号 `\div` ($\div$)
- **加减号与不等于**：加减 `\pm` ($\pm$)，不等于 `\neq` ($\neq$)
- **约等于与等价**：约等于 `\approx` ($\approx$)，等价于 `\equiv` ($\equiv$)
- **无穷大**：`\infty` ($\infty$)

### **5. 常用希腊字母**

- `\alpha` ($\alpha$)
- `\beta` ($\beta$)
- `\gamma` ($\gamma$)
- `\Delta` ($\Delta$)
- `\pi` ($\pi$)
- `\mu` ($\mu$)

### **6. 特殊顶部修饰**

- **宽帽子**：`\widehat{X}` ($\widehat{X}$)
- **平均值/顶宽线**：`\overline{X}` ($\overline{X}$)

### **7. 求和与积分**

- **求和**：`\sum_{下标}^{上标}`。代码：`$\sum_{i=1}^{n} x_i$`->$\sum_{i=1}^{n} x_i$
- **积分**：`\int_{下限}^{上限}`。代码：`$\int_{0}^{1} x^2 dx$`->$\int_{0}^{1} x^2 dx$

### **8. 特殊字符转义**

部分符号在公式中有特定语法作用，若只需显示符号本身，需在前面加反斜杠 `\`。

- 百分号：`\%`
- 大括号：`\{` 和 `\}`
