#import "../../common/style.typ": *

#let JOURNAL-NAME = [JUTI: Jurnal Ilmiah Teknologi Informasi]
#let get-align-by-page(pagei) = if calc.rem-euclid(pagei, 2) == 0 {
  left
} else {
  right
}

#let template(
  title: [Preparation of Papers for JUTI (JURNAL ILMIAH TEKNOLOGI INFORMASI)],
  authors: (
    (
      name: [First A. Author],
      institution-ref: 0,
      email: [first.author\@email.com],
    ),
    (
      name: [Second B. Author],
      institution-ref: 0,
      email: [second.author\@email.com],
    ),
    (
      name: [Third C. Author],
      institution-ref: 1,
      email: [third.author\@email.com],
    ),
  ),
  institutions: (
    (
      name: [department and institution name of authors],
      address: [address of institution],
    ),
    (
      name: [department and institution name of authors],
      address: [address of institution],
    ),
  ),
  abstract: [These instructions give you guidelines for preparing JUTI (Jurnal Ilmiah Teknologi Informasi) papers. Use this document as a template if you are using Microsoft Word 6.0 or later. The electronic file of your paper will be formatted further by JUTI editorial board. Paper titles should be written in uppercase. Avoid writing long formulas with subscripts in the title; short formulas that identify the elements are fine (e.g., "Nd–Fe–B"). Do not write “(Invited)” in the title. Full names of authors are preferred in the author field but are not required. If you have to shorten the author’s name, leave first name and last name unshorten. Put a space between authors’ initials. Do not cite references in the abstract. The length of abstract must between 150 – 250 words.],
  keywords: (
    [Enter key words or phrases in alphabetical order, separated by commas. The number of keywords must between 3-5 words.],
  ),
  metadata: (
    book: (
      volume: 1,
      number: 1,
      month: datetime.today().month(),
      year: datetime.today().year(),
      page: (123, 234),
    ),
    received: datetime.today(),
    revised: datetime.today(),
    accepted: datetime.today(),
    doi: "10.15676/juti.2024.16.4.1",
  ),
  body,
  bib: none,
) = {
  authors = authors
    .enumerate()
    .map(((i, v)) => (
      ..v,
      _index: i,
    ))
  institutions = institutions
    .enumerate()
    .map(((i, v)) => (
      ..v,
      _index: i,
    ))
  set page(
    paper: "a4",
    header: context {
      let pagei = here().page()
      set text(size: 10pt)
      set align(get-align-by-page(pagei))
      if calc.rem-euclid(pagei, 2) == 1 {
        let names = authors.enumerate().map(((i, v)) => [#v.name])
        inline-enum(prefix-fn: none, ..names)
        [ -- ]
        title
      } else {
        let month-year = datetime(
          year: metadata.book.year,
          month: metadata.book.month,
          day: 1,
        ).display("[month repr:long] [year]")
        JOURNAL-NAME
        [ \- Volume #metadata.book.volume, Number #metadata.book.number, #month-year: #metadata.book.page.map(v => [#v]).join([ -- ])]
      }
    },
    footer: context [
      #let pagei = here().page()
      #set text(size: 10pt)
      #set align(get-align-by-page(pagei))
      #here().page()
    ],
    margin: (
      x: 0.65in,
      y: 0.7in,
    ),
  )
  set text(font: "Times New Roman")
  set bibliography(
    style: "ieee",
    title: none,
    full: true,
  )

  //? Title
  {
    set align(center)
    set text(size: 16pt, weight: "bold")
    show: upper
    title
  }

  //? Author names
  {
    set align(center)
    set text(size: 12pt, weight: "bold")
    let names = authors.enumerate().map(((i, v)) => [#v.name#super[#{ i + 1 })]])

    inline-enum(prefix-fn: none, ..names)
  }

  //? Institutions
  {
    set align(center)
    set text(size: 10pt)

    for institution in institutions {
      let author-indices = authors.filter(v => v.institution-ref == institution._index).map(v => v._index + 1)

      [
        #super[#inline-enum(last-join: none, prefix-fn: none, ..author-indices.map(v => [#v])))]#institution.name \
        #institution.address

      ]
    }
  }

  //? Emails
  {
    set align(center)
    set text(size: 10pt)
    let emails = authors.enumerate().map(((i, v)) => [#link-b(none, v.email)#super[#{ i + 1 })]])

    [e-mail: ]
    inline-enum(prefix-fn: none, ..emails)
  }

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
      weight: "regular",
      style: "italic",
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
      weight: "regular",
      style: "italic",
    )
    set par(justify: true)
    [*Keywords:* ]
    inline-enum(
      prefix-fn: none,
      last-join: none,
      ..keywords,
    )
  }

  //? Numberings
  set heading(
    numbering: (num1, ..nums) => {
      if nums.pos().len() == 0 {
        numbering("I.", num1)
        h(10pt)
      } else {
        numbering("A.", ..nums)
        h(7pt)
      }
    },
  )
  set enum(numbering: "1)")
  //? Heading 1
  show heading.where(level: 1): it => {
    set align(center)
    set text(size: 11pt, weight: "regular")
    smallcaps(it)
    v(.5em)
  }
  //? Heading 2
  show heading.where(level: 2): it => {
    set text(
      size: 11pt,
      weight: "regular",
      style: "italic",
    )
    it
  }

  //? Metadata Footnote
  figure(
    [
      #set align(left)
      #set text(size: 9pt)
      Received: #metadata.received.display("[month repr:long] [day padding:none]")#super[th], #metadata.received.display("[year]").
      Revised: #metadata.revised.display("[month repr:long] [day padding:none]")#super[th], #metadata.revised.display("[year]").
      Accepted: #metadata.accepted.display("[month repr:long] [day padding:none]")#super[th], #metadata.accepted.display("[year]").

      #pad(y: -.65em, line(length: 100%))

      DOI: #metadata.doi
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
}
