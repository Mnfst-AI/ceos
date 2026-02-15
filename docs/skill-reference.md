# Skill Reference

Complete reference for all CEOS skills. Each skill is a Claude Code skill that implements a core EOS tool.

## How Skills Work

CEOS skills are markdown files (`SKILL.md`) that teach Claude Code how to perform EOS workflows. When you start a Claude Code session in your CEOS repository, Claude discovers the installed skills and matches your requests to the right skill automatically.

**Repo detection:** Every skill searches upward from your current directory for the `.ceos` marker file. If you're not in a CEOS repository, the skill will tell you to clone and set up first.

**Trigger phrases:** Each skill responds to natural language. You don't need to remember exact commands — just describe what you want to do and Claude will match it to the right skill.

---

## ceos-vto — Vision/Traction Organizer

Review and update the V/TO — the single document that captures where your company is going and how it plans to get there.

### When to Use

- "Review our vision" or "show me the V/TO"
- "Update our core values" or "change our 10-year target"
- "What's our core focus?" or "what are our 3 uniques?"
- "Are our Rocks aligned with the 1-Year Plan?"
- "Let's update the 3-year picture"

### Key Operations

| Operation | What Happens |
|-----------|-------------|
| **Review** | Reads `data/vision.md`, displays a summary of all 8 sections |
| **Update** | Shows current content of a section, drafts changes, shows diff, asks for approval |
| **Alignment Check** | Cross-references current Rocks against the 1-Year Plan, flags mismatches |

### The 8 V/TO Sections

| Section | Horizon | Key Question |
|---------|---------|-------------|
| Core Values | Permanent | What do we stand for? |
| Core Focus | Permanent | Why do we exist? What's our niche? |
| 10-Year Target | 10 years | What's our big audacious goal? |
| Marketing Strategy | Ongoing | Who do we serve? How are we different? |
| 3-Year Picture | 3 years | What does the company look like? |
| 1-Year Plan | 1 year | What must be true in 12 months? |
| Quarterly Rocks | 90 days | Managed by `ceos-rocks` |
| Issues List | Ongoing | Managed by `ceos-ids` |

### Example

```
You: "Review our vision"

Claude reads data/vision.md and shows:

  Acme Corp — V/TO Summary (last updated: 2026-02-01)
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Core Values: Integrity, Speed, Customer First
  Core Focus: Helping SMBs automate their operations
  10-Year Target: $100M ARR
  3-Year Picture: $20M revenue, 50 employees, 3 products
  1-Year Plan: $8M revenue, launch Product #2
  Rocks: 5 set for Q1 2026 (see ceos-rocks)
  Issues: 3 open (see ceos-ids)

  Which section would you like to review or update?
```

### Files

| File | Purpose |
|------|---------|
| `data/vision.md` | The V/TO document (source of truth) |
| `data/accountability.md` | Accountability chart (reference) |
| `data/rocks/` | Current Rocks (for alignment checks) |

---

## ceos-rocks — Quarterly Rocks

Manage quarterly Rocks — the 3-7 most important priorities for the next 90 days. Each Rock has one owner, a measurable outcome, and a due date at quarter end.

### When to Use

- "Set rocks for this quarter" or "let's plan our quarterly priorities"
- "Rock status" or "how are our rocks tracking?"
- "Score rocks" or "end of quarter review"
- "Create a rock" or "add a new rock for [person]"
- "What rocks does [person] own?"

### Three Modes

#### Setting Rocks (Start of Quarter)

Walk through creating each Rock:
1. Reviews the 1-Year Plan for context
2. Collects title, owner, measurable outcome, milestones
3. Validates: 3-7 per person, aligned with 1-Year Plan
4. Writes Rock files to `data/rocks/YYYY-QN/`

#### Tracking Rocks (Weekly)

Quick status check:
1. Reads all Rocks for the current quarter
2. Displays status table with milestone progress
3. Updates status (on_track / off_track) with approval

#### Scoring Rocks (End of Quarter)

Binary completion review:
1. For each Rock: "Complete or incomplete?"
2. Updates status to `complete` or `dropped` (no partial credit)
3. Shows completion rate (target: 80%+)

