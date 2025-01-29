#import "../common/currency.typ": *

#let invoice-table(
  type: "rp", // "rp" | "usd"
  headers,
  items,
) = [
  #let args = if type == "rp" {
    (
      comma: ",",
      splitter: ".",
      prefix: [Rp ],
    )
  } else if type == "usd" {
    (
      comma: ",",
      splitter: ".",
      prefix: [\$],
    )
  }
  #let p(value) = print-currency(value, ..args)
  #let sums = items.map(item => item.price * item.qty)
  #let total = sums.sum()
  #set text(number-type: "lining")
  #table(
    stroke: none,
    columns: (auto, auto, auto, auto),
    align: (
      (column, row) => if column >= 3 {
        right
      } else {
        left
      }
    ),
    table.hline(),
    table.header(
      ..headers.map(v => [*#v*]),
      [*Price*],
      [*Qty*],
      [*Total*],
    ),
    table.hline(),
    ..items.map(v => (..v.values, p(v.price), v.qty, p(v.price * v.qty))).flatten().map(v => [#v]),
    table.hline(),
    [],
    [],
    [*Total*],
    [#p(total)],
    table.hline(start: 2),
  )
]
