#let apply-defaults(v, defaults) = {
  for (key, value) in defaults.pairs() {
    if key not in v {
      v.insert(key, value)
    }
  }

  v
}

#let access-field(o, ..keys, default: none) = {
  let r = o
  if type(r) != dictionary {
    return r
  }
  for key in keys.pos() {
    if key in r {
      r = r.at(key)
    } else {
      return default
    }
  }
  return r
}

#let apply-refs(o, key, refs) = {
  o.insert(key, access-field(o, key, default: ()))
  for (i, v) in o.at(key).enumerate() {
    let ref = access-field(v, "ref")
    if ref != none {
      for (key, value) in refs.at(ref).pairs() {
        v.insert(key, value)
      }
      v.remove("ref")
    }

    let additional = access-field(v, "additional")
    if additional != none {
      for (key, value) in additional.pairs() {
        v.insert(key, value)
      }
      v.additional = none
      v.remove("additional")
    }

    o.at(key).at(i) = v
  }

  return o
}

#let deep-merge(a, b) = {
  let o = a
  for (key, value) in b.pairs() {
    if type(a.at(key, default: none)) == dictionary and type(b.at(key)) == dictionary {
      o.insert(key, deep-merge(a.at(key), b.at(key)))
    } else {
      o.insert(key, b.at(key))
    }
  }
  o
}

#let gen-rows(arr, keys, max-content: none, custom: (), empty-message: [Tidak ada.]) = {
  if max-content == none {
    max-content = arr.len()
  }
  let cells = arr
    .slice(0, calc.min(arr.len(), max-content))
    .enumerate()
    .map(((i, v)) => (
      [#(i + 1)],
      ..keys
        .map(key => if key in custom {
          custom.at(key)(v)
        } else [#v.at(key)])
        .flatten(),
    ))
    .flatten()
  if arr.len() == 0 {
    cells.push((table.cell(colspan: keys.len() + 1, align(center, empty-message)), (), (), ()))
  }
  return cells.flatten()
}

#let inline-list(..arr, n-format: "(1)", last-sep: [, and ], sep: [, ]) = {
  let values = arr.pos()
  let i = 0
  for (iv, v) in values.enumerate() {
    if i == values.len() - 1 {
      last-sep
    } else if i > 0 {
      sep
    }
    i += 1
    [#numbering(n-format, i) #v]
  }
}

#let transpose(arr) = {
  let c = arr.at(0).len()
  let r = arr.len()
  let res = c * (r * (none,),)

  for i in range(c) {
    for j in range(r) {
      res.at(i).at(j) = arr.at(j).at(i)
    }
  }

  res
}

#let chars-from(chars-str) = chars-str.split("").slice(1, -1)

#let cross-array(a, b) = {
  let res = ()
  for av in a {
    for bv in b {
      res.push((av, bv))
    }
  }
  res
}
#let cross-arrays(..arrs) = {
  arrs = arrs.pos()
  if arrs.len() == 2 {
    cross-array(..arrs)
  } else {
    cross-arrays(cross-array(arrs.at(0), arrs.at(1)), ..arrs.slice(2)).flatten().chunks(arrs.len())
  }
}
