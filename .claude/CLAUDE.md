Load @~/.claude/CLAUDE.local.md if it exists.

# Styling and formatting prose

## Code comment style

When writing ANY comment in code,
apply these rules automatically:

- Standalone comments MUST be full sentences
  with capital letters and periods
- Inline comments SHOULD be lowercase fragments
- If inline comments become multi-line,
  convert to standalone comments
- Multi-line comments MUST use `//`, never `/* ... */`
- Apply semantic line breaks to long comments
- Explain "why", not "what"
- DELETE comments that don't add value

Language-specific rules:
- Go: Start exported declarations with the item name (GoDoc style)

See the writing-comments skill for detailed examples and guidelines.

## Commit messages and commits

When writing commit messages,
ALWAYS use the writing-commits skill.

When committing changes to the repository,
ALWAYS use the committing-changes skill AFTER writing-commits.
NEVER use `git commit` directly.

## Prose formatting

Apply semantic line breaks formatting when writing Markdown
or other multi-line prose.

Note: Skills are invoked using `Skill(skill-name)` syntax.
The semantic-line-breaks formatting is applied automatically
when the skill is loaded.
