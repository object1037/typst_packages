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
  let (top-margin, bottom-margin, left-margin, right-margin) = (30pt, 30pt, 40pt, 40pt) //get-computed-page-margin()
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
  teaser: none,
  title: "タイトル",
  title_height: 400pt,
  author: "著者 （所属）",
  logos: none,
  size: "a2",
  columns: 2,
  flipped: false,
  bg: rgb("0f172a"),
  fg: rgb("fafafa"),
  lang: "ja",
  body,
) = {
  set page(
    paper: size,
    flipped: flipped,
    margin: (x: 60pt, top: 40pt, bottom: 100pt),
    columns: columns,
    foreground: context {
      let teaser_height = if (teaser != none) {
        measure(teaser, width: page.width - 120pt).height + 60pt
      } else { 0pt }
      let extended-top = title_height + teaser_height + 80pt
      draw-column-separators(
        extend-top: -1 * extended-top,
        extend-bottom: -60pt,
        line-options: (stroke: 2pt + rgb("#737373")),
      )
    },
  )
  set text(
    font: ("Helvetica Neue", "Hiragino Kaku Gothic ProN"),
    hyphenate: true,
    size: 40pt,
    lang: lang,
  )
  show heading.where(level: 1): set block(
    above: 1.5em,
    below: .75em,
    inset: (bottom: .25em),
  )
  set list(marker: (sym.square.filled.medium, sym.diamond.filled.medium, sym.bullet))
  let list-counter = counter("list")
  show list: it => {
    list-counter.step()

    context {
      set text(38pt) if list-counter.get().first() == 2
      it
    }
    list-counter.update(i => i - 1)
  }

  if (teaser != none) {
    place(
      top,
      scope: "parent",
      float: true,
      block(
        fill: bg,
        width: 100%,
        outset: (x: 60pt, y: 40pt),
        teaser,
      ),
    )
  }

  place(
    top,
    scope: "parent",
    float: true,
    block(
      fill: bg,
      width: 100%,
      height: title_height,
      outset: (x: 60pt, y: 40pt),
      align(horizon)[
        #grid(
          columns: (1fr, title_height),
          column-gutter: 0pt,
          [
            #set text(fill: fg, size: 80pt, weight: 700)
            #title
            #v(3pt)
            #text(size: 48pt, weight: 400, author)
          ],
          if (logos != none) {
            align(top + end, block(
              height: 125pt,
              stack(dir: rtl, spacing: 10%, ..logos.map(im => [#im])),
            ))
          },
        )
      ],
    ),
  )

  block(
    width: 100%,
    inset: (top: 60pt),
    body,
  )
}
