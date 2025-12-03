#import "../common/data.typ": *
#import "../common/style.typ": *
#import "university.typ"
#import "touying.typ": *
#import "its-theme.typ" as its-
#import "its-mooc.typ" as mooc

#let IS-MOOC = sys.inputs.at("MOOC", default: none) == "1"
#let its = if IS-MOOC {
  mooc
} else {
  its-
}
#let its-theme = if IS-MOOC {
  its.its-mooc-theme
} else {
  its.its-theme
}

#let sl(title, ..args) = {
  let bodies = args.pos()
  if type(bodies) != array {
    bodies = (bodies,)
  }
  //! Hacky way to prevent changing header and footer font size.
  bodies = bodies.map(v => [
    #place(top + left, scale(0%, hide[~]))
    #v
  ])
  let setting = body => body
  if IS-MOOC {
    setting = body => {
      show: place.with(
        dx: -1em,
        dy: -.6em,
      )
      show: scale.with(85%)
      body
    }
  }
  if title == [] {
    its.slide(..bodies, setting: setting, ..args.named())
  } else {
    heading(depth: 3)[#title]
    its.slide(..bodies, setting: setting, ..args.named())
  }
}

#let sl2(percent, ..args) = sl(composer: (percent, 1fr), ..args)

#let slc(..args, body) = {
  sl(..args)[
    #set align(center + horizon)
    #show: block
    #set align(left + top)
    // #show: pad.with(top: -2em)
    #body
  ]
}

#let announcement(
  code: none,
  title,
  course,
  lecturer: [Moch. Nafkhan Alzamzami, S.T., M.T.],
  room: [],
  datetime: [],
  timelimit: [],
  additional-entries: (),
  ..args,
  body,
) = [
  #if code != none {
    course = [[#code] #course]
  }
  #show: university.university-theme.with(
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
      ([*Room*], [#room]),
      ([*DateTime*], [#datetime]),
      render-if(timelimit != [], ([*Timelimit*], [#timelimit]), none),
      ..additional-entries,
    ).filter(v => v != none))

    #body
  ]
]

#let announcement-sl(
  title,
  course,
  lecturer: [Moch. Nafkhan Alzamzami, S.T., M.T.],
  room: [],
  datetime: [],
  timelimit: [],
  body,
) = sl[#title][
  #align(center)[*#course*]

  #entry-fields((
    ([*Lecturer*], [#lecturer]),
    ([*Room*], [#room]),
    ([*DateTime*], [#datetime]),
    ([*Timelimit*], [#timelimit]),
  ))

  #body
]
