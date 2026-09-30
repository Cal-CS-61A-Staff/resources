// =====================================================================
//  CS 61A Midterm Study Guide — Typst source
// ---------------------------------------------------------------------
//  HOW TO EDIT
//  • The page flows in 2 columns. Each topic is a #sec[Title][...] block;
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

#let BASE = 5.15pt          // main font size — the one knob for density
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
#set page(paper: "us-letter", margin: (x: 9pt, top: 31pt, bottom: 9pt), columns: 2,
  // 2 columns: 9–301.5 | 310.5–603, with the rule at 306.
  background: context {
    place(top + left, dx: 9pt, dy: 16.5pt, text(font: MONO, size: 6.3pt, weight: "bold",
      [CS 61A Midterm 3 Study Guide]))
    let rules = ((306pt, 783pt),)
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
#let sec(title, body, key: false, last: false) = block(width: 100%, breakable: true,
  stroke: if last { none } else { (bottom: 0.4pt) }, inset: (bottom: 3.5pt), below: 3.5pt, {
    // sticky: a title never sits alone at the bottom of a column
    block(sticky: true, below: 4pt,
      if key { box(fill: CFILL, outset: (x: 1.5pt, y: 1.2pt), radius: 1.5pt, text(weight: "bold", title)) }
      else { text(weight: "bold", title) })
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

// ======================= ENVIRONMENT DIAGRAM ========================
// Coordinates are pt inside a 393 × 136 box.
#let env-diagram = fig(393, 121, {
  let FR = rgb("#eef0f3")
  let M(sz, t, fill: black) = text(font: MONO, size: sz * 1pt, fill: fill, t)
  let lab(y, t) = att(3, y, M(5.1, t))
  let nm(y, t, fill: black) = {
    rtext(118, y, M(5.1, t, fill: fill))
    pline((120, y - 5.5), (120, y + 1.5), (128, y + 1.5), stroke: 0.4pt + GREY)
  }
  let val(y, t) = att(122, y, M(5.6, t))
  let EG = rgb("#b5b5b5")
  let RD = rgb("#d24b3a")
  let at-note(x, y, w, body) = place(top + left, dx: x * 1pt, dy: y * 1pt,
    box(width: w * 1pt, note(size: 0.95em, body)))
  att(0, 6, text(weight: "bold")[Environment diagram: mutation inside a function])
  // ---- frames ----
  rect-at(0, 10, 150, 37, fill: FR, stroke: none)
  lab(17, [*Global frame*])
  nm(25.5, "make_withdraw_list")
  nm(34, "withdraw")
  rect-at(0, 40, 150, 92, fill: FR, stroke: none)
  lab(47, [*f1:* make_withdraw_list \[parent=Global\]])
  nm(57, "balance"); val(57, "100")
  nm(66, "withdraw")
  nm(75, "b")
  rtext(118, 83, M(4.8, "Return")); rtext(118, 88, M(4.8, "value"))
  pline((120, 81), (120, 88.5), (128, 88.5), stroke: 0.4pt + GREY)
  dotbox(84, 49.5, 131, 90.5)
  at-note(3, 52, 70, [#c("withdraw") doesn't reassign any name within the parent])
  arrow((74, 70), (83.5, 70), color: CSTROKE, width: 0.5)
  rect-at(0, 95, 150, 121, fill: rgb("#e4eaf3"), stroke: none)
  lab(102, [*f2:* withdraw \[parent=f1\]])
  nm(110, "amount"); val(110, "25")
  rtext(118, 115, M(4.8, "Return", fill: RD)); rtext(118, 119.5, M(4.8, "value", fill: RD))
  pline((120, 113), (120, 120), (128, 120), stroke: 0.4pt + GREY)
  val(119.5, "75")
  // ---- objects ----
  att(161, 19, M(4.7, "func make_withdraw_list(balance) [parent=Global]"))
  att(161, 29, M(4.3, "list", fill: rgb("#555555")))
  rect-at(161, 31, 177, 45, fill: YEL, stroke: none)
  att(162.2, 35.5, M(4.1, "0", fill: GREY))
  att(164.5, 42.5, M(6, "75"))
  pline((161, 31), (161, 45), (177, 45), stroke: 0.6pt + rgb("#555555"))
  dotbox(158.5, 25, 179.5, 47.5)
  at-note(186, 27, 64, [It changes the contents of the #c("b") list])
  arrow((186, 36), (180.5, 36), color: CSTROKE, width: 0.5)
  att(161, 56, M(4.7, "func withdraw(amount) [parent=f1]"))
  // ---- pointers ----
  for (y0, tip) in ((25, (160, 17)), (65.5, (160, 54.5)), (74.5, (160, 41)), (87.5, (160, 55.5))) {
    dotp(124, y0, color: EG); arrow((124, y0), tip, color: EG)
  }
  dotp(124, 33.5, color: RD); arrow((124, 33.5), (160, 53.5), color: RD)
  place(top + left, dx: 300pt, dy: 0pt, box(width: 93pt, text(size: 4.5pt, fill: CTEXT)[
    No return type hint on #c("make_withdraw_list"): it returns a #sub[function] (#c("withdraw")), not a value.]))
  // ---- code ----
  let CX = 260
  let lines = (
    "def make_withdraw_list(balance: int):",
    "    b = [balance]",
    "    def withdraw(amount: int) -> int:",
    "        if amount > b[0]:",
    "            return 'Insufficient funds'",
    "        b[0] = b[0] - amount",
    "        return b[0]",
    "    return withdraw",
    "",
    "withdraw = make_withdraw_list(100)",
    "withdraw(25)",
  )
  rect-at(CX - 3, 24, 393, 121, stroke: 0.5pt + rgb("#6e6380"))
  for (k, l) in lines.enumerate() {
    if l != "" { att(CX, 32 + k * 8.5, text(size: 4.9pt, raw(l, lang: "python"))) }
  }
  at-note(186, 62, 64, [Name bound outside of #c("withdraw") def])
  arrow((250.5, 70), (CX + 11, 38.5), color: CSTROKE, width: 0.5)
  at-note(186, 88, 64, [Element assignment changes a list])
  arrow((250.5, 96), (CX + 22, 72.5), color: CSTROKE, width: 0.5)
})
#set par(spacing: 2.4pt)
#set block(spacing: 2.4pt)

// ============================== TREES ==============================
#sec(key: true)[Trees][
  #py(```
  from __future__ import annotations  # don't worry about this
  from dataclasses import dataclass, field

  @dataclass
  class Tree[T]:
      """A Tree has a label (of type T) and a list of branches, which are trees."""
      label: T
      branches: list[Tree[T]] = field(default_factory=list)  # branches defaults to []

      def __str__(self):
          return format_tree(self)

  def format_tree(t: Tree, indent='') -> str:
      "Format a tree with each branch indented below its label."
      assert isinstance(t, Tree), f'{t!r} is not a Tree'
      assert isinstance(t.branches, list), f'branches of {t!r} is not a list'
      string = indent + str(t.label)
      for b in t.branches:
          string += '\n' + format_tree(b, indent + '  ')
      return string
  ```)
  #py(```
  >>> expr = Tree(10, [Tree(6, [Tree(2), Tree('*'), Tree(3)]), Tree('+'), Tree(4)])
  ```)
  #two(cols: (1fr, 1fr), gap: 8pt)[
    - A tree has a root #sub[label] and a list of #sub[branches]#[;] each branch is a tree.
    - A tree with no branches is a #sub[leaf]: #c("t.branches == []"), or #c("not t.branches").
    - Each location is a #sub[node]#[;] a node is the #sub[parent] of its branches' roots (its #sub[children]).
    - A #sub[path] runs from the root down to a node.
    #align(center, fig(100, 62, {
      let N = (r: (50, 8), a: (26, 31), b: (72, 31), c: (57, 54), d: (86, 54))
      pline(N.r, N.a, stroke: 0.4pt); pline(N.r, N.b, stroke: 0.4pt)
      pline(N.b, N.c, stroke: 0.4pt); pline(N.b, N.d, stroke: 0.4pt)
      place(top + left, curve(stroke: (paint: rgb("#a0701a"), thickness: 1pt, dash: (1pt, 1pt)),
        curve.move(P(54, 11)), curve.line(P(75, 29)), curve.line(P(83, 47))))
      for (k, v) in (("r", "3"), ("a", "1"), ("b", "2"), ("c", "1"), ("d", "1")) {
        let (x, y) = N.at(k)
        place(top + left, dx: (x - 6.5) * 1pt, dy: (y - 6.5) * 1pt, circle(radius: 6.5pt, fill: white, stroke: 0.4pt,
          align(center + horizon, text(size: 6pt, top-edge: "cap-height", bottom-edge: "baseline", v))))
      }
      att(6, 8, text(font: SANS, size: 5pt, fill: rgb("#3a8a1f"), weight: "bold")[root])
      arrow((20, 7), (42.5, 7.5), color: rgb("#3a8a1f"), width: 0.6)
      att(4, 50, text(font: SANS, size: 5pt, fill: rgb("#3a8a1f"), weight: "bold")[leaf])
      arrow((15, 46), (22, 38.5), color: rgb("#3a8a1f"), width: 0.6)
      att(77, 20, text(font: SANS, size: 5pt, fill: rgb("#a0701a"), weight: "bold")[path])
    }))
  ][
    #py(```
    >>> t = Tree(3, [Tree(1, []),
    ...   Tree(2, [Tree(1, []), Tree(1, [])])])
    >>> t.branches[0]
    Tree(label=1, branches=[])
    >>> len(t.branches)
    2
    >>> t.branches[1].label
    2
    >>> len(t.branches[1].branches)
    2
    ```)
    #py(```
    >>> print(expr)
    10
      6
        2
        *
        3
      +
      4
    ```)
  ]
]

#sec[Tree Recursion][
  Each branch is a #sub[smaller tree], so a call on a branch keeps the same promise. Recurse on every branch, then combine.
  #two(cols: (1fr, 1fr), gap: 8pt)[
    #py(```
    def leaves(t):
        """The leaf values in t.
        >>> leaves(fib_tree(5))
        [1, 0, 1, 0, 1, 1, 0, 1]
        """
        if not t.branches:
            return [t.label]
        else:
            return sum([leaves(b)
                for b in t.branches], [])
    ```)
  ][
    #py(```
    def fib_tree(n):
        if n == 0 or n == 1:
            return Tree(n)
        else:
            left = fib_tree(n-2)
            right = fib_tree(n-1)
            fib_n = left.label + right.label
            return Tree(fib_n, [left, right])
    ```)
  ]
]

#sec[repr vs str][
  #two(cols: (1fr, 1fr), gap: 8pt)[
    The result of calling #kgb("repr") on a value is what Python #sub[displays in an interactive session]. \
    The result of calling #kgb("str") on a value is what Python #sub[prints] using the #kgb("print") function.
    #py(```
    >>> today = datetime.date(2019, 10, 13)
    >>> repr(today) # or today.__repr__()
    'datetime.date(2019, 10, 13)'
    >>> str(today)  # or today.__str__()
    '2019-10-13'
    ```)
  ][
    The result of evaluating an #sub[f-string] literal contains the #kg("str") string of the value of each sub-expression.
    #py(```
    >>> f'pi starts with {pi}...'
    'pi starts with 3.141592653589793...'
    >>> print(f'pi starts with {pi}...')
    pi starts with 3.141592653589793...
    ```)
    #note[#kgb("@dataclass") writes #c("__repr__"). #kgb("Tree") / #kgb("Link") define #c("__str__"), so #kg("print") uses #c("format_tree") / #c("format_link").]
  ]
]

// ============================= MUTATION ============================
#sec[List Methods (mutate the list)][
  #py(```
  >>> suits = ['coin', 'string', 'myriad']
  >>> suits.pop()          # remove & return last
  'myriad'
  >>> suits.remove('string')  # first match
  >>> suits.append('cup')     # add one
  >>> suits.extend(['sword', 'club'])  # add all
  >>> suits[2] = 'spade'
  >>> suits
  ['coin', 'cup', 'spade', 'club']
  >>> suits[0:2] = ['diamond']  # replace slice
  >>> suits
  ['diamond', 'spade', 'club']
  >>> suits.insert(0, 'heart')  # add at index
  >>> suits
  ['heart', 'diamond', 'spade', 'club']
  ```)
]

#sec[List Mutation: Identity, Aliases & Copies][
  #sub[Identity:] #ph("<exp0>") #kgb("is") #ph("<exp1>") is #kg("True") if both evaluate to the #sub[same object]. \
  #sub[Equality:] #ph("<exp0>") #kgb("==") #ph("<exp1>") is #kg("True") if both evaluate to #sub[equal values]. \
  _Identical objects are always equal values._
  #two[
    #py(```
    >>> a = [10]
    >>> b = a      # same list
    >>> a == b
    True
    >>> a.append(20)
    >>> a == b
    True
    >>> a
    [10, 20]
    >>> b          # b changed too
    [10, 20]
    ```)
  ][
    #py(```
    >>> a = [10]
    >>> b = [10]   # new list
    >>> a == b
    True
    >>> b.append(20)
    >>> a
    [10]
    >>> b
    [10, 20]
    >>> a == b
    False
    ```)
  ]
  #two[
    You can #sub[copy] a list by calling the list constructor or slicing the list from the beginning to the end.
  ][
    #py(```
    >>> a = [10, 20, 30]
    >>> list(a)   # copy
    [10, 20, 30]
    >>> a[:]      # copy
    [10, 20, 30]
    ```)
  ]
]

#sec[Dictionary Mutation][
  #py(size: 0.9em, ```
  >>> words["oruguita"] = 'caterpillar'
  >>> words["oruguita"] += '🐛'
  >>> words["oruguita"]
  'caterpillar🐛'
  ```)
]

// The environment diagram is 393pt wide, so it spans both columns.
#place(bottom + left, float: true, scope: "parent", clearance: 6pt, block(fill: white, env-diagram))

#sec[Mutating Trees & Linked Lists][
  Change a tree or linked list #sub[in place] by assigning to its attributes (#c("t.label"), #c("t.branches"), #c("s.first"), #c("s.rest")). A mutating function returns #kg("None")#[;] a non-mutating one returns a #sub[new] #kgb("Tree") / #kgb("Link").
]

// ========================= LAZY EVALUATION =========================
#sec(key: true)[Iterators & Lazy Evaluation][
  An #sub[iterable] is anything you can loop over (list, tuple, range, dict, str). An #sub[iterator] remembers a #sub[position] in one.
  #grid(columns: (auto, 1fr), column-gutter: 5pt,
    [#kg("iter")#c("(iterable)")], [Return an iterator over the elements of an iterable value],
    [#kg("next")#c("(iterator)")], [Return the next element of an iterator (#c("StopIteration") when none are left)],
  )
  #grid(columns: (1fr, 1.15fr, 1.2fr), column-gutter: 5pt,
    py(```
    >>> s = [3, 4, 5]
    >>> t = iter(s)
    >>> next(t)
    3
    >>> next(t)
    4
    ```),
    py(```
    >>> d = {'one': 1, 'two': 2}
    >>> k = iter(d)
    >>> next(k)
    'one'
    >>> next(k)
    'two'
    ```),
    py(```
    >>> v = iter(d.values())
    >>> next(v)
    1
    >>> next(v)
    2
    ```),
  )
  - An iterator is #sub[one pass]: once it reaches the end it stays empty. Calling #kg("iter") again gives a #sub[new] one that starts over; the list isn't changed.
  #v(1pt)
  #grid(columns: (1fr, 1fr), column-gutter: 6pt,
    note[#sub[Lazy]: return an iterator and compute #sub[nothing yet]. \ #kg("map") #kg("filter") #kg("zip") #kg("reversed"), generators],
    note[#sub[Eager]: look at #sub[every] element right now. \ #kg("list") #kg("tuple") #kg("sorted") #kg("sum") #kg("max") #kg("min"), #c("for") loops],
  )
  #v(1pt)
  Many built-in Python sequence operations return #sub[iterators that compute results lazily]. To view the contents of an iterator, place the resulting elements into a #sub[container]:
  #grid(columns: (auto, 1fr), column-gutter: 5pt,
    [#kg("map")#c("(func, iterable)")], [Iterate over #c("func(x)") for #c("x") in iterable],
    [#kg("filter")#c("(func, iterable)")], [Iterate over #c("x") in iterable if #c("func(x)")],
    [#kg("zip")#c("(first_iter, second_iter)")], [Iterate over co-indexed #c("(x, y)") pairs],
    [#kg("reversed")#c("(sequence)")], [Iterate over #c("x") in a sequence in reverse order],
    [#kg("list")#c("(iterable)")], [Create a list containing all #c("x") in iterable],
    [#kg("tuple")#c("(iterable)")], [Create a tuple containing all #c("x") in iterable],
    [#kg("sorted")#c("(iterable)")], [Create a sorted list containing #c("x") in iterable],
  )
  #sub[What "lazy" means:] making #c("map(func, s)") does #sub[not] call #c("func") at all. Each time #kg("next") asks, it calls #c("func") on #sub[one] more element. Passing the iterator to something eager (#kg("list"), #kg("sum"), a #c("for") loop) forces #sub[all the remaining] elements at once. #sub[Why:] you only pay for elements you use.
  - #sub[Gotchas:] printing a #c("map") shows #c("<map object at ...>"): wrap it in #kg("list"). A #c("map") has no #kg("len"). A used-up iterator gives #c("[]"). #kg("zip") stops at the shorter input.
]

// ============================ GENERATORS ===========================
#sec[Generators][
  A #sub[generator function] is a function that #kgb("yield")s values instead of #kgb("return")ing. Calling it returns a #sub[generator] (a lazy iterator) #sub[without running the body]. Each #kg("next") runs the body until the next #kgb("yield"), then pauses there.
  #two(cols: (1fr, 1fr), gap: 8pt)[
    #two(cols: (1fr, 1fr))[
      #py(bold: true, ```
      >>> def plus_minus(x):
      ...     yield x
      ...     yield -x
      ```)
    ][
      #py(bold: true, ```
      >>> t = plus_minus(3)
      >>> next(t)
      3
      >>> next(t)
      -3
      ```)
    ]
  ][
    #kgb("yield from") #ph("<iterable>") yields every value of the iterable, one by one.
    #py(bold: true, ```
    def a_then_b(a, b):
        yield from a
        yield from b
    >>> list(a_then_b([3, 4], [5, 6]))
    [3, 4, 5, 6]
    ```)
  ]
]

// ============================ EFFICIENCY ===========================
#sec[Efficiency: Orders of Growth][
  #table(columns: (auto, 1fr, 24pt, 24pt), inset: (x: 2pt, y: 1.2pt), stroke: none, row-gutter: 0pt,
    [#sub[Exponential]], [recursive #kg("fib"): incrementing #emph[n] multiplies #emph[time] by a constant], $Theta(b^n)$, $O(b^n)$,
    [#sub[Quadratic]], [#kg("overlap"): incrementing #emph[n] increases #emph[time] by #emph[n] × a constant], $Theta(n^2)$, $O(n^2)$,
    [#sub[Linear]], [slow #kg("exp"): incrementing #emph[n] increases #emph[time] by a constant], $Theta(n)$, $O(n)$,
    [#sub[Logarithmic]], [#kg("exp_fast"): doubling #emph[n] only increments #emph[time] by a constant], $Theta(log n)$, $O(log n)$,
    [#sub[Constant]], [increasing #emph[n] doesn't affect time], $Theta(1)$, $O(1)$,
  )
]

// ============================= CLASSES =============================
#sec(key: true)[Python Object System][
  #sub[Idea:] All bank accounts have a #kgb("balance") and an account #kgb("holder")#[;] the #kgb("Account") class should add those attributes to each of its #sub[instances].
  #two(cols: (1.3fr, 1fr))[
    #py(```
    class Account:
        interest = 0.02      # class attribute
        def __init__(self, account_holder):
            self.balance = 0
            self.holder = account_holder
        def deposit(self, amount):
            self.balance = self.balance + amount
            return self.balance
        def withdraw(self, amount):
            if amount > self.balance:
                return 'Insufficient funds'
            self.balance = self.balance - amount
            return self.balance
    ```)
  ][
    #sub[When a class is called:]
    + A new instance of that class is created.
    + The #c("__init__") method of the class (the #sub[constructor]) is called with the new object as its first argument (named #kg("self")), along with any additional arguments provided in the call expression.
    #v(2pt)
    #py(```
    >>> a = Account('Jim')
    >>> a.holder
    'Jim'
    >>> a.balance
    0
    ```)
    #note(tail: top)[#kg("self") should always be bound to an instance of the Account class or a subclass of Account]
  ]
]

#sec(key: true)[Dot Notation: Attributes vs Methods][
  #ph("<expression>")#c(" . ")#ph("<name>"): the #ph("<expression>") can be any valid Python expression; the #ph("<name>") must be a simple name. Evaluates to the value of the attribute looked up by #ph("<name>") in the object that is the value of the #ph("<expression>").
  #table(columns: (auto, auto, 1fr), inset: (x: 2.5pt, y: 1.6pt), stroke: 0.3pt + GREY,
    table.header([*Expression*], [*Evaluates to*], [*What it means*]),
    [#c("a.balance")], [a value], [an #sub[attribute]: no parentheses (#c("a.balance()") errors)],
    [#c("a.deposit")], [a #sub[bound method]], [#c("a") is already #kg("self")#[;] #sub[not called yet]],
    [#c("a.deposit(2)")], [a call], [#sub[method invocation]: object before the dot],
    [#c("Account.deposit")], [a plain #sub[function]], [looked up on the class: nothing bound],
    [#c("Account.deposit(a, 5)")], [a call], [#sub[function call]: all args inside, incl. #kg("self")],
  )
  #two[
    #py(```
    >>> type(Account.deposit)
    <class 'function'>
    >>> type(a.deposit)
    <class 'method'>
    ```)
  ][
    #py(```
    >>> Account.deposit(a, 5)
    10
    >>> ⟦a.deposit⟧(2)
    12
    ```)
  ]
  #sub[To evaluate a dot expression:]
  + Evaluate the #ph("<expression>") to the left of the dot, which yields the object of the dot expression
  + #ph("<name>") is matched against the instance attributes of that object; if an attribute with that name exists, its value is returned
  + If not, #ph("<name>") is looked up in the class, which yields a class attribute value
  + That value is returned unless it is a function, in which case a #sub[bound method] is returned instead
]

#sec[Class vs. Instance Attributes][
  Assignment statements with a dot expression on their left-hand side affect attributes for the object of that dot expression:
  - If the object is an #sub[instance], then assignment sets an #sub[instance attribute]
  - If the object is a #sub[class], then assignment sets a #sub[class attribute]
  #two(cols: (1fr, 1fr))[
    #py(```
    >>> jim_account = Account('Jim')
    >>> tom_account = Account('Tom')
    >>> tom_account.interest
    0.02
    >>> jim_account.interest
    0.02
    >>> Account.interest = 0.04
    >>> tom_account.interest
    0.04
    >>> jim_account.interest
    0.04
    ```)
  ][
    #py(```
    >>> jim_account.interest = 0.08
    >>> jim_account.interest
    0.08
    >>> tom_account.interest
    0.04
    >>> Account.interest = 0.05
    >>> tom_account.interest
    0.05
    >>> jim_account.interest
    0.08
    ```)
  ]
  #grid(columns: (1.25fr, 1fr, 1fr), column-gutter: 4pt,
    box(stroke: 0.4pt, inset: 2.5pt, width: 100%)[#text(fill: GREY)[Account class attributes] \ interest: #strike(stroke: 0.6pt + rgb("#e8321e"))[0.02] #strike(stroke: 0.6pt + rgb("#e8321e"))[0.04] 0.05 \ (withdraw, deposit, #c("__init__"))],
    box(stroke: 0.4pt, inset: 2.5pt, width: 100%)[#text(fill: GREY)[jim_account] \ balance: 0 \ holder: 'Jim' \ interest: 0.08],
    box(stroke: 0.4pt, inset: 2.5pt, width: 100%)[#text(fill: GREY)[tom_account] \ balance: 0 \ holder: 'Tom'],
  )
]

// =========================== INHERITANCE ===========================
#sec[Inheritance][
  #py(```
    class CheckingAccount(⟦Account⟧):
        """A bank account that charges for withdrawals."""
        withdraw_fee = 1
        interest = 0.01
        def withdraw(self, amount):
            return Account.withdraw(self, amount + self.withdraw_fee)
            # or
            return ⟦super()⟧.withdraw(amount + self.withdraw_fee)
    ```)
  #two(gap: 8pt)[
    - #c("super().withdraw(x)"): look up #c("withdraw") starting in the #sub[base class]#[;] #kg("self") is filled in for you.
  ][
    - #c("Account.withdraw(self, x)"): get the plain function #sub[through the class], so pass #kg("self") yourself.
  ]
  #box(width: 100%, fill: rgb("#fff4d6"), stroke: 0.6pt + rgb("#d9a400"), inset: 3.5pt, radius: 2pt)[
    #sub[Lookup order.] To look up a name in a class: (1) if it names an attribute in the class, return the attribute value; (2) otherwise, look up the name in the #sub[base class], if there is one. So for #c("obj.name"): #sub[instance → its class → base class → … → #c("AttributeError")]. Assignment never looks up: it sets the name on the object before the dot.
  ]
  #py(```
  >>> ch = CheckingAccount('Tom')  # Calls Account.__init__
  >>> ch.interest     # Found in CheckingAccount
  0.01
  >>> ch.deposit(20)  # Found in Account
  20
  >>> ch.withdraw(5)  # Found in CheckingAccount
  14
  ```)
]