### Example

```
You: "How are our rocks tracking?"

Claude reads data/rocks/2026-Q1/ and shows:

  Rock Status — Q1 2026
  ━━━━━━━━━━━━━━━━━━━━━
  rock-001  Launch Beta Program     brad     on_track   2/3 milestones
  rock-002  Hire VP Sales           daniel   off_track  No candidates yet
  rock-003  Implement CRM           daniel   on_track   1/2 milestones

  Any status changes to record?
```

### Rock Status Values

| Status | Meaning | Set When |
|--------|---------|----------|
| `on_track` | Progressing as expected | Default, updated during tracking |
| `off_track` | Behind or at risk | Updated during tracking |
| `complete` | Done — measurable outcome achieved | End-of-quarter scoring |
| `dropped` | No longer a priority | End-of-quarter scoring |

### Files

| File | Purpose |
|------|---------|
| `data/rocks/YYYY-QN/` | Rock files for each quarter |
| `data/vision.md` | 1-Year Plan (for alignment checks) |
| `templates/rock.md` | Template for new Rock files |

---

## ceos-scorecard — Weekly Measurables

Manage the weekly Scorecard — the 5-15 numbers that tell you the health of your business at a glance.

### When to Use

- "Log scorecard" or "enter this week's numbers"
- "Define a new metric" or "add a metric to the scorecard"
- "How are our metrics?" or "scorecard trend"
- "Show the scorecard" or "weekly numbers"
- "Which metrics are off track?"

### Three Modes

#### Define Metrics

Set up or modify the metrics your team tracks:
1. Reads current metrics from `data/scorecard/metrics.md`
2. Collects: metric name, owner, goal, frequency, green/red thresholds
3. Validates: 5-15 metrics total, one owner each, measurable
4. Updates the metrics definition file

#### Log Weekly

Record this week's numbers:
1. Determines current ISO week (YYYY-WNN format)
2. Prompts for each metric's value
3. Auto-calculates on_track / off_track against thresholds
4. Writes to `data/scorecard/weeks/YYYY-WNN.md`

#### Trend Analysis

Review metrics over time:
1. Reads the last 13 weeks of scorecard data
2. Shows per-metric trend with on/off track history
3. Flags concerning patterns:
   - 3+ consecutive weeks off-track
   - Declining trend over 4+ weeks
   - More than 50% of weeks off-track

### Example

```
You: "Log this week's scorecard"

Claude reads metrics.md, then asks for each value:

  Logging Scorecard — 2026-W07
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Weekly Revenue (brad) — Goal: $50K
    This week's value: $52K → on_track ✓

  New Customers (daniel) — Goal: 10
    This week's value: 7 → off_track ✗

  NPS (brad) — Goal: 70
    This week's value: 72 → on_track ✓

  Save this week's scorecard?
```

### Week Format

Weeks follow ISO 8601: `YYYY-WNN` (e.g., `2026-W07`). Week 1 is the week containing the first Thursday of the year.

### Files

| File | Purpose |
|------|---------|
| `data/scorecard/metrics.md` | Metric definitions (names, owners, goals, thresholds) |
| `data/scorecard/weeks/YYYY-WNN.md` | Weekly scorecard entries |
| `templates/scorecard-metrics.md` | Template for metrics definition |
| `templates/scorecard-week.md` | Template for weekly entries |

---

## ceos-l10 — Level 10 Meetings

Facilitate the Level 10 (L10) Meeting — the weekly 90-minute leadership meeting that keeps the team aligned, accountable, and solving problems.

### When to Use

- "Run L10" or "start our L10"
- "Level 10 meeting" or "weekly meeting"
- "Start our meeting" or "let's do our weekly"
- "Review last week's L10" or "what were our to-dos?"

### The 7-Section Agenda

| # | Section | Time | What Happens |
|---|---------|------|-------------|
| 1 | Segue | 5 min | Personal + professional good news |
| 2 | Scorecard Review | 5 min | Review weekly metrics, flag off-track items |
| 3 | Rock Review | 5 min | Quick on/off track check for each Rock |
| 4 | Headlines | 5 min | Customer and employee news — no discussion |
| 5 | To-Do Review | 5 min | Check last week's To-Dos (target: 90%+ done) |
| 6 | IDS | 60 min | Identify, Discuss, Solve top 3 issues |
| 7 | Conclude | 5 min | New To-Dos, cascading messages, rating (target: 8+/10) |

