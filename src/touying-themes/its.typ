#import "@preview/touying:0.4.2": *
#import "university.typ"

#let init(
  title,
  subtitle,
  author: [Moch. Nafkhan Alzamzami, S.T., M.T.],
  body,
) = {
  let s = {
    let s = university.register(aspect-ratio: "16-9")
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
      institution: [
        Department of Informatics \
        Faculty of Intelligent Electrical and Informatics Technology \
        Institut Teknologi Sepuluh Nopember
      ],
      copyright: [
        #sym.copyright #datetime.today().year() All rights reserved
      ],
    )
    s
  }
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
