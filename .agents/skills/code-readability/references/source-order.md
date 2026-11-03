# Source order

Let maintainers form a stable summary of an operation's purpose and input/output
boundary before choosing to inspect its implementation or continue to the next contract.
Minimize scrolling and context switching to reach that summary.
Identify the primary abstraction or operation explaining the surrounding declarations.

| Primary declaration | Reader order |
| --- | --- |
| Compact contract, such as an interface or trait | Contract first, then supporting declarations in first-need order. |
| Function/method whose body would separate the operation from request/result records | Request/result records immediately before the implementation. |
| Compact implementation keeping its boundary and records visible together | Implementation first, then request/result records in first-need order. |

Put other supporting declarations after the primary code in first-need order.
A name in a signature, field, or bound is not a source-order prerequisite.
Do not choose by declaration category or reference direction alone.
Actual language, compiler, generator, or other tool constraints may restrict the order.

Check that readers can see purpose and inputs/outputs without first scrolling
through an unexplained support inventory or implementation body.
