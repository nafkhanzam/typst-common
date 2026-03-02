#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *

#let code(value, font-size: 1em, ..args) = {
  show: codly-init.with()
  set text(size: font-size)
  codly(languages: codly-languages, number-format: none, ..args.named())

  value
}
