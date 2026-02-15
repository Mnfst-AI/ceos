---
name: ceos-todos
description: Use when tracking, creating, completing, or reviewing To-Dos
file-access: [data/todos/, templates/todo.md]
tools-used: [Read, Write, Glob]
---

# ceos-todos

Track To-Dos — the concrete actions that bridge meetings and execution. Every To-Do has one owner, a due date, and a source. EOS teams target 90%+ weekly completion rate.

## When to Use

- "Show my to-dos" or "what's on my list?"
- "Create a to-do" or "add a to-do for [person]"
- "Mark to-do done" or "complete [to-do]"
- "To-do review" or "how's our completion rate?"
- "What to-dos are overdue?"
- "Open to-dos" or "what needs to get done this week?"
- "To-do list" or "show all to-dos"
- "Weekly to-do report" or "to-do scorecard"
- "New to-do from L10" or "IDS to-do"
- Any time someone commits to a concrete action with a deadline

## Context

### Finding the CEOS Repository

Search upward from the current directory for the `.ceos` marker file. This file marks the root of the CEOS repository.

If `.ceos` is not found, stop and tell the user: "Not in a CEOS repository. Clone your CEOS repo and run setup.sh first."

**Sync before use:** Once you find the CEOS root, run `git -C <ceos_root> pull --ff-only --quiet 2>/dev/null` to get the latest data from teammates. If it fails (conflict or offline), continue silently with local data.

### Key Files

| File | Purpose |
|------|---------|
| `data/todos/` | To-Do files (one file per To-Do) |
| `templates/todo.md` | Template for new To-Do files |

### To-Do File Format

Each To-Do is a markdown file with YAML frontmatter:

```yaml
id: todo-001
title: "Send revised proposal to Acme"
owner: "brad"
due: "2026-02-20"
status: open           # open | complete
source: l10            # l10 | ids | quarterly | adhoc
created: "2026-02-13"
completed_on: ""       # filled when status → complete
```

**Status values:**
- `open` — not yet done
- `complete` — done (binary — no partial credit in EOS)

**Source values:**
- `l10` — created during an L10 meeting
- `ids` — created during IDS issue resolution
- `quarterly` — created during a Quarterly Conversation
- `adhoc` — created outside of a meeting context

**Overdue:** A To-Do is overdue if `status: open` and `due` is before today's date. This is computed when displaying — not stored as a status.

**File naming:** `todo-NNN-slug.md` where NNN is a zero-padded ID and slug is the title slugified (lowercase, hyphens, no special characters).

## Process

### Mode: List

When the user asks to see their To-Dos or check what's open.

#### Step 1: Read All To-Dos

Read all files in `data/todos/`. Parse the YAML frontmatter for each file.

If the directory doesn't exist or is empty: "No To-Dos yet. Use this skill to create one, or they'll be created during L10 meetings and IDS sessions."

#### Step 2: Filter

By default, show only `status: open` To-Dos. If the user asks for "all to-dos" or "show completed", include `status: complete` as well.

#### Step 3: Compute Overdue

For each open To-Do, compare `due` to today's date:
- If `due` < today: mark as overdue, calculate days overdue
- If `due` is today: mark as "due today"
- If `due` is in the future: show days remaining

Flag To-Dos that are 30+ days overdue with a warning — these should be discussed in the next L10 (drop them or recommit with a new deadline).

#### Step 4: Display

Group by owner, sorted by due date within each group:

```
Open To-Dos (7 total, 2 overdue)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Brad (3 to-dos):
  todo-003  Send revised proposal      due: Feb 20    3 days left
  todo-007  Review hiring pipeline     due: Feb 18    1 day left
  todo-001  Update onboarding doc      due: Feb 10    ⚠️ 4 days overdue

Daniel (2 to-dos):
  todo-005  Fix dashboard report       due: Feb 22    8 days left
  todo-004  Schedule vendor call       due: Feb 15    due today

Sarah (2 to-dos):
  todo-006  Draft Q2 budget            due: Feb 28    14 days left
  todo-002  Send partnership agreement due: Feb 12    ⚠️ 2 days overdue
```

#### Step 5: Summary

Show summary statistics:

```
Summary: 7 open | 2 overdue | 3 owners
```

---

### Mode: Create

