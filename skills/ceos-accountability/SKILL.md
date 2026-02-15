---
name: ceos-accountability
description: Use when viewing, updating, or auditing the Accountability Chart — seats, owners, and roles
file-access: [data/accountability.md, templates/accountability.md, data/people/]
tools-used: [Read, Write, Glob, Edit]
---

# ceos-accountability

Manage the Accountability Chart — the organizational structure that defines who owns what seat, what each seat's 5 key responsibilities are, and the reporting hierarchy. Every function of the business has one clear owner. A person can own multiple seats, but every seat needs exactly one owner.

## When to Use

- "Show the accountability chart" or "who owns what?"
- "Update the org chart" or "change seat ownership"
- "Add a new seat" or "we need a VP of Product"
- "Remove a seat" or "consolidate these roles"
- "Audit the accountability chart" or "check for gaps"
- "Who reports to whom?" or "show the structure"
- "How many seats does [person] own?"
- "Are there any empty seats?" or "what roles are unfilled?"
- "Update roles for [seat]" or "change responsibilities"
- Any discussion about organizational structure, seat ownership, or role definition

## Context

### Finding the CEOS Repository

Search upward from the current directory for the `.ceos` marker file. This file marks the root of the CEOS repository.

If `.ceos` is not found, stop and tell the user: "Not in a CEOS repository. Clone your CEOS repo and run setup.sh first."

**Sync before use:** Once you find the CEOS root, run `git -C <ceos_root> pull --ff-only --quiet 2>/dev/null` to get the latest data from teammates. If it fails (conflict or offline), continue silently with local data.

### Key Files

| File | Purpose |
|------|---------|
| `data/accountability.md` | The Accountability Chart (source of truth) |
| `templates/accountability.md` | Template for new charts (used by `setup.sh init`) |
| `data/people/` | Person evaluation files (cross-reference for Audit) |

### Accountability Chart Structure

The chart is a single markdown file (`data/accountability.md`) with this structure:

- **Company heading:** `## CompanyName` at the top with a `*Last updated: YYYY-MM-DD*` line
- **How to Use section:** Instructions block (preserved during edits)
- **Seats:** Each seat is a `## SeatName` heading followed by:
  - `**Owner:** PersonName` (or `[Name]` if unfilled)
  - A roles table with exactly 5 numbered rows

**Example seat:**

```markdown
## VP of Sales

**Owner:** Mike Torres

| # | Role |
|---|------|
| 1 | Revenue — hit quarterly sales targets |
| 2 | Pipeline — maintain 3x pipeline coverage |
| 3 | Team — recruit, coach, and retain sales reps |
| 4 | Process — define and enforce the sales playbook |
| 5 | Reporting — weekly forecast and funnel metrics |
```

**Hierarchy** is implicit from the order of seats in the file. The Visionary and Integrator appear first (top of org), followed by functional seats (Sales, Ops, Finance, etc.).

**Template placeholders:** `[Name]` for empty owner, `[Key responsibility]` for undefined roles.

## Process

### Mode: View

When the user asks to see the accountability chart or check seat ownership.

#### Step 1: Read the Chart

Read `data/accountability.md`. If the file doesn't exist: "No accountability chart found. Run `./setup.sh init` to create one from the template, or create `data/accountability.md` manually."

#### Step 2: Parse Seats

Walk through the file and extract each seat:
- **Title:** The `## SeatName` heading text
- **Owner:** The name after `**Owner:**` (or "empty" if `[Name]`)
- **Roles:** The numbered entries in the roles table
- **Role count:** How many non-placeholder roles are defined

#### Step 3: Display the Chart

Show the chart in a clear hierarchical format:

```
Accountability Chart — Acme Corp
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Last updated: 2026-02-01

  Visionary                Brad Feld         5/5 roles
  Integrator               Sarah Chen        5/5 roles
  ├── VP of Sales          Mike Torres       5/5 roles
  ├── VP of Operations     Daniel Kim        5/5 roles
  └── VP of Finance        (empty)           0/5 roles
```

If the user asks for detail, show each seat with its full role table.

#### Step 4: Summary Stats

```
Summary: 5 seats | 4 filled | 1 empty | avg 4.0 roles per seat
```

---

### Mode: Update

When the user wants to modify the accountability chart — add, change, or remove seats.

#### Sub-mode: Add Seat

##### Step 1: Collect Seat Information

Ask for:

