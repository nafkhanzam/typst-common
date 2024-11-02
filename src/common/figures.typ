#let fig-img-args = state(
  "fig-img-args",
  (
    supplement: "Figure",
  ),
)
#let fig-img(
  img,
  caption: none,
  lab: none,
  ..args,
) = (
  context [
    #figure(
      img,
      kind: "image",
      caption: caption,
      ..fig-img-args.get(),
      // placement: top,
      ..args,
    ) #if lab != none {
      label(lab)
    }
  ]
)

#let fig-tab-args = state(
  "fig-tab-args",
  (
    supplement: "Table",
  ),
)
#let fig-tab(
  tab,
  caption: none,
  lab: none,
  ..args,
) = (
  context [
    #figure(
      tab,
      kind: "table",
      caption: figure.caption(position: top, caption),
      ..fig-tab-args.get(),
      // placement: top,
      ..args,
    ) #if lab != none {
      label(lab)
    }
  ]
)

//~ Utilities
#let setup-indonesian(body) = [
  #fig-img-args.update(v => {
    v.at("supplement") = "Gambar"
    v
  })
  #fig-tab-args.update(v => {
    v.at("supplement") = "Tabel"
    v
  })
  #body
]
