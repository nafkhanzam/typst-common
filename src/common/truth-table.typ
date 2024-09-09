#import "@preview/truthfy:0.4.0"

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
#let gen-truth-order(n) = range(n).sorted(key: i => reverse-bits(i, max: bit-count(n)))
#let _always-0(a) = a + " and not " + a
#let truth-cells(vars, ..equations) = {
  let n = vars.len()
  let prefix = eval("$" + vars.map(_always-0).join(" and ") + "$")
  gen-truth-order(1.bit-lshift(n))
    .map(i => i + 1)
    .map(i => (
        ..truthfy.truth-table(prefix).children.slice(i * (n + 1)).slice(0, n),
        ..equations.pos().map(v => truthfy.truth-table($(#prefix) or (#v)$).children.slice(i * (n + 1)).at(n)),
      ))
    .flatten()
}

#let truth-table(vars, ..equation-pairs) = {
  let headers = vars + equation-pairs.pos().map(v => v.at(0))
  table(
    columns: headers.len(),
    inset: .4em,
    table.header(..headers.map(v => [*$#v$*])),
    ..truth-cells(
      vars,
      ..equation-pairs.pos().map(v => v.at(1)),
    )
  )
}
