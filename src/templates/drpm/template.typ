#import "lib.typ": *

#let srg-identity-page(data) = {
  let ketua = data.leader
  let anggota = data.non-leader-members
  let defaults = data.defaults.member
  let filter-authorship(arr) = {
    arr
      .map(v => {
        let authorship = access-field(v, "authorship")
        if authorship == "first" {
          v.sebagai = [First Author]
        } else if authorship == "corresponding" {
          v.sebagai = [Corresponding Author]
        } else {
          v.sebagai = none
        }
        return v
      })
      .filter(v => v.sebagai != none)
  }


  [
    #set align(center)
    #set text(weight: "bold")
    LEMBAR IDENTITAS PROPOSAL NON-KONSORSIUM \
    RISET PENUGASAN ITS \
    SKEMA STRATEGIC RESEARCH GRANT (SRG) TIPE #data.srg.type \
    DANA ITS \
    TAHUN 2026
  ]

  v(1em)

  // Helper for field with aligned colon
  let field(label, value, width: 10em) = grid(
    columns: (width, auto, 1fr),
    column-gutter: 0.3em,
    [#label], [:], [#value],
  )

  // Helper for subfields with letter numbering
  let subfields(width: 10em, ..items) = {
    set enum(numbering: "a.")
    enum(..items
      .pos()
      .map(item => {
        if type(item) == array and item.len() == 2 {
          field(item.at(0), item.at(1), width: width)
        } else {
          item
        }
      }))
  }

  enum(
    field([Judul Penelitian], data.title),
    field([Bidang Pusdi], data.srg.pusdi),
    field([Topik Frontiers Pusdi], data.srg.frontiers),
    field([Topik SDGs], data.sdgs),
    [Ketua Peneliti
      #subfields(
        ([Nama], ketua.name),
        ([NUPTK], ketua.at("nuptk", default: "-")),
        ([Scopus ID], ketua.at("scopus-id", default: "-")),
        ([H-Indeks Scopus], ketua.at("h-index", default: "-")),
        ([Fakultas/Departemen], [#defaults.faculty / #defaults.department]),
        ([Email Address], ketua.email),
      )
    ],
    field([Usulan Dana], print-rp(data.budget-total)),
    [Target Luaran
      #subfields(
        [Artikel Jurnal Internasional terindeks Scopus #data.target.scopus],
        ([Nama Jurnal], data.target.journal-name),
      )
    ],
    [Pengalaman Publikasi sebagai First Author dan/atau Corresponding Author dalam 5 (lima) tahun terakhir:
      #table(
        columns: 3,
        table.header([*Judul Publikasi*], [*Link Artikel*], [*Sebagai*]),
        ..filter-authorship(ketua.at("publication-history", default: ()))
          .map(v => (
            v.title,
            render-if(access-field(v, "link"))[#link-b(access-field(v, "link"))[]][-],
            [#v.sebagai],
          ))
          .flatten(),
        ..filter-authorship(ketua.at("seminar-history", default: ()))
          .map(v => (
            v.title,
            render-if(access-field(v, "link"))[#link-b(access-field(v, "link"))[]][-],
            [#v.sebagai],
          ))
          .flatten(),
      )
    ],
    [Anggota:
      #table(
        columns: (auto, 1fr, auto, auto),
        align: (center, left, center, center),
        table.header([*No*], [*Nama Anggota*], [*Departemen*], [*Fakultas*]),
        ..anggota
          .enumerate()
          .map(((i, m)) => (
            str(i + 1),
            m.name,
            m.at("department", default: defaults.department),
            m.at("faculty", default: defaults.faculty),
          ))
          .flatten(),
      )
    ],
  )
}

#let drpm-research-proposal(
  abstract-page: [],
  introduction-page: [],
  literature-review-page: [],
  method-page: [],
  output-page: [],
  bibliography-file: none,
  data,
) = [
  #{ data.entry = "proposal" }
  #drpm-type.update("research")
  #set document(title: data.title)
  #show: enable-todo-hl
  #show: template.with(appendices: [
    #team-page(data); #pagebreak(weak: true);
    #bio-page(data); #pagebreak(weak: true);
  ])

  #cover-white(data); #pagebreak(weak: true);
  #if data.is-srg {
    srg-identity-page(data)
  }
  #set page(numbering: "i")
  #outline-page(); #pagebreak(weak: true);
  #abstract-page; #pagebreak(weak: true);
  #set page(numbering: "1")
  #counter(page).update(1)
  #introduction-page; #pagebreak(weak: true);
  #literature-review-page; #pagebreak(weak: true);
  #method-page; #pagebreak(weak: true);
  #output-page; #pagebreak(weak: true);
  #timeline-page(data); #pagebreak(weak: true);
  #budget-page(data); #pagebreak(weak: true);
  #bib-page(bibliography-file); #pagebreak(weak: true);
]

