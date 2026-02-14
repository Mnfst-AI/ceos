---
name: ceos-l10
description: Use when running or reviewing a Level 10 weekly leadership meeting
---

# ceos-l10

Facilitate the Level 10 (L10) Meeting — the weekly 90-minute leadership meeting that keeps the team aligned, accountable, and solving problems. The L10 follows a strict 7-section agenda with time boxes.

## When to Use

- "Run L10" or "start our L10"
- "Level 10 meeting" or "weekly meeting"
- "Start our meeting" or "let's do our weekly"
- "Review last week's L10" or "what were our to-dos?"
- Any weekly leadership team meeting

## Context

### Finding the CEOS Repository

Search upward from the current directory for the `.ceos` marker file. This file marks the root of the CEOS repository.

If `.ceos` is not found, stop and tell the user: "Not in a CEOS repository. Clone your CEOS repo and run setup.sh first."

**Sync before use:** Once you find the CEOS root, run `git -C <ceos_root> pull --ff-only --quiet 2>/dev/null` to get the latest data from teammates. If it fails (conflict or offline), continue silently with local data.

### Key Files

| File | Purpose |
|------|---------|
| `data/meetings/l10/YYYY-MM-DD.md` | L10 meeting notes |
| `data/scorecard/weeks/` | Latest scorecard (pulled during Scorecard section) |
| `data/rocks/[quarter]/` | Current Rocks (pulled during Rock Review) |
| `data/issues/open/` | Open issues (surfaced during IDS section) |
| `data/meetings/l10/` | Previous L10s (for To-Do review) |
| `templates/l10-meeting.md` | Meeting template |

### Meeting Structure (90 minutes)

| # | Section | Time | Purpose |
|---|---------|------|---------|
| 1 | Segue | 5 min | Personal/professional good news |
| 2 | Scorecard | 5 min | Review weekly numbers |
| 3 | Rock Review | 5 min | Status of quarterly Rocks |
| 4 | Headlines | 5 min | Customer and employee news |
| 5 | To-Do Review | 5 min | Check last week's To-Dos |
| 6 | IDS | 60 min | Identify, Discuss, Solve top issues |
| 7 | Conclude | 5 min | New To-Dos, cascading messages, rating |

## Process

### Step 1: Set Up the Meeting

1. **Date**: Use today's date, or ask if scheduling for a different day.
2. **Attendees**: Ask who's attending. Default to the attendees from the most recent L10 if available.
3. Create the meeting file from `templates/l10-meeting.md` at `data/meetings/l10/YYYY-MM-DD.md`.

If an L10 already exists for today, ask: "There's already an L10 for today. Open it, or create a new one?"

### Step 2: Segue (5 minutes)

Prompt each attendee to share one personal and one professional good news. This builds connection before diving into business.

Record responses in the Segue section.

"Let's start with a segue. [Name], share one personal and one professional good news."

### Step 3: Scorecard Review (5 minutes)

1. Read the most recent weekly scorecard from `data/scorecard/weeks/`.
2. Display the metrics table with status.
3. For each **off-track** metric, note it for the Issues list.

```
Scorecard — Week 07:
  Weekly Revenue: $52K (goal: $50K) ✓
  New Customers: 7 (goal: 10) ✗ → add to Issues?
  NPS: 72 (goal: 70) ✓
```

Ask: "Any off-track items to add to today's Issues list?"

If no scorecard exists for this week: "No scorecard logged for this week yet. Skip, or enter numbers now?"

### Step 4: Rock Review (5 minutes)

1. Read all Rocks in `data/rocks/[current-quarter]/`.
2. Display status for each Rock.
3. Quick check — on track or off track? No discussion yet (save that for IDS).

```
Rock Review — Q1 2026:
  Launch Beta (brad): on_track
  Hire VP Sales (daniel): off_track → add to Issues?
  Implement CRM (daniel): on_track
```

Ask: "Any off-track Rocks to add to today's Issues list?"

