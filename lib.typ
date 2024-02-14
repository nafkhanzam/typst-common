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

// DATES
#let today = datetime.today()
#let display-year = today.display("[Year]")

// ID DATES
#let ID-day = ("Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min");
#let ID-days = ("Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu");
#let ID-month = ("Jan", "Feb", "Mar", "Apr", "Mei", "Jun", "Jul", "Agu", "Sep", "Okt", "Nov" ,"Des");
#let ID-months = ("Januari", "Februari", "Maret", "April", "Mei", "Juni", "Juli", "Agustus", "September", "Oktober", "November" ,"Desember");

#let ID-display-year = display-year
#let ID-display-today = today.display("[day]") + " " + ID-months.at(today.month() - 1) + " " + display-year
