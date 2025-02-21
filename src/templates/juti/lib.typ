#import "../../common/style.typ": *
#import "../../common/utils.typ": nths

#let JOURNAL-NAME = [JUTI: Jurnal Ilmiah Teknologi Informasi]
#let get-align-by-page(pagei) = if calc.rem-euclid(pagei, 2) == 0 {
  left
} else {
  right
}

#let paper-idx = state("paper-idx", "single")
#let book-state = state(
  "book-state",
  (
    volume: [-],
    number: [-],
    month: 2,
    year: 2025,
  ),
)

#let template(
  title: [Preparation of Papers for JUTI (JURNAL ILMIAH TEKNOLOGI INFORMASI)],
  authors: (
    (
      name: [First A. Author],
      institution-ref: 0,
      email: [first.author\@email.com],
      contribution: [],
    ),
    (
      name: [Second B. Author],
      institution-ref: 0,
      email: [second.author\@email.com],
      contribution: [],
    ),
    (
      name: [Third C. Author],
      institution-ref: 1,
      email: [third.author\@email.com],
      contribution: [],
    ),
  ),
  corresponding-ref: 0,
  institutions: (
    (
      name: [Department and institution name of authors],
      address: [Address of institution],
    ),
    (
      name: [Department and institution name of authors],
      address: [Address of institution],
    ),
  ),
  abstract: [These instructions give you guidelines for preparing JUTI (Jurnal Ilmiah Teknologi Informasi) papers. Use this document as a template if you are using Microsoft Word 6.0 or later. The electronic file of your paper will be formatted further by JUTI editorial board. Paper titles should be written in uppercase. Avoid writing long formulas with subscripts in the title; short formulas that identify the elements are fine (e.g., "Nd–Fe–B"). Do not write “(Invited)” in the title. Full names of authors are preferred in the author field but are not required. If you have to shorten the author’s name, leave first name and last name unshorten. Put a space between authors’ initials. Do not cite references in the abstract. The length of abstract must between 150 – 250 words.],
  keywords: (
    [Enter key words or phrases in alphabetical order, separated by commas. The number of keywords must between 3-5 words.],
  ),
  meta: (
    received: datetime.today(),
    revised: datetime.today(),
    accepted: datetime.today(),
    doi: [draft],
  ),
  body,
  bib: none,
) = context {
  let paper-id = paper-idx.get()
  show ref: it => if str(it.target).contains("::::") {
    it
  } else {
    ref(label(str(it.target) + "::::" + paper-id))
  }
  let book = book-state.get()
  counter(heading).update(0)
  counter(figure.where(kind: image)).update(0)
  counter(figure.where(kind: table)).update(0)
  counter(figure.where(kind: math.equation)).update(0)
  set page(
    paper: "a4",
    header: context {
      show: pad.with(bottom: 1em)
      let paper-page-range = (
        query(label(paper-id + ":start")).last().location().page(),
        query(label(paper-id + ":end")).last().location().page(),
      )
      let pagei = here().page()
      set text(size: 9pt)
      set align(get-align-by-page(pagei))
      if calc.rem-euclid(pagei, 2) == 0 {
        if authors.len() > 2 {
          [#authors.at(0).short et al.]
        } else {
          let names = authors.enumerate().map(((i, v)) => [#v.short])
          inline-enum(prefix-fn: none, ..names)
        }
        [ -- ]
        text(style: "italic", title)
      } else {
        let month-year = datetime(
          year: book.year,
          month: book.month,
          day: 1,
        ).display("[month repr:long] [year]")
        JOURNAL-NAME
        [ \- ]
        text(
          style: "italic",
        )[Volume #book.volume, Number #book.number, #month-year: #paper-page-range.map(v => [#v]).join([ -- ])]
      }
    },
    footer: context {
      let pagei = here().page()
      set text(size: 10pt)
      set align(get-align-by-page(pagei))
      here().page()
    },
    margin: (
      x: 0.65in,
      y: 1in,
    ),
  )
  set text(font: "Times New Roman")
  set bibliography(
    style: "ieee",
    title: none,
    full: true,
  )
  set par(linebreaks: "optimized")

  //? Figure
  // set figure(placement: top)

  //? Image
  show figure.where(kind: image): set figure(placement: top, supplement: [Fig.])
  show figure.where(kind: image): set text(size: .8em)

  //? Table
  show figure.where(kind: table): set figure(placement: top, supplement: [Table])
  set table(align: left)
  show table: set enum(indent: 0pt)
  show table: set list(indent: 0pt)
  show table: set par(justify: false)
  show table.header: set text(weight: "bold")
  set table(stroke: none)
  show figure.where(kind: table): set text(size: .8em)
  show figure.where(kind: table): set figure.caption(position: top)

  //? Equation
  set math.equation(numbering: "(1)")
  show ref: it => {
    let eq = math.equation
    let el = it.element
    if el != none and el.func() == eq {
      // Override equation references.
      link(
        el.location(),
        numbering(
          el.numbering,
          ..counter(eq).at(el.location()),
        ),
      )
    } else {
      // Other references as usual.
      it
    }
  }

  //? START OF CONTENT
  [#metadata(none)#label(paper-id + ":start")]

  //? Title
  {
    set align(center)
    set text(size: 16pt, weight: "bold")
    // show: upper
    title
  }

  //? Author names
  {
    set align(center)
    set text(size: 12pt, weight: "bold")
    let names = authors.enumerate().map(((i, v)) => [#v.name #super[#{ i + 1 }#if corresponding-ref == i [,\*])]])

    inline-enum(prefix-fn: none, ..names)
  }

  //? Institutions
  {
    set align(center)
    set text(size: 10pt)

    for (i-institution, institution) in institutions.enumerate() {
      let author-indices = authors
        .enumerate()
        .map(((i, v)) => (
          ..v,
          _index: i,
        ))
        .filter(v => v.institution-ref == i-institution)
        .map(v => v._index + 1)

      [
        #super[#inline-enum(last-join: none, prefix-fn: none, ..author-indices.map(v => [#v])))] #institution.name \
        #institution.address

      ]
    }
  }

  //? Emails
  {
    set align(center)
    set text(size: 10pt)
    let emails = authors.enumerate().map(((i, v)) => [#v.email#super[#{ i + 1 })]])

    [E-mail: ]
    inline-enum(prefix-fn: none, ..emails)
  }

  v(.5em)
  line(length: 100%)

  //? Abstract Title
  {
    set align(center)
    set text(size: 10pt, weight: "bold")
    [ABSTRACT]
  }

  //? Abstract
  {
    set text(
      size: 10pt,
      // weight: "regular",
      // style: "italic",
    )
    set par(
      justify: true,
      first-line-indent: (amount: 2em, all: true),
    )
    abstract
  }

  //? Keywords
  {
    set text(
      size: 10pt,
      // weight: "regular",
      // style: "italic",
    )
    set par(justify: true)
    [*Keywords:* ]
    inline-enum(
      prefix-fn: none,
      last-join: none,
      ..keywords,
    )
  }

  line(length: 100%)
  v(.5em)

  //? Numberings
  set heading(
    numbering: (num1, ..nums) => {
      let l = nums.pos().len()
      numbering("1.1.1.", num1, ..nums)
      // if l == 0 {
      //   numbering("I.", num1)
      //   h(10pt)
      // } else if l == 1 {
      //   numbering("A.", ..nums)
      //   h(7pt)
      // } else if l == 2 {
      //   numbering("1)", ..nums.pos().slice(1), ..nums.named())
      // } else {
      //   panic("Unhandled heading 4 or more.")
      // }
    },
  )
  // set enum(numbering: "1)")
  //? Heading 1
  show heading.where(level: 1): it => {
    // set align(center)
    set text(size: 11pt, weight: "bold")
    it
    // smallcaps(it)
    v(.5em)
  }
  //? Heading 2
  show heading.where(level: 2): it => {
    set text(
      size: 11pt,
      weight: "bold",
      // style: "italic",
    )
    it
  }
  //? Heading 3
  show heading.where(level: 3): it => {
    set text(
      size: 11pt,
      weight: "bold",
      // style: "italic",
    )
    it
  }

  //? Metadata Footnote
  figure(
    pad(bottom: -1.2em)[
      #set align(left)
      #set text(size: 9pt)

      \* Corresponding author. \
      Received: #meta.received.display("[month repr:long]") #nths(meta.received.day()), #meta.received.display("[year]").
      Revised: #meta.revised.display("[month repr:long]") #nths(meta.revised.day()), #meta.revised.display("[year]").
      Accepted: #meta.accepted.display("[month repr:long]") #nths(meta.accepted.day()), #meta.accepted.display("[year]").

      #pad(y: -.65em, line(length: 100%))

      DOI: #meta.doi \
      © #datetime.today().display("[year]") JUTI: JURNAL ILMIAH TEKNOLOGI INFORMASI. All rights are reserved, including those for text and data mining, AI training, and similar technologies.
    ],
    placement: bottom,
    supplement: none,
    kind: "footnote-metadata",
  )

  set par(
    justify: true,
    first-line-indent: (amount: 2em, all: true),
  )
  set text(size: 11pt, weight: "regular")

  body

  //? References
  if bib != none {
    headz[References]

    set text(size: 8pt)
    bib
  }
  //? END OF CONTENT
  [#metadata(none)#label(paper-id + ":end")]
}
