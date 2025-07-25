// University theme

// Originally contributed by Pol Dellaiera - https://github.com/drupol

#import "touying.typ": *

/// Default slide function for the presentation.
///
/// - `config` is the configuration of the slide. You can use `config-xxx` to set the configuration of the slide. For more several configurations, you can use `utils.merge-dicts` to merge them.
///
/// - `repeat` is the number of subslides. Default is `auto`，which means touying will automatically calculate the number of subslides.
///
///   The `repeat` argument is necessary when you use `#slide(repeat: 3, self => [ .. ])` style code to create a slide. The callback-style `uncover` and `only` cannot be detected by touying automatically.
///
/// - `setting` is the setting of the slide. You can use it to add some set/show rules for the slide.
///
/// - `composer` is the composer of the slide. You can use it to set the layout of the slide.
///
///   For example, `#slide(composer: (1fr, 2fr, 1fr))[A][B][C]` to split the slide into three parts. The first and the last parts will take 1/4 of the slide, and the second part will take 1/2 of the slide.
///
///   If you pass a non-function value like `(1fr, 2fr, 1fr)`, it will be assumed to be the first argument of the `components.side-by-side` function.
///
///   The `components.side-by-side` function is a simple wrapper of the `grid` function. It means you can use the `grid.cell(colspan: 2, ..)` to make the cell take 2 columns.
///
///   For example, `#slide(composer: 2)[A][B][#grid.cell(colspan: 2)[Footer]] will make the `Footer` cell take 2 columns.
///
///   If you want to customize the composer, you can pass a function to the `composer` argument. The function should receive the contents of the slide and return the content of the slide, like `#slide(composer: grid.with(columns: 2))[A][B]`.
///
/// - `..bodies` is the contents of the slide. You can call the `slide` function with syntax like `#slide[A][B][C]` to create a slide.
#let slide(
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  ..bodies,
) = touying-slide-wrapper(self => {
  let header(self) = {
    set align(top)
    grid(
      rows: (auto, auto),
      row-gutter: 3mm,
      if self.store.progress-bar {
        components.progress-bar(height: 4pt, self.colors.primary, self.colors.tertiary)
      },
      block(inset: (x: .5em), {
        grid(
          columns: 1,
          gutter: .3em,
          grid(
            columns: (auto, 1fr, auto),
            gutter: .3em,
            text(fill: self.colors.primary, weight: "bold", size: 1.2em, utils.call-or-display(
              self,
              self.store.header,
            )),
            align(center + horizon, line(length: 100%, stroke: self.colors.primary)),
            text(fill: self.colors.primary.lighten(65%), utils.call-or-display(self, self.store.header-right)),
          ),
        )
      }),
    )
  }
  let footer(self) = {
    set align(center + bottom)
    set text(size: .46em)
    {
      let cell(..args, it) = components.cell(..args, inset: 1mm, align(horizon, text(
        fill: self.colors.neutral-lightest,
        it,
      )))
      show: block.with(width: 100%, height: auto)
      grid(
        columns: self.store.footer-columns,
        rows: 1.5em,
        cell(fill: self.colors.primary, utils.call-or-display(self, self.store.footer-a)),
        cell(fill: self.colors.secondary, utils.call-or-display(self, self.store.footer-b)),
        cell(fill: self.colors.tertiary, utils.call-or-display(self, self.store.footer-c)),
      )
    }
  }
  let self = utils.merge-dicts(self, config-page(
    margin: 2em,
    header: header,
    footer: footer,
  ))

  touying-slide(self: self, config: config, repeat: repeat, setting: setting, composer: composer, ..bodies)
})


