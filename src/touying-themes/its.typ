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
) = {
  let s = university.register(
    aspect-ratio: "16-9",
    // color-theme: (
    //   primary: rgb("#04364A"),
    //   secondary: rgb("#0078C1"),
    //   tertiary: rgb("#82C1E2"),
    // ),
  )
  //? ITS affiliation version
  s = (
    s.methods.info
  )(
    self: s,
    logo: [
      #pad(x: .4em, y: .4em, image("its-logo.png", width: 4em))
      #v(-3.5em)
    ],
    title: title,
    subtitle: subtitle,
    author: author,
    // date: datetime.today(),
    institution: institution,
    copyright: copyright,
  )
  s
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
    show: slides
    body
  }

  show: init-slide

  body
}
