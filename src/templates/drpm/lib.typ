#import "@preview/codly:1.3.0"
#import "common/currency.typ": *
#import "common/data.typ": *
#import "common/dates.typ": *
#import "common/style.typ": *

// #let is-abmas = lower(sys.inputs.at("TYPE", default: "research")) == "abmas"
#let drpm-type = state("type", "abmas") // "abmas"
#let if-abmas(a, b) = context call-or-value(if drpm-type.get() == "abmas" { a } else { b })
#let peneliti = if-abmas([pengabdi], [peneliti])
#let Peneliti = if-abmas([Pengabdi], [Peneliti])
#let penelitian = if-abmas([pengabdian], [penelitian])
#let Penelitian = if-abmas([Pengabdian], [Penelitian])

#let outline-entry-fn(prefix-count, start-level: 1) = (
  it => {
    let loc = it.element.location()
    let num = numbering(loc.page-numbering(), ..counter(page).at(loc))
    let prefixed = it.body.at("children", default: ()).len() > 1
    let body = it.body
    if prefixed {
      body = it.body.at("children").slice(1 + prefix-count).join()
    }
    link(loc, box(grid(
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
    )))
  }
)

#let template(ref-style: "common/apa-id.csl", appendices: none, body) = {
  set page(
    paper: "a4",
    margin: 3cm,
    number-align: right,
  )
  set text(
    font: "Liberation Serif",
    size: 12pt,
    fallback: false,
    hyphenate: true,
    lang: "id",
  )
  set par(justify: true, linebreaks: "optimized")
  set enum(indent: 1em)
  set list(indent: 1em, marker: ([-], [#sym.arrow]))
  show table: set enum(indent: 0pt)
  show table: set list(indent: 0pt)
  show table: set par(justify: false)
  show table: set align(left)
  set enum(indent: 1em)
  set block(below: 1.5em)
  set heading(numbering: (num1, ..nums) => {
    if nums.pos().len() == 0 {
      [BAB #numbering("I", num1)] + "\t"
      h(10pt)
    } else {
      numbering("1.1", num1, ..nums)
      h(7pt)
    }
  })
  set bibliography(style: ref-style)
  show figure.caption: set text(size: 10pt)
  show figure.where(kind: table): set figure.caption(position: top)

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
  // show outline.entry: outline-entry-fn(1)
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
  show raw.where(block: true): set block(above: .65em)
  show raw.where(block: true): set text(size: .8em)
  show raw.where(block: false): it => {
    set text(font: "Noto Sans Mono", fallback: false)
    show: highlight.with(
      extent: .1em,
      fill: none,
      stroke: .5pt + blue,
    )
    // set text(size: .95em)
    it
  }
  show: enable-todo-hl
  show: codly.codly-init
  codly.codly(number-format: none)

  body

  if appendices != none {
    set page(numbering: "1")
    counter(heading).update(0)

    set heading(supplement: "Lampiran", numbering: (..nums) => {
      let arr = nums.pos()
      if arr.len() == 0 {
        []
      } else if arr.len() == 1 {
        [LAMPIRAN #numbering("1", ..arr).] + "\t"
      } else {
        numbering("1.", ..arr.slice(1))
      }
    })

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

#let spec-suffix(data) = if-abmas(
  [
    PENGABDIAN KEPADA MASYARAKAT \
    SKEMA #upper(data.schema) DANA #upper(data.funding-source)
  ],
  [
    SKEMA PENELITIAN #upper(data.schema) \
    SUMBER DANA #upper(data.funding-source) \
    TAHUN #display-year
  ],
)

#let spec(data) = (
  "proposal": (
    cover-title: [
      PROPOSAL \
      #spec-suffix(data)
    ],
  ),
  "progress": (
    cover-title: [
      LAPORAN KEMAJUAN \
      #spec-suffix(data)
    ],
  ),
  "logbook": (
    cover-title: [
      #text(size: 24pt)[CATATAN HARIAN] \
      #spec-suffix(data)
    ],
  ),
).at(data.entry)

#let BUDGET-KEYS = (
  "one-time-materials",
  "assets",
  "data-colletions",
  "reportings",
)

#let preprocess-data(d) = {
  // member defaults
  let member-default = access-field(d, "defaults", "member", default: ())
  d.members = d.members.map(member => apply-defaults(member, member-default))

  // ref defaults
  let apply-entries(members, ref-key) = members.map(member => apply-refs(member, ref-key, access-field(
    d,
    "entries",
    ref-key,
    default: (),
  )))
  d.members = apply-entries(d.members, "abmas-history")
  d.members = apply-entries(d.members, "publication-history")
  d.members = apply-entries(d.members, "intellectual-property-history")

  // calculate budget
  d.budget-total = 0
  for (i, value) in d.budget.enumerate() {
    let sub-total = 0
    for (j, item) in value.items.enumerate() {
      let sub-sub-total = int(item.price * item.volume)
      d.budget.at(i).items.at(j).total = sub-sub-total
      sub-total += sub-sub-total
    }
    d.budget.at(i).insert("total", sub-total)
    d.budget-total += sub-total
  }

  d
}

#let cover-blue(data) = [
  #let cl-blue = rgb(32, 64, 106)
  #let cl-yellow = rgb(255, 210, 46)

  #set page(fill: cl-blue, margin: 0em)
  #set text(fill: white)
  #set par(justify: false)
  #set align(center)

  #show: pad.with(x: 2em)

  #v(1fr)

  #[
    #set text(weight: "bold", size: 20pt)

    #spec(data).cover-title

    #v(1fr)

    #image("lambang.png", width: 2.33in)

    #v(1fr)

    #text(size: 16pt, upper(data.title))

    #v(1fr)
  ]

  #let write-member-entry(member) = [#member.name (#member.department/#member.faculty)]

  #[
    #set text(size: 14pt)

    #text(size: 16pt)[*Tim #Peneliti:*] \
    #for member in data.members.filter(v => not v.at("exclude-from-cover", default: false)) [
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
    rect(width: 100%, height: 100%, fill: none, stroke: border-width + rgb(47, 84, 150), pad(3cm - border-width, body))
  }

  #[
    #set text(weight: "bold", size: 14pt)

    #spec(data).cover-title

    #v(1fr)

    #image("lambang.png", width: 2.33in)

    #v(1fr)

    #text(size: 16pt, upper(data.title))

    #v(1fr)

    Tim #Peneliti:
  ]

  #let write-member-entry(member) = [#member.name / #member.department / #member.faculty / #member.institution]

  #pad(x: -1cm)[
    #grid(
      columns: (auto, 1fr),
      [Ketua #Peneliti], [: #write-member-entry(data.members.at(0))],
      [Anggota #Peneliti], [: 1. #write-member-entry(data.members.at(1))],
      ..(
        data
          .members
          .slice(2)
          .filter(v => not v.at("exclude-from-cover", default: false))
          .enumerate()
          .map((
            (i, member),
          ) => (
            [],
            [#hide[: ]#{ i + 2 }. #write-member-entry(member)],
          ))
          .flatten()
      ),
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

#let bib-page(ref-file) = [
  #headz[DAFTAR PUSTAKA]

  #bibliography(ref-file, title: none)
]

#let outline-page() = [
  #headz[DAFTAR ISI]

  #outline(
    title: none,
    depth: 4,
  )
]

