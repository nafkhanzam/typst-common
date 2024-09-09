#import "@preview/truthfy:0.4.0": *

#let bit-count(n) = {
  let res = 0
  while n > 0 {
    res += 1
    n = n.bit-rshift(1)
  }
  return res
}
#let reverse-bits(n, max: none) = {
  if max == none {
    max = bit-count(n)
  }
  let rev = 0

  for _ in range(max) {
    rev = rev.bit-lshift(1)
    if n.bit-and(1) == 1 {
      rev = rev.bit-xor(1)
    }
    n = n.bit-rshift(1)
  }

  return rev
}
#let gen-truth-order(N) = range(N).sorted(key: i => reverse-bits(i, max: bit-count(N)))
#let truth-cells(header-vars: "ABCDEFG", N, ..equations) = {
  gen-truth-order(1.bit-lshift(N))
    .map(i => i + 1)
    .map(i => (
        ..truth-table(eval("$not " + header-vars.at(0) + " or " + header-vars
            .slice(0, N)
            .split("")
            .slice(1, -1)
            .join(" and ") + "$")).children.slice(i * (N + 1)).slice(0, N),
        ..equations.pos().map(v => truth-table(v).children.slice(i * (N + 1)).at(N)),
      ))
    .flatten()
}