1. **Title** — "What's the seat title?" (e.g., "VP of Product")
2. **Owner** — "Who owns this seat?" (one person, or leave empty for a gap to fill)
3. **Five roles** — "What are the 5 key responsibilities for this seat?"
4. **Position** — "Where in the hierarchy? Under which seat, or at the leadership level?"

##### Step 2: Validate

- **Title required.** If empty, ask again.
- **5 roles recommended.** If fewer than 5, warn: "EOS recommends exactly 5 roles per seat. You have [N]. Want to add more, or save as-is?"
- **Check for duplicate title.** If a seat with the same title already exists: "A seat called '[Title]' already exists. Did you mean to modify it instead?"

##### Step 3: Show the Addition

Display the new seat in the correct format:

```markdown
## VP of Product

**Owner:** [Collected name or [Name]]

| # | Role |
|---|------|
| 1 | [Role 1] |
| 2 | [Role 2] |
| 3 | [Role 3] |
| 4 | [Role 4] |
| 5 | [Role 5] |
```

Ask: "Add this seat to the accountability chart?"

##### Step 4: Write

Insert the new seat at the correct position in `data/accountability.md`. Add a `---` separator before the new seat. Update the `*Last updated:*` date to today.

#### Sub-mode: Modify Seat

##### Step 1: Select the Seat

Show the current chart (list seats with owners). Ask: "Which seat do you want to modify?"

Accept by title or owner name.

##### Step 2: Show Current State

Display the seat's current title, owner, and all 5 roles.

##### Step 3: Collect Changes

Ask what to change:
- **Owner** — "Change the owner?"
- **Roles** — "Update any roles?" (show numbered list, let user update by number)
- **Title** — "Rename the seat?"

##### Step 4: Show Diff

Display the before and after:

```
Modifying: VP of Sales
━━━━━━━━━━━━━━━━━━━━━

Owner: Mike Torres → Sarah Chen

Roles changed:
  3. (was) Team — recruit, coach, and retain sales reps
  3. (now) Team — recruit and develop account executives
```

Ask: "Apply these changes?"

##### Step 5: Write

Update the seat in `data/accountability.md`. Update the `*Last updated:*` date to today.

#### Sub-mode: Remove Seat

##### Step 1: Select the Seat

Show the current chart. Ask: "Which seat do you want to remove?"

##### Step 2: Confirm

Show the seat being removed with all its details. Warn:

"Removing a seat means this function will no longer have a dedicated owner. Are you sure?"

If the seat has an owner: "The owner ([person]) will no longer be assigned to this seat. They may need to be assigned to another seat or evaluated."

##### Step 3: Write

Remove the seat section from `data/accountability.md`. Update the `*Last updated:*` date to today.

**Always show the complete diff before writing any changes in Update mode.**

---

### Mode: Audit

When the user wants to check the chart for structural issues, stale data, or mismatches with People Analyzer data.

#### Step 1: Structural Checks

Read `data/accountability.md` and check each seat for:

| Check | Pass | Fail |
|-------|------|------|
| Has an owner | Owner name present | `[Name]` or blank |
| Has 5 roles | Exactly 5 non-placeholder entries | Fewer or more than 5 |
| No placeholders | All roles have real text | Contains `[Key responsibility]` |
| Last updated date | Within 180 days | Older than 180 days |

#### Step 2: Cross-Reference with People Directory

Read all files in `data/people/` and compare:

- **Owner in chart but no person file:** Flag: "[Owner] is listed in accountability.md but has no evaluation file in `data/people/`. Create one?"
- **Person file references a seat not in the chart:** Flag: "[Person]'s file says seat: '[Seat]' but no such seat exists in accountability.md."
- **Name mismatch (fuzzy):** Flag: "Owner 'Mike' in accountability.md may be 'Mike Torres' in `data/people/mike-torres.md`. Confirm match?"

Name matching should be case-insensitive and match on first name if the full name matches a person file.

#### Step 3: Multi-Seat and Empty Seat Detection

- **Person owns multiple seats:** Note (not an error — common in small companies): "[Person] owns [N] seats: [list]. Ensure they have capacity."
- **Empty seats:** Flag: "[Seat Name] has no owner. This is a gap — hire or reassign."

#### Step 4: Display Audit Report

