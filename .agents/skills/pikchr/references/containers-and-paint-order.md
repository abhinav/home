# Containers and paint order

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
