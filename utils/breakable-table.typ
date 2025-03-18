#let xubiao = state("xubiao")
#set table(
  stroke: (x, y) => {
    if y == 0 { none } else { 1pt }
  },
)
#show table: it => xubiao.update(false) + it
#show figure: set block(breakable: true)


#let breakable-table(columns:auto, label: none, caption: none, header: (), ..args) = [
  #figure(
    table(
      columns: columns,
      table.header(
        table.cell(
          colspan: columns,
          {
            context if xubiao.get() {
              ref(label)+h(1em)+"(续)"
            } else {
              v(-0.9em)
              xubiao.update(true)
            }
          },
        ),
        table.hline(),
        ..header,
        table.hline(stroke: .5pt),
      ),
      ..args,
      table.hline()
    ),
    caption: caption,
  ) #label
]