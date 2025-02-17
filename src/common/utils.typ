#import "@preview/nth:1.0.1": *

#let call-or-value(a, args) = if type(a) == function {
  a(..args)
} else {
  a
}

#let ternary(bool, a, b) = if bool { a } else { b }
#let ternary-fn(bool, a-fn, b-fn) = if bool { a-fn() } else { b-fn() }
#let coalesce(a, b) = if a != none { a } else { b }
