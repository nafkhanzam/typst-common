#import "@preview/nth:1.0.1": *

#let call-or-value(a, args) = if type(a) == function {
  a(..args)
} else {
  a
}