### Data Integration

The L10 skill pulls real data from your CEOS repository:

| Section | Reads From |
|---------|-----------|
| Scorecard Review | `data/scorecard/weeks/` (latest week) |
| Rock Review | `data/rocks/[current-quarter]/` |
| To-Do Review | Previous L10 in `data/meetings/l10/` |
| IDS | `data/issues/open/` + new issues raised |

### Example

```
You: "Run our L10"

Claude creates data/meetings/l10/2026-02-13.md and guides you through:

  L10 Meeting — 2026-02-13
  ━━━━━━━━━━━━━━━━━━━━━━━━

  § 1. Segue (5 min)
  Brad, share one personal and one professional good news.
  ...

  § 2. Scorecard Review (5 min)
  Scorecard — Week 07:
    Weekly Revenue: $52K (goal: $50K) ✓
    New Customers: 7 (goal: 10) ✗ → add to Issues?
  ...

  [continues through all 7 sections]
```

### Files

| File | Purpose |
|------|---------|
| `data/meetings/l10/YYYY-MM-DD.md` | L10 meeting notes |
| `data/scorecard/weeks/` | Latest scorecard data |
| `data/rocks/[quarter]/` | Current Rocks |
| `data/issues/open/` | Open issues |
| `templates/l10-meeting.md` | Meeting template |

---

## ceos-ids — Issue Resolution

Run the IDS (Identify, Discuss, Solve) process — the EOS method for resolving issues systematically.

### When to Use

- "We have an issue" or "add to the issues list"
- "IDS this" or "let's identify discuss solve"
- "What are our open issues?" or "show the issues list"
- "Solve [issue]" or "discuss [issue]"
- "Close this issue" or "mark [issue] as solved"
- During L10 meetings when the IDS section begins

### Four Modes

#### List Issues

Display all open issues sorted by priority:

```
Open Issues (5 total):
━━━━━━━━━━━━━━━━━━━━
P1  issue-003  Slow customer onboarding     [process]  identified
P1  issue-007  Key account churning          [people]   discussed
P2  issue-001  Reporting gaps in dashboard   [data]     identified
P2  issue-005  Misaligned marketing spend    [vision]   identified
P3  issue-002  Office Wi-Fi unreliable       [process]  identified
```

#### Create Issue (Identify)

1. Name the issue
2. Dig for root cause using the 5 Whys technique
3. Classify: priority (1-3) and category
4. Generate unique ID
5. Write to `data/issues/open/`

#### Discuss

Capture each person's perspective on an identified issue. Update status to `discussed`.

#### Solve

Create at least one To-Do with an owner and due date. Move the issue to `data/issues/solved/`.

### Issue Priority

| Priority | Meaning |
|----------|---------|
| 1 | Critical — solve first |
| 2 | Important — solve soon |
| 3 | Minor — solve when time allows |

### Issue Categories (The 5 EOS Issue Types)

| Category | What It Covers |
|----------|---------------|
| `people` | Right person, right seat issues |
| `process` | Systems, workflows, efficiency |
| `data` | Metrics, reporting, information gaps |
| `vision` | Alignment with V/TO, Core Focus |
| `traction` | Execution, accountability, follow-through |

### IDS Stages

| Stage | Meaning |
|-------|---------|
| `identified` | Root cause found, not yet discussed |
| `discussed` | Perspectives captured, not yet solved |
| `solved` | To-Dos created, ready to move to solved/ |

### Example

```
You: "We have an issue with customer onboarding"

Claude walks through IDS:

  § Identify — What's the real issue?

  "Why is onboarding slow?"
  → "Because the setup process has too many steps"

  "Why does it have too many steps?"
  → "Because we added steps for edge cases that rarely happen"

  "Why weren't those edge cases handled differently?"
  → "Because we never reviewed the flow after launch"

  Root cause: No post-launch review process for customer flows.

  Priority: 1 (Critical)
  Category: process

  § Discuss — [captured during L10 or dedicated session]

  § Solve —
  | Action | Owner | Due Date |
  |--------|-------|----------|
  | Audit onboarding flow, remove unnecessary steps | brad | 2026-02-20 |
  | Create quarterly UX review process | daniel | 2026-02-20 |

  Issue moved to data/issues/solved/
```

