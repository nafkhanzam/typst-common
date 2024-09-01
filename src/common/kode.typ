#import "@preview/pinit:0.2.0": *
#import "@preview/showybox:2.0.1": showybox
#import "style.typ": phantom

#let kode-default-filename = state("kode-default-filename", hide[a])

#let kode(
  filename: context kode-default-filename.get(),
  font-size: .7em,
  width: 35em,
  o: none,
  escape-mode: "comment",
  status: "success",
  nextBody: [],
  body,
) = {
  show: block.with(inset: -.1em)
  set text(
    font: "Liberation Mono",
    size: font-size,
  )
  //? HACKY way to make filename pinnable.
  let anchor-hack = hide[#text(size: 0pt)[~]]
  let output-content = if o != none {
    o = [#anchor-hack#o#anchor-hack]
    show: pad.with(x: -1em, y: -.65em)
    if status == "success" {
      showybox(
        title: [#anchor-hack#[Output#pin("o-title")]#anchor-hack],
        width: auto,
        shadow: (offset: 3pt),
        frame: (title-color: green.lighten(60%), body-color: green.lighten(80%)),
        title-style: (color: black, align: center),
        o,
      )
    } else if status == "compile" {
      showybox(
        title: [#anchor-hack#[Compile-time error#pin("o-title")]#anchor-hack],
        width: auto,
        shadow: (offset: 3pt),
        frame: (title-color: red.lighten(60%), body-color: red.lighten(80%)),
        title-style: (color: black, align: center),
        o,
      )
    } else if status == "runtime" {
      showybox(
        title: [#anchor-hack#[Runtime error#pin("o-title")]#anchor-hack],
        width: auto,
        shadow: (offset: 3pt),
        frame: (title-color: red.lighten(60%), body-color: red.lighten(80%)),
        title-style: (color: black, align: center),
        o,
      )
    }
  } else {
    ""
  }
  let kode-content = {
    let body = {
      show raw.line: it => {
        show regex("#pin\(.*?\)"): it => pin(eval(it.text.slice(5, it.text.len() - 1)))
        if escape-mode == "comment" {
          show regex("(/\*|\*/)"): none
          it
        } else {
          it
        }
      }
      body
    }
    if filename != none {
      show: showybox.with(
        shadow: (offset: 3pt),
        width: auto,
        title: [
          #anchor-hack#filename#anchor-hack
          #if status == "success" {
            place(right + horizon)[
              #rect(fill: green, radius: .32em)[
                #text(font: "Segoe UI Symbol")[#sym.checkmark]
                #place(dx: 50% + .24em, pin("kode-status"))
              ]
            ]
          } else if status == "compile" or status == "runtime" {
            place(right + horizon)[
              #rect(fill: red, radius: .32em)[
                #text(font: "Segoe UI Symbol")[#sym.times]
                #place(dx: 50% + .24em, pin("kode-status"))
              ]
            ]
          }
        ],
        title-style: (color: white, align: center + horizon),
        footer: output-content,
      )
      body
    } else {
      show: showybox.with(shadow: (offset: 3pt), width: auto, footer: output-content)
      body
    }
  }
  kode-content
  nextBody
}
#let kode-content(body) = text(fill: black, rect(fill: blue.lighten(40%).transparentize(20%), radius: .36em, body))
#let err-content(body) = text(fill: black, rect(fill: red.transparentize(20%), radius: .36em, body))
#let kode-arrow-to-left(..args, start, end) = pinit-arrow(
  start-dx: -4pt,
  start-dy: -4pt,
  end-dx: 4pt,
  end-dy: -4pt,
  start,
  end,
  ..args,
)
#let kode-arrow-to-right(..args, start, end) = pinit-arrow(
  start-dx: 4pt,
  start-dy: -4pt,
  end-dx: -4pt,
  end-dy: -4pt,
  start,
  end,
  ..args,
)
#let kode-to(..args, target, body) = pinit-point-to(
  pin-dx: -5pt,
  body-dx: -10pt,
  body-dy: 0pt,
  ..args.named(),
  (target,),
  kode-content(body),
)
#let kode-to-straight(..args, target, body) = pinit-point-to(
  pin-dx: 3pt,
  pin-dy: -4pt,
  body-dx: 3pt,
  body-dy: -12pt,
  offset-dx: 64pt,
  offset-dy: -4pt,
  ..args.named(),
  (target,),
  kode-content(body),
)
#let kode-to-bottom(..args, target, body) = pinit-point-to(
  pin-dx: -16pt,
  body-dx: -25%,
  offset-dx: -16pt,
  offset-dy: 55pt,
  ..args.named(),
  (target,),
  kode-content(body),
)
#let kode-to-red(..args, target, body) = pinit-point-to(
  pin-dx: -5pt,
  body-dx: -10pt,
  body-dy: 0pt,
  ..args.named(),
  (target,),
  err-content(body),
)
#let kode-to-red-bottom(..args, target, body) = pinit-point-to(
  pin-dx: -16pt,
  body-dx: -25%,
  offset-dx: -16pt,
  offset-dy: 55pt,
  ..args.named(),
  (target,),
  err-content(body),
)
#let kode-to-red-straight(..args, target, body) = pinit-point-to(
  pin-dx: 3pt,
  pin-dy: -4pt,
  body-dx: 3pt,
  body-dy: -12pt,
  offset-dx: 64pt,
  offset-dy: -4pt,
  ..args.named(),
  (target,),
  err-content(body),
)
#let kode-hl(..args, st, ed) = pinit-highlight(
  fill: green.transparentize(75%),
  dx: -.2em,
  dy: -.9em,
  extended-width: .4em,
  extended-height: 1.2em,
  ..args.named(),
  st,
  ed,
)
#let kode-hl-red(..args, st, ed) = pinit-highlight(
  fill: red.transparentize(75%),
  dx: -.2em,
  dy: -.9em,
  extended-width: .4em,
  extended-height: 1.2em,
  ..args.named(),
  st,
  ed,
)