#import "../common/binary.typ": *
#import "../common/gray.typ": *
#import "../common/data.typ": *

#let zstack(
  alignment: top + left,
  ..args,
) = (
  context {
    let width = 0pt
    let height = 0pt
    for item in args.pos() {
      let size = measure(item.at(0))
      width = calc.max(width, size.width)
      height = calc.max(height, size.height)
    }
    block(
      width: width,
      height: height,
      {
        for item in args.pos() {
          place(
            alignment,
            dx: item.at(1),
            dy: item.at(2),
            item.at(0),
          )
        }
      },
    )
  }
)

#let kmap-render(
  row,
  col,
  cells,
  x-label: none,
  x-headers: (),
  y-label: none,
  y-headers: (),
  implicants: (),
  horizontal-implicants: (),
  vertical-implicants: (),
  corner-implicants: false,
  cell-size: 2.2em,
  stroke-width: 0.5pt,
  colors: (
    rgb(255, 0, 0, 100),
    rgb(0, 255, 0, 100),
    rgb(0, 0, 255, 100),
    rgb(0, 255, 255, 100),
    rgb(255, 0, 255, 100),
    rgb(255, 255, 0, 100),
  ),
  implicant-inset: 5pt,
  edge-implicant-overflow: 10pt,
  implicant-radius: 5pt,
  implicant-stroke-transparentize: -100%,
  implicant-stroke-darken: 60%,
  implicant-stroke-width: 0.5pt,
) = {
  implicants = implicants.map(v => v.map(vv => (vv.at(0), row - 1 - vv.at(1))))
  horizontal-implicants = horizontal-implicants.map(v => v.map(vv => (vv.at(0), row - 1 - vv.at(1))))
  vertical-implicants = vertical-implicants.map(v => v.map(vv => (vv.at(0), row - 1 - vv.at(1))))

  let implicant-count = 0
  let cell-total-size = cell-size

  let base = table(
    columns: col * (cell-size,),
    rows: cell-size,
    align: center + horizon,
    stroke: stroke-width,

    ..cells.map(term => [#term])
  )
  let body = zstack(
    alignment: bottom + left,
    (base, 0pt, 0pt),

    // Implicants.
    ..for (index, implicant) in implicants.enumerate() {
      implicant-count += 1

      let p1 = implicant.at(0)
      let p2 = implicant.at(1)

      let bottom-left-point
      let top-right-point

      bottom-left-point = (calc.min(p1.at(0), p2.at(0)), calc.min(p1.at(1), p2.at(1)))
      top-right-point = (calc.max(p1.at(0), p2.at(0)), calc.max(p1.at(1), p2.at(1)))

      let dx = bottom-left-point.at(0) * cell-total-size + implicant-inset
      let dy = bottom-left-point.at(1) * cell-total-size + implicant-inset

      let width = (top-right-point.at(0) - bottom-left-point.at(0) + 1) * cell-size - implicant-inset * 2
      let height = (top-right-point.at(1) - bottom-left-point.at(1) + 1) * cell-size - implicant-inset * 2

      // Loop back on the colors array if there are more implicants than there
      // are colors.
      let color = colors.at(calc.rem-euclid(implicant-count - 1, colors.len()))

      (
        (
          rect(
            stroke: color.darken(implicant-stroke-darken).transparentize(implicant-stroke-transparentize) + implicant-stroke-width,
            fill: color,
            width: width,
            height: height,
            radius: implicant-radius
          ), dx, -dy
        ),
      )
    }, // Implicants.

    // Horizontal implicants.
    ..for (index, implicant) in horizontal-implicants.enumerate() {
      implicant-count += 1

      let p1 = implicant.at(0)
      let p2 = implicant.at(1)

      let bottom-left-point = (calc.min(p1.at(0), p2.at(0)), calc.min(p1.at(1), p2.at(1)))
      let bottom-right-point = (calc.max(p1.at(0), p2.at(0)), calc.min(p1.at(1), p2.at(1)))
      let top-right-point = (calc.max(p1.at(0), p2.at(0)), calc.max(p1.at(1), p2.at(1)))

      let dx1 = bottom-left-point.at(0) * cell-total-size - edge-implicant-overflow + implicant-inset
      let dx2 = bottom-right-point.at(0) * cell-total-size + implicant-inset
      let dy = bottom-left-point.at(1) * cell-total-size + implicant-inset
      // let dy2 = bottom-right-point.at(1) * cell-total-size

      let width = cell-size + edge-implicant-overflow - implicant-inset * 2
      let height = (top-right-point.at(1) - bottom-left-point.at(1) + 1) * cell-size - implicant-inset * 2

      // Loop back on the colors array if there are more implicants than there
      // are colors.
      let color = colors.at(calc.rem-euclid(implicant-count - 1, colors.len()))

      (
        (
          rect(
            stroke: (
              top: color.darken(implicant-stroke-darken).transparentize(implicant-stroke-transparentize) + implicant-stroke-width,
              right: color.darken(implicant-stroke-darken).transparentize(implicant-stroke-transparentize) + implicant-stroke-width,
              bottom: color.darken(implicant-stroke-darken).transparentize(implicant-stroke-transparentize) + implicant-stroke-width
            ),
            fill: color,
            width: width ,
            height: height,
            radius: (right: implicant-radius)
          ), dx1, -dy
        ),
        (
          rect(
            stroke: (
              top: color.darken(implicant-stroke-darken).transparentize(implicant-stroke-transparentize) + implicant-stroke-width,
              left: color.darken(implicant-stroke-darken).transparentize(implicant-stroke-transparentize) + implicant-stroke-width,
              bottom: color.darken(implicant-stroke-darken).transparentize(implicant-stroke-transparentize) + implicant-stroke-width
            ),
            fill: color,
            width: width,
            height: height,
            radius: (left: implicant-radius)
          ), dx2, -dy
        )
      )
    },

    // Vertical implicants.
    ..for (index, implicant) in vertical-implicants.enumerate() {
      implicant-count += 1

      let p1 = implicant.at(0)
      let p2 = implicant.at(1)

      let bottom-left-point = (calc.min(p1.at(0), p2.at(0)), calc.min(p1.at(1), p2.at(1)))
      let top-left-point = (calc.min(p1.at(0), p2.at(0)), calc.max(p1.at(1), p2.at(1)))
      let top-right-point = (calc.max(p1.at(0), p2.at(0)), calc.max(p1.at(1), p2.at(1)))

      let dx = bottom-left-point.at(0) * cell-total-size + implicant-inset
      let dy1 = bottom-left-point.at(1) * cell-total-size - edge-implicant-overflow + implicant-inset
      let dy2 = top-left-point.at(1) * cell-total-size + implicant-inset

      let width = (top-right-point.at(0) - bottom-left-point.at(0) + 1) * cell-size - implicant-inset * 2
      let height = cell-size + edge-implicant-overflow - implicant-inset * 2

      // Loop back on the colors array if there are more implicants than there
      // are colors.
      let color = colors.at(calc.rem-euclid(implicant-count - 1, colors.len()))

      (
        (
          rect(
            stroke: (
              left: color.darken(implicant-stroke-darken).transparentize(implicant-stroke-transparentize) + implicant-stroke-width,
              top: color.darken(implicant-stroke-darken).transparentize(implicant-stroke-transparentize) + implicant-stroke-width,
              right: color.darken(implicant-stroke-darken).transparentize(implicant-stroke-transparentize) + implicant-stroke-width
            ),
            fill: color,
            width: width,
            height: height,
            radius: (top: implicant-radius)
          ), dx, -dy1
        ),
        (
          rect(
            stroke: (
              left: color.darken(implicant-stroke-darken).transparentize(implicant-stroke-transparentize) + implicant-stroke-width,
              bottom: color.darken(implicant-stroke-darken).transparentize(implicant-stroke-transparentize) + implicant-stroke-width,
              right: color.darken(implicant-stroke-darken).transparentize(implicant-stroke-transparentize) + implicant-stroke-width,
            ),
            fill: color,
            width: width,
            height: height,
            radius: (bottom: implicant-radius)
          ), dx, -dy2
        )
      )
    }, // Vertical implicants.

    // Corner implicants.
    ..if corner-implicants {
      implicant-count += 1

      // Index (below) of array is the Gray code position of that corner.
      //
      //    0    1
      //
      //    2    3
      //
      // For example, at index 3, in a 4x4 K-map, the Gray code at that corner
      // is 10.

      let dx-left = -edge-implicant-overflow + implicant-inset
      let dx-right = (col - 1) * cell-total-size + implicant-inset
      let dy-top = (row - 1) * cell-total-size + implicant-inset
      let dy-bottom = edge-implicant-overflow - implicant-inset

      let width = cell-size + edge-implicant-overflow - implicant-inset * 2

      // Loop back on the colors array if there are more implicants than there
      // are colors.
      let color = colors.at(calc.rem-euclid(implicant-count - 1, colors.len()))

      (
        (
          rect(
            width: width,
            height: width,
            stroke: (right: color.darken(implicant-stroke-darken).transparentize(implicant-stroke-transparentize) + implicant-stroke-width, bottom: color.darken(implicant-stroke-darken).transparentize(implicant-stroke-transparentize) + implicant-stroke-width),
            fill: color,
            radius: (bottom-right: implicant-radius)
          ), dx-left, -dy-top
        ),
        (
          rect(
            width: width,
            height: width,
            stroke: (left: color.darken(implicant-stroke-darken).transparentize(implicant-stroke-transparentize) + implicant-stroke-width, bottom: color.darken(implicant-stroke-darken).transparentize(implicant-stroke-transparentize) + implicant-stroke-width),
            fill: color,
            radius: (bottom-left: implicant-radius)
          ), dx-right, -dy-top
        ),
        (
          rect(
            width: width,
            height: width,
            stroke: (top: color.darken(implicant-stroke-darken).transparentize(implicant-stroke-transparentize) + implicant-stroke-width, right: color.darken(implicant-stroke-darken).transparentize(implicant-stroke-transparentize) + implicant-stroke-width),
            fill: color,
            radius: (top-right: implicant-radius)
          ), dx-left, dy-bottom
        ),
        (
          rect(
            width: width,
            height: width,
            stroke: (top: color.darken(implicant-stroke-darken).transparentize(implicant-stroke-transparentize) + implicant-stroke-width, left: color.darken(implicant-stroke-darken).transparentize(implicant-stroke-transparentize) + implicant-stroke-width),
            fill: color,
            radius: (top-left: implicant-radius)
          ), dx-right, dy-bottom
        )
      )
    } // Corner implicants.
  )
  block(
    breakable: false,
    grid(
      columns: 3,
      align: center + horizon,
      [], [], x-label,
      [],
      [],
      table(
        columns: col * (cell-size,),
        align: center + horizon,
        inset: (y: 10pt),
        stroke: none,
        ..x-headers,
      ),

      y-label,
      table(
        rows: cell-size,
        align: center + horizon,
        inset: (x: 10pt),
        stroke: none,
        ..y-headers,
      ),
      body,
    ),
  )
}

#let kmap(
  vars: (),
  landscape: true,
  headers: (:),
  terms: (:),
  implicants: (), // ((top-left, bottom-right),) | "maxterms" | "minterms"
) = {
  terms = (
    type: "gray", // "minterms" | "maxterms" | "manual" | "gray"
    label-1: [1],
    label-0: [0],
    label-X: [X],
    positions: (),
    ignores: (),
    values: (),
    ..terms,
  )
  let n = vars.len()
  let r = if landscape {
    int(calc.floor(n / 2))
  } else {
    int(calc.ceil(n / 2))
  }
  let c = n - r

  let rr = calc.pow(2, r)
  let cc = calc.pow(2, c)
  let nn = rr * cc

  let gray-indices = range(nn).map(v => decimal-to-gray(v))
  let gray-mat = gray-indices.chunks(cc).enumerate().map(((i, res)) => {
    if calc.rem-euclid(i, 2) == 1 {
      res = res.rev()
    }
    res
  })
  let gray-map = nn * (none,)
  for (k, v) in gray-mat
    .enumerate()
    .map(((i, v)) => v.enumerate().map(((j, v)) => (v, (x: j, y: i))))
    .flatten()
    .chunks(2) {
    gray-map.at(k) = (v.x, v.y)
  }
  let gray-at(x, y) = gray-mat.at(y).at(x)
  let pos-at(g) = gray-map.at(g)
  let cells = if terms.type == "manual" {
    terms
      .values
      .enumerate()
      .sorted(key: ((i, v)) => {
          let g = gray-map.at(i)
          g.at(1) * cc + g.at(0)
        })
      .map(v => v.at(1))
  } else if terms.type == "gray" {
    gray-mat.flatten()
  } else if ("minterms", "maxterms").contains(terms.type) {
    gray-mat.flatten().map(i => if int(terms.positions.contains(i)).bit-xor(int(terms.type == "maxterms")) == 1 {
      terms.label-1
    } else if terms.ignores.contains(i) {
      terms.label-X
    } else {
      terms.label-0
    })
  }

  let gen-headers(n) = range(n).map(v => decimal-to-binary(v, n: binary-count(n - 1))).map(v => binary-to-gray(v))
  if access-field(headers, "x") == none {
    headers.x = gen-headers(cc)
  }
  if access-field(headers, "y") == none {
    headers.y = gen-headers(rr)
  }

  let corner-pair = (
    gray-at(-1, -1),
    gray-at(0, 0),
  )
  let corner-implicants = implicants.contains(corner-pair)

  let implicants-pos = implicants.map(pair-g => pair-g.map(pos-at))

  let vertical-implicants = implicants-pos.filter(((g1, g2)) => g1.at(1) > g2.at(1) and g1.at(0) <= g2.at(0))
  let horizontal-implicants = implicants-pos.filter(((g1, g2)) => g1.at(0) > g2.at(0) and g1.at(1) <= g2.at(1))
  let implicants = implicants-pos.filter(((g1, g2)) => g1.at(0) <= g2.at(0) and g1.at(1) <= g2.at(1))

  kmap-render(
    rr,
    cc,
    cells,
    corner-implicants: corner-implicants,
    vertical-implicants: vertical-implicants,
    horizontal-implicants: horizontal-implicants,
    implicants: implicants,
    x-label: vars.slice(r, r + c).join([]),
    y-label: vars.slice(0, r).join([]),
    x-headers: headers.x,
    y-headers: headers.y,
  )
}

// #kmap(vars: ($x$, $y$))
// #kmap(vars: ($x$, $y$, $z$))
// #kmap(vars: ($x$, $y$, $z$), landscape: false, implicants: ((5, 0),))
// #kmap(
//   vars: ($x$, $y$, $z$, $w$),
//   implicants: ((10, 0),),
// )
#kmap(
  vars: ($x$, $y$, $z$, $w$),
  // terms: (type: "gray"),
  terms: (type: "minterms", positions: (5, 7, 13, 15)),
  implicants: ((10, 0), (9, 3), (6, 12), (5, 15)),
)
