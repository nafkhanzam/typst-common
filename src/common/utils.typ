#let call-or-value(a, args) = if type(a) == function {
  a(..args)
} else {
  a
}
