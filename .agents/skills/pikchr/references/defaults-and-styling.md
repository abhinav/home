# Defaults and styling

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
