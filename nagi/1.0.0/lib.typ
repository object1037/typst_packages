#import "@preview/polylux:0.3.1": *

#let bullet-text(size: 14pt, body) = [#text(size, fill: gray, baseline: 4pt, body)]
#let bigarrow(dir: "r") = {
  set align(center + horizon)
  set text(40pt)

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

#let nagi-theme(
  aspect-ratio: "16-9",
  body
) = {
  set page(
    paper: "presentation-" + aspect-ratio,
  )
  set text(
    size: 24pt,
    font: ("Helvetica Neue", "Hiragino Kaku Gothic ProN", "Noto Sans", "Noto Sans CJK JP"),
    weight: 400,
    hyphenate: true,
    lang: "ja"
  )
  show footnote.entry: set text(size: 15pt)
  set footnote.entry(gap: 0.25em, clearance: 0pt)
  set list(marker: (bullet-text(sym.square.filled), bullet-text(sym.diamond.filled), bullet-text(sym.bullet)))
  
  body
}

#let gray = rgb("262626")

#let footcite(body) = [
  #h(.2em) // space
  #set footnote(numbering: n => text(15pt, baseline: -2pt)[[#n]])
  #footnote[#h(.2em) #body]
]

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
      text(size: .75em, font: "JetBrainsMono NF", label)
    }
    text(size: 36pt, weight: 700, title)
    if subtitle != none {
      linebreak()
      text(size: 0.9em, subtitle)
    }
    line(length: 100%, stroke: 1pt + gray)
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

#let slide(title: none, body) = {
  let last-number = utils.last-slide-number
  let header = {
    set align(top)
    v(0.5cm)
    if title != none {
      show: block.with(
        width: 100%,
        height: 2.5cm,
        inset: 0.5cm,
        stroke: (bottom: (paint: gray, thickness: 1pt)),
      )
      set align(horizon)
      set text(36pt, weight: 600)
      title
    } else { [] }
  }

  let footer = {
    set text(size: 1em)
    show: pad.with(bottom: 1em)
    set align(bottom)
    h(1fr)
    text(22pt)[
      #logic.logical-slide.display() / #last-number
    ] 
  }

  let content = {
    show: pad.with(.75em)
    set text(24pt, weight: 400)
    body
  }

  set page(
    header: header,
    margin: (top: 4cm, bottom: 0.5cm, left: 1cm, right: 1cm),
    footer: footer,
  )

  polylux-slide(content)
}
