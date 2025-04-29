#import "@preview/showybox:2.0.3": showybox

#let ans-mode-ref = state("ans-mode-ref", false)

#let get-ans-env() = {
  if "ANS" in sys.inputs {
    let v = lower(sys.inputs.ANS)
    return v == "true" or v == "1"
  } else {
    return false
  }
}

#let its-exam-template(
  course: none,
  title: none,
  descriptions: (),
  ans-mode: get-ans-env(),
  page-init: none,
  body,
) = {
  set document(title: course + ": " + title)
  set par(justify: true, linebreaks: "simple")
  set text(font: "Roboto", size: 12pt, fallback: false, hyphenate: false)
  set enum(full: true)
  show: body => {
    if page-init != none {
      page-init(body)
    } else {
      page(
        paper: "a4",
        margin: 3cm,
        footer: context align(right)[
          Page
          #counter(page).display(
            "1 of 1",
            both: true,
          )
        ],
        body,
      )
    }
  }
  ans-mode-ref.update(v => ans-mode)

  align(center)[= #course \ #title]

  v(1em)

  if descriptions.len() > 0 {
    grid(
      columns: 2,
      gutter: 1em,
      ..descriptions.map(((key, value)) => ([#key], [#value])).flatten()
    )
  }

  v(1em)

  body
}

#let answer(body) = (
  context {
    if ans-mode-ref.final() {
      showybox(
        frame: (
          border-color: blue.darken(50%),
          title-color: blue.lighten(60%),
          body-color: blue.lighten(80%),
        ),
        shadow: (
          offset: 3pt,
        ),
        body,
      )
      v(1em)
    }
  }
)