When the user wants to add a new To-Do.

#### Step 1: Collect Information

Ask for each field:

1. **Title** — "What needs to be done?" (short, specific, action-oriented)
2. **Owner** — "Who owns this?" (one person — never "the team")
3. **Due date** — "When is this due?" (specific date, usually within 7 days for L10 To-Dos)
4. **Source** — "Where did this come from?" (l10, ids, quarterly, or adhoc)

If the user is creating multiple To-Dos (e.g., from an L10 meeting), collect all of them before writing files.

#### Step 2: Validate

- **Title required.** If empty, ask again.
- **Owner required.** If empty or "the team", explain: "Every To-Do needs one owner — who's accountable?"
- **Due date required.** If empty, explain: "Every To-Do needs a deadline. When is this due?"
- **Due date sanity check.** If more than 14 days out, note: "Most EOS To-Dos are 7-day actions. Is this really a To-Do, or might it be a Rock?"

#### Step 3: Generate the ID

Read existing To-Do files in `data/todos/`. Find the highest `todo-NNN` ID and increment. If no files exist, start at `todo-001`.

Create the directory `data/todos/` if it doesn't exist.

#### Step 4: Slugify the Title

Convert the title to a filename slug:
- Lowercase
- Replace spaces with hyphens
- Remove special characters
- Truncate to 50 characters

#### Step 5: Create the File

Use `templates/todo.md` as the template. Fill in:
- Frontmatter: id, title, owner, due, status=open, source, created=today
- Body: description from the user's input

Show the complete file before writing. Ask: "Create this To-Do?"

#### Step 6: Write

Write to `data/todos/todo-NNN-slug.md`.

#### Step 7: Repeat or Finish

Ask: "Create another To-Do, or done for now?"

When finished, display a summary of all created To-Dos:

```
Created 3 To-Dos:
  todo-008  Send revised proposal      brad     due: Feb 20  [l10]
  todo-009  Fix dashboard report       daniel   due: Feb 22  [l10]
  todo-010  Draft Q2 budget            sarah    due: Feb 28  [l10]
```

---

### Mode: Complete

When the user wants to mark To-Do(s) as done.

#### Step 1: Show Open To-Dos

List all open To-Dos (same as List mode, filtered to `status: open`).

If no open To-Dos exist: "No open To-Dos to complete. Nice work!"

#### Step 2: Select

Ask which To-Do(s) to mark complete. Accept:
- By ID: "todo-003"
- By title match: "the proposal one"
- Multiple: "todo-003 and todo-007"
- All: "all of them" (confirm before proceeding)

#### Step 3: Update Each File

For each selected To-Do:

