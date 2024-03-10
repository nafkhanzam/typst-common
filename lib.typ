#import "@preview/tablex:0.0.8": *

#let headz(body) = heading(numbering: none, body)
#let phantom(body) = {
  place(top, scale(x: 0%, y: 0%)[#body])
}
#let access-field(o, ..keys, default: none) = {
  let r = o
  for key in keys.pos() {
    if key in r {
      r = r.at(key)
    } else {
      return default
    }
  }
  return r
}
#let enable-todo-hl(body) = {
  show "TODO": highlight(fill: red.darken(10%), text(fill: white)[TODO])

  body
}
#let icite(key) = cite(label(key), form: "prose")
#let i(body) = {
    set cite(form: "prose")
    body
}

// DATES
#let today = datetime.today()
#let display-year = today.display("[Year]")

// ID DATES
#let ID-day = ("Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min");
#let ID-days = ("Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu");
#let ID-month = ("Jan", "Feb", "Mar", "Apr", "Mei", "Jun", "Jul", "Agu", "Sep", "Okt", "Nov" ,"Des");
#let ID-months = ("Januari", "Februari", "Maret", "April", "Mei", "Juni", "Juli", "Agustus", "September", "Oktober", "November" ,"Desember");

#let ID-display-year = display-year
#let ID-display-today = today.display("[day padding:none]") + " " + ID-months.at(today.month() - 1) + " " + display-year

// CURRENCY
#let round-fixed-str(num, d) = {
  let res = str(calc.round(num, digits: d))
  let pad = res.split(".")
  let post-len = 0
  if pad.len() < 2 {
    if d != none and d > 0 {
      res += "."
    }
  } else if pad.len() >= 2 {
    post-len = pad.at(1).len()
  }
  pad = d - post-len
  while pad > 0 {
    res += "0"
    pad -= 1
  }
  return res
}

#let print-currency(num, prefix: none, splitter: [,], split-num: 3, d: 0, comma: ".") = {
  if num < 0 [\- ]
  [#prefix]
  num = calc.abs(num)
  let res = str(num)
  if d != none {
    res = round-fixed-str(num, d)
    res = res.replace(".", comma)
  }
  let res-split = res.split(comma)
  let left = res-split.at(0)
  let right = res-split.at(1, default: none)
  let mod = calc.rem(left.len(), split-num)
  [#left.slice(0, mod)]
  let i = mod
  while i < left.len() {
    if i > 0 {
      splitter
    }
    [#left.slice(i, i + split-num)]
    i += split-num
  }
  if right != none {
    comma + [#right]
  }
}

#let print-rp(num) = print-currency(num, prefix: [Rp ], comma: ",", splitter: ".")

// Preprocess

#let apply-defaults(v, defaults) = {
  for (key, value) in defaults.pairs() {
    if key not in v {
      v.insert(key, value)
    }
  }

  v
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
    if type(a.at(key, default: none)) == "dictionary" and type(b.at(key)) == "dictionary" {
      o.insert(key, deep-merge(a.at(key), b.at(key)))
    } else {
      o.insert(key, b.at(key))
    }
  }
  o
}

#let gen-rows(arr, keys, max-content: none, custom: ()) = {
  if max-content == none {
    max-content = arr.len()
  }
  let cells = arr
    .slice(0, calc.min(arr.len(), max-content))
    .enumerate()
    .map(((i, v)) => (
      [#(i+1)], ..keys.map(key => if key in custom {custom.at(key)(v)} else [#v.at(key)]).flatten(),
    )).flatten()
  if arr.len() == 0 {
    cells.push((colspanx(keys.len()+1, align(center)[Tidak ada.]), (), (), ()))
  }
  return cells.flatten()
}
