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
#let _always-0(a) = {
  $ #a.body and not #a.body $.body
}
// #let _always-0(a) = a + " and not " + a
#let _prefix(vars) = {
  $#vars.map(_always-0).join($" "and" "$.body)$
}
// #let _prefix(vars) = eval("$" + vars.map(_always-0).join(" and ") + "$")
#let _var-comb-truth-tcells(vars) = {
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
    //? To Equations
    res = res.map(v => $#v$)

    res
  })

  transpose(cells)
}
#let _truth-equation-cells(vars, equation) = {
  let n = vars.len()
  let prefix = _prefix(vars)
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
#let _truth-col-cells(vars, vv) = {
  let n = vars.len()
  let t = type(vv)
  if t == "content" {
    _truth-equation-cells(vars, vv)
  } else if t == "function" {
    range(comb-n(n)).map(i => vv(i))
  } else if t == "array" {
    vv
  } else {
    panic("Type " + t + " is not supported.")
  }.map(v => [#v])
}
#let truth-table-rows(slice-args: (0,), vars, ..pairs) = {
  pairs = pairs.pos()
  let vvs = pairs.map(v => v.at(1))
  transpose((
      .._var-comb-truth-tcells(vars),
      ..vvs.map(vv => _truth-col-cells(vars, vv)),
    )).slice(..slice-args)
}
#let truth-table-cells(slice-args: (0,), vars, ..pairs) = {
  truth-table-rows(slice-args: slice-args, vars, ..pairs).flatten().filter(v => v != none and v != [])
}
#let truth-table(table-args: (:), slice-args: (0,), vars, ..pairs) = {
  let var-headers = vars.map(v => if type(v) == "array" {
    v.at(0)
  } else {
    v
  })
  vars = vars.map(v => if type(v) == "string" {
    $#v$
  } else if type(v) == "array" {
    v.at(1)
  } else {
    v
  })
  pairs = pairs.pos()
  let headers = var-headers + pairs.map(v => v.at(0))
  let vvs = pairs.map(v => v.at(1))
  table(
    columns: headers.len(),
    inset: .4em,
    align: center + horizon,
    ..table-args,
    table.header(..headers.map(v => [*$#v$*])),
    ..truth-table-cells(slice-args: slice-args, vars, ..pairs)
  )
}