#let bio-page(data) = [
  #headz[BIODATA]

  #let bio(index, member, show-on-zero: true, extend: true) = [
    #let label = if index == 0 {
      [Ketua]
    } else {
      [Anggota #numbering("I", index)]
    }

    == #label

    #[
      Identitas #Peneliti

      #{
        show table.cell.where(x: 0): strong
        table(
          columns: (auto, 1fr),
          [Nama Lengkap], [#member.name],
          [Jenis Kelamin], [#member.gender],
          [NIP/NIK], [#member.id-number],
          [NIDN (jika ada)], [#member.nidn],
          [Tempat dan Tanggal Lahir], [#member.birth],
          [E-mail], [#member.email],
          [Nomor Telepon/HP], [#member.phone],
          [Nama Institusi Tempat Kerja], [#member.institution-long],
          [Alamat Kantor], [#member.address],
        )
      }

      #show table.cell.where(y: 0): strong

      Riwayat Pendidikan

      #{
        let s-keys = (
          ("s1", [S-1]),
          ("s2", [S-2]),
          ("s3", [S-3]),
        ).filter(((key, _)) => access-field(member, "education-history", key) != none)
        let counter = s-keys.len()

        show table.cell.where(x: 0): strong
        table(
          columns: counter + 1,
          table.header([], ..s-keys.map(((_, col)) => [#col])),
          ..(
            (
              ([Nama Perguruan Tinggi], "instition-name"),
              ([Bidang Ilmu], "major"),
              ([Tahun Masuk-Lulus], "start-end-year"),
              ([Judul Skripsi / \ Tesis / Disertasi], "thesis-title"),
              ([Nama Pembimbing/Promotor], "supervisor-name"),
            )
              .map(((title, field)) => (
                title,
                ..(s-keys.map(((key, _)) => [#access-field(member, "education-history", key, field)])),
              ))
              .flatten()
          ),
        )
      }

      #let rest-args = (:)
      #let empty-message = access-field(member, "empty-message")
      #if empty-message != none {
        rest-args += (empty-message: empty-message)
      }

      #let arr = member.at("research-history", default: ())
      #let col-n = 5
      #if arr.len() > 0 or show-on-zero [
        // #show: block.with(breakable: false)
        Pengalaman Penelitian dalam 5 Tahun Terakhir (Bukan Skripsi, Tesis, dan Disertasi)
        #table(
          columns: if (extend and arr.len() == 0) {
            (auto, ..((col-n - 1) * (1fr,)))
          } else {
            col-n
          },
          table.header([No], [Tahun], [Judul Penelitian], [Sumber Dana], [Jumlah Dana]),
          ..gen-rows(
            custom: (
              "funding-amount": v => {
                let value = access-field(v, "funding-amount")
                if value != none {
                  print-rp(value)
                } else {
                  [--]
                }
              },
            ),
            arr,
            ("year", "title", "funding-source", "funding-amount"),
            ..rest-args,
          ),
        )
      ]

      #let arr = member.at("publication-history", default: ())
      #let col-n = 4
      #if arr.len() > 0 or show-on-zero [
        // #show: block.with(breakable: false)
        Publikasi Artikel Ilmiah Jurnal yang Relevan Dalam 5 Tahun Terakhir
        #table(
          columns: if (extend and arr.len() == 0) {
            (auto, ..((col-n - 1) * (1fr,)))
          } else {
            col-n
          },
          table.header([No], [Judul Artikel Ilmiah], [Nama Jurnal], [Volume / Nomor / Tahun]),
          ..gen-rows(arr, ("title", "journal-name", "number"), ..rest-args),
        )
      ]

      #let arr = member.at("seminar-history", default: ())
      #let col-n = 4
      #if arr.len() > 0 or show-on-zero [
        // #show: block.with(breakable: false)
        Pemakalah Seminar Ilmiah (_Oral Presentation_) yang Relevan Dalam 5 Tahun Terakhir
        #table(
          columns: if (extend and arr.len() == 0) {
            (auto, ..((col-n - 1) * (1fr,)))
          } else {
            col-n
          },
          table.header([No], [Judul], [Pemakalah Seminar Ilmiah], [Waktu dan Tempat]),
          ..gen-rows(arr, ("title", "seminar-name", "date-time"), ..rest-args),
        )
      ]

      #let arr = member.at("book-history", default: ())
      #let col-n = 5
      #if arr.len() > 0 or show-on-zero [
        // #show: block.with(breakable: false)
        Karya Buku dalam 5 Tahun Terakhir
        #table(
          columns: if (extend and arr.len() == 0) {
            (auto, ..((col-n - 1) * (1fr,)))
          } else {
            col-n
          },
          table.header([No], [Judul Buku], [Tahun], [Jumlah Halaman], [Penerbit]),
          ..gen-rows(arr, ("title", "year", "total-page", "publisher"), ..rest-args),
        )
      ]

      #let arr = member.at("intellectual-property-history", default: ())
      #let col-n = 5
      #if arr.len() > 0 or show-on-zero [
        // #show: block.with(breakable: false)
        HKI dalam 10 Tahun Terakhir
        #table(
          columns: if (extend and arr.len() == 0) {
            (auto, ..((col-n - 1) * (1fr,)))
          } else {
            col-n
          },
          table.header([No], [Judul/Tema HKI], [Tahun], [Jenis], [Nomor P/ID]),
          ..gen-rows(arr, ("title", "year", "type", "number"), ..rest-args),
        )
      ]

      #let arr = member.at("policy-history", default: ())
      #let col-n = 5
      #if arr.len() > 0 or show-on-zero [
        // #show: block.with(breakable: false)
        Pengalaman Merumuskan Kebijakan Publik/Rekayasa Sosial Lainnya dalam 10 Tahun Terakhir
        #table(
          columns: if (extend and arr.len() == 0) {
            (auto, ..((col-n - 1) * (1fr,)))
          } else {
            col-n
          },
          table.header(
            [No],
            [Judul/Tema/Jenis Rekayasa Sosial Lainnya yang Telah Diterapkan],
            [Tahun],
            [Tempat Penerapan],
            [Respon Masyarakat],
          ),
          ..gen-rows(arr, ("title", "year", "place", "response"), ..rest-args),
        )
      ]

      #let arr = member.at("reward-history", default: ())
      #let col-n = 4
      #if arr.len() > 0 or show-on-zero [
        // #show: block.with(breakable: false)
        Penghargaan dalam 10 tahun Terakhir (dari pemerintah, asosiasi atau institusi lainnya)
        #table(
          columns: if (extend and arr.len() == 0) {
            (auto, ..((col-n - 1) * (1fr,)))
          } else {
            col-n
          },
          table.header([No], [Jenis Penghargaan], [Institusi Pemberi Penghargaan], [Tahun]),
          ..gen-rows(arr, ("name", "institution", "year"), ..rest-args),
        )
      ]
    ]

    #show: text.with(weight: "bold")

    Semua data yang saya isikan dan tercantum dalam biodata ini adalah benar dan dapat dipertanggungjawabkan secara hukum.
    Apabila di kemudian hari ternyata dijumpai ketidaksesuaian dengan kenyataan, saya sanggup menerima sanksi.
    Demikian biodata ini saya buat dengan sebenarnya untuk memenuhi salah satu persyaratan dalam pengajuan.

    #grid(
      columns: (1fr, auto),
      [],
      [
        #member.sign-city, #ID-display-today \
        #label

        #{
          show: pad.with(y: -1em)
          align(center, image(member.sign, height: 5em))
        }

        (#member.name)
      ],
    )

    // #pagebreak(weak: true)
  ]

  #let show-on-zero = access-field(data, "show-bio-on-zero", default: true)
  #for (i, member) in (
    data
      .members
      .filter(v => (
        (access-field(v, "exclude-from-cover") == none or access-field(v, "exclude-from-cover") == false)
          and (access-field(v, "exclude-from-bio") == none or access-field(v, "exclude-from-bio") == false)
      ))
      .enumerate()
  ) {
    bio(i, member, show-on-zero: show-on-zero)
  }

  #if-abmas(
    () => [
      == Mahasiswa

      Daftar mahasiswa yang terlibat dalam pengabdian masyarakat ini adalah sebagai berikut:

      #show table.cell.where(y: 0): strong

      #table(
        columns: 2,
        table.header([NRP], [Nama]),
        ..data.students.map(v => ([#v.id], [#v.name])).flatten(),
      )
    ],
    [],
  )
]

