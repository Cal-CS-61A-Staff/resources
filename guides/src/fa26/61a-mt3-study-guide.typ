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
#let COLS2_H = 628pt   // page 2: columns 1–2 end here; the environment diagram fills the rest
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
    let n = counter(page).get().first()
    place(top + left, dx: 9pt, dy: 16.5pt, text(font: MONO, size: 6.3pt, weight: "bold",
      [CS 61A Midterm 3 Study Guide]))
    // page 2: the rule between columns 1 and 2 stops above the environment diagram
    let rules = ((205.5pt, 31pt + COLS2_H + 3pt), (406.5pt, 783pt))
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
//                        MIDTERM 3 CONTENT
// #####################################################################

// ================ ENVIRONMENT DIAGRAM (bottom of columns 1–2) ================
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
  att(1, 6, text(weight: "bold")[Environment diagram: mutation inside a function])
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
  at-note(186, 88, 64, [Item assignment changes a list])
  arrow((250.5, 96), (CX + 22, 72.5), color: CSTROKE, width: 0.5)
})

#set text(size: 5.2pt)   // page 2 base size (same as page 1)
#grid(columns: (393pt, 192pt), column-gutter: 9pt,
  [
    #block(height: COLS2_H, columns(2, gutter: 9pt)[

// ============================== TREES ==============================
#sec[Trees][
  #grid(columns: (90pt, 1fr), column-gutter: 3pt,
    [
      #text(fill: rgb("#3a8a1f"), weight: "bold")[Recursive description:]
      - A #sub[tree] has a root #sub[label] and a list of #sub[branches]
      - Each branch is a #sub[tree]
      - A tree with zero branches is a #sub[leaf]
      #text(fill: rgb("#1f6fc4"), weight: "bold")[Relative description:]
      - Each location is a #sub[node]
      - Each #sub[node] has a #sub[label]
      - A node is a branch of its #sub[parent]#[;] its branches are its #sub[children]
    ],
    align(right, fig(97, 86, {
      let GR = rgb("#3a8a1f"); let BL = rgb("#1f6fc4"); let BR = rgb("#a0701a")
      let lab(x, y, col, t) = att(x, y, text(font: SANS, size: 4.8pt, fill: col, weight: "bold", t))
      let N = (r: (54, 13), a: (31, 33), b: (74, 33), a1: (20, 53), a2: (42, 53),
               b1: (63, 53), b2: (85, 53), c1: (76, 74), c2: (91, 74))
      for (p, q) in (("r","a"),("r","b"),("a","a1"),("a","a2"),("b","b1"),("b","b2"),("b2","c1"),("b2","c2")) {
        pline(N.at(p), N.at(q), stroke: 0.4pt)
      }
      // branch box (left subtree) and leaf box
      rect-at(12.5, 26, 50, 60, stroke: (paint: DOT, thickness: 0.5pt, dash: (0.8pt, 0.8pt)), radius: 2pt)
      // path: root -> 2 -> 1 -> 0
      place(top + left, curve(stroke: (paint: BR, thickness: 1pt, dash: (1pt, 1pt)),
        curve.move(P(57, 17)), curve.line(P(77, 37)), curve.line(P(87, 57)), curve.line(P(79, 71))))
      for (k, v) in (("r","3"),("a","1"),("b","2"),("a1","0"),("a2","1"),("b1","1"),("b2","1"),("c1","0"),("c2","1")) {
        let (x, y) = N.at(k)
        place(top + left, dx: (x - 5.5) * 1pt, dy: (y - 5.5) * 1pt, circle(radius: 5.5pt, fill: white, stroke: 0.4pt,
          align(center + horizon, text(size: 5.5pt, top-edge: "cap-height", bottom-edge: "baseline", v))))
      }
      lab(0, 3, GR, [root])
      arrow((15, 6), (47.5, 11.5), color: GR, width: 0.6)
      lab(0, 16, GR, [branch])
      arrow((8, 21.5), (13, 26), color: GR, width: 0.6)
      lab(0, 70, GR, [leaf])
      arrow((8, 69), (17.2, 57.2), color: GR, width: 0.6)
      lab(70, 1, BL, [label])
      arrow((71, 4.5), (56.5, 11.5), color: BL, width: 0.6)
      lab(86, 19, BL, [node])
      arrow((89, 24), (79, 30), color: BL, width: 0.6)
      lab(55, 70, BR, [path])
    })),
  )
  #v(-8pt)
  #py(size: 0.92em, ```
  @dataclass
  class Tree[T]:
      """A Tree has a label (of type T) and a list of branches."""
      label: T
      branches: list[Tree[T]] = field(default_factory=list)  # []
      def __str__(self):
          return format_tree(self)

  def format_tree(t: Tree, indent='') -> str:
      "Format a tree with each branch indented below its label."
      assert isinstance(t, Tree) and isinstance(t.branches, list)
      string = indent + str(t.label)
      for b in t.branches:
          string += '\n' + format_tree(b, indent + '  ')
      return string

  def is_leaf(t: Tree) -> bool:
      "Return whether a Tree t is a leaf with no branches."
      return not t.branches
  ```)
  #py(size: 0.92em, ```
  >>> expr = Tree(10, [Tree(6, [Tree(2), Tree('*'),
  ...   Tree(3)]), Tree('+'), Tree(4)])
  >>> expr.branches[0].label, len(expr.branches)
  (6, 3)
  ```)
  #grid(columns: (auto, 1fr), column-gutter: 8pt,
    py(size: 0.92em, ```
    >>> print(expr)
    10
      6
        2
        *
        3
      +
      4
    ```),
    [
      #align(center, fig(110, 34, {
        let N = (r: (55, 5), a: (25, 17), b: (55, 17), c: (85, 17), a1: (10, 29), a2: (25, 29), a3: (40, 29))
        for (p, q) in (("r","a"),("r","b"),("r","c"),("a","a1"),("a","a2"),("a","a3")) { pline(N.at(p), N.at(q), stroke: 0.4pt) }
        for (k, v) in (("r","10"),("a","6"),("b","+"),("c","4"),("a1","2"),("a2","*"),("a3","3")) {
          let (x, y) = N.at(k)
          place(top + left, dx: (x - 5) * 1pt, dy: (y - 5) * 1pt, circle(radius: 5pt, fill: white, stroke: 0.4pt,
            align(center + horizon, text(size: 5pt, top-edge: "cap-height", bottom-edge: "baseline", v))))
        }
      }))
      #py(size: 0.92em, ```
      >>> expr.branches[1]
      Tree(label='+', branches=[])
      ```)
    ],
  )
  Each branch of a tree is a tree, so a function that takes trees can be called recursively on each of its branches.
  #py(```
  def increment_leaves(t: Tree[int]) -> Tree[int]:
      "Return a tree like t with the leaf labels incremented."
      if not t.branches:
          return Tree(t.label + 1)
      incremented = [increment_leaves(b) for b in t.branches]
      return Tree(t.label, incremented)
  ```)
]

// ============================ MUTATION =============================
#sec[List Mutation][
  #py(```
  >>> suits = ['coin', 'string', 'myriad', 'cup']
  >>> suits.pop()               # remove & return last
  'cup'
  >>> suits.pop(1)              # remove & return index 1
  'string'
  >>> suits.remove('myriad')    # remove first match
  >>> suits
  ['coin']
  >>> suits.append('spade')     # add one to the end
  >>> suits.extend(['heart', 'club'])  # add all to end
  >>> suits[0] = 'diamond'
  >>> suits.insert(0, 'joker')  # add at index
  >>> suits
  ['joker', 'diamond', 'spade', 'heart', 'club']
  >>> print(suits.append('x'))  # append returns None
  None                          # so do extend, insert & remove
  ```)
  #v(3pt)
  #two[
    #py(```
    >>> s = [1, 2]
    >>> s.append([3, 4])
    >>> s.extend([5, 6])
    >>> s
    [1, 2, [3, 4], 5, 6]
    ```)
  ][
    #py(```
    >>> t = s
    >>> s += [7]     # mutates
    >>> s = s + [8]  # new list
    >>> t
    [1, 2, [3, 4], 5, 6, 7]
    ```)
  ]
  #v(3pt)
  #two[
    #py(```
    >>> a = [10]
    >>> b = a      # same list
    >>> a == b
    True
    >>> b.append(20)
    >>> a == b
    True
    >>> a
    [10, 20]
    >>> b
    [10, 20]
    >>> a is b
    True
    ```)
  ][
    #py(```
    >>> a = [10]
    >>> b = [10]   # new list
    >>> a == b
    True
    >>> b.append(20)
    >>> a == b
    False
    >>> a
    [10]
    >>> b
    [10, 20]
    >>> a is b
    False
    ```)
  ]
]

#sec(last: true)[Mutation and Box-and-Pointer Diagrams][
  #grid(columns: (auto, 1fr), column-gutter: 6pt,
    py(```
    >>> s = [1, [2, 3], 4]
    >>> s.append([s[1], 5])
    >>> print(s)
    [1, [2, 3], 4, [[2, 3], 5]]
    ```),
    align(center, fig(80, 31, {
      rect-at(0, 0, 20, 15, fill: rgb("#eef0f3"), stroke: none)
      fname(9, 10, "s")
      pylist(24, 2, 10, 11, ("1", "", "4", ""))
      pylist(26, 20, 10, 11, ("2", "3"))
      pylist(58, 20, 10, 11, ("", "5"))
      dotp(15, 8); arrow((15, 8), (23.5, 8))
      dotp(39, 9.5); arrow((39, 9.5), (38, 19.5))
      dotp(59, 9.5); arrow((59, 9.5), (66.5, 19.5))
      dotp(63, 26); arrow((63, 26), (46.5, 26))
    })),
  )
]

#colbreak()
#sec[Dictionary Mutation][
  #py(```
  >>> words = {"oruguita": "caterpillar"}
  >>> words["oruguita"] += "🐛"
  >>> words["oruguita"]
  'caterpillar🐛'
  >>> words["mariposa"] = "butterfly"
  >>> words
  {'oruguita': 'caterpillar🐛', 'mariposa': 'butterfly'}
  ```)
]

#sec[Copies and Tuples][
  #two(cols: (1fr, 1fr), gap: 4pt)[
    Making a new list does not copy nested lists it contains.
    #py(```
    >>> a = [[1], 2]
    >>> c = list(a)
    >>> c[0].append(5)
    >>> c[1] = 9
    >>> a
    [[1, 5], 2]
    >>> (c is a, c[0] is a[0])
    (False, True)
    ```)
  ][#pad(left: 0.6em)[
    A tuple can't change, but a list inside it can.
    #py(```
    >>> t = (1, [2])
    >>> t.append(3)
    Error: tuple has no append
    >>> t[1].append(3)
    >>> t
    (1, [2, 3])
    ```)
  ]]
]

// ============================ ITERATORS ============================
#sec[Iterators & Iterables][
  An #sub[iterable] value is one that #sub[for] can iterate over (list, tuple, range, dict, str). An #sub[iterator] provides the items of an iterable one at a time, tracking its position through the iterable. Iterators are also iterables.
  #grid(columns: (auto, 1fr), column-gutter: 5pt,
    [#kg("iter")#c("(iterable)")], [make an iterator over the iterable's items],
    [#kg("next")#c("(iterator)")], [return the next item in the iterator],
  )
  #grid(columns: (1fr, 1.25fr, 1.15fr), column-gutter: 4pt,
    py(```
    >>> s = [3, 4, 5]
    >>> t = iter(s)
    >>> next(t)
    3
    >>> next(t)
    4
    ```),
    py(```
    >>> d = {'one': 1,
    ...      'two': 2}
    >>> k = iter(d)
    >>> next(k)
    'one'
    >>> next(k)
    'two'
    ```),
    py(```
    >>> v = iter(
    ...   d.values())
    >>> next(v)
    1
    >>> next(v)
    2
    ```),
  )
  Once an iterator reaches the end, calling #kg("next") on it causes an error (#kg("StopIteration")). Calling #kg("iter") again on an iterable such as a list makes a new iterator.
  #two[
    #py(```
    >>> s = [3, 4, 5]
    >>> t = iter(s)
    >>> next(t)
    3
    >>> next(t)
    4
    ```)
  ][
    #py(```
    >>> u = iter(s)
    >>> next(u)
    3
    >>> next(t)
    5
    >>> next(u)
    4
    ```)
  ]
  - A #sub[#c("for")] statement calls #kg("iter"), then #kg("next") until #c("StopIteration").
  - #kg("iter") of an iterator returns itself.
  - Adding a dict key while iterating over it: #kg("RuntimeError").
]

#sec[Lazy Evaluation][
  These functions return iterators whose evaluation is lazy:
  #grid(columns: (auto, 1fr), column-gutter: 5pt,
    [#kg("map")#c("(func, iterable)")], [#c("func(x)") for #c("x") in iterable],
    [#kg("filter")#c("(func, iterable)")], [#c("x") in iterable if #c("func(x)")],
    [#kg("zip")#c("(first, second)")], [co-indexed #c("(x, y)") pairs],
    [#kg("reversed")#c("(sequence)")], [#c("x") in reverse order],
  )
  To view the contents of an iterator, place the items into a #sub[container] with #kg("list"), #kg("tuple"), or #kg("sorted").
  #py(```
  def double(x):
      print('***', x, '=>', 2*x, '***')
      return 2*x
  ```)
  #two(cols: (auto, 1fr), gap: 8pt)[
    #py(```
    >>> s = [3, 4, 5]
    >>> doubled = map(double, s)
    >>> next(doubled)
    *** 3 => 6 ***
    6
    ```)
  ][
    #py(```
    >>> list(doubled)
    *** 4 => 8 ***
    *** 5 => 10 ***
    [8, 10]
    ```)
  ]
]

// ============================ GENERATORS ===========================
#sec(last: true)[Generators][
  A #sub[generator function] has #kgb("yield") in its body. Calling it #sub[doesn't run the body]: it returns a #sub[generator], which is an iterator. Each #kg("next") runs the body until the next #kgb("yield"), returns that value, and #sub[pauses] there (local names keep their values). When the body ends, #kg("next") raises #c("StopIteration").
  #two(cols: (1fr, 1fr), gap: 4pt)[
    #py(```
    def countdown(n):
        print('start')
        while n > 0:
            yield n
            n -= 1
        print('done')
    ```)
    #v(2pt)
    #text(fill: GREY)[#c("countdown(2)") printed nothing#[;] each #kg("next") resumes after #kgb("yield").]
  ][
    #py(```
    >>> g = countdown(2)
    >>> next(g)
    start
    2
    >>> next(g)
    1
    >>> next(g)
    done
    StopIteration
    ```)
  ]
  #kgb("yield from") #ph("<it>") yields every value of #ph("<it>"), one at a time.
  #two(cols: (0.7fr, 1.3fr), gap: 4pt)[
    #py(```
    def a_then_b(a, b):
        yield from a
        yield from b
    ```)
  ][
    #py(```
    >>> list(a_then_b([3, 4],
    ...               range(5, 7)))
    [3, 4, 5, 6]
    ```)
  ]
  A recursive call to a generator function returns an iterator.
  #two(cols: (auto, 1fr), gap: 4pt)[
    #py(```
    def prefixes(s):
      if s:
        yield from prefixes(s[:-1])
        yield s
    ```)
  ][
    #py(```
    >>> list(prefixes('abc'))
    ['a', 'ab', 'abc']
    ```)
  ]
]

    ])
    #v(1fr)
    #line(length: 100%, stroke: 0.4pt)
    #v(-3pt)
    #env-diagram
  ],
  [
    #set text(size: 5pt)   // column 3 is 4% smaller so it fits on the page

// ============================= CLASSES =============================
// Callout whose tail points UP at x (pt from the left of the column); the box is w wide.
#let upnote(x, w, body, off: 7pt) = pad(left: calc.max(0pt, x - off), top: 3.6pt, box(width: w, fill: CFILL,
  stroke: 0.5pt + CSTROKE, radius: 2.5pt, inset: (x: 2.5pt, top: 2pt, bottom: 1.6pt), {
    let t = 3.4pt
    let w2 = 2.1pt
    place(top + left, dx: off - w2 - 2.5pt, dy: -2pt - t, curve(fill: CFILL, stroke: 0.5pt + CSTROKE,
      curve.move((0pt, t + 0.3pt)), curve.line((w2, 0pt)), curve.line((2 * w2, t + 0.3pt))))
    place(top + left, dx: off - w2 - 2.5pt + 0.45pt, dy: -2.25pt, rect(width: 2 * w2 - 0.9pt, height: 0.7pt, fill: CFILL, stroke: none))
    set text(fill: CTEXT)
    body
  }))
#let CH = 3.75   // width of one code character at this size (pt)

#sec[Python Object System][
  #sub[When a class is called:]
  + A new instance of that class is created.
  + The #kg("__init__") method of the class is called with the new object as its first argument (named #kg("self")), along with any additional arguments provided in the call expression.
  #sub[Example:] All bank accounts have a #kgb("balance") and a #kgb("holder")#[;] the #kgb("Account") class adds those attributes to each of its #sub[instances].
  #grid(columns: (auto, 1fr), column-gutter: 7pt, align: horizon,
    py(```
    >>> a = Account('Jim')
    >>> a.holder
    'Jim'
    >>> a.balance
    0
    ```),
    stack(spacing: 2pt,
      note(tail: left)[A new instance is created by calling a class],
      align(center, box[
        #text(fill: GREY, size: 0.9em)[An account instance] \
        #box(stroke: 0.9pt + rgb("#7b2b1e"), inset: (x: 3pt, y: 2pt))[#c("balance: 0  holder: 'Jim'")]
      ]),
    ),
  )
  #py(```
  class Account:
      interest = 0.02   # class attribute: shared
      def ⟦__init__⟧(self, account_holder):
  ```)
  #upnote(8 * CH * 1pt + 6pt, 115pt)[#c("__init__") is called a #sub[constructor]]
  #py(```
          self.balance = 0    # instance attributes:
          self.holder = account_holder  # one per object
      def deposit(⟦self⟧, amount):
  ```)
  #upnote(16 * CH * 1pt - 5.5pt, 172pt, off: 47pt)[#kg("self") should always be bound to an instance of the #c("Account") class or a subclass of #c("Account")]
  #py(```
          self.balance = self.balance + amount
          return self.balance
      def withdraw(self, amount):
          if amount > self.balance:
              return 'Insufficient funds'
          self.balance = self.balance - amount
          return self.balance
  ```)
  #grid(columns: (auto, 1fr), column-gutter: 7pt, row-gutter: 1.5pt, align: horizon,
    py(```
    >>> type(Account.deposit)
    <class 'function'>
    >>> type(a.deposit)
    <class 'method'>
    ```),
    note(tail: left)[Looked up by the class: a plain #sub[function]. Looked up by an instance: a #sub[bound method]],
    py(```
    >>> Account.deposit(a, 10)
    10
    ```),
    note(tail: left)[#sub[Function call:] all arguments within parentheses],
    py(```
    >>> a.deposit(2)
    12
    ```),
    note(tail: left)[#sub[Method invocation:] one object before the dot, other arguments within parentheses],
    py(```
    >>> f = a.deposit
    >>> f(10)
    22
    >>> a.balance
    22
    ```),
    [],
  )
]

#sec[Class vs. Instance Attributes][
  Assigning to #ph("<expression>")#c(".")#ph("<name>") sets an attribute on that object: on an #sub[instance], an instance attribute#[;] on a #sub[class], a class attribute.
  #two(cols: (1fr, 1fr))[
    #py(```
    >>> jim = Account('Jim')
    >>> tom = Account('Tom')
    >>> tom.interest
    0.02
    >>> Account.interest = 0.04
    >>> tom.interest
    0.04
    >>> jim.interest
    0.04
    ```)
  ][
    #py(```
    >>> jim.interest = 0.08
    >>> jim.interest
    0.08
    >>> tom.interest
    0.04
    >>> Account.interest = 0.05
    >>> tom.interest
    0.05
    >>> jim.interest
    0.08
    ```)
  ]
  #grid(columns: (80pt, 1fr, 1fr), column-gutter: 3pt,
    box(stroke: 0.4pt, inset: 2pt, width: 100%)[#text(fill: GREY)[Account (class)] \ interest: #strike(stroke: 0.6pt + rgb("#e8321e"))[0.02] #strike(stroke: 0.6pt + rgb("#e8321e"))[0.04] 0.05],
    box(stroke: 0.4pt, inset: 2pt, width: 100%)[#text(fill: GREY)[jim (instance)] \ balance: 0 \ interest: 0.08],
    box(stroke: 0.4pt, inset: 2pt, width: 100%)[#text(fill: GREY)[tom (instance)] \ balance: 0],
  )
]

// =========================== INHERITANCE ===========================
#sec[Inheritance][
  A #sub[subclass] inherits all attributes of its #sub[base class] and can #sub[override] some. Use it for #sub[is-a] relationships (a checking account #emph[is an] account).
  #py(```
  class CheckingAccount(⟦Account⟧):
      """A bank account that charges for withdrawals."""
      withdraw_fee = 1
      interest = 0.01
      def withdraw(self, amount):
          return ⟦super()⟧.withdraw(amount + self.withdraw_fee)
  ```)
  #box(width: 100%, fill: CFILL, inset: 3pt, radius: 2pt)[
    #sub[#c("super()") = "the parent class's version, bound to #c("self")".] Inside #kg("CheckingAccount.withdraw"), #kg("super().withdraw(x)") skips #kg("CheckingAccount") and looks #kg("withdraw") up starting in #kg("Account"), so the #sub[original] behavior is used. #kg("self") is passed automatically.
    - Same as #kg("Account.withdraw(self, x)").
    - *Not* #kg("self.withdraw(x)")\; that finds #kg("CheckingAccount.withdraw") which results in infinite recursion.
    - Write #kg("self.withdraw_fee"), not #kg("CheckingAccount.withdraw_fee"), so a subclass or instance can override the fee.
    - A subclass #kg("__init__") #sub[overrides] the parent's#[;] call #kg("super().__init__(...)") to also run the parent's setup.
  ]
  #py(```
  >>> ch = CheckingAccount('Tom')  # Account.__init__
  >>> ch.interest     # Found in CheckingAccount
  0.01
  >>> ch.deposit(20)  # Found in Account
  20
  >>> ch.withdraw(5)  # Found in CheckingAccount
  14
  ```)
  #box(width: 100%, fill: rgb("#fff4d6"), stroke: 0.6pt + rgb("#d9a400"), inset: 3pt, radius: 2pt)[
    #sub[Looking up #c("obj.name"):]
    + Evaluate #kg("obj") to get an object.
    + If #kg("name") is an #sub[instance attribute] of that object, use it.
    + Otherwise look in the object's #sub[class], then its #sub[base class], then that class's base class, and so on.
    + Not found anywhere: #kg("AttributeError").

    If an attribute is found in the class and is a function, you get a #sub[bound method].

    #kg("obj.name = v") always sets the attribute #kg("name") on #kg("obj").
  ]
]

// ============================ EFFICIENCY ===========================
#sec(last: true)[Memoization][
  Save each result (e.g. in a dict keyed by the argument) so a repeated call is just a lookup instead of being recomputed. A memoized tree-recursive #kg("fib") computes each #c("fib(k)") only once.
]
  ],
)
