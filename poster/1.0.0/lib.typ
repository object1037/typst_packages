#let poster(
  title: "タイトル",
  author: "著者 （所属）",
  logo: [],
  size: "a2",
  flipped: false,
  background: rgb("0f172a"),
  lang: "ja",
  body
) = {
  set page(
    paper: size,
    flipped: flipped,
    margin: (x: 40pt, y: 30pt),
    columns: 2,
    background: line(
      start: (0%, 210pt),
      length: 78%,
      angle: 90deg
    ),
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
      height: 150pt,
      outset: (x: 40pt, y: 30pt),
      align(horizon)[
        #grid(
          columns: (1fr, 150pt),
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
