# Language basics and relative geometry

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
