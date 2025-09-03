#import "@preview/showybox:2.0.4": showybox

#let get-ans-env() = {
  if "ANS" in sys.inputs {
    let v = lower(sys.inputs.ANS)
    return v == "true" or v == "1"
  } else {
    return false
  }
}

#let answer(body) = (
  if get-ans-env() {
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
  }
)
