#import "./cpl.typ": *
#import "./dosen.typ": *
#import "../../common/style.typ": *
#import "../../common/data.typ": *
#import "../../common/utils.typ": *

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

#let get-st-week(data, rps, i) = data.rps.slice(0, i).fold(0, (curr, next) => curr + next.at("span", default: 1)) + 1
#let get-ed-week(data, rps, i) = (
  get-st-week(data, rps, i)
    + {
      let span = rps.at("span", default: 1)
      span - 1
    }
)
#let get-week(data, rps, i) = {
  let st = get-st-week(data, rps, i)
  let ed = get-ed-week(data, rps, i)
  if st == ed [
    #st
  ] else [
    #st\-#ed
  ]
}
#let get-span(rps) = rps.at("span", default: 1)
#let get-bobot(rps) = rps.at("bobot", default: 0)

#let blue-color = rgb("#DAE3F3")
#let gray-color = rgb("#eeeeee")

#let rps-template(
  init-fn: it => {
    set text(font: "FreeSerif", size: 10pt)
    it
  },
  data,
) = {
  set page(flipped: true)
  show: it => if init-fn != none {
    show: it => init-fn(it)
    it
  } else {
    it
  }

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
          //! TEMP HACK: force height
          rows: 2 * 1.5em,
          stroke: none,
          [#data.sks],
          table.vline(),
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
      // columns: (1fr, 3fr, 3fr, 2fr, 2fr, 2fr, 3fr, 1fr),
      columns: (1fr, ..(2.5fr,) * 6, 1fr),
      align: (x, y) => if y < 3 {
        center + horizon
      } else if x == 0 {
        center
      } else {
        left
      },
      fill: (x, y) => if y <= 2 { gray-color },
      table.header(
        table.cell(rowspan: 2)[
          #set text(weight: "bold")
          Minggu Ke
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
      ),
      ..range(1, 9).map(i => [*(#i)*]),
      ..data
        .rps
        .enumerate()
        .map(((i, rps)) => {
          let week = get-week(data, rps, i)
          let span = get-span(rps)
          let if-span = if span > 1 [#span #sym.times]
          let time-template(rps, key1, key2, label, length) = {
            let content = access-field(rps, key1, key2, "content")
            if content != none {
              content
              linebreak()
            }
            if access-field(rps, key1, key2, "time", default: false) [
              *#label:* #if-span #data.sks #sym.times #length" = #{span * data.sks * length}"
            ]
          }
          if rps.at("test-only", default: false) {
            let gray-dark = gray-color.darken(10%)
            return (
              table.cell(fill: gray-dark)[#week],
              table.cell(colspan: 6, fill: gray-dark)[#rps.kemampuan],
              table.cell(
                fill: gray-dark,
                {
                  if rps.bobot > 0 {
                    [#rps.bobot%]
                  }
                },
              ),
            )
          } else {
            return (
              [#week],
              [#rps.kemampuan],
              [#rps.penilaian.indikator],
              {
                let method = access-field(rps, "penilaian", "kriteria", "method")
                if method != none [
                  *#method*
                ]

                parbreak()

                let non-tests = access-field(rps, "penilaian", "kriteria", "non-tests")
                if non-tests != none [
                  *Non-Tes:*
                  #list(..non-tests)
                ]

                let tests = access-field(rps, "penilaian", "kriteria", "tests")
                if tests != none [
                  *Tes:*
                  #list(..tests)
                ]
              },
              {
                time-template(rps, "tatap-muka", "tm", [TM], 50)
              },
              {
                time-template(rps, "daring", "pt", [PT], 60)
                parbreak()
                time-template(rps, "daring", "bm", [BM], 60)
              },
              [#list(..rps.materi)],
              {
                if rps.bobot > 0 {
                  [#rps.bobot%]
                }
              },
            )
          }
        })
        .flatten(),
      table.cell(colspan: 7)[_*Total Bobot*_],
      text(weight: "bold")[#data.rps.map(v => v.at("bobot", default: 0)).sum()%],
    ),
  )
}

#let rae-template(
  init-fn: it => {
    set text(font: "FreeSerif", size: 10pt)
    it
  },
  data,
) = {
  show: it => if init-fn != none {
    show: it => init-fn(it)
    it
  } else {
    it
  }

  table(
    columns: (1fr, 2fr, 2fr, 1fr),
    table.cell(rowspan: 2)[
      #image("logo.png", width: 60pt)
    ],
    table.cell(rowspan: 2, colspan: 2)[
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
    table.cell(inset: 1.2em)[
      #show: s-center
      #set text(weight: "bold", size: 26pt)
      RAE
    ],
    [
      #show: s-center
      #set text(weight: "bold", size: 12pt)
      Kode \ Dokumen
    ],
    table.cell(colspan: 4)[
      #show: s-center
      #set text(weight: "bold", size: 14pt)
      RENCANA ASESMEN DAN EVALUASI
    ],
    [
      *Kode:* #data.kode
    ],
    [
      *Bobot sks (T/P):* #data.sks / #data.sks-prak
    ],
    [
      *Rumpun MK:* #data.rumpun-mk
    ],
    [
      *Semester:* #data.semester
    ],
    [
      #set text(weight: "bold")
      OTORISASI
    ],
    [
      *Penyusun RAE* \
      #list-or-alone(data.pengembang.map(v => [#dosen.at(v)]))
    ],
    [
      *Koordinator RMK* \
      #dosen.at(data.koordinator)
    ],
    [
      *Ka PRODI* \
      #dosen.at(data.kaprodi)
    ],
  )

  table(
    columns: (auto, 1.1fr, 2fr, 3fr, auto),
    table.header(
      ..(
        [*No*],
        [*Jadwal (Minggu ke-)*],
        [*Bentuk Asesmen*],
        [*Sub-CPMK*],
        [*Bobot (%)*],
      ).map(v => table.cell(fill: gray-color, align(center, v))),
    ),
    ..data
      .rps
      .enumerate()
      .filter(((i, v)) => v.keys().contains("assessment") or get-bobot(v) > 0)
      .enumerate()
      .map(((i, (rps-i, rps))) => {
        (
          [#{ i + 1 }],
          [#get-week(data, rps, rps-i)],
          [#coalesce(
              access-field(rps, "assessment", "content"),
              list(..access-field(rps, "penilaian", "kriteria", "tests", default: ())),
            )],
          // [#(
          //     data
          //       .cpmk
          //       .enumerate()
          //       .filter(((i-cpmk, cpmk)) => access-field(rps, "cpmk", default: ()).contains(i-cpmk + 1))
          //       .map(((i-cpmk, cpmk)) => [
          //         *CPMK #{i-cpmk + 1}* \
          //         #cpmk.text.at(0)
          //       ])
          //       .join(parbreak())
          //   )],
          [
            #rps.kemampuan
          ],
          [#{ coalesce(access-field(rps, "assessment", "weight"), get-bobot(rps)) }%],
        )
      })
      .flatten()
  )
}

#let rtm-template(
  init-fn: it => {
    set text(font: "FreeSerif", size: 10pt)
    it
  },
  data,
) = {
  show: it => if init-fn != none {
    show: it => init-fn(it)
    it
  } else {
    it
  }

  let tasks = data.rps.filter(v => v.keys().contains("tugas"))

  table(
    columns: (1fr, 4fr),
    table.cell(fill: gray-color)[
      #image("logo.png", width: 60pt)
    ],
    table.cell(fill: gray-color)[
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
    table.cell(fill: gray-color, colspan: 2)[
      #show: s-center
      #set text(weight: "bold", size: 14pt)
      RENCANA TUGAS MAHASISWA
    ],
    table.cell(fill: gray-color)[
      *MATA KULIAH*
    ],
    [
      #data.judul.id
    ],
    table.cell(fill: gray-color)[
      *KODE*
    ],
    table.cell(
      inset: 0pt,
      table(
        columns: (20em, auto, 1fr, auto, 1fr),
        [#data.kode], table.cell(fill: gray-color)[*sks*], [#{ data.sks + data.sks-prak }], table.cell(
          fill: gray-color,
        )[*SEMESTER*], [#data.semester],
      ),
    ),
    table.cell(fill: gray-color)[
      *DOSEN PENGAMPU*
    ],
    [
      #list-or-alone(data.pengampu.map(v => [#dosen.at(v)]))
    ],
    table.cell(
      colspan: 2,
      inset: 0pt,
      table(
        columns: 1fr,
        fill: (x, y) => if calc.rem-euclid(y, 2) == 0 {
          gray-color
        },
        [*BENTUK TUGAS*],
        [
          #list(..tasks.map(rps => rps.tugas.bentuk-tugas).dedup())
        ],
        [*JUDUL TUGAS*],
        [
          #enum(..tasks.map(rps => [#rps.tugas.bentuk-tugas: #rps.tugas.judul-tugas]))
        ],
        [*DESKRIPSI DAN TUJUAN TUGAS*],
        [
          #enum(..tasks.map(rps => [#rps.tugas.deskripsi-dan-tujuan-tugas]))
        ],
        [*METODE PENGERJAAN TUGAS*],
        [
          #enum(..tasks.map(rps => [#rps.tugas.metode-pengerjaan-tugas]))
        ],
        [*BENTUK DAN FORMAT LUARAN*],
        [
          #enum(
            ..tasks.map(rps => {
              let v = rps.tugas.bentuk-dan-format-luaran
              ternary-fn(type(v) == str, () => v, () => list(..v))
            }),
          )
        ],
        [*INDIKATOR DAN BOBOT PENILAIAN*],
        [
          #enum(
            ..tasks.map(rps => {
              let v = rps.tugas.indikator-dan-bobot-penilaian
              ternary-fn(type(v) == str, () => v, () => list(..v))
            }),
          )
        ],
        [*JADWAL PELAKSANAAN*],
        [
          #enum(..tasks.map(rps => [#rps.tugas.jadwal-pelaksanaan]))
        ],
        [*DAFTAR RUJUKAN*],
        [
          #enum(..tasks.map(rps => list(..rps.tugas.daftar-rujukan)))
        ],
      ),
    )
  )
}
