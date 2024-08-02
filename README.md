# 数学建模Typst模板

## 格式

### 首行缩进

```typst
#let indent = h(2em)
```

### 页面设置

```typst
#let template(body, abstract: [摘要内容], title: "测试题目", keywords: ([key1], [key2], [key3])) = {
  //设置页面
  set page(
    paper: "a4", 
    margin: (x: 2.5cm, y: 2.5cm),		//页边距
    numbering: numbly("{1}","{1}/{2}"),	//页码格式：1/2
  )
   
  //设置文本样式
  set text(
    font: 字体.宋体,
    size: 字号.小四, //正文字体大小
    fill: black,
    lang: "zh",
  )
   
  //创建假段落样式，解决自动缩进
  let fake-par = style(styles=>{
    let b = par[#box()]
    let t = measure(b + b, styles)
    b
    v(-t.height)
  })
  show strong: it => text(font: 字体.黑体, weight: "semibold", it.body)//设置加粗字体
  show emph: it => text(font: 字体.楷体, style: "italic", it.body)//设置倾斜字体
   
  //设置标题样式
  set heading(numbering: numbly(
    "{1:一、}",
    "{1:1}.{2}",
    "{1:1}.{2:1}.{3:1}"
  ))
   
  show heading.where(level: 1):it=>{ //单独设置一级标题
    set align(center)
    set text(font: 字体.黑体, size: 字号.四号)
    v(0.5em)
    it
    v(1em)
  }
  show heading.where(level: 2):it=>{ //单独设置二级标题
    set align(left)
    set text(font: 字体.黑体, size: 字号.小四)
    it
    v(0.5em)//二级标题后 行距
  }
  show heading.where(level: 3):it=>{ //单独设置三级标题
    set align(left)
    set text(font: 字体.黑体, size: 字号.小四)
    it
    v(0.2em)
  }
   
  show heading:it =>{
    it
    fake-par
  }
  //设置有序列表格式
  set enum( numbering:  " 1.")		//有序列表格式：1.
  //设置段落
  set par(
    justify: true, //两端对齐
    first-line-indent: 2em, //首段缩进
    leading: 1em, //行距
  )
  //设置图、表、代码样式
  show figure: it =>[
    #set align(center);//设置居中
    #set block(breakable: true)//允许表格换行
    #if it.kind == "image" { //图
      it.body
      //设置标题样式
      set text(font: 字体.黑体, size: 字号.五号)
      it.caption
    } else if it.kind == "table" { //表
      //表标题
      set text(font: 字体.黑体, size: 字号.五号)
      it.caption
      //设置表字体
      set text(font: 字体.宋体, size: 字号.五号)
      it.body
    } else if it.kind == "code" { //代码
      //设置标题样式
      set text(font: 字体.黑体, size: 字号.小五)
      it.caption
      //设置代码字体
      set text(font: 字体.代码, size: 字号.五号)
      it.body
    } else if it.kind == "equation" { //公式
      //通过大比例来达到中间靠右的排布
      grid(
        columns: (20fr, 1fr), //两列
        it.body, //显示公式
        align(center + horizon, it.counter.display(it.numbering)), //显示编号
      )
    } else if it.kind=="codeAppendix"{//附录代码
    table(
      columns: 100%,
      fill: (x,y)=>{if(x==0 and y==0){gray}},
      table.header(align(left)[*#it.caption*], repeat: false),
      [
        #set par(leading: 0.45em)
        #align(left)[
          #set text(font: 字体.代码, size: 字号.五号)
          #it.body]
      ]
    )}else {
      it
    }
  ]

  [
    #set page(footer: [#none])
    #[//题目
      #set text(font: 字体.黑体, size: 字号.三号)
      #align(center)[#title]
    ]
    #[//摘要字
      #set text(font: 字体.黑体, size: 字号.四号)
      #align(center)[摘#h(1em)要]
    ]
     
    #abstract
    #v(2em)
    //关键词
    #[
      #set text(font: 字体.黑体, size: 字号.小四)
      关键词：
    ]
    #for item in keywords{
      //set text(font: 字体.黑体, size: 字号.小四)
      item
      h(1em)
    }
    /*目录*/
    #contents()
  ]

  counter(page).update(1)
  body //正文
}
```

## 图表类

### 插入图片

```typst
#img(
  image("../figures/图片1.png", width:80%),
  caption: "问题二分析流程图"
)<1>
```

### 插入表格

```typst
#table(
  columns: (1fr,)*6,
  stroke: none,
  align: center + horizon,
  table.hline(stroke: 1.5pt),
  table.cell(rowspan: 2)[],
  table.cell(colspan: 2)[未标准化系数],table.cell(colspan: 2)[标准化系数],table.cell(rowspan: 2)[显著性],
  table.hline(stroke: 0.8pt),
  [$B$],[标准化错误],[$"Beta"$],[$t$],
  table.hline(stroke: 0.8pt),
  [$X$],[-.197],[.010],[-3.334],[-19.949],[<.001],
  [$X^2$],[.000],[.000],[2.752],[16.466],[<.001],
  [(常量)],[28.396],[.887],[],[32.018],[<.001],
  table.hline(stroke: 1.5pt)
)
```

