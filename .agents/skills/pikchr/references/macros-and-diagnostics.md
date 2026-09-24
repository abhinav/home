# Macros and diagnostics

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
