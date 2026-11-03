# Updating guidance

Locate the rule, pointer, example, reference, and tests that govern the affected
decision before editing.
Use local authority and the user's requested outcome to establish what must remain.
Existing wording is evidence of intent, not a reason to preserve repetition.

## Compact an existing package

Read the complete body and routed references; inspect other resources they use.
Work from structure to wording:

1. Recover the distinct decisions and their conditions, obligations, exceptions,
   and completion criteria.
   Separate shared requirements from detail needed only for particular tasks.
2. Organize around those decisions, regardless of the original section structure.
   Consolidate repeated inventories, explanations, and checks into one governing home.
   Use condition/action mappings for alternatives and examples for syntax.
   Keep a unified workflow together when splitting it only adds required reads.
3. Shorten wording, then audit from source to rewrite.
   Locate each required decision, including discovery descriptions and routing,
   and compare its actor, action, scope, timing, and logical force:
   possibility, preference, permission, or obligation.
   Include conditions inherited from headings, list introductions, and table labels.

Keep plain grammar and relationships; dense shorthand can cost more understanding
than it saves tokens.
Leave already economical guidance alone.

Illustrative consolidation:

```diff
-Before publication, obtain user authorization.
-For an authorized publication, run `release publish`.
-Completion checklist: authorization received; remote release ready.
+After user authorization, run `release publish`.
+Confirm the remote release is ready before reporting completion.
```

The repeated authorization becomes one condition;
the separate completion condition remains explicit.

## Repair a behavioral defect

Distinguish:

```text
Requirement: the general condition future agents must preserve
Failure: the observed decision that violated it
Adjacent valid case: a nearby decision the repair must still permit
```

Write the requirement into its governing home.
When moving a requirement, include its destination and the route to it
in the same change.
Use the failure to design a test; do not turn incident details into universal policy.
Every new obligation needs support from the user's request, retained valid guidance,
or authoritative evidence independent of a discarded proposal.

| Finding | Repair to try |
| --- | --- |
| Skill is missed or selected too broadly | Adjust the distinct trigger or exclusion; test selection and non-use. |
| Reference is missed or overread | Put its condition and destination at the decision that needs it. |
| Agent knows the ideal artifact but chooses the wrong disposition | State when to create, change, keep, or omit it. |
| Agent cannot choose between valid methods | Add the missing decision criterion or a contrasting example. |
| Agent skips a known requirement | Put the gate and completion check beside the action. |
| Guidance repeats itself or teaches familiar mechanics | Delete or consolidate; compare retained behavior and cost. |
| Output is verbose | Replace narrated syntax with an example; remove repeated reasons and obligations. |
| A required fact changes independently | Route to its maintained source when the operation needs it. |

Preserve valid behavior while removing unnecessary agent-introduced scope,
including any artifacts or visible effects it left behind.
Disclose findings that affect the user's decision when discovered;
workflow order does not justify withholding them.

Use the main skill's comparison, integration, and final-validation workflow.
