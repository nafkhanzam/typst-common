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
  #show: template.with(
    appendices: [
      #team-page(data); #pagebreak(weak: true);
      #bio-page(data); #pagebreak(weak: true);
    ],
  )

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
  #show: template.with(
    appendices: [
      #statement-letter-page; #pagebreak(weak: true);
      #tech-imagery-page; #pagebreak(weak: true);
      #location-page; #pagebreak(weak: true);
      #bio-page(data); #pagebreak(weak: true);
    ],
  )

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
  #bib-page(bibliography-file); #pagebreak(weak: true);
]