### Files

| File | Purpose |
|------|---------|
| `data/issues/open/` | Open issues awaiting resolution |
| `data/issues/solved/` | Resolved issues (archive) |
| `templates/issue.md` | Template for new issue files |

---

## ceos-todos — To-Do Tracking

Track To-Dos — the concrete actions that bridge meetings and execution. Every To-Do has one owner, a due date, and a source. EOS teams target 90%+ weekly completion rate.

### When to Use

- "Show my to-dos" or "what's on my list?"
- "Create a to-do" or "add a to-do for [person]"
- "Mark to-do done" or "complete [to-do]"
- "To-do review" or "how's our completion rate?"
- "What to-dos are overdue?"

### Four Modes

| Mode | What Happens |
|------|-------------|
| **List** | Shows all open To-Dos grouped by owner with due dates and overdue indicators |
| **Create** | Adds a To-Do with title, owner, due date, and source |
| **Complete** | Marks To-Do(s) as done, records completion date |
| **Review** | Weekly completion rate report with patterns and flags |

### To-Do Status Values

| Status | Meaning |
|--------|---------|
| `open` | Not yet done |
| `complete` | Done — binary, no partial credit |

Overdue is computed (not stored): `status: open` + `due` before today.

### Source Values

| Source | Meaning |
|--------|---------|
| `l10` | Created during L10 meeting |
| `ids` | Created during IDS resolution |
| `quarterly` | Created during Quarterly Conversation |
| `adhoc` | Created outside meetings |

### Example

```
You: "Show my to-dos"

Claude reads data/todos/ and shows:

  Open To-Dos (5 total, 1 overdue)
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Brad (3 to-dos):
    todo-003  Send revised proposal      due: Feb 20    3 days left
    todo-007  Review hiring pipeline     due: Feb 18    1 day left
    todo-001  Update onboarding doc      due: Feb 10    ⚠️ 4 days overdue

  Daniel (2 to-dos):
    todo-005  Fix dashboard report       due: Feb 22    8 days left
    todo-004  Schedule vendor call       due: Feb 15    due today

  Summary: 5 open | 1 overdue | 2 owners
```

### Files

| File | Purpose |
|------|---------|
| `data/todos/` | To-Do files (one file per To-Do) |
| `templates/todo.md` | Template for new To-Do files |

---

## Cross-Skill Workflows

The skills are designed to work together through the natural EOS cadence. Here are common multi-skill workflows:

### Weekly L10 → Scorecard + Rocks + IDS

```
1. ceos-l10 starts the meeting
2. § Scorecard Review pulls data from ceos-scorecard
3. § Rock Review pulls data from ceos-rocks
4. Off-track items drop to the Issues list
5. § IDS uses ceos-ids to resolve top 3 issues
6. New To-Dos recorded in meeting notes
```

### Off-Track Rock → Issue → Solution

```
1. ceos-rocks shows a Rock is off_track during tracking
2. Team creates an Issue: "Why is Rock X off track?"
3. ceos-ids runs the 5 Whys to find root cause
4. To-Dos created to get the Rock back on track
5. Next week's L10 reviews progress
```

### Quarterly Planning → V/TO + Rocks

```
1. ceos-vto reviews the 1-Year Plan
2. Team discusses: "What must we accomplish this quarter?"
3. ceos-rocks creates Rocks aligned with the plan
4. ceos-vto runs alignment check: Rocks ↔ 1-Year Plan
5. Misalignments become Issues for IDS
```

### Scorecard Trend → Escalation → IDS

```
1. ceos-scorecard trend analysis shows 3+ weeks off-track
2. Skill suggests creating an Issue
3. ceos-ids investigates root cause
4. Solution To-Dos assigned to metric owner
5. Future scorecards show whether the fix worked
```
