//~ Dates

#let today = datetime.today()
#let display-year = today.display("[Year]")


//~ Indonesian Dates

#let ID-day = ("Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min");
#let ID-days = ("Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu");
#let ID-month = ("Jan", "Feb", "Mar", "Apr", "Mei", "Jun", "Jul", "Agu", "Sep", "Okt", "Nov", "Des");
#let ID-months = (
  "Januari",
  "Februari",
  "Maret",
  "April",
  "Mei",
  "Juni",
  "Juli",
  "Agustus",
  "September",
  "Oktober",
  "November",
  "Desember",
);

#let ID-display-year = display-year
#let ID-display-today = today.display("[day padding:none]") + " " + ID-months.at(today.month() - 1) + " " + display-year
