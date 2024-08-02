# 数学建模$Typst$模板

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

## 图标类

### 插入图片

```typst
#img(
  image("../figures/图片1.png", width:80%),
  caption: "问题二分析流程图"
)<1>
```

![](E:\typst\readme\1.png)

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

![](E:\typst\readme\2.png)