#let drpm-abmas-proposal(
  abstract-page: [],
  introduction-page: [],
  solution-page: [],
  method-page: [],
  output-page: [],
  bibliography-file: none,
  statement-letter-page: [],
  tech-imagery-page: [],
  location-page: [],
  data,
) = [
  #{ data.entry = "proposal" }
  #drpm-type.update("abmas")
  #set document(title: data.title)
  #show: enable-todo-hl
  #show: template.with(appendices: [
    #statement-letter-page; #pagebreak(weak: true);
    #tech-imagery-page; #pagebreak(weak: true);
    #location-page; #pagebreak(weak: true);
    #bio-page(data); #pagebreak(weak: true);
  ])

  #cover-blue(data); #pagebreak(weak: true);
  #set page(numbering: "i")
  #outline-page(); #pagebreak(weak: true);
  #abstract-page; #pagebreak(weak: true);
  #set page(numbering: "1")
  #counter(page).update(1)
  #introduction-page; #pagebreak(weak: true);
  #solution-page; #pagebreak(weak: true);
  #method-page; #pagebreak(weak: true);
  #output-page; #pagebreak(weak: true);
  #budget-page(data); #pagebreak(weak: true);
  #timeline-page(data); #pagebreak(weak: true);
  #if bibliography-file != none [
    #bib-page(bibliography-file); #pagebreak(weak: true);
  ]
]

#let drpm-research-progress(
  abstract-page: [],
  research-result: [],
  output-status: [],
  mitra-role: [],
  research-constraint: [],
  next-plan: [],
  bibliography-file: none,
  data,
) = [
  #{ data.entry = "progress" }
  #drpm-type.update("research")
  #set document(title: data.title)
  #show: enable-todo-hl
  #show: template.with(appendices: [
    #research-target-progress(data)
  ])

  #cover-white(data); #pagebreak(weak: true);
  #set page(numbering: "i")
  #outline-page(); #pagebreak(weak: true);
  #abstract-page; #pagebreak(weak: true);
  #set page(numbering: "1")
  #counter(page).update(1)
  #research-result; #pagebreak(weak: true)
  #output-status; #pagebreak(weak: true)
  #mitra-role; #pagebreak(weak: true)
  #research-constraint; #pagebreak(weak: true)
  #next-plan; #pagebreak(weak: true)
  #bib-page(bibliography-file); #pagebreak(weak: true);
]

