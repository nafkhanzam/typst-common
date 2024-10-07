#import "@preview/oxifmt:0.2.1": *

#let decimal-to-binary(v, n: none) = {
  if n != none {
    strfmt("{:0" + str(n) + "b}", v)
  } else {
    strfmt("{:b}", v)
  }
}

#let binary-count(v) = {
  let n = 0
  while v > 0 {
    v = v.bit-rshift(1)
    n += 1
  }
  n
}

#let k-bit(v, k) = (v.bit-rshift(k)).bit-and(1)