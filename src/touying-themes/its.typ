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
#let announcement = its.announcement

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
    #show: pad.with(top: -2em)
    #body
  ]
}
