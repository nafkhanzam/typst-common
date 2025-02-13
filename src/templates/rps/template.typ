#import "./cpl.typ": *
#import "./dosen.typ": *
#import "../../common/style.typ": *

#let bilingual(entry) = if type(entry) == array [
  #if entry.len() > 1 [
    #entry.at(0) \
    _#entry.at(1)_
  ] else [
    #entry.at(0)
  ]
] else [
  #entry
]

#let list-or-alone(entry) = if type(entry) == array [
  #if entry.len() > 1 [
    #list(..entry)
  ] else [
    #entry.at(0)
  ]
] else [
  #entry
]

#let rps-template(data) = {
  set page(flipped: true)
  set text(font: "FreeSerif")

  let blue-color = rgb("#DAE3F3")
  let gray-color = rgb("#E7E6E6")
  let cpl-filtered = cpl
    .enumerate()
    .map(v => (v.at(0) + 1, v.at(1)))
    .filter(((i, _)) => data.cpmk.map(cpmk-v => (cpmk-v.cpl)).flatten().contains(i))

  let week = counter("week")

  grid(
    table(
      columns: (auto, 1fr, auto),
      fill: blue-color,
      image("logo.png", width: 60pt),
      [
        #set text(weight: "bold")
        #show: s-center
        #text(size: 18pt)[
          INSTITUT TEKNOLOGI SEPULUH NOPEMBER (ITS)
        ] \
        #text(size: 14pt)[
          FAKULTAS TEKNOLOGI ELEKTRO DAN INFORMATIKA CERDAS \
          DEPARTEMEN TEKNIK INFORMATIKA
        ]
      ],
      [
        #show: s-center
        #set text(weight: "bold", size: 12pt)
        Kode \ Dokumen
      ],
      table.cell(colspan: 3)[
        #show: s-center
        #set text(weight: "bold", size: 14pt)
        RENCANA PEMBELAJARAN SEMESTER
      ]
    ),
    table(
      columns: 6,
      ..(
        [MATA KULIAH (MK)],
        [KODE],
        [Rumpun MK],
        [BOBOT (sks)],
        [SEMESTER],
        [Tgl Penyusunan],
      ).map(v => table.cell(fill: gray-color)[*#v*]),
      text(weight: "bold")[#data.judul.id],
      [#data.kode],
      [#data.rumpun-mk],
      table.cell(
        inset: 0pt,
        table(
          columns: 2 * (1fr,),
          [#data.sks],
          [
            #if data.sks-prak > 0 {
              data.sks-prak
            }
          ],
        ),
      ),
      [#data.semester],
      [#data.created-at],

      table.cell(rowspan: 2)[
        #set text(weight: "bold")
        OTORISASI / \ PENGESAHAN
      ],
      ..(
        (2, [Dosen Pengembang RPS]),
        (1, [Koordinator RMK]),
        (2, [Ka PRODI]),
      ).map(((sp, v)) => table.cell(colspan: sp, fill: gray-color)[*#v*]),
      ..(
        (2, [#list-or-alone(data.pengembang.map(v => [#dosen.at(v)]))]),
        (1, [#dosen.at(data.koordinator)]),
        (
          2,
          [
            #show: s-center
            #v(3em)

            Tanda tangan
          ],
        ),
      ).map(((sp, v)) => table.cell(colspan: sp)[#v]),
    ),
    table(
      columns: (1fr, 1fr, 7fr),
      table.cell(rowspan: cpl-filtered.len() + data.cpmk.len() + 2)[
        *Capaian Pembelajaran*
      ],
      table.cell(colspan: 2)[*CPL-PRODI yang dibebankan pada MK*],
      ..cpl-filtered
        .map((
          (i, v),
        ) => (
          [CPL #i],
          [#bilingual(v)],
        ))
        .flatten(),
      table.cell(colspan: 2)[*Capaian Pembelajaran Mata Kuliah (CPMK)*],
      ..data.cpmk.enumerate().map(((i, v)) => ([CPMK #(i+1)], [#bilingual(v.text)])).flatten(),
      [*Peta CPL-CPMK*],
      table.cell(
        inset: 0pt,
        colspan: 2,
        table(
          columns: (6em,) + cpl-filtered.len() * (auto,),
          [], ..cpl-filtered.map(((cpl-i, v)) => text(weight: "bold")[CPL #cpl-i]),
          ..data
            .cpmk
            .enumerate()
            .map(((i, cpmk-v)) => (
              [CPMK #(i+1)],
              ..cpl-filtered.map(((cpl-i, v)) => {
                show: s-center
                if cpmk-v.cpl.contains(cpl-i) {
                  sym.checkmark
                } else { }
              }),
            ))
            .flatten(),
        ),
      ),
      [*Deskripsi Singkat MK*],
      table.cell(colspan: 2)[#bilingual(data.deskripsi)],
      [*Bahan Kajian:* \ Materi pembelajaran],
      table.cell(colspan: 2)[#list(..data.bahan-kajian.map(v => [#v]))],
      [*Pustaka*],
      table.cell(colspan: 2)[
        #pad(bottom: -.6em, rect(fill: gray-color, stroke: 1pt + black)[*Utama:*])
        #enum(..data.pustaka.utama)
        #pad(bottom: -.6em, rect(fill: gray-color, stroke: 1pt + black)[*Pendukung:*])
        #enum(..data.pustaka.pendukung)
      ],
      [*Dosen Pengampu*],
      table.cell(colspan: 2)[#list(..data.pengampu.map(v => dosen.at(v)))],
      [*Matakuliah Syarat*],
      table.cell(colspan: 2)[
        #if data.mk-syarat.len() > 0 {
          list(..data.mk-syarat)
        } else [--]
      ],
    ),
    table(
      columns: (1fr, 3fr, 3fr, 2fr, 1.5fr, 1.5fr, 3fr, 1fr),
      align: (x, y) => if y < 3 {
        center + horizon
      } else if x == 0 {
        center
      } else {
        left
      },
      table.cell(rowspan: 2)[
        #set text(weight: "bold")
        Mg Ke-
      ],
      table.cell(rowspan: 2)[
        #set text(weight: "bold")
        Kemampuan akhir tiap tahapan belajar (Sub-CPMK)
      ],
      table.cell(colspan: 2)[
        #set text(weight: "bold")
        Penilaian
      ],
      table.cell(colspan: 2)[
        #set text(weight: "bold")
        Bentuk Pembelajaran; \
        Metode Pembelajaran; \
        Penugasan Mahasiswa; \
      ],
      table.cell(rowspan: 2)[
        #set text(weight: "bold")
        Materi Pembelajaran
      ],
      table.cell(rowspan: 2)[
        #set text(weight: "bold")
        Bobot Penilaian (%)
      ],
      text(weight: "bold")[Indikator],
      text(weight: "bold")[Kriteria & Teknik],
      text(weight: "bold")[Tatap Muka],
      text(weight: "bold")[Daring],
      ..range(1, 9).map(i => [*(#i)*]),
      ..data
        .rps
        .enumerate()
        .map(((i, rps)) => {
          let st = data.rps.slice(0, i).fold(0, (curr, next) => curr + next.at("span", default: 1)) + 1
          let span = rps.at("span", default: 1)
          let ed = st + span - 1
          let cell = if st == ed {
            [(#st)]
          } else {
            [(#st\-#ed)]
          }
          return (
            [#cell],
            [#rps.kemampuan],
            [#rps.penilaian.indikator],
            [#rps.penilaian.kriteria],
            [#rps.tatap-muka],
            [#rps.daring],
            [#rps.materi],
            {
              if rps.bobot > 0 {
                [#rps.bobot%]
              }
            },
          )
        })
        .flatten(),
      table.cell(colspan: 7)[_*Total Bobot*_],
      text(weight: "bold")[#data.rps.map(v => v.bobot).sum()%],
    ),
  )

  pagebreak(weak: true)
}
