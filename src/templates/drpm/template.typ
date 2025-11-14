#import "lib.typ": *

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
  #table(
    columns: 3,
    [*No*], [*Tanggal*], [*Kegiatan*],
    ..entries.enumerate().map(((i, (d, ev))) => ([#{ i + 1 }], [#d], [#ev])).flatten(),
  )
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
  #table(
    columns: 3,
    [*No*], [*Tanggal*], [*Kegiatan*],
    ..entries.enumerate().map(((i, (d, ev))) => ([#{ i + 1 }], [#d], [#ev])).flatten(),
  )
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
  #bib-page(bibliography-file); #pagebreak(weak: true);
]