/// Title slide for the presentation. You should update the information in the `config-info` function. You can also pass the information directly to the `title-slide` function.
///
/// Example:
///
/// ```typst
/// #show: university-theme.with(
///   config-info(
///     title: [Title],
///     logo: emoji.school,
///   ),
/// )
///
/// #title-slide(subtitle: [Subtitle])
/// ```
///
/// - `extra` is the extra information of the slide. You can pass the extra information to the `title-slide` function.
#let title-slide(
  extra: none,
  ..args,
) = touying-slide-wrapper(self => {
  let info = self.info + args.named()
  info.authors = {
    let authors = if "authors" in info {
      info.authors
    } else {
      info.author
    }
    if type(authors) == array {
      authors
    } else {
      (authors,)
    }
  }
  let body = {
    let b-size = .65em
    set page(background: rect(stroke: self.colors.secondary + b-size, width: 100%, height: 100%, rect(
      stroke: self.colors.primary + .25em,
      width: 100% - b-size + .25em,
      height: 100% - b-size + .25em,
    )))
    if info.logo != none {
      place(top + end)[
        #set text(fill: self.colors.primary, size: .7em)
        #info.logo
      ]
    }
    align(left + horizon, {
      block(inset: 0em, breakable: false, {
        text(size: 2em, fill: self.colors.primary, strong(info.title))
        if info.subtitle != none {
          parbreak()
          text(size: 1.2em, fill: self.colors.primary, info.subtitle)
        }
      })
      set text(size: .8em)
      grid(
        columns: 1,
        // columns: (1fr,) * calc.min(info.authors.len(), 3),
        column-gutter: 1em,
        row-gutter: 1em,
        ..info.authors.map(author => text(fill: self.colors.neutral-darkest, author))
      )
      v(1em)
      if info.institution != none {
        parbreak()
        text(size: .9em, info.institution)
      }
      if info.date != none {
        parbreak()
        text(size: .8em, utils.display-info-date(self))
      }
    })
    if info.copyright != none {
      show: place.with(bottom + end)
      show: text.with(size: .5em)
      info.copyright
    }
  }
  self = utils.merge-dicts(self, config-common(freeze-slide-counter: true), config-page(
    fill: self.colors.neutral-lightest,
  ))
  touying-slide(self: self, body)
})


/// Focus on some content.
///
/// Example: `#focus-slide[Wake up!]`
///
/// - `background-color` is the background color of the slide. Default is the primary color.
///
/// - `background-img` is the background image of the slide. Default is none.
#let _focus-slide(self: none, background-color: none, background-img: none, body) = {
  let background-color = if background-img == none and background-color == none {
    rgb(self.colors.primary)
  } else {
    background-color
  }
  let args = (:)
  if background-color != none {
    args.fill = background-color
  }
  if background-img != none {
    args.background = {
      set image(fit: "stretch", width: 100%, height: 100%)
      background-img
    }
  }
  self = utils.merge-dicts(self, config-common(freeze-slide-counter: true), config-page(margin: 1em, ..args))
  set text(fill: self.colors.neutral-lightest, weight: "bold", size: 2em)
  touying-slide(self: self, align(horizon, body))
}
#let focus-slide(background-color: none, background-img: none, body) = touying-slide-wrapper(self => _focus-slide(
  self: self,
  background-color: background-color,
  background-img: background-img,
  body,
))


// Create a slide where the provided content blocks are displayed in a grid and coloured in a checkerboard pattern without further decoration. You can configure the grid using the rows and `columns` keyword arguments (both default to none). It is determined in the following way:
///
/// - If `columns` is an integer, create that many columns of width `1fr`.
/// - If `columns` is `none`, create as many columns of width `1fr` as there are content blocks.
/// - Otherwise assume that `columns` is an array of widths already, use that.
/// - If `rows` is an integer, create that many rows of height `1fr`.
/// - If `rows` is `none`, create that many rows of height `1fr` as are needed given the number of co/ -ntent blocks and columns.
/// - Otherwise assume that `rows` is an array of heights already, use that.
/// - Check that there are enough rows and columns to fit in all the content blocks.
///
/// That means that `#matrix-slide[...][...]` stacks horizontally and `#matrix-slide(columns: 1)[...][...]` stacks vertically.
#let matrix-slide(columns: none, rows: none, ..bodies) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(self, config-common(freeze-slide-counter: true), config-page(margin: 0em))
  touying-slide(self: self, composer: components.checkerboard.with(columns: columns, rows: rows), ..bodies)
})


