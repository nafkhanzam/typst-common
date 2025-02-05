#import "../../common/currency.typ": *
#import "../../common/dates.typ": *

#let outline-entry-fn(prefix-count, start-level: 1) = (
  it => {
    let loc = it.element.location()
    let num = numbering(loc.page-numbering(), ..counter(page).at(loc))
    let prefixed = it.body.at("children", default: ()).len() > 1
    let body = it.body
    if prefixed {
      body = it.body.at("children").slice(1 + prefix-count).join()
    }
    link(
      loc,
      box(
        grid(
          columns: 3,
          gutter: 0pt,
          {
            for _ in range(it.level - start-level) {
              box(width: 1em)
            }
            if prefixed {
              it.body.at("children").slice(0, 1 + prefix-count).join()
              h(4pt)
            }
          },
          [#body#box(width: 1fr)[#it.fill]],
          align(bottom)[#num],
        ),
      ),
    )
  }
)

#let template(pintorita: false, ref-style: "apa", appendices: none, body) = {
  set page(
    paper: "a4",
    margin: 3cm,
    number-align: right,
  )
  set par(
    justify: true,
    leading: 1em,
    linebreaks: "optimized",
  )
  set text(
    font: "FreeSerif",
    size: 12pt,
    fallback: false,
    hyphenate: false,
    lang: "id",
  )
  set enum(indent: 1em, spacing: 1.5em, tight: false)
  set block(below: 1.5em)
  set heading(
    numbering: (num1, ..nums) => {
      if nums.pos().len() == 0 {
        [BAB #numbering("I", num1)] + "\t"
        h(10pt)
      } else {
        numbering("1.1", num1, ..nums)
        h(7pt)
      }
    },
  )
  set bibliography(style: ref-style)
  show figure.caption: set text(size: 10pt)

  if pintorita {
    import "@preview/pintorita:0.1.0"
    show raw.where(lang: "pintora"): it => pintorita.render(it.text)
  }
  show table: it => {
    set par(justify: false)
    set text(size: 10pt)
    // set align(left)
    it
  }
  set grid(gutter: 1em)
  show grid: it => {
    set par(justify: false)
    set align(left)
    it
  }
  show outline.entry: outline-entry-fn(1)
  show heading: it => {
    if it.level == 1 {
      set align(center)
      set text(size: 18pt, weight: "bold")
      it
      v(1.5em, weak: true)
    } else {
      set align(left)
      set text(size: 12pt, weight: "bold")
      it
      v(1.5em, weak: true)
    }
  }

  body

  if appendices != none {
    set page(numbering: "1")
    counter(heading).update(0)

    set heading(
      supplement: "Lampiran",
      numbering: (..nums) => {
        let arr = nums.pos()
        if arr.len() == 0 {
          []
        } else if arr.len() == 1 {
          [LAMPIRAN #numbering("1", ..arr).] + "\t"
        } else {
          numbering("1.", ..arr.slice(1))
        }
      },
    )

    show heading.where(level: 2): set heading(outlined: false)

    appendices
  }
}

#let budget-template(data, extend: true) = [
  #for (i, bd) in data.budget.enumerate() {
    set text(size: 11pt)
    let title-i = numbering("A", i + 1)
    show: block.with(breakable: false)
    show table.cell: it => {
      if it.y <= 1 or it.y >= bd.items.len() + 2 {
        strong(it)
      } else {
        it
      }
    }

    table(
      columns: if extend {
        (auto, 1fr, 1fr, auto, auto, auto, auto)
      } else {
        7
      },
      [#title-i],
      table.cell(colspan: 6)[#bd.title],
      [No],
      [Komponen],
      [Item],
      [Satuan],
      [Volume],
      [Biaya satuan],
      [Jumlah],
      ..bd
        .items
        .enumerate()
        .map(((j, item)) => (
          [#{
              j + 1
            }],
          [#item.component],
          [#item.item],
          [#item.unit],
          [#item.volume],
          table.cell(breakable: false)[#print-rp(item.price)],
          table.cell(breakable: false)[#box[#print-rp(item.total)]],
        ))
        .flatten(),
      table.cell(colspan: 6)[#align(center)[SUB TOTAL #title-i]],
      box[#print-rp(bd.total)],
    )
  }

  *TOTAL BIAYA #print-rp(data.budget-total)*
]

#let timeline-template(data) = {
  set text(size: 11pt)
  let (unit, length, ranges) = data.timeline
  let l = length

  show table.cell.where(x: 0): strong
  show table.cell.where(y: 0): strong

  table(
    columns: 2 * (auto,) + l * (1fr,),
    fill: (x, y) => if ranges
      .enumerate()
      .any(((j, v)) => {
        let (a, b) = v.range
        let pos = x - 2
        return j == y - 2 and a <= pos and pos <= b
      }) {
      blue.lighten(20%)
    } else {
      none
    },
    table.cell(rowspan: 2)[No],
    table.cell(rowspan: 2)[Jenis Kegiatan],
    table.cell(colspan: l)[#unit ke],
    ..(() * (l - 1)),
    ..range(l).map(i => [#{
        i + 1
      }]),
    ..ranges
      .enumerate()
      .map(((i, v)) => (
        [#{
            i + 1
          }],
        table.cell(align: left)[#v.title],
        l * ([],),
      ))
      .flatten(),
  )
}

#let cover-solid(data) = [
  #let cl-blue = rgb(32, 64, 106)
  #let cl-yellow = rgb(255, 210, 46)

  #set text(fill: white)
  #set page(fill: cl-blue, margin: 0em)
  #set par(justify: false)
  #set align(center)

  #show: pad.with(x: 2em)

  #v(1fr)

  #[
    #set text(weight: "bold", size: 20pt)

    PROPOSAL \
    PENGABDIAN KEPADA MASYARAKAT \
    SKEMA #upper(data.schema) DANA #upper(data.funding-source)

    #v(1fr)

    #image("lambang.png", width: 2.33in)

    #v(1fr)

    #set text(size: 18pt)

    #upper[#data.title]

    Lokasi : #data.partner.address

    #v(1fr)
  ]

  #let write-member-entry(member) = [#member.name (#member.department/#member.faculty)]

  #[
    #set text(size: 14pt)

    #text(size: 16pt)[*Tim Pengabdi:*] \
    #for member in data.members [
      #write-member-entry(member) \
    ]
  ]

  #v(1fr)

  #show: pad.with(x: -2em)

  #block(fill: cl-yellow, width: 100%, inset: (x: 1em, y: 3em))[
    #set text(fill: cl-blue)
    #set text(weight: "bold", size: 18pt)

    DIREKTORAT RISET DAN PENGABDIAN KEPADA MASYARAKAT \
    INSTITUT TEKNOLOGI SEPULUH NOPEMBER \
    SURABAYA #display-year
  ]
]

#let cover-white(data) = [
  #set par(justify: false)
  #set align(center)

  #let border-width = 12pt

  #show: body => {
    set page(margin: 0pt)
    rect(
      width: 100%,
      height: 100%,
      fill: none,
      stroke: border-width + rgb(47, 84, 150),
      pad(3cm - border-width, body),
    )
  }

  #[
    #set text(weight: "bold", size: 14pt)

    PROPOSAL \
    SKEMA PENELITIAN #upper(data.schema) \
    SUMBER DANA #upper(data.funding-source) \
    TAHUN #display-year

    #v(1fr)

    #image("lambang.png", width: 2.33in)

    #v(1fr)

    #text(size: 16pt, upper(data.title))

    #v(1fr)

    Tim Peneliti:
  ]

  #let write-member-entry(member) = [#member.name / #member.department / #member.faculty / #member.institution]

  #pad(x: -1cm)[
    #grid(
      columns: (auto, 1fr),
      [Ketua Peneliti], [: #write-member-entry(data.members.at(0))],
      [Anggota Peneliti], [: 1. #write-member-entry(data.members.at(1))],
      ..(
        data
          .members
          .slice(2)
          .enumerate()
          .map(((i, member)) => (
            [],
            [#hide[: ]#{
                i + 2
              }. #write-member-entry(member)],
          ))
          .flatten()
      )
    )
  ]

  #v(1fr)

  #[
    #set text(weight: "bold", size: 12pt)
    DIREKTORAT RISET DAN PENGABDIAN KEPADA MASYARAKAT \
    INSTITUT TEKNOLOGI SEPULUH NOPEMBER \
    SURABAYA \
    #display-year
  ]
]
