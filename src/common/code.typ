#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *

#let code(value, font-size: .65em, ..args) = {
  show: codly-init.with()
  set text(size: font-size)
  codly(
    languages: codly-languages,
    number-format: none,
    stroke: 1pt + gray,
    zebra-fill: gray.lighten(70%),
    ..args.named(),
  )

  value
}
