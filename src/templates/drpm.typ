#import "../common/currency.typ": *

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

#let sym_ = body => {
  show: text.with(fallback: true)
  body
}

#let template(pintorita: false, ref-style: "apa", appendices: none, body) = {
  set page(
    paper: "a4",
    margin: 3cm,
    number-align: right,
  )
  set par(justify: true, leading: 1em, linebreaks: "optimized")
  set text(
    font: "Nimbus Roman No9 L",
    size: 12pt,
    fallback: false,
    hyphenate: false,
    lang: "id",
  )
  set enum(indent: 1em, spacing: 1.5em, tight: false)
  set block(below: 1.5em)
  set heading(numbering: (num1, ..nums) => {
    if nums.pos().len() == 0 {
      [BAB #numbering("I", num1)] + "\t"
      h(10pt, weak: true)
    } else {
      numbering("1.1", num1, ..nums)
      h(7pt, weak: true)
    }
  })
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

#let fig-img(img, caption: none, ..args) = figure(
  img,
  kind: "gambar",
  supplement: "Gambar",
  caption: caption,
  ..args,
)

#let fig-tab(tab, caption: none, ..args) = figure(
  tab,
  kind: "tabel",
  supplement: "Tabel",
  caption: figure.caption(position: top, caption),
  ..args,
)

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
    fill: (x, y) => if ranges.enumerate().any(((j, v)) => {
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