1. Read the file
2. Update frontmatter:
   - `status: complete`
   - `completed_on: "YYYY-MM-DD"` (today's date)
3. Add a note: `- YYYY-MM-DD: Completed`
4. Show the diff (frontmatter changes + note addition)
5. Ask: "Mark this To-Do complete?"
6. Write the file

#### Step 4: Summary

After completing all selected To-Dos, show:

```
Completed 2 To-Dos:
  ✓ todo-003  Send revised proposal      (was due: Feb 20, completed: Feb 18 — 2 days early)
  ✓ todo-007  Review hiring pipeline     (was due: Feb 18, completed: Feb 18 — on time)

Remaining open: 5
```

---

### Mode: Review

When the user wants to check the team's To-Do completion rate — typically during or after an L10 meeting.

#### Step 1: Determine Time Period

Default to the last 7 days. If the user specifies a range (e.g., "last month", "since January"), adjust accordingly.

#### Step 2: Read All To-Dos

Read all files in `data/todos/`. Categorize:

- **Completed in period**: `status: complete` AND `completed_on` falls within the time range
- **Overdue in period**: `status: open` AND `due` falls within (or before) the time range
- **Still open (future)**: `status: open` AND `due` is after the time range end

#### Step 3: Calculate Completion Rate

```
Completion Rate = Completed / (Completed + Overdue) × 100
```

Only count To-Dos whose `due` date falls within or before the review period. To-Dos with future due dates are not yet countable.

#### Step 4: Display Report

```
To-Do Review — Feb 7-14, 2026
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Completion Rate: 85% (target: 90%+)

Completed (6):
  ✓ todo-001  Update onboarding doc      brad     completed Feb 10
  ✓ todo-002  Send partnership agreement sarah    completed Feb 12
  ✓ todo-004  Schedule vendor call       daniel   completed Feb 15
  ✓ todo-008  Send revised proposal      brad     completed Feb 14
  ✓ todo-009  Fix dashboard report       daniel   completed Feb 13
  ✓ todo-010  Draft Q2 budget            sarah    completed Feb 14

Overdue (1):
  ✗ todo-005  Update pricing page        brad     due Feb 12 (2 days overdue)

Still Open (2 — not yet due):
  • todo-011  Prepare board deck          brad     due Feb 21
  • todo-012  Review vendor contracts     daniel   due Feb 20
```

#### Step 5: Patterns and Flags

Analyze the data for actionable patterns:

- **Below 90% target**: "Completion rate is 85%. Below the 90% EOS target. Consider: are there too many To-Dos, or is the team overcommitted?"
- **Specific owner below average**: "[Person] completed 2/4 (50%). Worth discussing — are they overloaded?"
- **Source patterns**: "4 of 6 overdue To-Dos came from IDS. Are IDS actions being set with realistic timelines?"
- **Chronic overdue (same To-Do overdue 2+ weeks)**: "todo-005 has been overdue for 14 days. Either do it, drop it, or turn it into a Rock."

## Output Format

**List:** Owner-grouped table of open To-Dos with due dates and overdue indicators.
**Create:** Complete To-Do file preview before writing. Summary table after creation.
**Complete:** Diff for each To-Do being completed. Summary with timing (early/on-time/late).
**Review:** Completion rate report with completed, overdue, and still-open sections. Pattern analysis.

## Guardrails

- **Always show diff before writing.** Never create or modify a To-Do file without showing the content and getting approval.
- **Owner required.** Every To-Do has exactly one owner. Not "the team", not "TBD", not blank. If someone won't commit to owning it, it's not a real To-Do.
- **Due date required.** Every To-Do has a deadline. No deadline = no accountability. If the user doesn't specify a date, ask for one.
- **One To-Do per file.** Each To-Do gets its own file in `data/todos/`. Don't combine multiple To-Dos into one file.
- **ID uniqueness.** Always scan all existing files in `data/todos/` before generating a new ID. Never reuse IDs — even if a file was deleted, use the next sequential number.
- **Don't delete To-Do files.** Completed To-Dos stay in `data/todos/` with `status: complete`. They're the audit trail for completion rate analytics.
- **Don't auto-invoke other skills.** Mention `ceos-l10`, `ceos-ids`, and `ceos-quarterly` when relevant, but let the user decide when to switch workflows.
- **Warn on overload.** If one person has 10+ open To-Dos, warn: "That's a lot of open To-Dos. Consider prioritizing or pushing some to a future week."
- **To-Dos vs Rocks.** If a To-Do has a due date more than 14 days out or describes a large initiative, suggest: "This sounds like it might be a Rock rather than a To-Do. Rocks are 90-day priorities managed by `ceos-rocks`."
- **Completion rate only reflects `data/todos/`.** To-Dos embedded in old L10 meeting notes are not counted. The Review mode should note this if the user asks about discrepancies.
- **Source field is immutable.** Once set, don't change the source — it's the audit trail for where the To-Do originated.

## Integration Notes

### L10 Meetings (ceos-l10)

- **Section 5 — To-Do Review**: During L10 meetings, the To-Do Review section should reference `data/todos/` as the source of truth. Use `ceos-todos` List mode to show open To-Dos and Complete mode to mark items done during the meeting.
- **Section 7 — Conclude**: New To-Dos created during the L10 should be tracked via `ceos-todos` Create mode with `source: l10`.

### IDS (ceos-ids)

- When an Issue is solved in `ceos-ids`, the Solve step creates To-Dos with owners and due dates. These should be tracked in `data/todos/` via `ceos-todos` Create mode with `source: ids`.

### Quarterly Conversations (ceos-quarterly)

- Action items from Quarterly Conversations should be created as To-Dos via `ceos-todos` Create mode with `source: quarterly`.

**Important:** These integrations are suggestions, not automatic. The user controls the workflow. During an L10, the facilitator decides when and how to use each skill. Don't auto-create To-Dos — always let the user initiate.
