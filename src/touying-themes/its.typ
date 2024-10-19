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

#let sl(title, body, ..args) = {
  if title == [] {
    its.slide(body, ..args)
  } else {
    heading(depth: 3)[#title]
    its.slide(body, ..args)
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
