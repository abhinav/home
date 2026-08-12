# Pikchr language reference

Use this as a working reference while writing Pikchr.
It emphasizes the language features that make diagrams relative,
self-sizing, and easy to revise.

## Contents

- [Evaluation model](#evaluation-model)
- [Statements and objects](#statements-and-objects)
- [Diagram-wide defaults](#diagram-wide-defaults)
- [Labels, references, and geometry](#labels-references-and-geometry)
- [Direction and relative positioning](#direction-and-relative-positioning)
- [Paths and routing](#paths-and-routing)
- [Dimensions, style, and text](#dimensions-style-and-text)
- [Containers and drawing order](#containers-and-drawing-order)
- [Variables, expressions, macros, and diagnostics](#variables-expressions-macros-and-diagnostics)

## Evaluation model

Pikchr evaluates statements once, in source order.
A statement can refer to an object already created, not a later object.
Defaults, direction changes, and variable assignments affect subsequent
statements.

An unescaped newline or `;` ends a statement.
A backslash followed by whitespace and a newline continues the statement.
Comments are `#`, `//`, or `/* ... */`.

Strings use double quotes.
Inside a string, escape only `"` and backslash with backslash.
Pikchr recognizes no other string escape sequences; newlines are allowed.

Numeric literals can be decimal integers, floating point numbers,
or hexadecimal integers beginning with `0x`.
A distance without a unit is measured in inches.
Explicit units are `in`, `cm`, `mm`, `px`, `pt`, and `pc`,
with no whitespace between the number and unit.

## Statements and objects

A script is a statement list.
The important statement forms are:

```pikchr
Object: box "text" fit       # labeled object definition
Point: Object.e              # labeled place
right                        # active direction
$gap = 0.35in                # variable assignment
define name { ... }          # macro definition
print "gap=", $gap           # diagnostic output
assert(Object.e == Point)    # equality assertion
```

Object classes:

- Positioned objects:
  `box`, `circle`, `cylinder`, `diamond`, `dot`, `ellipse`, `file`,
  `oval`, and `text`.
- Path objects:
  `arc`, `arrow`, `line`, `move`, and `spline`.
- A bare string creates a text object.
- `[ ... ]` creates a container object around an inner statement list.

`move` is an invisible line that advances the current position.

Attributes follow an object definition and may set position, size, path,
stroke, fill, text, or drawing order.

`same` copies the previous object of the same class.
`same as Object` copies an explicit prior object,
including one of another class.
Prefer same-class copies.
After a cross-class copy,
reset class-specific geometry such as a circle's radius.

`fit` sizes a positioned object around text attributes that precede `fit`
on the same object.
A non-positive width or height also enables fitting on that axis.
Pikchr estimates text dimensions from `charwid` and `charht`.

## Diagram-wide defaults

Built-in variables are the diagram's shared defaults.
Set coherent defaults near the beginning,
then use per-object attributes for semantic exceptions.
Because evaluation is single-pass,
a later assignment changes only later objects.

This is a valid diagram prologue:

```pikchr
scale = 0.9
fontscale = 1.05
margin = 0.08in

boxwid = 1.05in
boxht = 0.55in
boxrad = 5px
linewid = 0.55in

color = 0x24324a
fill = white
thickness = 1.2px
```

### Whole-diagram controls

| Variable | Effect |
| --- | --- |
| `scale` | Drawing scale multiplier; larger is bigger. |
| `fontscale` | Text-size multiplier. |
| `margin` | Extra border on all four sides. |
| `topmargin`, `rightmargin`, `bottommargin`, `leftmargin` | Extra border on one side, added to `margin`. |
| `fgcolor` | Foreground color used in place of black. |
| `color` | Default stroke and text color. |
| `fill` | Default fill; a negative value means transparent. |
| `thickness` | Default stroke thickness. |
| `layer` | Default layer for subsequent objects. |

### Object geometry defaults

| Object | Variables |
| --- | --- |
| Box | `boxwid`, `boxht`, `boxrad` |
| Circle | `circlerad` |
| Cylinder | `cylwid`, `cylht`, `cylrad` |
| Diamond | `diamondwid`, `diamondht` |
| Dot | `dotrad` |
| Ellipse | `ellipsewid`, `ellipseht` |
| File | `filewid`, `fileht`, `filerad` |
| Oval | `ovalwid`, `ovalht` |
| Arc | `arcrad` |

### Paths, arrows, and text fitting

| Variables | Effect |
| --- | --- |
| `linewid`, `lineht` | Default horizontal and vertical path lengths. |
| `linerad` | Default radius for rounded line corners. |
| `movewid` | Default distance for `move`. |
| `arrowwid`, `arrowht` | Arrowhead width and length. |
| `dashwid` | Default dash length. |
| `charwid`, `charht` | Character-size estimates used by fitting. |

`arrowhead`, `textht`, and `textwid` exist for legacy compatibility
but are not used by Pikchr.

`color`, `fill`, and `thickness` are also keywords.
Assignment is unambiguous, but parenthesize one when reading it in an
expression:

```pikchr
box "Emphasis" thickness 2*(thickness)
```

## Labels, references, and geometry

A label begins with an uppercase ASCII letter;
the remaining characters may be ASCII letters, digits, or underscores.
Give semantically important objects stable labels:

```pikchr
Gateway: box "API gateway" fit
Exit: Gateway.e
```

Reference an object by label or by relative occurrence:

```pikchr
Gateway
previous
last box
2nd box
2nd previous box
```

For an object inside a labeled container, qualify the inner label:

```pikchr
Cluster.Worker
```

Anchors are `.n`, `.ne`, `.e`, `.se`, `.s`, `.sw`, `.w`, `.nw`, and `.c`.
Long aliases such as `.top`, `.right`, `.bottom`, `.left`, and `.center`
are also accepted.
`.start` and `.end` depend on the active direction.

Numeric geometry includes:

- A place's `.x` and `.y`.
- An object's `.width`/`.wid`, `.height`/`.ht`,
  `.radius`/`.rad`/`.diameter`, `.thickness`,
  `.color`, `.fill`, `.dashed`, and `.dotted`.
- A path's ordinal vertices, such as `3rd vertex of Route`.

## Direction and relative positioning

The active direction is `right` initially.
Change it with `right`, `down`, `left`, or `up`.
The first automatically placed positioned object is centered at `(0,0)`;
later ones follow the previous object's `.end`.

| Direction | `.start` | `.end` |
| --- | --- | --- |
| `right` | `.w` | `.e` |
| `down` | `.n` | `.s` |
| `left` | `.e` | `.w` |
| `up` | `.s` | `.n` |

A direction change also updates the previous object's `.end`
for the new direction.
Use an explicit anchor when that stateful behavior would be surprising.

`at Position` places an object's center.
`with .anchor at Position` places a selected anchor.

Useful position forms:

```pikchr
Node.e                         # anchor
0.5in below Node.s             # relative displacement
Node + (0.5in, -0.2in)         # Cartesian offset
(Left, Lower)                  # x from Left, y from Lower
1/2<Left.e, Right.w>           # interpolation
0.4in heading 30 from Node     # polar displacement
3rd vertex of Route            # path vertex
```

The verbose interpolation forms,
such as `1/2 of the way between A and B`,
are equivalent to `1/2<A,B>`.

Prefer labels, anchors, projections, interpolation,
and container bounds over canvas coordinates.
Use literal distances for local gaps and padding.

## Paths and routing

Path objects are `line`, `arrow`, `spline`, `arc`, and invisible `move`.
If `from` is omitted,
a path starts at the previous object's `.end` or at `(0,0)`.
A path without explicit length uses `linewid` horizontally
or `lineht` vertically.

Build paths from:

- `from Position`
- `to Position`
- a direction plus optional distance
- a direction `until even with Position`
- `heading Angle` or a compass heading
- `then` or `go`
- `close`

Consecutive direction clauses without `then` combine into one vector
and one segment.
Use `then` when the route needs another segment or addressable vertex:

```pikchr
Source: box "Source"
Sink: box "Sink" at Source + (1.3in, -0.8in)
Route: arrow from Source.e right 0.35in then down until even with Sink then to Sink.w
```

`until even with` projects onto the relevant axis and is useful for
orthogonal routing.
`chop` shortens center-to-center paths where they meet positioned objects.
`<-`, `->`, and `<->` set arrowheads.
`rad` rounds line corners.
`cw` and `ccw` select an arc's direction.
`close` returns a path to its first vertex and allows it to act as a filled
polygon.

Text attached to a multi-segment path is positioned around the path's
bounding-box center.
When a label belongs to one segment,
place a separate text object or an invisible overlay line on that segment.

## Dimensions, style, and text

Numeric properties are:

- `width`/`wid`
- `height`/`ht`
- `radius`/`rad`/`diameter`
- `thickness`

A value followed by `%` scales the property's previous value.
Radius has object-specific meaning:
rounded corners for boxes, end-cap shape for cylinders,
and fold size for files.
For circles, width, height, diameter, and radius are coupled.
Ellipses and ovals ignore radius; diamonds currently ignore it.

Stroke and fill attributes:

```pikchr
thickness 1.2px
thick
thin
solid
dashed
dashed 0.08in
dotted
invisible
color 0x345995
fill AliceBlue
```

Colors are 24-bit RGB integers or HTML/CSS color names,
case-insensitively.
`None`, `Off`, and any negative fill value mean transparent.
`invisible` removes the stroke but does not necessarily hide attached text;
`solid` restores a solid visible stroke.

An object can carry up to five text annotations.
Text attributes are `above`, `aligned`, `below`, `big`, `bold`, `center`,
`italic`, `ljust`, `mono`/`monospace`, `rjust`, and `small`.
`aligned` rotates text to follow a line.

## Containers and drawing order

`[ ... ]` evaluates its inner statements and exposes their bounding box
as one outer object.
Use containers for a group that should move, align, or resize as a unit:

```pikchr
Workers: [
  A: box "Worker A" fit
  move down 0.18in
  B: box "Worker B" fit
]

arrow from Workers.A.e to Workers.B.e
```

The outer object accepts placement attributes such as `at` and `with`.
The container itself is invisible.
Create a separate object for a visible border, background, or caption,
deriving its geometry from the container:

```pikchr
Frame: box width Workers.width+0.2in height Workers.height+0.2in at Workers.c behind Workers
"Workers" small at 0.12in above Workers.n
```

Inner object labels are scoped through the container.
Direction and variable changes inside a container remain active afterward;
restore them explicitly when needed.

Objects normally paint in source order.
`behind PriorObject` makes a later statement paint behind the named earlier
object.
Use it for backgrounds that must derive their size from foreground objects.
The special `layer` variable changes the default layer of subsequent objects.

## Variables, expressions, macros, and diagnostics

A variable begins with a lowercase ASCII letter, `$`, or `@`;
remaining characters may be ASCII letters, digits, or underscores.
An initial underscore is not part of the documented grammar.
The `$` and `@` prefixes are useful for avoiding keyword collisions.

Assignment operators are `=`, `+=`, `-=`, `*=`, and `/=`.
Expressions support arithmetic, unary `+` and `-`,
and `abs`, `cos`, `dist`, `int`, `max`, `min`, `sin`, and `sqrt`.

Macros are lexical source substitution:

```pikchr
$stagewid = 1.1in
$stageht = 0.55in

define stage { box wid $stagewid \
  ht $stageht $1 }

Input: stage("Input") with .w at (0,0)
```

There must be no whitespace between a macro name and `(`.
At most nine arguments are substituted as `$1` through `$9`;
missing arguments are omitted.
Because expansion happens before parsing,
unescaped newlines in the macro body remain statement terminators.
When an invocation participates in surrounding syntax,
such as `Input: stage(...) with .w at Position`,
make the expansion begin and end with syntax tokens rather than newlines.
Keep the body on one physical line,
or put its first token after `{` and its last token before `}`
while escaping internal line breaks.
Newlines remain valid when a macro deliberately expands to complete statements
and the invocation stands at a statement boundary.
Macros reduce repeated syntax,
but labels, anchors, and containers should still express geometry.

`print` writes expressions or strings before the generated SVG.
`assert(A == B)` accepts scalar expressions or positions and fails when the
two sides differ.
Use these for diagnostics,
not in source intended to be emitted directly as clean SVG.
