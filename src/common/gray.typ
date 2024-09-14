#let binary-to-gray(digits) = {
  let str-res = str(digits.at(0))
  for i in range(digits.len() - 1) {
    let l = int(digits.at(i))
    let r = int(digits.at(i + 1))
    let xorr = if l == r {
      0
    } else {
      1
    }

    str-res += str(xorr)
  }

  return str-res
}

#let gray-to-binary(digits) = {
  let str-res = str(digits.at(0))
  let bef = int(digits.at(0))
  for i in range(1, digits.len()) {
    let l = int(digits.at(i))
    let xorr = if l == bef {
      0
    } else {
      1
    }

    str-res += str(xorr)
    bef = xorr
  }

  return str-res
}

#let decimal-to-gray(v) = v.bit-xor(v.bit-rshift(1))
#let gray-to-decimal(v) = {
  let res = 0

  while v {
    res = res.bit-xor(v)
    v = v.bit-rshift(1)
  }

  return res
}
