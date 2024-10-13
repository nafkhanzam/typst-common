#import "../common/style.typ": *
#import "touying.typ": *
#import "university.typ": *

#let its-theme(
  title,
  subtitle,
  author: [Moch. Nafkhan Alzamzami, S.T., M.T.],
  institution: [
    Department of Informatics \
    Faculty of Intelligent Electrical and Informatics Technology \
    Institut Teknologi Sepuluh Nopember
  ],
  logo: image("its-logo.png", width: 4em),
  copyright: [
    #sym.copyright #datetime.today().year() All rights reserved
  ],
  ..args,
  body,
) = [
  #show: university-theme.with(
    config-info(
      title: title,
      subtitle: subtitle,
      author: author,
      institution: institution,
      logo: logo,
      copyright: copyright,
    ),
    ..args,
  )
  #show link: text.with(fill: rgb("#176B87"))
  #show link: underline

  #title-slide()

  #body
]

#let sl(title, body, ..args) = {
  if title == [] {
    slide(body, ..args)
  } else {
    heading(depth: 3)[#title]
    slide(body, ..args)
  }
}

#let sl2(percent, ..args) = sl(composer: (percent, 1fr), ..args)

#let slc(..args, body) = {
  sl(..args)[
    #set align(center + horizon)
    #show: pad.with(top: -2em)
    #body
  ]
}

#let announcement(
  title,
  course,
  lecturer: [Moch. Nafkhan Alzamzami, S.T., M.T.],
  datetime: [],
  timelimit: [],
  ..args,
  body,
) = [
  #show: university-theme.with(
    config-store(
      footer-a: none,
      footer-b: none,
      footer-c: none,
    ),
    config-page(height: auto),
    ..args,
  )
  #set text(size: .8em)

  #sl[#title][
    #align(center)[*#course*]

    #entry-fields((
      ([*Lecturer*], [#lecturer]),
      ([*DateTime*], [#datetime]),
      ([*Timelimit*], [#timelimit]),
    ))

    #body
  ]
]
