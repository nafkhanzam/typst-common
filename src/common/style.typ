#let headz(outlined: true, body) = heading(outlined: outlined, numbering: none, body)
#let phantom(body) = place(top, scale(x: 0%, y: 0%, body))
#let s-center(body) = align(center + horizon, body)

#let enable-todo-hl(body) = {
  show "TODO": box(
    fill: red.darken(25%),
    outset: .15em,
    text(fill: white)[TODO],
  )

  body
}
#let icite(key) = cite(label(key), form: "prose")
#let i(body) = {
  set cite(form: "prose")
  body
}
#let entry-fields(entries, ..args) = grid(
  columns: 3,
  gutter: 0.65em,
  ..args,
  ..entries.map(v => (v.at(0), [: ], v.at(1))).flatten(),
)
