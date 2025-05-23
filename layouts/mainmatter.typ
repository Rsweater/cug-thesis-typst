// #import "@preview/anti-matter:0.0.2": anti-front-end
#import "../utils/style.typ": 字号, 字体
#import "../utils/custom-numbering.typ": custom-numbering
#import "../utils/custom-heading.typ": heading-display, active-heading, current-heading
#import "../utils/unpairs.typ": unpairs
#import "../utils/anonymous-info.typ": anonymous-info
#import "../utils/word-counter.typ": *
#import "../utils/number-per-chapter.typ": sub-figure-numbering, figure-numbering, equation-numbering, raw-numbering


#let mainmatter(
  // documentclass 传入参数
  twoside: false,
  anonymous: false,
  fonts: (:),
  info: (:),
  // 其他参数
  leading: 20pt-1.0em,
  spacing: 20pt-1.0em,
  justify: true,
  first-line-indent: (amount: 2em, all: true),
  custom-numbering: custom-numbering.with(first-level: "第一章   ", depth: 4, "1.1   "),
  // 正文字体与字号参数
  text-args: auto, // auto =>宋体、小四, 20pt
  // 标题字体与字号
  heading-font: auto,  // auto => 黑体
  heading-size: (字号.三号, 字号.四号, 字号.小四, 字号.小四),  // TIps: 自定义四级标题格式
  heading-weight: ("bold", "bold", "regular", "regular"),
  heading-above: (2.0 * 1.0em, 1.0 * 1.0em, 1.0 * 1.0em, 
  ),  // 页面最上方的距离压缩到 0em，四级标题使用固定值20pt
  heading-below: (2.0 * 1.0em, 1.0 * 1.0em, 1.0 * 1.0em, 
  ), 
  heading-pagebreak: (true, false, false, ),
  heading-align: (center, center, left, ),
  // 页眉
  header-vspace: 0.5cm,
  header-line-width: 0.6pt,
  // caption 的 separator
  separator: 1.0em,
  // caption 样式
  caption-leading: 1.0em, 
  caption-size: 字号.五号,
  // // figure 计数
  // show-figure: i-figured.show-figure,
  // // equation 计数
  // show-equation: i-figured.show-equation,
  ..args,
  it,
) = {
  // 1.  默认参数
  fonts = 字体 + fonts
  if text-args == auto {
    text-args = (
      font: fonts.宋体, size: 字号.小四, 
      // bottom-edge: "descender", top-edge: "ascender",
      bottom-edge: 0em, top-edge: 1.0em,
      // cjk-latin-spacing: auto, // 自动添加cjk与latin间距
    )
  }
  
  // 1.1 字体与字号
  if heading-font == auto {
    heading-font = (fonts.黑体,)
  }
  // 1.0 处理 heading- 开头的其他参数
  let heading-text-args-lists = args.named().pairs()
    .filter((pair) => pair.at(0).starts-with("heading-"))
    .map((pair) => (pair.at(0).slice("heading-".len()), pair.at(1)))

  let header-annotations = {
    if info.doctype == "doctor" {
      if info.is-equivalent { "同等学力博士学位论文" }
      else { "博士学位论文" }
      } 
    else { // 硕士：
      if info.is-equivalent { "同等学力硕士学位论文" }
      else { 
        if info.degreetype == "academic" { "硕士学位论文" } 
        else { 
          if info.is-fulltime { "硕士专业学位论文(全日制)" } 
          else { "硕士专业学位论文(非全日制)" }
        }
      }
    }   
  }
  if type(info.title) == str {
    info.title = info.title.split("\n")
  }

  // 2.  辅助函数
  let array-at(arr, pos) = {
    arr.at(calc.min(pos, arr.len()) - 1)
  }
  let anonymous-info = anonymous-info.with(anonymous: anonymous)

  // 3.  设置基本样式
  // 3.1 文本和段落样式
  set text(..text-args)
  show text: set block(breakable: true)
  set par(
    leading: leading,
    justify: justify,
    spacing: spacing,
    first-line-indent: first-line-indent, 
    linebreaks: "simple" // 避免压缩CJK标点符号，与 Word 默认保持一致
  )
  show raw.where(block: false): box.with(
    fill: rgb("#fafafa"),
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 2pt,
  )
  show raw.where(block: false): text.with(
    font: 字体.等宽,
    size: 10.5pt,
  )
  show raw.where(block: true): block.with(
    fill: rgb("#fafafa"),
    inset: 8pt,
    radius: 4pt,
    width: 100%,
  )
  show raw.where(block: true): text.with(
    font: 字体.等宽,
    size: 10.5pt,
  )

  // 3.2 脚注样式
  show footnote.entry: set text(font: fonts.宋体, size: 字号.五号)
  // set heading(numbering: "1.1")
  // 子图编号
  // let sub-figure-numbering = (super, sub) => numbering("1.1a", counter(heading).get().first(), super, sub)
  // let figure-numbering = super => numbering("1.1", counter(heading).get().first(), super)
  // let equation-numbering = super => numbering("（1.1）", counter(heading).get().first(), super)
  // set heading(numbering: "1.1")
  show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(figure.where(kind: raw)).update(0)
    it
  }
  show figure.caption: it => {
    let pattern = "^[^:]+" + sym.space.nobreak + "[\d.]+"
    show regex(pattern): strong
    show regex(pattern): emph
    // show regex(pattern): set text(weight: "bold")
    // show regex(pattern): set text(style: "italic")
    it
  }
  show figure: set figure(numbering: figure-numbering)
  show math.equation: set math.equation(numbering: equation-numbering)
  show figure.where(kind: raw): set figure(numbering: raw-numbering)

  // 3.3 设置 figure 的编号
  // show heading: i-figured.reset-counters
  // show figure: show-figure
  // 3.4 设置 equation 的编号和假段落首行缩进
  // show math.equation.where(block: true): show-equation
  // 3.5 表格表头置顶 + 不用冒号用空格分割 + 样式
  show figure.where(
    kind: table
  ): set figure.caption(position: top)
  set figure.caption(separator: h(separator))
  show figure: set text(font: fonts.宋体, size: 字号.五号)
  show figure: set par(leading: caption-leading)
  // 表格可跨页
  show figure: set block(breakable: true)
  let xubiao = state("xubiao")
  show table: it => xubiao.update(false) + it
  // 3.6 优化列表显示
  //     术语列表 terms 不应该缩进
  show terms: set par(first-line-indent: 0pt)

  // 4.  处理标题
  // 4.1 设置标题的 Numbering
  set heading(numbering: custom-numbering)
  // 4.2 设置字体字号并加入假段落模拟首行缩进
  show heading: it => {
    set text(
      bottom-edge: 0em, top-edge: 1.0em,
      font: array-at(heading-font, it.level),
      size: array-at(heading-size, it.level),
      weight: array-at(heading-weight, it.level),
      ..unpairs(heading-text-args-lists
        .map((pair) => (pair.at(0), array-at(pair.at(1), it.level))))
    )
    set block(
      above: array-at(heading-above, it.level)*1.5,
      below: array-at(heading-below, it.level)*1.5,
    )
    it
  }
  show heading.where(level: 1): it => {
    v(array-at(heading-above, 1), weak: false)
    it
  }
  // 4.3 标题居中与自动换页
  show heading: it => {
    if array-at(heading-pagebreak, it.level) {
      // 如果打上了 no-auto-pagebreak 标签，则不自动换页
      if "label" not in it.fields() or str(it.label) != "no-auto-pagebreak" {
        pagebreak(weak: true)
      }
    }
    if array-at(heading-align, it.level) != auto {
      set align(array-at(heading-align, it.level))
      it
    } else {
      it
    }
  }

  // 5.  处理页眉
  set page(..(
      header: context {
        let numbering = if page.numbering != none { page.numbering } else { "1" }
        // 
        let page = counter(page).display(numbering)
        set text(font: 字体.宋体, size: 字号.五号, baseline: 6pt)

        stack(
          dir: if calc.odd(here().page()) { rtl } else { ltr }, 
          page, 
          1fr, 
          if calc.odd(here().page()) { 
            anonymous-info(info.school-name)+header-annotations 
          } else {
            anonymous-info(info.author)+"："+info.title.join("") }, 
          1fr
        )
        line(length: 100%, stroke: header-line-width)
      }, 
      header-ascent: 0.5cm,  // 3.0 - 0.5 = 2.5cm 页眉上边距
      footer-descent: 1.0cm  // 3.0 - 1.0 = 2.0cm 页脚下边距
  ))

  // show link: it => {
  //   underline(text(rgb(0, 0, 255), it))
  // }

  // 列表样式
  set enum(indent: 0.9em, body-indent: 0.35em)
  set list(indent: 1.2em, body-indent: 0.6em)

  // 引述文本样式
  // show quote: set text(font: fonts.楷体)
  show quote: set pad(x: 2em)

  set underline(stroke: 0.5pt + black, offset: 0.35em)

  show ref.where(): it => {
    if it.element == none {
      // Keep citations as is
      it
    } else {
      // Remove spacing
      if it.element.func() == heading {
        it + h(-0.8em)
      } else {
      // Other references as usual.
      it
      } 
    }
  }
  show ref: set block(breakable: true)

  // 字数统计（正文 + 附录）
  //   typst query main.typ '<total-words>' 2>/dev/null --field value --one
  context [
    #metadata(state("total-words-cjk").final()) <total-words>
    #metadata(state("total-characters").final()) <total-chars>
  ]
  counter(page).update(1)

  it
}

// test code
// #import "../mythesis/others/test-text.typ": test-text, mainmatter-parms
// #set text(fallback: false, lang: "zh", region: "CN")
// #set page(margin: (x: 3cm, y: 3cm))
// #mainmatter(
//   ..mainmatter-parms,
//   test-text
// )
