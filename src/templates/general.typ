#import "@preview/codly:1.1.1"
#import "@preview/drafting:0.2.0": *
#import "../common/data.typ": *
#import "../common/style.typ": *
#import "../common/utils.typ": *

#let template(
  title: [],
  logo: "res/its-logo.png",
  event: [],
  author: [],
  author-desc: [],
  affiliation: [],
  date-display: datetime.today().display("[day] [month repr:long] [year]"), // date
  with-date: false,
  footer-left: args => [#args.author -- #args.author-desc],
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
  // let z-content = z.either(z.string(), z.content())
  // title = z.parse(title, z-content)
  // logo = z.parse(logo, z.string(optional: true))
  // event = z.parse(event, z-content)
  // author = z.parse(author, z-content)
  // author-desc = z.parse(author-desc, z-content)
  // affiliation = z.parse(affiliation, z-content)
  // date-display = z.parse(date-display, z-content)
  // with-date = z.parse(with-date, z.boolean())
  // bib = z.parse(bib, z.content(optional: true))
  let args = arguments((
    title: title,
    logo: logo,
    event: event,
    author: author,
    author-desc: author-desc,
    affiliation: affiliation,
    date-display: date-display,
    with-date: with-date,
    bib: bib,
  ))

  // ~ Setups
  set text(font: "FreeSerif", size: font-size, fallback: false, hyphenate: false)
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
      #call-or-value(footer-left, args)
      #h(1fr)
      #call-or-value(footer-right, args)
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
  set par(justify: true, linebreaks: "optimized")
  set enum(indent: 1em)
  set list(indent: 1em)
  show table: set enum(indent: 0pt)
  show table: set list(indent: 0pt)
  show table: set par(justify: false)
  show table: set align(left)
  // show link: underline
  // show link: text.with(fill: rgb(0, 0, 238))
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

  body

  if bib != none {
    set par(justify: false)
    bib
  }
}

#let toc(..args) = {
  // show outline.entry: it => {
  //   [
  //     #it.body.children.at(0) #it.element.body #box(width: 1fr, it.fill) #it.page
  //   ]
  // }
  // show outline.entry: it => {
  //   [
  //     #box(width: auto, it.body.children.at(0)) #box(width: auto, it.element.body) #box(
  //       width: 1fr,
  //       it.fill,
  //     ) #box(
  //       width: auto,
  //       it.page,
  //     )
  //   ]
  // }
  // show outline.entry: it => link(it.element.location())[
  //   // #set box(clip: true, outset: (y: 0.5em), inset: (top: 0.125em))
  //   // #show: pad.with(left: .75em * (it.element.depth - 1))
  //   #grid(
  //     columns: 3,
  //     column-gutter: 4pt,
  //     row-gutter: 0em,
  //     inset: 0pt,
  //     gutter: 0pt,
  //     rows: 1,
  //     [
  //       #it.body.children.at(0)
  //     ],
  //     [
  //       #it.element.body #box(width: 1fr, it.fill)
  //     ],
  //     [
  //       #set align(bottom)
  //       #it.page
  //     ],
  //   )
  // ]
  // show outline.entry: it => repr(it)
  // show outline.entry: it => it
  show outline.entry.where(level: 1): strong
  set outline(indent: true, title: [Table of Contents])
  outline(..args)
}
