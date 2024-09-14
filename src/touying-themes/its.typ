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