#let drpm-abmas-progress(
  abstract-page: [],
  introduction-page: [],
  solution-page: [],
  method-page: [],
  output-page: [],
  bibliography-file: none,
  statement-letter-page: [],
  tech-imagery-page: [],
  location-page: [],
  additional-progress: [],
  data,
) = [
  #{ data.entry = "progress" }
  #drpm-type.update("abmas")
  #set document(title: data.title)
  #show: enable-todo-hl
  #show: template.with(appendices: [
    // #statement-letter-page; #pagebreak(weak: true);
    // #tech-imagery-page; #pagebreak(weak: true);
    // #location-page; #pagebreak(weak: true);
    // #bio-page(data); #pagebreak(weak: true);
  ])

  #cover-blue(data); #pagebreak(weak: true);
  #set page(numbering: "i")
  #outline-page(); #pagebreak(weak: true);
  #abstract-page; #pagebreak(weak: true);
  #set page(numbering: "1")
  #counter(page).update(1)
  #introduction-page; #pagebreak(weak: true);
  #solution-page; #pagebreak(weak: true);
  #method-page; #pagebreak(weak: true);
  #output-page; #pagebreak(weak: true);
  #abmas-target-progress(data); #additional-progress; #pagebreak(weak: true);
  #budget-page(data); #pagebreak(weak: true);
  #timeline-page(data); #pagebreak(weak: true);
  #if bibliography-file != none [
    #bib-page(bibliography-file); #pagebreak(weak: true);
  ]
]

#let drpm-research-logbook(
  entries: (),
  data,
) = [
  #{ data.entry = "progress" }
  #drpm-type.update("research")
  #set document(title: data.title)
  #show: enable-todo-hl
  #show: template

  #cover-blue(data); #pagebreak(weak: true);
  #set page(numbering: "1")
  #logbook-table(entries)
]

#let drpm-abmas-logbook(
  entries: (),
  data,
) = [
  #{ data.entry = "progress" }
  #drpm-type.update("abmas")
  #set document(title: data.title)
  #show: enable-todo-hl
  #show: template

  #cover-blue(data); #pagebreak(weak: true);
  #set page(numbering: "1")
  #logbook-table(entries)
]

#let drpm-research-final(
  abstract-page: [],
  research-result: [],
  output-status: [],
  mitra-role: [],
  research-constraint: [],
  next-plan: [],
  bibliography-file: none,
  data,
) = [
  #{ data.entry = "final" }
  #drpm-type.update("research")
  #set document(title: data.title)
  #show: enable-todo-hl
  #show: template.with(appendices: [
    #research-target-progress(data)
  ])

  #cover-blue(data); #pagebreak(weak: true);
  #set page(numbering: "i")
  #outline-page(); #pagebreak(weak: true);
  #abstract-page; #pagebreak(weak: true);
  #set page(numbering: "1")
  #counter(page).update(1)
  #research-result; #pagebreak(weak: true)
  #output-status; #pagebreak(weak: true)
  #mitra-role; #pagebreak(weak: true)
  #research-constraint; #pagebreak(weak: true)
  #next-plan; #pagebreak(weak: true)

  #if bibliography-file != none [
    #bib-page(bibliography-file); #pagebreak(weak: true);
  ]
]

#let drpm-abmas-final(
  abstract-page: [],
  introduction-page: [],
  solution-page: [],
  method-page: [],
  additional-progress: [],
  logbook-page: [],
  conclusions-page: [],
  bibliography-file: none,
  data,
) = [
  #{ data.entry = "final" }
  #drpm-type.update("abmas")
  #set document(title: data.title)
  #show: enable-todo-hl
  #show: template.with(appendices: [
  ])

  #cover-blue(data); #pagebreak(weak: true);
  #set page(numbering: "i")
  #outline-page(); #pagebreak(weak: true);
  #abstract-page; #pagebreak(weak: true);
  #set page(numbering: "1")
  #counter(page).update(1)
  #introduction-page; #pagebreak(weak: true);
  #solution-page; #pagebreak(weak: true);
  #method-page; #pagebreak(weak: true);
  #abmas-target-progress(data); #additional-progress; #pagebreak(weak: true);
  #abmas-budget-recapitulation(data); #pagebreak(weak: true);

  #logbook-page; #pagebreak(weak: true);
  #abmas-partner-benefits(data); #pagebreak(weak: true);
  #conclusions-page; #pagebreak(weak: true);

  #if bibliography-file != none [
    #bib-page(bibliography-file); #pagebreak(weak: true);
  ]
]
