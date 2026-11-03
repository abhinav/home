# Language basics and relative geometry

## Evaluation model

Pikchr evaluates once in source order: statements reference earlier objects, not later ones.
Defaults, directions, and variable assignments affect subsequent statements.

An unescaped newline or `;` ends a statement.
A backslash followed by whitespace and a newline continues the statement.
Comments are `#`, `//`, or `/* ... */`.

Strings use double quotes; escape only `"` and backslash with backslash.
No other string escapes are recognized; newlines are allowed.

Numbers are decimal integers, floating point, or `0x` hexadecimal integers.
Distances default to inches; explicit units are `in`, `cm`, `mm`, `px`, `pt`, and `pc`,
without whitespace between number and unit.

## Statements and objects

A script is a statement list:

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

`same` copies the previous same-class object.
`same as Object` copies an explicit prior object, possibly of another class.
Prefer same-class copies; after cross-class copies, reset class-specific geometry
such as a circle's radius.

`fit` sizes positioned objects around text attributes preceding `fit` on the same object.
Non-positive width or height also enables fitting on that axis.
Text estimates use `charwid` and `charht`.

## Labels, references, and geometry

Labels start with an uppercase ASCII letter;
remaining characters may be ASCII letters, digits, or underscores.
Give important objects stable labels:

```pikchr
Gateway: box "API gateway" fit
Exit: Gateway.e
```

Reference objects by label or relative occurrence:

```pikchr
Gateway
previous
last box
2nd box
2nd previous box
```

Qualify labels inside labeled containers:

```pikchr
Cluster.Worker
```

Anchors are `.n`, `.ne`, `.e`, `.se`, `.s`, `.sw`, `.w`, `.nw`, and `.c`.
Long aliases include `.top`, `.right`, `.bottom`, `.left`, and `.center`.
`.start` and `.end` depend on the active direction.

Numeric geometry includes:

- A place's `.x` and `.y`.
- An object's `.width`/`.wid`, `.height`/`.ht`,
  `.radius`/`.rad`/`.diameter`, `.thickness`,
  `.color`, `.fill`, `.dashed`, and `.dotted`.
- A path's ordinal vertices, such as `3rd vertex of Route`.

## Direction and relative positioning

Direction starts as `right`; change it with `right`, `down`, `left`, or `up`.
The first automatically placed positioned object centers at `(0,0)`;
later automatically placed ones follow the previous object's `.end`.

| Direction | `.start` | `.end` |
| --- | --- | --- |
| `right` | `.w` | `.e` |
| `down` | `.n` | `.s` |
| `left` | `.e` | `.w` |
| `up` | `.s` | `.n` |

Changing direction also updates the previous object's `.end`.
Use explicit anchors when that stateful behavior would surprise.

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

Verbose forms such as `1/2 of the way between A and B` equal `1/2<A,B>`.

## Paths and routing

Paths are `line`, `arrow`, `spline`, `arc`, and invisible `move`.
Without `from`, start at the previous object's `.end` or `(0,0)`.
Default length is `linewid` horizontally or `lineht` vertically.

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

Text on multi-segment paths centers around their bounding box.
For a label on one segment, use separate text or an invisible overlay line there.
