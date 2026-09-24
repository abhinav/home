# Source order

Source order should let a maintainer form a stable summary
before asking them to descend into detail.
For an operation, that summary is its purpose and input/output boundary.
Once the reader has both, the reader can decide
whether to inspect the implementation or continue to the next contract.
Minimize the scrolling and context switching needed to reach that point.

Identify the primary abstraction or operation
that explains why the surrounding declarations exist.
For a compact contract declaration such as an interface or trait,
place that contract first
and its supporting declarations after it in first-need order.
The reader can absorb the contract and its related records
without scrolling through implementation.

For a function or method whose body would otherwise
separate the operation from its request and result records,
place its request and result records immediately before the implementation.
That order lets the reader absorb the inputs and outputs
before scrolling through the body.
When a compact implementation keeps its boundary and records visible together,
place the implementation first
and its request and result records after it in first-need order.
Place other supporting declarations after the primary code in first-need order.

Do not treat a name appearing in a signature, field, or bound
as a source-order prerequisite.
Do not choose an order from declaration category or reference direction alone.
An actual language, compiler, generator, or other tool constraint
may further restrict the order.

Check that a maintainer can see the purpose and input/output boundary
without first scrolling through an unexplained support inventory
or an implementation body.
