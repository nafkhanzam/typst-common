#import "@preview/valkyrie:0.2.1" as z
#import "@preview/codly:1.0.0"
#import "@preview/drafting:0.2.0": *

#let theme = (
  main: rgb("#0079C2"),
)

#let template(
  title: "",
  logo: "res/its-logo.png",
  event: "",
  author: "",
  author-desc: "",
  affiliation: "",
  date-display: datetime.today().display("[day] [month repr:long] [year]"), // date
  with-toc: false,
  with-date: false,
  bib-file: none,
  infinite-height: false,
  hl-todo: false,
  body,
) = {
  // ~ Argument Validations
  title = z.parse(title, z.string())
  logo = z.parse(logo, z.string(optional: true))
  event = z.parse(event, z.string())
  author = z.parse(author, z.string())
  author-desc = z.parse(author-desc, z.string())
  affiliation = z.parse(affiliation, z.string())
  date-display = z.parse(date-display, z.string())
  with-toc = z.parse(with-toc, z.boolean())
  with-date = z.parse(with-date, z.boolean())
  bib-file = z.parse(bib-file, z.string(optional: true))

  // ~ Setups
  set page(
    paper: "a4",
    margin: (
      x: 2cm,
      y: 3cm,
    ),
    header: context {
      let page-counter = counter(page).get().at(0)
      if page-counter > 1 [
        #set text(8pt)
        #title
        #h(1fr)
        #event
        #line(length: 100%)
      ]
    },
    footer: context [
      #set text(8pt)
      #line(length: 100%)
      #set align(right)
      Page
      #counter(page).display(
        "1 of 1",
        both: true,
      )
    ],
  )
  show: it => {
    if infinite-height {
      set page(
        height: auto,
        footer: context [
          #set text(8pt)
          #line(length: 100%)
          #set align(right)
        ],
      )
      it
    } else {
      it
    }
  }
  set-page-properties()
  set text(font: "FreeSerif", size: 10pt, fallback: false, hyphenate: false)
  set par(justify: true, linebreaks: "optimized")
  set enum(indent: 2em)
  set list(indent: 2em)
  show table: set enum(indent: 0pt)
  show table: set list(indent: 0pt)
  show table: set par(justify: false)
  show link: underline
  show link: text.with(fill: rgb(0, 0, 238))
  // show par: set block(spacing: 2em)
  set heading(numbering: "1.", supplement: "Section")
  // show heading: it => block({
  //   if it.numbering != none {
  //     grid(
  //       columns: (32pt, 1fr),
  //       gutter: .25em,
  //       counter(heading).display(), it.body,
  //     )
  //   } else {
  //     it.body
  //   }
  // })
  show heading.where(level: 1): body => {
    set text(fill: theme.main, size: 14pt)
    body
    v(0.25em)
  }
  show heading.where(level: 2): body => {
    set text(size: 12pt)
    body
    v(0.25em)
  }
  show heading.where(level: 3): body => {
    set text(size: 10pt)
    body
    v(0.25em)
  }
  show figure.where(kind: "table"): set text(size: 8pt)
  show figure.caption: it => [
    #set text(size: 9pt)
    #grid(
      columns: 2,
      gutter: .5em,
      [
        #set text(fill: theme.main, weight: "bold")
        #it.supplement
        #context it.counter.display(it.numbering).
      ],
      it.body,
    )
  ]
  show raw: set block(above: .65em)
  show: enable-todo-hl
  show: codly.codly-init.with()
  codly.codly(number-format: none)

  // ~ Content

  let title-content = [
    #if with-date {
      set text(size: 10pt)
      show: place.with(right + top, float: false)

      date-display
    }

    #if logo != none {
      show: place.with(left + top, float: false)
      image(logo, height: 6em)
    }

    #set align(center)

    #[
      #show: box.with(width: 60%)

      #{
        set text(size: 16pt, weight: "bold")

        title
      } \
      #set text(size: 9pt)
      #event

      #set text(size: 10pt)
      #author \
      #author-desc \
      #affiliation
    ]

    #line(length: 100%)
  ]

  title-content

  if with-toc {
    headz(outlined: false)[Table of Contents]
    pad(left: 0em, outline(title: none, indent: true))
  }

  body

  if bib-file != none {
    headz[References]
    bibliography(title: none, bib-file)
  }
}

#let fig-img-args = state(
  "fig-img-args",
  (
    supplement: "Figure",
  ),
)
#let fig-img(
  img,
  caption: none,
  lab: none,
  ..args,
) = (
  context [
    #figure(
      img,
      kind: "image",
      ..fig-img-args.get(),
      caption: caption,
      // placement: top,
      ..args,
    ) #if lab != none {
      label(lab)
    }
  ]
)

#let fig-tab-args = state(
  "fig-tab-args",
  (
    supplement: "Table",
  ),
)
#let fig-tab(
  tab,
  caption: none,
  lab: none,
  ..args,
) = (
  context [
    #figure(
      tab,
      kind: "table",
      ..fig-tab-args.get(),
      caption: figure.caption(position: top, caption),
      // placement: top,
      ..args,
    ) #if lab != none {
      label(lab)
    }
  ]
)

#let hl(body) = highlight(body)
#let red-hl(body) = highlight(fill: red, body)
