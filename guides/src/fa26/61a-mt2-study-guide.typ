// =====================================================================
//  CS 61A Midterm Study Guide — Typst source
// ---------------------------------------------------------------------
//  HOW TO EDIT
//  • The page flows in 3 columns. Each topic is a #sec[Title][...] block;
//    reorder, add or delete sections and everything reflows.
//  • Code / REPL goes in #py(```...```). Lines starting with >>> or ...
//    get an orange prompt and the other lines of a REPL block print grey.
//    Inside code, ⟦...⟧ draws a dotted blue outline; ⟦yel:...⟧ ⟦red:...⟧
//    ⟦grn:...⟧ ⟦blu:...⟧ highlight.
//  • #two(a, b) puts two things side by side. #note[...] is a grey
//    callout (tail: left / right / top / bottom points its arrow).
//  • #c("...") prints text literally (safe for <x>, [x], *, _ , #).
//  • Too long for one page? lower BASE below. Too short? raise it.
// =====================================================================

// Columns 1–2 end COLS_H below the top margin (the rest of the page).
#let COLS_H = 752pt
#let BASE = 5.2pt          // main font size — the one knob for density
#let MONO = ("Menlo", "DejaVu Sans Mono")
#let SANS = ("Helvetica Neue", "Helvetica", "Arial", "Liberation Sans", "DejaVu Sans")

// ---------- colors ----------
#let ORANGE = rgb("#c65e0a")   // >>> prompt
#let GREY = rgb("#888888")     // REPL output
#let KW = rgb("#008800")       // keywords
#let BI = rgb("#007020")       // builtins
#let FN = rgb("#0066bb")       // function names
#let CLS = rgb("#bb0066")      // class names
#let PH = rgb("#05ad19")       // <placeholders>
#let PHB = rgb("#007ecf")      // <placeholders> (blue)
#let CFILL = rgb("#dce3ed")    // callout fill
#let CSTROKE = rgb("#6b7079")
#let CTEXT = rgb("#4a4f57")
#let DOT = rgb("#1a86d6")      // dotted outlines
#let YEL = rgb("#fdf6c3")      // list cells
#let PTR = rgb("#1f5f8b")      // pointer arrows

