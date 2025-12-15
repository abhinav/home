---
description: Commit changes using git-spice. Handles branch creation, stacking, and amending commits.
---

Use the committing skill exactly as specified.

**Important:**
- If user says "commit to current branch" or "this branch" → Use `gs commit create` directly (no need to check current branch)
- If user says "commit to new branch" or "new feature branch" → Use `gs branch create` directly (no need to check current branch)
- Only check current branch with `git branch --show-current` if user's intent is ambiguous
