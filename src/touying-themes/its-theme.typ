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
  with-end: false,
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

  #if with-end {
    new-section-slide(level: 1, numbered: false)[
      #set align(center)
      End
    ]
  }
]
