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
    set text(font: "Calibri", size: 10pt)
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
      columns: (auto, 8fr, 1fr),
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
        #set text(weight: "bold", size: 16pt)
        RPS
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
            #dosen.at(data.kaprodi)
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
      [*Peta CPL-CPMK-Sub-CPMK*],
      table.cell(
        inset: 0pt,
        colspan: 2,
        table(
          columns: (5em, 6.5em,) + cpl-filtered.len() * (auto,) + (auto,),
          align: center + horizon,
          [], [*Sub-CPMK*], ..cpl-filtered.map(((cpl-i, v)) => text(weight: "bold")[CPL #cpl-i]), [*Prosentase*],
          ..data
            .cpmk
            .enumerate()
            .map(((cpmk-i, cpmk-v)) => {
              let sub-cpmks = if "sub-cpmk" in data and data.sub-cpmk.len() > 0 {
                data.sub-cpmk.filter(s => s.cpmk == cpmk-i + 1)
              } else { () }
              
              if sub-cpmks.len() > 0 {
                // Get total percentage for this CPMK
                let total-pct = sub-cpmks.fold(0, (acc, s) => {
                  let cpl-map = s.at("cpl-mapping", default: (:))
                  acc + cpl-map.values().fold(0, (a, v) => a + int(str(v).replace("%", "")))
                })
                
                (
                  // First row with CPMK label and first Sub-CPMK
                  table.cell(rowspan: sub-cpmks.len())[CPMK #(cpmk-i+1)],
                  [Sub-CPMK #sub-cpmks.at(0).id],
                  ..cpl-filtered.map(((cpl-i, v)) => {
                    let cpl-map = sub-cpmks.at(0).at("cpl-mapping", default: (:))
                    if str(cpl-i) in cpl-map {
                      str(cpl-map.at(str(cpl-i)))
                    } else { [-] }
                  }),
                  table.cell(rowspan: sub-cpmks.len())[#total-pct%],
                  // Remaining Sub-CPMKs
                  ..sub-cpmks.slice(1).map(s => (
                    [Sub-CPMK #s.id],
                    ..cpl-filtered.map(((cpl-i, v)) => {
                      let cpl-map = s.at("cpl-mapping", default: (:))
                      if str(cpl-i) in cpl-map {
                        str(cpl-map.at(str(cpl-i)))
                      } else { [-] }
                    }),
                  )).flatten()
                )
              } else {
                // Fallback to old behavior if no sub-cpmk defined
                (
                  [CPMK #(cpmk-i+1)],
                  [-],
                  ..cpl-filtered.map(((cpl-i, v)) => {
                    if cpmk-v.cpl.contains(cpl-i) {
                      sym.checkmark
                    } else { }
                  }),
                  [-],
                )
              }
            })
            .flatten(),
          // Total row
          table.cell(colspan: 2)[*Total*],
          ..cpl-filtered.map(((cpl-i, v)) => {
            let total = if "sub-cpmk" in data and data.sub-cpmk.len() > 0 {
              data.sub-cpmk.fold(0, (acc, s) => {
                let cpl-map = s.at("cpl-mapping", default: (:))
                if str(cpl-i) in cpl-map {
                  acc + int(str(cpl-map.at(str(cpl-i))).replace("%", ""))
                } else { acc }
              })
            } else { 0 }
            [*#total%*]
          }),
          [*#{
            if "sub-cpmk" in data and data.sub-cpmk.len() > 0 {
              data.sub-cpmk.fold(0, (acc, s) => {
                let cpl-map = s.at("cpl-mapping", default: (:))
                acc + cpl-map.values().fold(0, (a, v) => a + int(str(v).replace("%", "")))
              })
            } else { 0 }
          }%*],
        ),
      ),
      [*Peta Evaluasi-CPMK*],
      table.cell(
        inset: 0pt,
        colspan: 2,
        table(
          columns: (13em,) + data.cpmk.len() * (auto,) + (auto,),
          align: center + horizon,
          table.header(
            [*Evaluasi*],
            ..data.cpmk.enumerate().map(((i, _)) => text(weight: "bold")[CPMK-#(i+1)]),
            [*Bobot*],
          ),
          ..if "evaluasi" in data {
            data.evaluasi.map(eval => {
              let total = eval.at("cpmk-mapping", default: (:))
                .values()
                .fold(0, (acc, v) => acc + int(str(v).replace("%", "")))
              (
                [#eval.name _(#eval.jenis)_],
                ..data.cpmk.enumerate().map(((i, _)) => {
                  let mapping = eval.at("cpmk-mapping", default: (:))
                  if str(i + 1) in mapping {
                    str(mapping.at(str(i + 1)))
                  } else { [-] }
                }),
                [#total%],
              )
            }).flatten()
          } else { () },
          // Total row
          [*Total*],
          ..data.cpmk.enumerate().map(((cpmk-i, _)) => {
            let total = if "evaluasi" in data {
              data.evaluasi.fold(0, (acc, eval) => {
                let mapping = eval.at("cpmk-mapping", default: (:))
                if str(cpmk-i + 1) in mapping {
                  acc + int(str(mapping.at(str(cpmk-i + 1))).replace("%", ""))
                } else { acc }
              })
            } else { 0 }
            [*#total%*]
          }),
          [*#{
            if "evaluasi" in data {
              data.evaluasi.fold(0, (acc, eval) => {
                let eval-total = eval.at("cpmk-mapping", default: (:))
                  .values()
                  .fold(0, (a, v) => a + int(str(v).replace("%", "")))
                acc + eval-total
              })
            } else { 0 }
          }%*],
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
      columns: (1fr, 2fr, 3fr, 4fr, 2fr, 2fr, 3fr, 1fr),
      // columns: (1fr, ..(2.5fr,) * 6, 1fr),
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
          Bentuk Pembelajaran, \
          Metode Pembelajaran, dan \
          Penugasan Mahasiswa \
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
        text(weight: "bold")[Luring (_offline_)],
        text(weight: "bold")[Daring (_online_)],
      ),
      ..range(1, 9).map(i => [*(#i)*]),
      ..data
        .rps
        .enumerate()
        .map(((i, rps)) => {
          let week = get-week(data, rps, i)
          let span = get-span(rps)
          let if-span = if span > 1 [#span#sym.times]
          let time-template(rps, key1, key2, label, length) = {
            let content = access-field(rps, key1, key2, "content")
            if content != none {
              content
              linebreak()
            }
            if access-field(rps, key1, key2, "time", default: false) [
              [*#label:* #if-span\(#data.sks#sym.times#length\)" = #{span * data.sks * length}"]
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
              {
                if access-field(rps, "penilaian") != none {
                  if type(rps.penilaian.indikator) == str {
                    rps.penilaian.indikator
                  } else {
                    list(..rps.penilaian.indikator)
                  }
                }
              },
              {
                if access-field(rps, "penilaian") != none {
                  let method = access-field(rps, "penilaian", "kriteria", "method")
                  if method != none [
                    *#method*
                  ]

                  parbreak()

                  let non-tests = access-field(rps, "penilaian", "kriteria", "non-tests")
                  if non-tests != none [
                    *Non-Tes:* \
                    #non-tests.map((v) => {
                      let name = access-field(v, "name", default: "Non-Tes")
                      let method = access-field(v, "method")
                      let materials = access-field(v, "materials", default: ())
                      [*#name:* #emph(method) #list(..materials)]
                    }).join()
                  ]

                  let tests = access-field(rps, "penilaian", "kriteria", "tests")
                  if tests != none [
                    *Tes:* \
                    #tests.map((v) => {
                      let name = access-field(v, "name", default: "Tes")
                      let method = access-field(v, "method")
                      let materials = access-field(v, "materials", default: ())
                      [*#name:* #emph(method) #list(..materials)]
                    }).join()
                  ]
                }
              },
              {
                time-template(rps, "tatap-muka", "tm", [TM], 50)
              },
              {
                time-template(rps, "daring", "pt", [PT], 60)
                parbreak()
                time-template(rps, "daring", "bm", [BM], 60)
              },
              [
                #if type(rps.materi) == str {
                  rps.materi
                } else {
                  list(..rps.materi)
                }
              ],
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
    set text(font: "Calibri", size: 10pt)
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
    columns: (0.7fr, 2fr, 3fr, auto),
    table.header(
      ..(
        [*Minggu ke-*],
        [*Sub-CPMK*],
        [*Bentuk Asesmen _(Penilaian)_*],
        [*Bobot (%)*],
      ).map(v => table.cell(fill: gray-color, align(center, v))),
    ),
    ..data
      .rps
      .enumerate()
      .filter(((i, v)) => v.keys().contains("assessment") or get-bobot(v) > 0)
      .enumerate()
      .map(((i, (rps-i, rps))) => {
        let assessments = access-field(rps, "penilaian", "assessment", default: ())
        if assessments.len() > 0 {
          // New structured format with method and jenis - merge cells
          let week-val = get-week(data, rps, rps-i)
          let sub-cpmk-id = rps.at("sub-cpmk", default: "-")
          let sub-cpmk-text = rps.kemampuan
          (
            // First assessment gets the merged cells for week and sub-cpmk
            table.cell(rowspan: assessments.len())[
              #show: s-center
              #week-val
            ],
            table.cell(rowspan: assessments.len())[
              *Sub-CPMK #sub-cpmk-id:* \
              #sub-cpmk-text
            ],
            [
              *#assessments.at(0).method* _(#assessments.at(0).jenis)_ \
              #assessments.at(0).deskripsi
            ],
            table.cell[
              #show: s-center
              #assessments.at(0).at("bobot", default: "-")%
            ],
            // Remaining assessments only have assessment and bobot columns
            ..assessments.slice(1).map(assess => (
              [
                *#assess.method* _(#assess.jenis)_ \
                #assess.deskripsi
              ],
              table.cell[
                #show: s-center
                #assess.at("bobot", default: "-")%
              ],
            )).flatten()
          )
        } else {
          // Fallback to old format
          (
            table.cell[
              #show: s-center
              #get-week(data, rps, rps-i)
            ],
            [
              #rps.kemampuan
            ],
            [#coalesce(
                access-field(rps, "assessment", "content"),
                list(..access-field(rps, "penilaian", "assessment", default: ())),
              )],
            table.cell[
              #show: s-center
              #{ coalesce(
                  access-field(rps, "assessment", "weight"), 
                  get-bobot(rps)) }%
            ],
          )
        }
      })
      .flatten(),
    // Total row
    table.cell(colspan: 3, fill: gray-color)[
      #show: s-center
      *Total*
    ],
    table.cell(fill: gray-color)[
      #show: s-center
      *#{
        data.rps
          .filter(rps => rps.keys().contains("assessment") or get-bobot(rps) > 0)
          .fold(0, (acc, rps) => {
            let assessments = access-field(rps, "penilaian", "assessment", default: ())
            if assessments.len() > 0 {
              acc + assessments.fold(0, (a, assess) => a + assess.at("bobot", default: 0))
            } else {
              acc + get-bobot(rps)
            }
          })
      }%*
    ],
  )
}

#let rtm-template(
  init-fn: it => {
    set text(font: "Calibri", size: 10pt)
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
        [#data.kode], table.cell(fill: gray-color)[*SKS*], [#{ data.sks + data.sks-prak }], table.cell(
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
