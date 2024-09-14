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
#let comb-n(n) = 1.bit-lshift(n)
#let gen-truth-order(n) = range(n).sorted(key: i => reverse-bits(i, max: bit-count(n)))
#let _always-0(a) = a + " and not " + a
#let var-comb-truth-cells(vars) = {
  let n = vars.len()
  let prefix = eval("$" + vars.map(_always-0).join(" and ") + "$")
  gen-truth-order(comb-n(n)).map(i => i + 1).map(i => truthfy.truth-table(prefix).children.slice(i * (n + 1)).slice(
    0,
    n,
  ))
}
#let truth-cells(vars, ..values) = {
  let n = vars.len()
  let prefix = eval("$" + vars.map(_always-0).join(" and ") + "$")
  let var-comb-cells = var-comb-truth-cells(vars)
  range(comb-n(n))
    .map(i => (
        ..var-comb-cells.at(i),
        ..values.pos().map(v => v.at(i)).map(v => [#v]),
      ),
    )
    .flatten()
}
#let truth-cells-equations(vars, ..equations) = {
  let n = vars.len()
  let prefix = eval("$" + vars.map(_always-0).join(" and ") + "$")
  truth-cells(
    vars,
    ..equations.pos().map(v => gen-truth-order(comb-n(n)).map(i => i + 1).map(i => (
      truthfy.truth-table($(#prefix) or (#v)$).children.slice(i * (n + 1)).at(n)
    ))),
  )
}

#let truth-table-manual(table-args: (), vars, ..values) = {
  let headers = vars + values.pos().map(v => v.at(0))
  table(
    columns: headers.len(),
    inset: .4em,
    ..table-args,
    table.header(..headers.map(v => [*$#v$*])),
    ..truth-cells(
      vars,
      ..values.pos().map(v => v.at(1)),
    )
  )
}

#let truth-table-fn(table-args: (), vars, ..values-fn) = {
  let headers = vars + values-fn.pos().map(v => v.at(0))
  table(
    columns: headers.len(),
    inset: .4em,
    ..table-args,
    table.header(..headers.map(v => [*$#v$*])),
    ..truth-cells(
      vars,
      ..values-fn.pos().map(v => range(comb-n(vars.len())).map(i => v.at(1)(i))),
    )
  )
}

#let truth-table(table-args: (), vars, ..equation-pairs) = {
  let headers = vars + equation-pairs.pos().map(v => v.at(0))
  table(
    columns: headers.len(),
    inset: .4em,
    ..table-args,
    table.header(..headers.map(v => [*$#v$*])),
    ..truth-cells-equations(
      vars,
      ..equation-pairs.pos().map(v => v.at(1)),
    )
  )
}