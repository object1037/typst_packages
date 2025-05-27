/// Draw separator lines between columns.
/// -> none
#let draw-column-separators(
  /// Extend top margin of the separator line. -> length
  extend-top: 5pt,
  /// Extend bottom margin of the separator line. -> length
  extend-bottom: 5pt,
  /// Options for the separator line. -> list
  line-options: (:),
) = {
  let (top-margin, bottom-margin, left-margin, right-margin) = (30pt, 30pt, 40pt, 40pt)//get-computed-page-margin()
  let page-width = {
    if page.flipped {
      page.height
    } else {
      page.width
    }
  }
  let page-height = {
    if page.flipped {
      page.width
    } else {
      page.height
    }
  }

  let content-width = page-width - (left-margin + right-margin)
  let column-width = (content-width - (columns.gutter * (page.columns - 1))) / page.columns

  let separator-coordinates = range(1, page.columns).map(i => {
    let separator-relative-position = (i * column-width) + ((i - 0.5) * columns.gutter)
    (
      left-margin + separator-relative-position,
      top-margin - extend-top,
      left-margin + separator-relative-position,
      page-height - (bottom-margin) + extend-bottom,
    )
  })

  for (x1, y1, x2, y2) in separator-coordinates {
    place(
      top + left,
      line(
        start: (x1, y1),
        end: (x2, y2),
        ..line-options,
      ),
    )
  }
}

#let poster(
  title: "タイトル",
  title_height: 150pt,
  author: "著者 （所属）",
  logo: [],
  size: "a2",
  columns: 2,
  flipped: false,
  background: rgb("0f172a"),
  lang: "ja",
  body
) = {
  let extened-top = title_height + 60pt
  set page(
    paper: size,
    flipped: flipped,
    margin: (x: 40pt, y: 30pt),
    columns: columns,
    foreground: context { draw-column-separators(
      extend-top: -1 * extened-top,
    ) },
  )
  set text(
    font: ("Helvetica Neue", "Hiragino Kaku Gothic ProN"),
    hyphenate: true,
    size: 26pt,
    lang: lang,
  )
  show heading.where(level: 1): set block(above: 1.5em, below: 1em)
  set list(marker: (sym.square.filled.medium, sym.diamond.filled.medium, sym.bullet))
  let list-counter = counter("list")
  show list: it => {
    list-counter.step()
  
    context {
      set text(24pt) if list-counter.get().first() == 2
      it
    }
    list-counter.update(i => i - 1)
  }

  place(
    top,
    scope: "parent",
    float: true,
    block(
      fill: background,
      width: 100%,
      height: title_height,
      outset: (x: 40pt, y: 30pt),
      align(horizon)[
        #grid(
          columns: (1fr, title_height),
          [
            #set text(fill: white)
            #text(size: 42pt, weight: 700, title)
            #v(3pt)
            #text(size: 26pt, author)
          ],
          logo
        )
      ]
    )
  )

  block(
    width: 100%,
    inset: (top: 60pt),
    body
  )
}
