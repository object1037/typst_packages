#import "@preview/polylux:0.4.0": toolbox, slide as polylux-slide

#let fg = rgb("262626")
#let bullet-text(size: 14pt, body) = [#text(size, fill: fg, baseline: 4pt, body)]
#let bigarrow(dir: "r") = {
  set align(center + horizon)
  set text(30pt)

  if dir == "r" {
    sym.arrow.r.filled
  } else if dir == "l" {
    sym.arrow.l.filled
  } else if dir == "t" {
    sym.arrow.t.filled
  } else if dir == "b" {
    sym.arrow.b.filled
  }
}
#let footcite(body) = [
  #h(.2em) // space
  #set footnote(numbering: n => text(15pt, baseline: -2pt)[[#n]])
  #footnote[#h(.2em) #body]
]

#let setup(
  aspect-ratio: "16-9",
  bg: rgb("f5f5f5"),
  fg: rgb("262626"),
  body
) = {
  set page(
    paper: "presentation-" + aspect-ratio,
    fill: bg,
  )
  set text(
    size: 20pt,
    font: ("Helvetica Neue", "Hiragino Kaku Gothic ProN", "Noto Sans", "Noto Sans CJK JP"),
    weight: 400,
    hyphenate: true,
    lang: "ja"
  )
  show footnote.entry: set text(size: 15pt)
  set footnote.entry(gap: 0.4em, clearance: 0pt)
  set list(marker: (bullet-text(sym.square.filled), bullet-text(sym.diamond.filled), bullet-text(sym.bullet)))
  let list-counter = counter("list")
  show list: it => {
    list-counter.step()
    context {
      set text(.9em) if list-counter.get().first() == 2
      it
    }
    list-counter.update(i => i - 1)
  }
  show heading.where(level: 1): _ => none

  body
}

#let title-slide(
  title: [],
  subtitle: none,
  label: none,
  affiliation: none,
  author: none,
)= {
  show: align.with(horizon)
  show: block.with(
    width: 100%,
  )
  let content = {
    if label != none {
      show: block.with(
        stroke: 1pt,
        inset: 8pt,
        radius: .25em,
      )
      text(size: .75em, font: ("JetBrainsMono NF", "Cica"), label)
    }
    text(size: 36pt, weight: 700, title)
    if subtitle != none {
      linebreak()
      text(size: 0.9em, subtitle)
    }
    line(length: 100%, stroke: 1pt + fg)
    set text(size: .8em)
    if affiliation != none {
      block(spacing: 1em, affiliation)
    }
    set text(size: 1.2em)
    if author != none {
      block(spacing: 1em, author)
    }
  }
  
  polylux-slide(content)
}

#let slide-title-header = toolbox.next-heading(h => {
  set align(top)
  v(0.25cm)
  if h != none {
    show: block.with(
      width: 100%,
      height: 2.5cm,
      inset: 0.5cm,
      stroke: (bottom: (paint: fg, thickness: 1pt)),
    )
    set align(horizon)
    set text(32pt, weight: 600)
    h
  } else { none }
})

#let slide(title: none, body) = {
  let content = {
    show: pad.with(.75em)
    set text(22pt, weight: 400)
    body
  }

  let footer = {
    set align(right)
    set text(18pt)
    show: pad.with(top: -1.5cm)
    line(length: 100%, stroke: 0pt + fg.lighten(50%))
    [#toolbox.slide-number #text(size: .8em, [\/ #toolbox.last-slide-number])]
  }

  set page(
    header: slide-title-header,
    margin: (top: 4cm, bottom: 0.5cm, left: 1cm, right: 1cm),
    footer: footer,
  )

  polylux-slide(content)
}
