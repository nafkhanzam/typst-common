#let headz(outlined: true, body) = heading(outlined: outlined, numbering: none, body)
#let phantom(body) = place(top, scale(x: 0%, y: 0%, hide(body)))
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

#let hl(body) = highlight(body)
#let red-hl(body) = highlight(fill: red, body)
#let bl = block.with(breakable: false)
#let inline-enum(
  join-sym: [,],
  last-join: [and],
  prefix-fn: i => [(#{i+1}) ],
  ..entries,
) = {
  entries = entries.pos()
  let n = entries.len()
  if n == 1 {
    return entries.at(0)
  }
  for (i, v) in entries.enumerate() {
    if i > 0 {
      [#join-sym ]
    }
    if n != 0 and i == n - 1 and last-join != none {
      [#last-join ]
    }
    let prefix = if prefix-fn != none {
      prefix-fn(i)
    }
    [#prefix#v]
  }
}
#let link-b(url, body) = {
  show: underline
  show: text.with(fill: rgb(0, 0, 238))

  if url != none {
    link(
      url,
      if body == [] {
        url
      } else {
        body
      },
    )
  } else {
    body
  }
}
#let allow-table-break(body) = {
  show figure.where(kind: "table"): set block(breakable: true)
  body
}
#let important(body) = underline[*#body*]
#let sym_ = body => {
  show: text.with(fallback: true)
  body
}
//! Experimental
#let bold-table-header(..args) = {
  table.header(..args.named(), ..args.pos().map(v => if v == table.hline() { v } else { text(weight: "bold", v) }))
}
