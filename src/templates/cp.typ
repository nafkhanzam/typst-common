#import "../common/style.typ": *

#let template(title: [], body) = {
  set page(
    paper: "a4",
    margin: 4em,
    height: auto,
  )
  set text(font: "FreeSerif", fallback: false, hyphenate: false)
  set par(justify: true, linebreaks: "optimized")
  show: enable-todo-hl

  heading(title)

  body
}
