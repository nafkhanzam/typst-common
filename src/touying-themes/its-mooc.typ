#import "its-theme.typ": *

#let its-mooc-theme(
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
    footer-a: none,
    footer-b: none,
    footer-c: none,
    footer-columns: (0%,),
    progress-bar: false,
    config-info(
      title: title,
      subtitle: subtitle,
      author: author,
      institution: institution,
      logo: logo,
      copyright: copyright,
    ),
    config-methods(init: (self: none, body) => {
      show: university-init.with(self: self)
      set page(background: image("its-mooc-electics-background.jpg"))

      body
    }),
    config-colors(
      primary: white,
      secondary: white,
      tertiary: white,
      neutral-lightest: white,
      neutral-darkest: white,
    ),
    ..args,
  )
  #set line(stroke: white)
  #show link: text.with(fill: rgb("#176B87"))
  #show link: underline

  #title-slide()

  #body
]
