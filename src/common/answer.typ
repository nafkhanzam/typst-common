#import "@preview/showybox:2.0.3": showybox

#let ANS = if "ANS" in sys.inputs {
  let v = lower(sys.inputs.ANS)
  v == "true" or v == "1"
} else {
  false
}

#let answer(body) = {
  answer-raw({
    v(-.5em)
    showybox(
      frame: (
        border-color: blue.darken(50%),
        title-color: blue.lighten(60%),
        body-color: blue.lighten(80%),
      ),
      shadow: (
        offset: 3pt,
      ),
      body,
    )
    v(1em)
  })
}

#let answer-raw(body) = {
  if ANS {
    body
  }
}
