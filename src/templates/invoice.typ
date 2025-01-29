#import "../common/currency.typ": *

#let invoice-table(
  table-args: (),
  type: "rp", // "rp" | "usd"
  headers,
  items,
) = [
  #let args = if type == "rp" {
    (
      comma: ",",
      splitter: ".",
      prefix: [Rp ],
      d: 0,
    )
  } else if type == "usd" {
    (
      comma: ".",
      splitter: ",",
      prefix: [\$ ],
      d: 2,
    )
  }
  #let p(value) = print-currency(value, ..args)
  #let sums = items.map(item => item.price.at(0) * item.qty.at(0))
  #let total = sums.sum()
  #set text(number-type: "lining")
  #table(
    stroke: none,
    columns: (1fr, auto, auto, auto),
    align: (
      (column, row) => if column >= 3 {
        right
      } else {
        left
      }
    ),
    ..table-args,
    table.hline(),
    table.header(
      ..headers.map(v => [*#v*]),
      [*Price*],
      [*Qty*],
      [*Total*],
    ),
    table.hline(),
    ..items
      .map(v => (
        ..v.values,
        [#p(v.price.at(0))#v.price.at(1)],
        [#v.qty.at(0)#v.qty.at(1)],
        p(v.price.at(0) * v.qty.at(0)),
      ))
      .flatten()
      .map(v => [#v]),
    table.hline(),
    [],
    [],
    [*Total*],
    [#p(total)],
    table.hline(start: 2),
  )
]