/// New section slide for the presentation. You can update it by updating the `new-section-slide-fn` argument for `config-common` function.
///
/// Example: `config-common(new-section-slide-fn: new-section-slide.with(numbered: false))`
///
/// - `level` is the level of the heading.
///
/// - `numbered` is whether the heading is numbered.
///
/// - `title` is the title of the section. It will be pass by touying automatically.
#let new-section-slide(level: 1, numbered: true, title) = touying-slide-wrapper(self => {
  let title = if title != none {
    title
  } else {
    utils.display-current-heading(level: level, numbered: numbered)
  }
  if level == 1 {
    _focus-slide(self: self, title)
  } else if level == 2 {
    let body = {
      set align(horizon)
      show: pad.with(x: 20%, top: -.5em)
      set text(
        size: 1.5em,
        fill: self.colors.primary,
        weight: "bold",
      )
      {
        set align(right)
        show: pad.with(top: -1em)
        set text(size: .5em, fill: self.colors.tertiary)
        utils.display-current-heading(level: level - 1, numbered: numbered)
      }
      v(.25em)
      block(height: 2pt, width: 100%, spacing: 0pt, components.progress-bar(
        height: 2pt,
        self.colors.primary,
        self.colors.primary-light,
      ))
      v(.25em)
      title
    }
    self = utils.merge-dicts(self, config-page(fill: self.colors.neutral-lightest))
    touying-slide(self: self, body)
  }
})


/// Touying university theme.
///
/// Example:
///
/// ```typst
/// #show: university-theme.with(aspect-ratio: "16-9", config-colors(primary: blue))`
/// ```
///
/// - `aspect-ratio` is the aspect ratio of the slides. Default is `16-9`.
///
/// - `progress-bar` is whether to show the progress bar. Default is `true`.
///
/// - `header` is the header of the slides. Default is `utils.display-current-heading(level: 2)`.
///
/// - `header-right` is the right part of the header. Default is `self.info.logo`.
///
/// - `footer-columns` is the columns of the footer. Default is `(25%, 1fr, 25%)`.
///
/// - `footer-a` is the left part of the footer. Default is `self.info.author`.
///
/// - `footer-b` is the middle part of the footer. Default is `self.info.short-title` or `self.info.title`.
///
/// - `footer-c` is the right part of the footer. Default is `self => h(1fr) + utils.display-info-date(self) + h(1fr) + context utils.slide-counter.display() + " / " + utils.last-slide-number + h(1fr)`.
///
/// ----------------------------------------
///
/// The default colors:
///
/// ```typ
/// config-colors(
///   primary: rgb("#04364A"),
///   secondary: rgb("#176B87"),
///   tertiary: rgb("#448C95"),
///   neutral-lightest: rgb("#ffffff"),
///   neutral-darkest: rgb("#000000"),
/// )
/// ```
#let university-init(self: none, body) = {
  set text(font: ("FreeSerif", "Noto Color Emoji"), fallback: false)
  set text(fill: self.colors.neutral-darkest, size: 25pt)
  set text(size: 22pt)
  show raw: set text(size: .8em)
  show heading: set text(fill: self.colors.primary)
  show strong: self.methods.alert.with(self: self)

  body
}
#let university-theme(
  aspect-ratio: "16-9",
  progress-bar: true,
  header: utils.display-current-heading(level: auto),
  header-right: self => utils.display-current-heading(level: 1),
  footer-columns: (25%, 1fr, 25%),
  footer-a: self => self.info.title,
  footer-b: self => if self.info.short-title == auto {
    self.info.subtitle
  } else {
    self.info.short-title
  },
  footer-c: self => {
    h(1fr)
    utils.display-info-date(self)
    h(1fr)
    context utils.slide-counter.display() + " / " + utils.last-slide-number
    h(1fr)
  },
  copyright: none,
  ..args,
  body,
) = {
  show: touying-slides.with(
    config-page(paper: "presentation-" + aspect-ratio, header-ascent: 0em, footer-descent: 0em, margin: (
      top: 2.5em,
      bottom: 1em,
      x: 2em,
    )),
    config-common(
      slide-fn: slide,
      new-section-slide-fn: new-section-slide.with(level: 1),
      new-subsection-slide-fn: new-section-slide.with(level: 2),
      slide-level: 3,
    ),
    config-methods(
      init: university-init,
      alert: utils.alert-with-primary-color,
    ),
    config-colors(
      primary: rgb("#04364A"),
      secondary: rgb("#176B87"),
      tertiary: rgb("#448C95"),
      neutral-lightest: rgb("#ffffff"),
      neutral-darkest: rgb("#000000"),
    ),
    // save the variables for later use
    config-store(
      progress-bar: progress-bar,
      header: header,
      header-right: header-right,
      footer-columns: footer-columns,
      footer-a: footer-a,
      footer-b: footer-b,
      footer-c: footer-c,
      copyright: copyright,
    ),
    ..args,
  )

  body
}
