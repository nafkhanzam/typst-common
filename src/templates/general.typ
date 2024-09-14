#import "@preview/valkyrie:0.2.1" as z
#import "@preview/codly:1.0.0"
#import "@preview/drafting:0.2.0": *
#import "../common/style.typ": *

#let template(
  title: [],
  logo: "res/its-logo.png",
  event: [],
  author: [],
  author-desc: [],
  affiliation: [],
  date-display: datetime.today().display("[day] [month repr:long] [year]"), // date
  with-toc: false,
  toc-title: [Table of Contents],
  with-date: false,
  footer-left: none,
  footer-right: context counter(page).display("1"),
  bib: none,
  infinite-height: false,
  hl-todo: false,
  theme: (
    main: rgb("#0079C2"),
  ),
  font-size: 10pt,
  body,
) = {
  // ~ Argument Validations
  let z-content = z.either(z.string(), z.content())
  title = z.parse(title, z-content)
  logo = z.parse(logo, z.string(optional: true))
  event = z.parse(event, z-content)
  author = z.parse(author, z-content)
  author-desc = z.parse(author-desc, z-content)
  affiliation = z.parse(affiliation, z-content)
  date-display = z.parse(date-display, z-content)
  with-toc = z.parse(with-toc, z.boolean())
  with-date = z.parse(with-date, z.boolean())
  bib = z.parse(bib, z.content(optional: true))

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
        #set text(.8em)
        #title
        #h(1fr)
        #event
        #line(length: 100%)
      ]
    },
    footer: [
      #set text(.8em)
      #line(length: 100%)
      #footer-left
      #h(1fr)
      #footer-right
    ],
  )
  show: it => {
    if infinite-height {
      set page(height: auto)
      it
    } else {
      it
    }
  }
  set-page-properties()
  set text(font: "FreeSerif", size: font-size, fallback: false, hyphenate: false)
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
  show heading.where(level: 1): it => {
    set text(fill: theme.main)
    it
    v(0.25em)
  }
  show heading.where(level: 2): it => {
    it
    v(0.25em)
  }
  show heading.where(level: 3): it => {
    it
    v(0.25em)
  }
  show figure.where(kind: "table"): set text(size: .8em)
  show figure.caption: it => [
    #set text(size: .9em)
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

  //~ Title
  [
    #set par(spacing: .6em)

    #grid(
      columns: (1fr, 60%, 1fr),
      if logo != none {
        set align(left + top)
        image(logo, height: 6em)
      },
      {
        set align(center)
        set par(justify: false)
        text(size: 16pt, weight: "bold", title)
        linebreak()
        text(size: .9em, event)
        linebreak()
        set text(size: 1.0em)
        author
        linebreak()
        author-desc
        linebreak()
        affiliation
      },
      if with-date {
        set align(right + top)
        set text(size: 1.0em)

        date-display
      },
    )

    #line(length: 100%)
  ]

  // ~ Content

  if with-toc {
    outline(title: toc-title, indent: true)
  }

  body

  if bib != none {
    set par(justify: false)
    bib
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

//~ Utilities
#let setup-indonesian(body) = [
  #fig-img-args.update(v => {
    v.at("supplement") = "Gambar"
    v
  })
  #fig-tab-args.update(v => {
    v.at("supplement") = "Tabel"
    v
  })
  #body
]
