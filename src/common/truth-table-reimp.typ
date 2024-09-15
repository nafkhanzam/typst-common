#import "@preview/truthfy:0.4.0"
#import "data.typ": transpose

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
#let _prefix(vars) = eval("$" + vars.map(_always-0).join(" and ") + "$")
#let var-comb-truth-tcells(vars) = {
  let n = vars.len()
  let prefix = _prefix(vars)
  let truthfy-children = truthfy.truth-table(prefix).children
  let cells = gen-truth-order(comb-n(n))
    //? Skip headers
    .map(i => i + 1)
    //? Get collection of variable rows
    .map(i => {
    let res = truthfy-children
    //? Get corresponding row
    res = res.slice(i * (n + 1))
    //? Get variable parts
    res = res.slice(0, n)

    res
  })

  transpose(cells)
}
#let truth-equation-cells(vars, equation) = {
  let n = vars.len()
  let prefix = eval("$" + vars.map(_always-0).join(" and ") + "$")
  let truthfy-children = truthfy.truth-table($(#prefix) or (#equation)$).children
  //? Reorder truthfy indices
  gen-truth-order(comb-n(n))
    //? Skip headers
    .map(i => i + 1)
    //? Get corresponding row and column
    .map(i => (
    truthfy-children.slice(i * (n + 1)).at(n)
  ))
}
#let truth-col-cells(vars, vv) = {
  let n = vars.len()
  let t = type(vv)
  if t == "content" {
    truth-equation-cells(vars, vv)
  } else if t == "function" {
    range(comb-n(n)).map(i => vv(i))
  } else if t == "array" {
    vv
  } else {
    panic("Type " + t + " is not supported.")
  }.map(v => [#v])
}
#let truth-table(table-args: (:), vars, ..pairs) = {
  pairs = pairs.pos()
  let headers = vars + pairs.map(v => v.at(0))
  let vvs = pairs.map(v => v.at(1))
  table(
    columns: headers.len(),
    inset: .4em,
    ..table-args,
    table.header(..headers.map(v => [*$#v$*])),
    ..transpose((
        ..var-comb-truth-tcells(vars),
        ..vvs.map(vv => truth-col-cells(vars, vv)),
      )).flatten()
  )
}