### Step 5: Headlines (5 minutes)

Prompt for customer and employee headlines — good news, bad news, updates. Quick hits only. No discussion.

"What headlines do we need to share? Customer news, employee news, anything the team should know."

Record as bullet points.

### Step 6: To-Do Review (5 minutes)

1. Read the **most recent previous L10** from `data/meetings/l10/`.
2. Find the "New To-Dos" table from the Conclude section.
3. For each To-Do, ask: "Done or not done?"

```
To-Do Review (from L10 2026-02-06):
  ☐ Send proposal to Acme (brad) — Done? [yes/no]
  ☐ Schedule interviews (daniel) — Done? [yes/no]
```

4. Calculate completion rate. Target is 90%+.
5. If below 90%, note it but don't dwell — it's data, not a guilt trip.

### Step 7: IDS (60 minutes)

This is the core of the L10 — where the real work happens.

#### Step 7a: Build the Issues List

Collect issues from:
- Off-track Scorecard items (from Step 3)
- Off-track Rocks (from Step 4)
- Open issues from `data/issues/open/`
- New issues raised by attendees

Ask: "What other issues should we add to today's list?"

#### Step 7b: Prioritize

List all issues and ask the team to pick the **top 3** most important ones. These get solved today. The rest stay on the list for next week.

#### Step 7c: IDS Each Issue

For each of the top 3 issues, follow the IDS process:

1. **Identify** — What is the real issue? Dig past symptoms. Use the 5 Whys if the root cause isn't obvious.
2. **Discuss** — Each person shares their perspective. Stay focused — no tangents, no solving yet.
3. **Solve** — What's the action? Create at least one To-Do with an owner and due date.

Record the IDS work in the meeting notes. If this creates a new issue file, use `ceos-ids` or write to `data/issues/open/` directly.

### Step 8: Conclude (5 minutes)

#### New To-Dos

Compile all To-Dos created during the meeting (from IDS and any other sections):

| To-Do | Owner | Due Date |
|-------|-------|----------|
| [Action] | [Name] | [YYYY-MM-DD] |

#### Cascading Messages

Ask: "What needs to be communicated to the rest of the organization?"

#### Meeting Rating

Each attendee rates the meeting 1-10. Record ratings and calculate average. Target: 8+.

If average is below 8: "Below the 8/10 target. What could we improve for next week?"

### Step 9: Save the Meeting

1. Show the completed meeting file.
2. Ask for any final edits.
3. Write to `data/meetings/l10/YYYY-MM-DD.md`.
4. Update the frontmatter with the average rating.
5. Remind: "Run `git commit` to save the meeting notes."

## Output Format

The meeting file follows the template structure in `templates/l10-meeting.md`:
- YAML frontmatter: date, attendees, rating
- 7 numbered sections with content from the meeting
- To-Do table in the Conclude section

During the meeting, display each section header with its time box as you move through the agenda.

## Guardrails

- **Respect time boxes.** The L10 is 90 minutes total. Don't let any section (especially IDS) expand beyond its allocation without acknowledging the trade-off.
- **IDS gets the most time.** If the team is rushing through Segue/Scorecard/Rocks/Headlines/To-Dos, that's fine — bank the extra time for IDS. But don't skip any section entirely.
- **Top 3 only.** During IDS, solve the top 3 issues. Don't try to solve everything — the rest go to next week's list.
- **Pull real data.** Scorecard and Rock Review should use actual data from `data/scorecard/weeks/` and `data/rocks/`. Don't ask the user to recite numbers that are already on file.
- **Reference previous L10.** To-Do review must check the actual previous meeting file, not rely on memory.
- **Don't auto-invoke skills.** When IDS work creates an issue worth tracking, mention that `ceos-ids` can create the issue file, but let the user decide. Same for scorecard logging (`ceos-scorecard`).
- **One meeting per day.** If an L10 already exists for the date, confirm before overwriting.
- **Save at the end.** Write the complete meeting file at the end, not incrementally during the meeting.
