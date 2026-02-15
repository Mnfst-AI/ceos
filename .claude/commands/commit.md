---
description: Commit work, push to main, and mark Linear ticket Done
disable-model-invocation: true
allowed-tools: Bash, Read, Glob, Grep, mcp__linear__get_issue, mcp__linear__update_issue, mcp__linear__create_comment, mcp__linear__list_comments, mcp__linear__list_issue_labels
---

# Commit Work (CEOS)

Commit to main, push, and update Linear.

**Reference:** `~/.claude/rules/commit-recipe.md` (shared recipe)

**Usage:** `/commit`

**Current status:**

- **Current branch:** !`git branch --show-current`
- **Git status:** !`git status --short`

## What This Command Does

1. **Validates** there are changes to commit
2. **Stages** all changes
3. **Generates** a descriptive commit message
4. **Pushes** to origin main
5. **Updates Linear** ticket status to **Done** and adds progress comment

**CEOS commits directly to main.** There is no staging/production pipeline — commit IS the deploy. This is why the status goes straight to Done.

## Workflow

### Step 1: Pre-flight Validation

```
On main branch?
├─ YES → Continue (CEOS commits to main)
└─ NO → `git checkout main && git merge <branch>` or warn user

Has changes to commit?
├─ YES → Continue
└─ NO → "No changes to commit. Nothing to do."
```

### Step 2: Stage and Commit

1. Stage all changes: `git add .`
2. Review staged changes: `git diff --cached --stat`
3. Extract ticket ID from recent branch or commit context:
   - Look at branch name for `CEO-\d+` pattern
   - If on main, check if changes relate to a known ticket
4. Generate commit message:

```
feat: [Brief description of changes]

- [Key change 1]
- [Key change 2]

Refs CEO-XXX
```

**Note:** Co-author attribution is added automatically by `settings.json` `attribution.commit`. Do not add it manually.

Use HEREDOC for commit message formatting.

### Step 3: Push to Remote

```bash
git push origin main
```

### Step 4: Update Linear (if ticket ID found)

1. **Fetch ticket**:

   ```typescript
   mcp__linear__get_issue({ id: "CEO-XXX" });
   ```

2. **Update status to Done**:
   - If status is "Backlog", "In Progress", or "Todo" → set to **Done**
   - If already "Done" → no change

3. **Apply labels** (merge, don't replace):

   ```typescript
   const existing = issue.labels || [];
   const merged = [...new Set([...existing, ...newLabels])];
   mcp__linear__update_issue({ id: "CEO-XXX", state: "Done", labels: merged });
   ```

4. **Add progress comment**:

   Check for existing implementation plan comment to thread under:

   ```typescript
   const comments = mcp__linear__list_comments({ issueId: "<uuid>" });
   const planComment = comments.find(c => c.body.includes("## Implementation Plan"));

   mcp__linear__create_comment({
     issueId: "<uuid>",
     body: "## Completed\n\n**Commit**: `abc1234`\n\n### Changes\n- [Summary]\n\nCommitted to `main` and pushed.",
     ...(planComment ? { parentId: planComment.id } : {})
   });
   ```

### Step 5: Success Summary

```
Done — CEO-XXX committed and marked Done

Branch: main
Commit: abc1234 - feat: [description]
Pushed: origin/main
Linear: Status → Done, comment added
```

## Pre-commit Hooks

If the repo has pre-commit hooks, fix any failures and re-run `/commit`.

## Error Reference

| Error | Fix |
|-------|-----|
| No changes to commit | Make changes first |
| Push rejected | Run `git pull --ff-only` then retry |
| Linear API error | Check MCP config, verify ticket exists |