#let budget-page(data) = [
  = RENCANA ANGGARAN DAN BIAYA

  Adapun total rencana anggaran belanja untuk #penelitian adalah #print-rp(data.budget-total) dan rincian ditunjukkan pada tabel berikut ini.

  #budget-template(data)
]

#let timeline-page(data) = [
  = JADWAL KEGIATAN

  Jadwal detil kegiatan #penelitian ditunjukkan pada @tab-schedule.

  #figure(timeline-template(data), caption: [Jadwal kegiatan #penelitian.]) <tab-schedule>
]

#let team-page(data) = [
  #headz[TIM RISET]

  Bagan organisasi tim #peneliti bisa dilihat pada @tab-team.

  #show figure: set block(breakable: true)
  #figure(
    kind: table,
    {
      show table.cell.where(y: 0): strong
      table(
        columns: 5,
        [No.], [Nama], [Departemen / \ Fakultas], [Posisi di \ Tim Riset], [Uraian Tugas],
        ..(
          data
            .members
            .enumerate()
            .map(((i, member)) => (
              [#{ i + 1 }],
              [#member.name],
              [#member.department / \ #member.faculty],
              [#member.position],
              enum(..member.tasks.map(v => [#v])),
            ))
            .flatten()
        ),
      )
    },
    caption: [Organisasi Tim #Peneliti.],
  ) <tab-team>
]

#let abmas-target-progress(data) = [
  = CAPAIAN LUARAN KEGIATAN

  *Program Pengabdian kepada Masyarakat Tematik Dana Unit Tahun Anggaran #data.year*

  #let check = sym_(sym.checkmark)
  #let check-if(i, real) = {
    if i == real {
      check
    }
  }
  #let o = data.output

  #grid(
    columns: 3,
    [Judul Abmas], [:], [#data.title],
    [Ketua Pengabdi], [:], [#data.members.at(0).name],
    [Departemen], [:], [#data.members.at(0).department],
  )

  #table(
    columns: 2,
    [*1. PUBLIKASI JURNAL ILMIAH PENGABDIAN KEPADA MASYARAKAT*], [Keterangan],
    [Nama jurnal yang dituju], [#o.journal.name],
    [Judul artikel], [#data.title],
    [Status naskah (diberi tanda #check)], [],
    [- Draf artikel], [#check-if(o.journal.status, 0)],
    [- Submitted], [#check-if(o.journal.status, 1)],
    [- Under Reviewed], [#check-if(o.journal.status, 2)],
    [- Accepted], [#check-if(o.journal.status, 3)],
    [- Published], [#check-if(o.journal.status, 4)],
    [*2. PUBLIKASI DI MEDIA MASSA*], [Keterangan],
    [Judul artikel], [],
    [URL artikel], [],
    [Nama Media Massa], [],
    [Terdaftar di Dewan Pers? #link("https://www.dewanpers.or.id/data/perusahaanpers")[https://www.dewanpers.or.id/data/perusahaanpers]],
    [],

    [Status naskah (diberi tanda #check)], [],
    [- Draf artikel], [#check-if(o.media.status, 0)],
    [- Submitted], [#check-if(o.media.status, 1)],
    [- Published], [#check-if(o.media.status, 2)],
    [*3. HAK KEKAYAAN INTELEKTUAL*], [Keterangan],
    [Nomor dan tanggal permohonan], [#o.hki.number, #o.hki.date],
    [Jenis Ciptaan], [#o.hki.type],
    [Judul Ciptaan], [#o.hki.title],
    [Tanggal dan tempat diumumkan], [#o.hki.publish.location, #o.hki.publish.date],
    [Nomor pencatatan], [#o.hki.written-number],
  )
  #o.progress-reason
]
