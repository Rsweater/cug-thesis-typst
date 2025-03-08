#import "@preview/codelst:2.0.2": sourcecode, code-frame
#import "./style.typ": 字体, 字号

#let codelst-sourcecode = sourcecode
#let hit-sourcecode = codelst-sourcecode.with(frame: code => {
  set text(font: 字体.等宽, size: 字号.五号)
  code-frame(code)
})

#let code-figure(content, caption: [], supplement: [代码], label-name: "") = {
  let fig = figure(
    hit-sourcecode(content),
    caption: caption,
    kind: raw,
    supplement: supplement,
  )
  [
    #if label-name == "" {
      [#fig]
    } else {
      let new-label = label(label-name)
      [#fig #new-label]
    }
  ]
}