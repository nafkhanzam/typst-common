#import "touying.typ": *
#import "university.typ"

#let init-s(
  title,
  subtitle,
  author: [Moch. Nafkhan Alzamzami, S.T., M.T.],
  institution: [
    Department of Informatics \
    Faculty of Intelligent Electrical and Informatics Technology \
    Institut Teknologi Sepuluh Nopember
  ],
  copyright: [
    #sym.copyright #datetime.today().year() All rights reserved
  ],
  ..args,
) = {
  let s = university.register(
    aspect-ratio: "16-9",
    ..args,
  )
  s = (s.methods.info)(
    self: s,
    logo: [
      #pad(x: .4em, y: .4em, image("its-logo.png", width: 4em))
      #v(-3.5em)
    ],
    title: title,
    subtitle: subtitle,
    author: author,
    institution: institution,
    copyright: copyright,
  )
  s
}

#let sl(self, title, body, ..args) = {
  let (slide, empty-slide) = utils.slides(self)
  if title == [] {
    slide(body, ..args)
  } else {
    slide(subsubsection: (title: title), body, ..args)
  }
}

#let init(
  s,
  body,
) = {
  let (slide, empty-slide) = utils.slides(s)
  let (init, slides, touying-outline, alert) = utils.methods(s)
  let init-slide(body) = {
    show: init
    set text(font: "FreeSerif", fallback: false)
    show strong: alert
    set enum(full: true)
    show: slides
    body
  }

  show: init-slide

  body
}

#let methods(s) = {
  let sl_(..args) = sl(s, ..args)
  let sl2(percent, ..args) = sl(s, composer: (percent, 1fr), ..args)

  (sl: sl_, sl2: sl2)
}
