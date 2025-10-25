Load @~/.claude/CLAUDE.local.md if it exists.

# Styling and formatting prose

When writing comments,
ALWAYS use the writing-comments skill.

When writing commit messages,
ALWAYS use the writing-commits skill.

When committing changes to the repository,
ALWAYS use the committing-changes skill AFTER writing-commits.
NEVER use `git commit` directly.

Apply semantic line breaks formatting when writing Markdown
or other multi-line prose.

Note: Skills are invoked using `Skill(skill-name)` syntax.
The semantic-line-breaks formatting is applied automatically
when the skill is loaded.
