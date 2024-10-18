#import "touying.typ": *
#import "its-theme.typ" as its
#import "its-mooc.typ" as mooc

#let its-theme = if sys.inputs.at("MOOC", default: none) == "1" {
  mooc.its-mooc-theme
} else {
  its.its-theme
}
#let announcement = its.announcement

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
