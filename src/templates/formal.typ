#import "../common/dates.typ": ID-display-today

#let template(body) = {
  // ~ Setups
  // set document(title: title, author: author-name)
  set page(
    paper: "a4",
    margin: (
      x: 2cm,
      y: 3cm,
    ),
  )
  set par(justify: true, linebreaks: "optimized")
  set text(font: "Nimbus Roman", size: 12pt, fallback: false, hyphenate: false)
  set block(below: 1.5em)

  body
}

#let sign-part(
  use-info: true,
  name: [Moch. Nafkhan Alzamzami],
  city: [Sidoarjo],
  date-display: ID-display-today,
  info: [Yang membuat pernyataan,],
  sign: none,
) = {
  set align(left)
  if not use-info {
    info = none
  }
  let sign-part = if sign != none {
    sign
  } else {
    v(6em)
  }
  grid(
    columns: (1fr, auto, 2em),
    [],
    [
      #city, #date-display

      #info

      #sign-part

      #name
    ],
    [],
  )
}