```
Accountability Chart Audit
━━━━━━━━━━━━━━━━━━━━━━━━━━

Seat Checks:
| Seat           | Owner         | Roles | Placeholders | Status |
|----------------|---------------|-------|-------------|--------|
| Visionary      | Brad Feld     | 5/5   | None        | ✅     |
| Integrator     | Sarah Chen    | 5/5   | None        | ✅     |
| VP Sales       | Mike Torres   | 5/5   | None        | ✅     |
| Operations     | (empty)       | 3/5   | 2 remaining | 🔴     |
| Finance        | (empty)       | 0/5   | 5 remaining | 🔴     |

Cross-Reference:
  ⚠️  Mike Torres has no person file — create data/people/mike-torres.md?
  ⚠️  Operations seat is empty — hiring gap or reassignment needed

Multi-Seat Check:
  Brad Feld owns 1 seat (Visionary)
  Sarah Chen owns 1 seat (Integrator)
  Mike Torres owns 1 seat (VP Sales)

Chart Freshness:
  ✅ Last updated 14 days ago (within 180-day threshold)

Overall: 3/5 seats fully defined | 2 empty seats | 1 person missing evaluation
```

#### Step 5: Suggest Fixes

For each issue found, suggest an action:

- **Empty seat:** "Run Update mode to assign an owner or remove the seat."
- **Missing roles:** "Run Update mode to define all 5 roles for [Seat]."
- **Missing person file:** "Run `ceos-people` Evaluate mode for [Person]."
- **Stale chart:** "Run Update mode to refresh. Last updated [N] days ago."
- **Name mismatch:** "Update accountability.md to use the full name, or update the person file."

## Output Format

**View:** Hierarchical chart display with seat titles, owners, and role counts. Summary stats at the bottom.

**Update:** Before/after diff for modifications. Complete seat preview for additions. Confirmation prompt before every write.

**Audit:** Table with per-seat status flags. Cross-reference results. Multi-seat ownership summary. Suggested fixes for each issue found.

## Guardrails

- **Always show diff before writing.** Never modify `data/accountability.md` without showing the complete change and getting approval. This is the most important rule — the accountability chart affects everyone in the company.
- **5 roles per seat (recommended, not enforced).** EOS methodology says exactly 5 roles per seat. Warn if fewer or more than 5, but allow the user to proceed after acknowledging. Some companies are still defining roles.
- **One owner per seat.** Every seat has exactly one person's name — not "the team", not two names. If multiple people share a function, split it into separate seats.
- **Don't modify other files.** This skill writes to `data/accountability.md` only. It reads from `data/people/` for Audit, but never writes to people files. Suggest running `ceos-people` instead.
- **Update the last-updated date.** Every time `data/accountability.md` is modified, update the `*Last updated: YYYY-MM-DD*` line at the top of the file to today's date.
- **Don't auto-invoke other skills.** Mention `ceos-people`, `ceos-quarterly`, and `ceos-annual` when relevant, but let the user decide when to switch workflows.
- **Sensitive data warning.** On first use, remind the user: "The Accountability Chart may contain sensitive organizational data. Use a private repo."
- **Preserve file structure.** When editing, keep the `## How to Use This Chart` section and all `---` separators intact. Only modify seat sections.

## Integration Notes

### People Analyzer (ceos-people)

- **Read:** `ceos-people` reads `data/accountability.md` to determine which seat a person occupies during GWC evaluation. The `seat:` field in person files should match a seat title from the chart.
- **Audit cross-reference:** `ceos-accountability` Audit mode reads `data/people/` to detect mismatches between seat owners and person files. It does not write to people files.
- **Suggested flow:** If Audit detects a missing person file, suggest: "Run `ceos-people` Evaluate mode for [Person]."

### Quarterly Conversations (ceos-quarterly)

- **Read:** `ceos-quarterly` uses the accountability chart to understand reporting relationships — who reports to whom determines which conversations need to happen.
- **Suggested flow:** Before running quarterly conversations, run `ceos-accountability` Audit to ensure the chart is current and seats are correctly assigned.

### Annual Planning (ceos-annual)

- **Read:** `ceos-annual` references the accountability chart during the organizational checkup — a key step where the leadership team reviews the chart top-to-bottom.
- **Suggested flow:** During Annual Planning, the team should review and update the accountability chart using `ceos-accountability` Update mode before setting next year's Rocks.

### Read-Only Principle

Other skills (`ceos-people`, `ceos-quarterly`, `ceos-annual`, `ceos-l10`) read `data/accountability.md` for reference. **Only `ceos-accountability` writes to this file.** This preserves a single source of truth for organizational structure changes.