## 参考文献

### 引用格式

```typst
#bibliography("refs.bib", title: none, style: "gb-7714-2015-numeric")
	//refs.bib参考文献文件，gb-7714-2015-numeric文献格式
```

### 文献文件
```latex
// refs.bib
@article{ wx1,
author = { 田凤调 },
title = {秩和比法及其应用},
journal = {中国医师杂志},
pages = {115-119},
year = {2002},
issn = {1006-1339},
number = {02},
}
// 田凤调.秩和比法及其应用[J].中国医师杂志,2002(2):115-119.
@book{ wx2,
    maintitle = {数学建模算法与应用},
    title = {数学建模算法与应用},
    author = {司守奎 and 孙玺菁},
    date = {2023},
    publisher = {国防工业大学出版社},
    location = {3版.北京},
}
// 司守奎,孙玺菁.数学建模算法与应用[M].3版.北京:国防工业大学出版社,2023.
@article{ wx3,
    author = { 杨维 and 李歧强 },
    title = {粒子群优化算法综述},
    journal = {中国工程科学},
    number = {05},
    pages = {87-94},
    year = {2004},
    issn = {1008-5599},
}
// 杨维,李歧强.粒子群优化算法综述[J].中国工程科学,2004(5):87-94.
@Patent{ wx4,
    title = {国家公务员局《中央和国家机关培训费管理办法》},
    serial-number = {财行[2016]540号},
    author = {财政部 and 中共中央组织部 and 国家公务员局},
    url = {http://www.scs.gov.cn/zcfg/201701/t20170105_6894.html},
    date = {2017-01-05},
}
// 财政部,中共中央组织部,国家公务员局.国家公务员局《中央和国家机关培训费管理办法》[P/OL].20170105.http://www.scs.gov.cn/zcfg/201701/t20170105_6894.html.
```

### 文件类型格式

- `article`. A short text, possibly of journalistic or scientific nature, appearing in some greater publication (default parent: `periodical`).
- `chapter`. A section of a greater containing work (default parent: `book`).
- `entry`. A short segment of media on some subject matter. Could appear in a work of reference or a data set (default parent: `reference`).
- `anthos`. Text published within an Anthology (default parent: `anthology`).
- `report`. A document compiled by authors that may be affiliated to an organization. Presents information for a specific audience or purpose.
- `thesis`. Scholarly work delivered to fulfill degree requirements at a higher education institution.
- `web`. Piece of content that can be found on the internet and is native to the medium, like an animation, a web app, or a form of content not found elsewhere. Do not use this entry type when referencing a textual blog article, instead use an `article` with a `blog` parent (default parent: `web`).
- `scene`. A part of a show or another type of performed media, typically all taking place in the same location (default parent: `video`).
- `artwork`. A form of artistic/creative expression (default parent: `exhibition`).
- `patent`. A technical document deposited at a government agency that describes an invention to legally limit the rights of reproduction to the inventors.
- `case`. Reference to a legal case that was or is to be heard at a court of law.
- `newspaper`. The issue of a newspaper that was published on a given day.
- `legislation`. Legal document or draft thereof that is, is to be, or was to be enacted into binding law (default parent: `anthology`).
- `manuscript`. Written document that is submitted as a candidate for publication.
- `original`. The original container of the entry before it was re-published.
- `post`. A post on a micro-blogging platform like Twitter (default parent: `post`).
- `misc`. Items that do not match any of the other Entry type composites.
- `performance`. A live artistic performance.
- `periodical`. A publication that periodically publishes issues with unique content. This includes scientific journals and news magazines.
- `proceedings`. The official published record of the events at a professional conference.
- `book`. Long-form work published physically as a set of bound sheets.
- `blog`. Set of self-published articles on a website.
- `reference`. A work of reference. This could be a manual or a dictionary.
- `conference`. Professional conference. This Entry type implies that the item referenced has been an event at the conference itself. If you instead want to reference a paper published in the published proceedings of the conference, use an `article` with a `proceedings` parent.
- `anthology`. Collection of different texts on a single topic/theme.
- `repository`. Publicly visible storage of the source code for a particular software, papers, or other data and its modifications over time.
- `thread`. Written discussion on the internet triggered by an original post. Could be on a forum, social network, or Q&A site.
- `video`. Motion picture of any form, possibly with accompanying audio (default parent: `video`).
- `audio`. Recorded audible sound of any kind (default parent: `audio`).
- `exhibition`. A curated set of artworks.