// ---------- syntax theme for code ----------
#let THEME = bytes(```
<?xml version="1.0" encoding="UTF-8"?>
<plist version="1.0"><dict><key>settings</key><array>
<dict><key>settings</key><dict><key>foreground</key><string>#000000</string></dict></dict>
<dict><key>scope</key><string>keyword.control, keyword.operator.logical, keyword.operator.word, keyword.other, storage.type, storage.modifier</string><key>settings</key><dict><key>foreground</key><string>#008800</string></dict></dict>
<dict><key>scope</key><string>support.function, support.type, variable.language, constant.language</string><key>settings</key><dict><key>foreground</key><string>#007020</string></dict></dict>
<dict><key>scope</key><string>entity.name.function, support.function.magic, meta.function-call.generic</string><key>settings</key><dict><key>foreground</key><string>#0066bb</string></dict></dict>
<dict><key>scope</key><string>entity.name.class, entity.name.type.class, entity.other.inherited-class</string><key>settings</key><dict><key>foreground</key><string>#bb0066</string></dict></dict>
<dict><key>scope</key><string>entity.name.function.decorator, meta.function.decorator</string><key>settings</key><dict><key>foreground</key><string>#aa22ff</string></dict></dict>
<dict><key>scope</key><string>constant.numeric</string><key>settings</key><dict><key>foreground</key><string>#0000dd</string></dict></dict>
<dict><key>scope</key><string>string</string><key>settings</key><dict><key>foreground</key><string>#4070a0</string></dict></dict>
<dict><key>scope</key><string>string.quoted.docstring, comment.block.documentation</string><key>settings</key><dict><key>foreground</key><string>#dd4422</string></dict></dict>
<dict><key>scope</key><string>comment</string><key>settings</key><dict><key>foreground</key><string>#888888</string></dict></dict>
</array></dict></plist>
```.text)

// ---------- page ----------
// Column edges (pt): 9–201 | 210–402 | 411–603. Rules sit in the gutters.
#set page(paper: "us-letter", margin: (x: 9pt, top: 31pt, bottom: 9pt), columns: 1,
  // 3 columns, with rules at 205.5 and 406.5.
  background: context {
    place(top + left, dx: 9pt, dy: 16.5pt, text(font: MONO, size: 6.3pt, weight: "bold",
      [CS 61A Midterm 2 Study Guide]))
    let rules = ((205.5pt, 31pt + COLS_H), (406.5pt, 783pt))
    for (x, y1) in rules { place(top + left, line(start: (x, 30pt), end: (x, y1), stroke: 0.4pt)) }
  })
#set columns(gutter: 9pt)
#set text(font: MONO, size: BASE, top-edge: 0.92em, bottom-edge: -0.27em, hyphenate: false)
#set par(leading: 0pt, spacing: 3pt, justify: false)
#set block(spacing: 3pt)
#set smartquote(enabled: false)
#set raw(theme: THEME)
#show raw: set text(font: MONO, size: 1.25em)
#set list(indent: 0pt, body-indent: 3pt, marker: [•], spacing: 0pt)
#set enum(indent: 0pt, body-indent: 3pt, spacing: 0pt)

// ---------- text helpers ----------
#let c(s, fill: black) = text(fill: fill, s)            // literal text
#let ph(s) = text(fill: PH, s)                          // green <placeholder>
#let phb(s) = text(fill: PHB, s)                        // blue <placeholder>
#let kg(s) = text(fill: rgb("#00882b"), s)              // green code word
#let kgb(s) = text(fill: rgb("#00882b"), weight: "bold", s)
#let hl(color, body) = box(fill: color, outset: (y: 1.1pt), body)
#let ind(n) = h(n * 0.602em)                            // n monospace spaces
#let sub(t) = text(weight: "bold", t)                   // sub-heading

// ---------- layout helpers ----------
// A section: bold title, body, rule underneath. `key: true` shades the title.
// An empty title [] omits the title line (the body sets its own title).
#let sec(title, body, key: false, last: false) = block(width: 100%, breakable: true,
  stroke: if last { none } else { (bottom: 0.4pt) }, inset: (bottom: 3.5pt), below: 3.5pt, {
    // sticky: a title never sits alone at the bottom of a column
    if title != [] { block(sticky: true, below: 4pt,
      if key { box(fill: CFILL, outset: (x: 1.5pt, y: 1.2pt), radius: 1.5pt, text(weight: "bold", title)) }
      else { text(weight: "bold", title) }) }
    body
  })
#let two(a, b, cols: (1fr, 1fr), gap: 5pt) = grid(columns: cols, column-gutter: gap, a, b)

// Grey speech-bubble callout. tail: none | left | right | top | bottom.
#let note(tail: none, size: 1em, body) = box(fill: CFILL, stroke: 0.5pt + CSTROKE, radius: 2.5pt,
  inset: (x: 2.5pt, top: 2pt, bottom: 1.6pt), {
    let t = 3.4pt
    let w = 2.1pt
    let tip(pts) = curve(fill: CFILL, stroke: 0.5pt + CSTROKE, ..pts)
    if tail == left {
      place(left + horizon, dx: -2.5pt - t, tip((curve.move((t + 0.3pt, 0pt)), curve.line((0pt, w)), curve.line((t + 0.3pt, 2 * w)))))
      place(left + horizon, dx: -2.75pt, rect(width: 0.7pt, height: 2 * w - 0.9pt, fill: CFILL, stroke: none))
    } else if tail == right {
      place(right + horizon, dx: 2.5pt + t, tip((curve.move((0pt, 0pt)), curve.line((t + 0.3pt, w)), curve.line((0pt, 2 * w)))))
      place(right + horizon, dx: 2.75pt, rect(width: 0.7pt, height: 2 * w - 0.9pt, fill: CFILL, stroke: none))
    } else if tail == top {
      place(top + center, dy: -2pt - t, tip((curve.move((0pt, t + 0.3pt)), curve.line((w, 0pt)), curve.line((2 * w, t + 0.3pt)))))
      place(top + center, dy: -2.25pt, rect(width: 2 * w - 0.9pt, height: 0.7pt, fill: CFILL, stroke: none))
    } else if tail == bottom {
      place(bottom + center, dy: 1.6pt + t, tip((curve.move((0pt, 0pt)), curve.line((w, t + 0.3pt)), curve.line((2 * w, 0pt)))))
      place(bottom + center, dy: 1.85pt, rect(width: 2 * w - 0.9pt, height: 0.7pt, fill: CFILL, stroke: none))
    }
    set text(fill: CTEXT, size: size)
    align(center, body)
  })

// ---------- code rendering ----------
#let MARKS = (
  dot: b => box(stroke: (paint: DOT, thickness: 0.5pt, dash: (0.8pt, 0.8pt)), radius: 1.5pt, outset: (x: 0.6pt, top: 0.7pt, bottom: 0.5pt), b),
  red: b => hl(rgb("#ffbab8"), b),
  yel: b => hl(rgb("#fdeb3b"), b),
  grn: b => hl(rgb("#eefac9"), b),
  blu: b => hl(CFILL, b),
)
#let segs(l, piece) = {
  let parts = l.split("⟦")
  let lead(t) = if t != "" and t.trim() == "" { h(t.len() * 0.602em) } else { piece(t) }
  let out = (lead(parts.at(0)),)
  for p in parts.slice(1) {
    let q = p.split("⟧")
    let inner = q.at(0)
    let style = "dot"
    for k in MARKS.keys() {
      if inner.starts-with(k + ":") { style = k; inner = inner.slice(k.len() + 1); break }
    }
    out.push((MARKS.at(style))(piece(inner)))
    if q.len() > 1 { out.push(piece(q.slice(1).join("⟧"))) }
  }
  out.join()
}
// Python code or a REPL session. size: e.g. 0.92em to shrink one block.
#let py(src, bold: false, size: 1em) = {
  let s = if type(src) == str { src } else { src.text }
  let lines = s.split("\n")
  let first = lines.find(l => l.trim() != "")
  let repl = first != none and (first.starts-with(">>>") or first.starts-with("..."))
  let wt = if bold { "bold" } else { "regular" }
  let code(t) = text(weight: wt, raw(t, lang: "python"))
  let render(l) = {
    if repl and (l.starts-with(">>>") or l.starts-with("...")) {
      text(fill: ORANGE, weight: wt, l.slice(0, 3)) + segs(l.slice(3), code)
    } else if repl {
      segs(l, t => text(fill: GREY, weight: wt, t))
    } else { segs(l, code) }
  }
  block(text(size: size, lines.map(render).join(linebreak())))
}

// ---------- drawing helpers (coordinates in pt, inside a #fig box) ----------
#let fig(w, h, body) = box(width: w * 1pt, height: h * 1pt, body)
#let P(x, y) = (x * 1pt, y * 1pt)
#let pline(..pts, stroke: 0.5pt) = place(top + left, curve(stroke: stroke,
  ..pts.pos().enumerate().map(((i, p)) => if i == 0 { curve.move(P(..p)) } else { curve.line(P(..p)) })))
#let rect-at(x0, y0, x1, y1, ..args) = place(top + left, dx: x0 * 1pt, dy: y0 * 1pt,
  rect(width: (x1 - x0) * 1pt, height: (y1 - y0) * 1pt, ..args))
#let att(x, y, body) = place(top + left, dx: x * 1pt, dy: y * 1pt,
  box(text(top-edge: "baseline", bottom-edge: "baseline", body)))                 // (x, y) = baseline start
#let rtext(x, y, body) = place(top + left, dx: (x - 100) * 1pt, dy: y * 1pt,
  box(width: 100pt, align(right, text(top-edge: "baseline", bottom-edge: "baseline", body)))) // right-aligned
#let dotp(x, y, color: PTR, r: 1.2) = place(top + left, dx: (x - r) * 1pt, dy: (y - r) * 1pt,
  circle(radius: r * 1pt, fill: color, stroke: none))
#let arrow(a, b, color: PTR, width: 0.7) = {
  let ang = calc.atan2(b.at(0) - a.at(0), b.at(1) - a.at(1))
  let (cx, cy) = (calc.cos(ang), calc.sin(ang))
  let (len, wid) = (3.0, 1.3)
  let (bx, by) = (b.at(0) - len * cx, b.at(1) - len * cy)
  pline(a, (b.at(0) - (len - 0.5) * cx, b.at(1) - (len - 0.5) * cy), stroke: width * 1pt + color)
  place(top + left, curve(fill: color, stroke: none, curve.move(P(..b)),
    curve.line(P(bx - wid * cy, by + wid * cx)), curve.line(P(bx + wid * cy, by - wid * cx)), curve.close()))
}
// Python-Tutor style list with its top-left at (x, y); cells cw wide, h tall.
#let pylist(x, y, cw, h, vals, label: "list") = {
  let n = vals.len()
  att(x, y - 1.3, text(font: SANS, size: 4.3pt, fill: rgb("#555555"), label))
  rect-at(x, y, x + n * cw, y + h, fill: YEL, stroke: none)
  for (i, v) in vals.enumerate() {
    let cx = x + i * cw
    att(cx + 1.2, y + 4.6, text(font: SANS, size: 4.1pt, fill: GREY, str(i)))
    place(top + left, dx: cx * 1pt, dy: (y + h * 0.78) * 1pt, box(width: cw * 1pt,
      align(center, text(font: SANS, size: 6.2pt, top-edge: "baseline", bottom-edge: "baseline", v))))
    pline((cx, y), (cx, y + h), stroke: 0.5pt + GREY)
  }
  pline((x, y), (x, y + h), (x + n * cw, y + h), stroke: 0.6pt + rgb("#555555"))
}
// A name in a frame: right-aligned label ending at x, a small value box, returns nothing.
#let fname(x, y, name) = {
  rtext(x, y, text(font: SANS, size: 5.8pt, name))
  pline((x + 2, y - 5.5), (x + 2, y + 1.5), (x + 10, y + 1.5), stroke: 0.4pt + GREY)
}


#let dotbox(x0, y0, x1, y1) = rect-at(x0, y0, x1, y1, stroke: (paint: DOT, thickness: 0.5pt, dash: (0.8pt, 0.8pt)), radius: 2pt)

// #####################################################################
//                        MIDTERM 2 CONTENT
// #####################################################################

#grid(columns: (393pt, 192pt), column-gutter: 9pt,
  [
    #block(height: 752pt, columns(2, gutter: 9pt)[
    #set text(size: 5.7pt)
// ======================= PYTHON FUNDAMENTALS =======================
#sec[][
  #two(cols: (1fr, 1.05fr))[
    #block(below: 4pt, sub[Values that are false in a boolean context:])
    • #kg("0") and #kg("0.0") \
    • #kg("False") and #kg("None") \
    • An empty container, such\
    #ind(2)as '', [], (), {} \
    Others are true values.
  ][
    #py(```
    >>> bool(0)
    False
    >>> bool('0')
    True
    >>> bool([[]])
    True
    >>> bool(lambda x: 0)
    True
    ```)
  ]

  #sub[Membership]
  #two[
    #py(```
    >>> digits = [1, 8, 2, 8]
    >>> 2 in digits
    True
    >>> 1828 not in digits
    True
    ```)
  ][
    #py(```
    >>> [1, 8] in digits
    False
    >>> 'd' in 'hotdog'
    True
    >>> 'dog' in 'hotdog'
    True
    ```)
  ]

  #sub[Error Types]
  #grid(columns: (auto, 1fr), column-gutter: 6pt, row-gutter: 2.5pt,
    [#c("IndexError")], [indexing a list past its last element],
    [#c("KeyError")], [a key isn't in a dictionary],
    [#c("TypeError")], [an operation on the wrong type: calling  a function with wrong number of arguments; indexing or calling #kg("None")],
    [#c("AttributeError")], [an attribute is not found for an object],
    [#c("NameError")], [A name is not bound in the environment],
  )
]

#sec[Lambda & Currying: #text(weight: "regular")[e.g. #c("f(x, y)") → #c("f(x)(y)")]][
  #py(```
  >>> square = lambda x: x * x   # anonymous function
  >>> curry2 = lambda f: lambda x: lambda y: f(x, y)
  >>> square(4), curry2(add)(3)(4)
  (16, 7)
  ```)
]

#sec[Function Inputs, Outputs, & Type Hints][
  #note[Always ask: #sub[what type goes in, what type comes out?]]
  #py(```
  def sum_list(s: list[int]) -> int:
      ...
  ```)
  Python #sub[doesn't check or enforce] type hints. \ They document a function's intended behavior.
  #grid(columns: (auto, 1fr, auto, 1fr), column-gutter: 4pt,
    [#c("list[int]")], text(fill: GREY)[list of ints],
    [#c("None")], text(fill: GREY)[no return],
    [#c("dict[str,int]")], text(fill: GREY)[str → int],
    [#c("A | B")], text(fill: GREY)[an A or a B],
    [#c("tuple[int,str]")], text(fill: GREY)[(int,str) pair],
    [#c("tuple[()]")], text(fill: GREY)[#c("()")],
    [#c("Link[int]")], text(fill: GREY)[T = #c("int")],
    [#c("LinkedList")], text(fill: GREY)[Link or #c("()")],
  )
  #sub[Type variables:] A name, usually #c("T"), is used to indicate that the same type is involved in two or more formal parameters or return values.
  #py(```
  def pair[T](a: T, b: T) -> list[T]:
      return [a, b]
  ```)
]

// ============================ SEQUENCES ============================
#sec[Lists][
  #two(cols: (1.3fr, 1fr))[
    #py(```
    >>> digits = [1, 8, 2, 8]
    >>> len(digits)
    4
    >>> digits[3]
    8
    >>> digits[-1]  # last
    8
    >>> [2, 7] + digits * 2
    [2, 7, 1, 8, 2, 8, 1, 8, 2, 8]
    ```)
  ][
    #py(```
    >>> pairs = [[10, 20],
    ...          [30, 40]]
    >>> pairs[1]
    [30, 40]
    >>> pairs[1][0]
    30
    ```)
  ]
  #align(center, fig(160, 62, {
    let M(sz, t, fill: black) = text(font: MONO, size: sz * 1pt, fill: fill, t)
    let cells(x, y, cw, vals) = {
      att(x, y - 1.3, M(4.3, "list", fill: rgb("#555555")))
      rect-at(x, y, x + vals.len() * cw, y + 13, fill: YEL, stroke: none)
      for (i, v) in vals.enumerate() {
        let cx = x + i * cw
        att(cx + 1.2, y + 4.3, M(4.1, str(i), fill: GREY))
        place(top + left, dx: cx * 1pt, dy: (y + 10.8) * 1pt, box(width: cw * 1pt,
          align(center, text(top-edge: "baseline", bottom-edge: "baseline", M(6, v)))))
        pline((cx, y), (cx, y + 13), stroke: 0.5pt + GREY)
      }
      pline((x, y), (x, y + 13), (x + vals.len() * cw, y + 13), stroke: 0.6pt + rgb("#555555"))
    }
    rect-at(0, 0, 44, 62, fill: rgb("#eef0f3"), stroke: none)
    att(3, 7, M(5.1, [*Global*]))
    for (y, n) in ((20, "digits"), (46, "pairs")) {
      rtext(32, y, M(5.1, n))
      pline((34, y - 5.5), (34, y + 1.5), (42, y + 1.5), stroke: 0.4pt + GREY)
    }
    cells(56, 10, 13, ("1", "8", "2", "8"))
    cells(56, 38, 13, ("", ""))
    cells(118, 22, 15, ("10", "20"))
    cells(118, 46, 15, ("30", "40"))
    dotp(38, 18.5); arrow((38, 18.5), (55.5, 16.5))
    dotp(38, 44.5); arrow((38, 44.5), (55.5, 44.5))
    dotp(62.5, 46); arrow((62.5, 46), (117.5, 29))
    dotp(75.5, 46); arrow((75.5, 46), (117.5, 52))
  })) \
  #sub[Slicing:] #c("s[<start>:<end>]") makes a new list: from #c("<start>") (#sub[included]) up to #c("<end>") (#sub[not included]). \  *Defaults*: start=#c("0"), end=#c("len(s)") \ #c("s[:]") and #c("list(s)") #sub[copy] the whole list.
  #two(cols: (1.45fr, 1fr), gap: 3pt)[
    #py(size: 0.95em, ```
    >>> s = [6, 5, 4, 3, 2, 1, 0]
    >>> s[1:3]
    [5, 4]
    >>> s[:3]
    [6, 5, 4]
    >>> s[3:]
    [3, 2, 1, 0]
    >>> s[-3:]  #last three elements
    [2, 1, 0]
    ```)
  ][
    #py(size: 0.95em, ```
    >>> s[:]
    [6, 5, 4, 3, 2, 1, 0]
    >>> s[10:]
    []
    >>> empty = []
    >>> empty[0]
    IndexError
    >>> empty[1:]
    []
    ```)
  ]
  A slice of a list always evaluates to a list (maybe empty) and never causes an #c("IndexError").
]

// ============================ ITERATION ============================
#sec(last: true)[Iteration: `for` Statements][
  #c("for") #ph("<name>") #c("in") #ph("<expression>"): \
  #ind(4)#ph("<suite>")
  + Evaluate the header #ph("<expression>"), which must be an #sub[iterable] value (a list, tuple, range, dict, etc.)
  + For each element in that iterable value, in order:
    - Bind #ph("<name>") to that element in the current frame
    - Execute the #ph("<suite>")
  #two(cols: (1.4fr, 1fr), gap: 4pt)[
    #sub[Unpacking in a #c("for") statement:]
    #py(```
    >>> pairs = [[1, 2], [2, 2],
    ...          [3, 2], [4, 4]]
    >>> same_count = 0
    >>> for ⟦x, y⟧ in pairs:
    ...     if x == y:
    ...         same_count += 1
    >>> same_count
    2
    ```)
  ][
    #v(8pt)
    #note(tail: left)[#c("pairs") is a sequence of fixed-length sequences]
    #v(3pt)
    #note(tail: left)[A name for each element in a fixed-length sequence]
  ]
]

#block(breakable: false, sec[Ranges][
  #py("range(-2, 2)").body contains
  #c("..., -3, ")#hl(CFILL)[#c("-2, -1, 0, 1")]#c(", 2, 3, ...")
  - #sub[Length:] ending value − starting value.
  - #sub[Element selection:] starting value + index.
  #two[
    #py(```
    >>> r = range(-2, 2)
    >>> r
    range(-2, 2)
    >>> len(r)
    4
    ```)
  ][
    #py(```
    >>> list(range(-2, 2))
    [-2, -1, 0, 1]
    >>> list(range(4))
    [0, 1, 2, 3]
    ```)
  ]
])

#sec[Aggregation Functions for an iterable s][
  #grid(columns: (auto, auto, 1fr), column-gutter: 5pt, row-gutter: 0pt,
    [*sum*#c("(s, start=0)")], [], text(style: "italic", fill: GREY)[total],
    [*max*#c("(s, key=None)"), ], [*max*#c("(a, b, ..., key=None)")], text(style: "italic", fill: GREY)[largest],
    [*min*#c("(s, key=None)"), ], [*min*#c("(a, b, ..., key=None)")], text(style: "italic", fill: GREY)[smallest],
    [*all*#c("(s)")], [], text(style: "italic", fill: GREY)[all true?],
    [*any*#c("(s)")], [], text(style: "italic", fill: GREY)[any true?],
    [*len*#c("(s)")], [], text(style: "italic", fill: GREY)[length],
  )
  #two[
    #py(```
    >>> all([False, True])
    False
    >>> all([])
    True
    >>> sum([1, 2])
    3
    >>> sum([1, 2], 3)
    6
    >>> sum([])
    0
    >>> sum([[1], [2]], [])
    [1, 2]
    ```)
  ][
    #py(```
    >>> any([False, True])
    True
    >>> any([])
    False
    >>> max(1, 2)
    2
    >>> max([1, 2])
    2
    >>> max([1, -2], key=abs)
    -2
    >>> len([[1, 2], 3])
    2
    ```)
  ]
]

#sec[Dictionaries][
  A container of key-value pairs; keys must be unique#[;] iteration gives the #sub[keys]#[;] #c("d[k]") errors on a missing key#[;] #c("d.get(k, default)") returns `default` if `k` is not a key.
  #two(cols: (1fr, 1fr), gap: 4pt)[
    #py(size: 0.9em, ```
    >>> words = {"más": "more",
    ...          "otro": "other",
    ...          "agua": "water"}
    >>> len(words)
    3
    >>> "agua" in words
    True
    >>> "water" in words
    False
    >>> "water" in words.values()
    True
    ```)
  ][
    #py(size: 0.9em, ```
    >>> words["otro"]
    'other'
    >>> words["hola"]
    KeyError
    >>> words.get("otro", "hi")
    'other'
    >>> words.get("hola", "hi")
    'hi'
    >>> list(words)
    ['más', 'otro', 'agua']
    >>> list(words.values())
    ['more', 'other', 'water']
    ```)
  ]
]

#sec[List & Dictionary Comprehensions][
  #c("[")#phb("<map exp>") #c("for") #phb("<name>") #c("in") #phb("<iter exp>") #c("if") #phb("<filter exp>")#c("]")

  Short version: #c("[")#phb("<map exp>") #c("for") #phb("<name>") #c("in") #phb("<iter exp>")#c("]")

  A combined expression that evaluates to a list by:
  + For each item in the iterable value of #phb("<iter exp>"), bind #phb("<name>") to that item, then if #phb("<filter exp>") evaluates to a true value, include the value of #phb("<map exp>") in the resulting list
  + #phb("<name>") is not bound in the current frame.

  #py(```
  >>> [word for word in words if len(word) == 4]
  ['otro', 'agua']
  >>> [word for word in words]
  ['más', 'otro', 'agua']
  >>> [words[word] for word in words]
  ['more', 'other', 'water']
  >>> {x: x*x for x in range(3,6)}  # dict comprehension
  {3: 9, 4: 16, 5: 25}
  >>> x
  NameError
  ```)
]

#sec[Tuples][
  #two(cols: (1fr, 1.4fr))[
    #py(```
    >>> empty = ()
    >>> len(empty)
    0
    >>> print(empty)
    ()
    >>> (2, 3) + (4, 5)
    (2, 3, 4, 5)
    ```)
  ][
    #py(```
    >>> conditions = ('rain', 'shine')
    >>> conditions[0]
    'rain'
    >>> ra, sh = conditions
    >>> sh
    'shine'
    ```)
  ]
]

#sec(last: true)[Classes with `@dataclass`][
  A #kgb("class") statement creates a new type. When decorated with #kgb("@dataclass"), each name that has a type hint becomes an attribute of the instances of this new class. The `__str__` method within the class determines the output when `str` or `print` is called on an instance.
  #py(```
  @dataclass
  class Position:
      "A geographic position."
      lat: float
      lon: float

      def __str__(self):
          return format_pos(self)

  def format_pos(p: Position) -> str:
      "Format the position with directional suffixes."
      assert abs(p.lat) <= 90 and abs(p.lon) <= 180, \
          f'{p!r} is not on Earth!'
      ... # formats a Position as 33.87° S, 151.21° E
  ```)
  #py(```
  >>> sydney = Position(-33.87, 151.21)
  >>> sydney.lat
  -33.87
  >>> type(sydney) == Position
  True
  >>> print(sydney)
  33.87° S, 151.21° E
  ```)
]
    ])
  ],
  [

// ============================ RECURSION ============================
#let recursion-sec = sec[Recursion][
  State what the function #sub[takes in] and #sub[should return]. \
  #c("sum_digits(n)"): takes a positive #kg("int") #c("n")#[;] returns the sum of its digits.
  - #sub[Base case:] an input simple/small enough that the return value can be found without recursion. One digit: return #c("n").
  - #sub[Recursive case:] call on a #sub[simpler/smaller input] and rely on the recursive call's correctness: #c("sum_digits(all_but_last)") returns the digit sum of all but the last digit; add #c("last").
  #py(size: 0.95em, ```
  def ⟦red:sum_digits(n: int) -> int:⟧
      "Sum the digits of positive integer n."
      if ⟦yel:n < 10⟧:
          ⟦grn:return n⟧
      else:
          ⟦blu:all_but_last, last = n // 10, n % 10⟧
          ⟦blu:return sum_digits(all_but_last) + last⟧
  ```)
  #set text(size: 0.92em)
  #grid(columns: (1fr, 1fr), column-gutter: 4pt,
    [• #hl(rgb("#ffbab8"))[*def header*]: like any function], [• Base: #hl(rgb("#eefac9"))[*no recursive calls*]],
    [• Conditionals: #hl(rgb("#fdeb3b"))[*base cases*]], [• Recursive: #hl(CFILL)[*recursive calls*]],
  )
]

#block(breakable: false, recursion-sec)

#sec[Tree Recursion][
  A recursive case makes #sub[more than one] recursive call.
  #two(cols: (1fr, auto), gap: 3pt)[
    #py(```
    def fib(n: int) -> int:
        if n == 0:
            return 0
        elif n == 1:
            return 1
        else:
            return fib(n-2) + fib(n-1)
    ```)
  ][
    #let fibs = (0, 1, 1, 2, 3, 5, 8, 13, 21)
    #let half(lo, hi) = table(columns: 2, inset: (x: 2pt, y: 1.1pt), stroke: 0.3pt + GREY, align: center,
      [#sub[n]], [#sub[fib(n)]], ..range(lo, hi).map(i => ([#i], [#fibs.at(i)])).flatten())
    #grid(columns: 2, column-gutter: 3pt, half(0, 5), half(5, 9))
  ]
  #sub[Recursive decomposition:] find simpler instances of the same problem that complete most of the work. \ #c("count_partitions(n, m)") = ways to write #c("n") as a sum of parts up to size #c("m"). For #c("(6, 4)"), explore two possibilities:
  - #sub[use at least one 4]: what's left is a partition of 2 → #c("count_partitions(2, 4)")
  - #sub[don't use any 4]: parts up to 3 → #c("count_partitions(6, 3)")
  The last step of the recursive case is to add the two counts to get a total count for (6, 4).
  #py(```
  def count_partitions(n: int, m: int) -> int:
      if n == 0:
          return 1
      elif n < 0:
          return 0
      elif m == 0:
          return 0
      else:
          with_m = count_partitions(n-m, m)
          without_m = count_partitions(n, m-1)
          return with_m + without_m
  ```)
]

// =========================== LINKED LISTS ==========================
#sec(last: true)[Linked Lists][
  A linked list is either #sub[empty] #c("()") or a #kgb("Link") with a #kg("first") value and the #kg("rest") of the list.
  - An empty list is #c("()"). Test if #c("s") is empty with \  #kg("not isinstance")#c("(s, Link)") or #c("s == ()").
  - There's no indexing: to reach item k, follow #c(".rest") k times.
  #py(size: 0.92em, ```
  type LinkedList[T] = Link[T] | tuple[()]

  @dataclass
  class Link[T]:
      first: T
      rest: LinkedList[T] = ()  # empty list

      def __str__(self):
          return format_link(self)

  def format_link(s: Link) -> str:
      """Return a Link s formatted as items within parentheses."""
      string = '(' + str(s.first)
      remaining = s.rest
      while isinstance(remaining, Link):
          string += ' ' + str(remaining.first)
          remaining = remaining.rest
      assert remaining == (), f'{s!r} is not a LinkedList'
      return string + ')'
  ```)
  #align(center, fig(186, 30, {
    rtext(8, 19, text(font: SANS, size: 6pt)[s])
    pline((10, 13), (10, 20.5), (17, 20.5), stroke: 0.4pt + GREY)
    dotp(14, 17)
    for (i, v) in ("3", "4", "5").enumerate() {
      let x = 24 + i * 56
      att(x + 1, 5.6, text(font: SANS, size: 4.8pt, fill: PTR)[Link])
      rect-at(x, 7, x + 17, 29, fill: rgb("#d9d9d9"), stroke: none)
      rect-at(x, 7, x + 40, 29, stroke: 0.5pt + rgb("#6c6c6c"))
      pline((x, 18), (x + 40, 18), stroke: 0.5pt + rgb("#6c6c6c"))
      pline((x + 17, 7), (x + 17, 29), stroke: 0.5pt + rgb("#6c6c6c"))
      rtext(x + 16, 14.5, text(font: SANS, size: 4.6pt)[first:])
      rtext(x + 16, 25.5, text(font: SANS, size: 4.6pt)[rest:])
      att(x + 26.5, 15, text(font: SANS, size: 6.2pt, v))
      if i < 2 { dotp(x + 28.5, 23.5); arrow((x + 28.5, 23.5), (x + 55.5, 13)) }
      else { att(x + 24, 26, text(size: 6pt)[()]) }
    }
    arrow((14, 17), (23.5, 13))
  }))
  #two(cols: (1fr, 1fr))[
    #py(```
    >>> end = Link(5)
    >>> s = Link(3, Link(4, end))
    >>> s.first
    3
    >>> s.rest.first
    4
    >>> s.rest.rest.first
    5
    >>> s.rest.rest.rest == ()
    True
    >>> isinstance((), Link)
    False
    ```)
  ][
    #py(```
    >>> isinstance(s, Link)
    True
    >>> s.rest.rest
    Link(first=5, rest=())
    >>> s.rest.rest == end
    True
    >>> print(s)
    (3 4 5)
    >>> print(end)
    (5)
    >>> print(Link(end, s))
    ((5) 3 4 5)
    ```)
  ]
  #sub[Examples]
  #block(width: 100%, {
  place(top + left, dx: 65% + 1.67pt - 0.6cm, dy: 37pt, note(tail: left)[Stops when #c("s") is #c("()")])
  py(size: 0.92em, ```
  def len_link(s: LinkedList) -> int:
      """Return the length of a linked list.

      >>> len_link(Link(3, Link(4, Link(5))))
      3
      """
      length = 0
      while isinstance(s, Link):
          length += 1
          s = s.rest
      return length
  ```)
  })
  #block(width: 100%, {
  place(top + left, dx: 65% + 1.67pt - 0.6cm, dy: 5pt, note(tail: left)[Base case: #c("s") is #c("()")])
  py(size: 0.92em, ```
  def len_link(s: LinkedList) -> int:
      if not isinstance(s, Link):
          return 0
      return 1 + len_link(s.rest)
  ```)
  })
  #py(size: 0.92em, ```
  def range_link(start: int, end: int) -> LinkedList[int]:
      if start >= end:
          return ()
      else:
          return Link(start, range_link(start + 1, end))
  ```)
]

  ],
)
