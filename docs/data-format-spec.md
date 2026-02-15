# Data Format Specification

Technical specification for the CEOS data format. All EOS data is stored as markdown files with YAML frontmatter — human-readable, git-friendly, and parseable by any language.

## Overview

CEOS uses a deliberately simple data format:

- **YAML frontmatter** for structured data (status, priority, dates, IDs)
- **Markdown body** for human-written content (notes, perspectives, outcomes)
- **File-per-record** pattern — each Rock, Issue, To-Do, and meeting is its own file
- **Directory-as-collection** pattern — `data/rocks/2026-Q1/` contains all Q1 Rocks

This format is the **portable contract** that tools depend on. Any tool that can parse YAML + markdown can read CEOS data — you're not locked into Claude Code.

## General Rules

### Frontmatter

YAML frontmatter is delimited by `---` on its own line:

```markdown
---
key: value
another_key: "quoted value"
---

# Markdown body starts here
```

- All date values use ISO 8601: `YYYY-MM-DD`
- All string values with special characters should be quoted
- Enum values are lowercase with underscores: `on_track`, `off_track`

### File Naming

Files that represent individual records follow the pattern:

```
{type}-{NNN}-{slug}.md
```

- `{type}` — the record type (`rock`, `issue`)
- `{NNN}` — zero-padded numeric ID (`001`, `002`, `042`)
- `{slug}` — title slugified (lowercase, hyphens, no special characters)

Examples:
- `rock-001-launch-beta-program.md`
- `issue-003-slow-customer-onboarding.md`

### ID Generation

IDs are sequential within their type and directory. When creating a new record:

1. Scan all existing files in the relevant directories
2. Find the highest numeric ID
3. Increment by 1

For Issues, check **both** `data/issues/open/` and `data/issues/solved/` to avoid ID collisions.

---

## Rock Format

**Location:** `data/rocks/YYYY-QN/rock-NNN-slug.md`

### Frontmatter Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | string | Yes | Unique identifier (e.g., `rock-001`) |
| `title` | string | Yes | Short description of the Rock |
| `owner` | string | Yes | One person responsible (never shared) |
| `quarter` | string | Yes | Quarter in `YYYY-QN` format (e.g., `2026-Q1`) |
| `status` | enum | Yes | Current status (see below) |
| `created` | date | Yes | Date the Rock was created |
| `due` | date | Yes | Last day of the quarter |

### Status Values

| Value | Meaning | Set When |
|-------|---------|----------|
| `on_track` | Progressing as expected | Default; updated during weekly tracking |
| `off_track` | Behind schedule or at risk | Updated during weekly tracking |
| `complete` | Measurable outcome achieved | End-of-quarter scoring only |
| `dropped` | No longer a priority | End-of-quarter scoring only |

### Body Structure

```markdown
# [Rock Title]

## Measurable Outcome

[Specific, verifiable definition of "done"]

## Milestones

- [ ] [First milestone]
- [ ] [Second milestone]
- [ ] [Third milestone]

## Notes

- YYYY-MM-DD: [Progress update or context]
```

### Example

```markdown
---
id: rock-001
title: "Launch Beta Program"
owner: "brad"
quarter: "2026-Q1"
status: on_track
created: "2026-01-02"
due: "2026-03-31"
---

# Launch Beta Program

## Measurable Outcome

Beta program launched with 10+ users actively providing feedback.

## Milestones

- [x] Beta invitation system built
- [x] First 10 users onboarded
- [ ] Feedback collection process established

## Notes

- 2026-01-02: Rock created for 2026-Q1
- 2026-01-15: Invitation system complete
- 2026-02-01: 12 users onboarded, ahead of schedule
```

---

## Issue Format

**Location:** `data/issues/open/issue-NNN-slug.md` (open) or `data/issues/solved/issue-NNN-slug.md` (resolved)

### Frontmatter Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | string | Yes | Unique identifier (e.g., `issue-001`) |
| `title` | string | Yes | Short description of the issue |
| `priority` | integer | Yes | 1 (critical), 2 (important), 3 (minor) |
| `category` | enum | Yes | EOS issue category (see below) |
| `ids_stage` | enum | Yes | Current IDS stage (see below) |
| `created` | date | Yes | Date the issue was identified |

### Priority Values

| Value | Meaning |
|-------|---------|
| `1` | Critical — solve first |
| `2` | Important — solve soon |
| `3` | Minor — solve when time allows |

### Category Values (The 5 EOS Issue Types)

| Value | Meaning |
|-------|---------|
| `people` | Right person, right seat issues |
| `process` | Systems, workflows, efficiency |
| `data` | Metrics, reporting, information gaps |
| `vision` | Alignment with V/TO, Core Focus |
| `traction` | Execution, accountability, follow-through |

### IDS Stage Values

| Value | Meaning |
|-------|---------|
| `identified` | Root cause found, not yet discussed |
| `discussed` | Perspectives captured, not yet solved |
| `solved` | To-Dos created, issue resolved |

### Body Structure

```markdown
# [Issue Title]

## Identify

**Stated problem:**
> [What was originally reported]

**Root cause:**
> [After 5 Whys analysis]

## Discuss

- **[Name]:** [Their perspective]
- **[Name]:** [Their perspective]

## Solve

| Action | Owner | Due Date | Done |
|--------|-------|----------|------|
| [Action item] | [Name] | [YYYY-MM-DD] | [ ] |
```

### File Lifecycle

1. Created in `data/issues/open/` with `ids_stage: identified`
2. Updated to `ids_stage: discussed` after discussion
3. Updated to `ids_stage: solved` after To-Dos are created
4. Moved to `data/issues/solved/` when the IDS process is complete

Solved issues are never deleted — they serve as an audit trail.

### Example

```markdown
---
id: issue-003
title: "Slow customer onboarding"
priority: 1
category: process
ids_stage: solved
created: "2026-02-06"
---

# Slow customer onboarding

## Identify

**Stated problem:**
> New customers take 3+ weeks to complete onboarding

**Root cause:**
> Setup flow has 12 steps added for edge cases that affect <5% of users.
> No post-launch review process exists for customer-facing flows.

## Discuss

- **Brad:** We added those steps after two enterprise customers had issues.
  They shouldn't apply to standard tier.
- **Daniel:** Sales team is hearing complaints. It's affecting close rates.

## Solve

| Action | Owner | Due Date | Done |
|--------|-------|----------|------|
| Audit onboarding flow, remove unnecessary steps | brad | 2026-02-20 | [x] |
| Create quarterly UX review process | daniel | 2026-02-20 | [ ] |
```

---

## To-Do Format

**Location:** `data/todos/todo-NNN-slug.md`

### Frontmatter Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | string | Yes | Unique identifier (e.g., `todo-001`) |
| `title` | string | Yes | Short, action-oriented description |
| `owner` | string | Yes | One person responsible (never shared) |
| `due` | date | Yes | Deadline for completion |
| `status` | enum | Yes | Current status (see below) |
| `source` | enum | Yes | Where the To-Do originated (see below) |
| `created` | date | Yes | Date the To-Do was created |
| `completed_on` | date | No | Date the To-Do was completed (set when status → complete) |

### Status Values

| Value | Meaning |
|-------|---------|
| `open` | Not yet done |
| `complete` | Done — binary, no partial credit |

**Overdue** is computed, not stored: a To-Do is overdue if `status: open` and `due` is before today's date.

### Source Values

| Value | Meaning |
|-------|---------|
| `l10` | Created during an L10 meeting |
| `ids` | Created during IDS issue resolution |
| `quarterly` | Created during a Quarterly Conversation |
| `adhoc` | Created outside of a meeting context |

### Body Structure

```markdown
# [To-Do Title]

## Description

[What needs to be done — specific enough that the owner knows "done"]

## Notes

- YYYY-MM-DD: To-Do created (source: l10)
- YYYY-MM-DD: Completed
```

### Example

```markdown
---
id: todo-003
title: "Send revised proposal to Acme"
owner: "brad"
due: "2026-02-20"
status: complete
source: l10
created: "2026-02-13"
completed_on: "2026-02-18"
---

# Send revised proposal to Acme

## Description

Send the revised proposal with updated pricing to Acme Corp. Include the volume discount table and Q2 timeline.

## Notes

- 2026-02-13: To-Do created (source: l10)
- 2026-02-18: Completed
```

---

## L10 Meeting Format

**Location:** `data/meetings/l10/YYYY-MM-DD.md`

### Frontmatter Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `date` | date | Yes | Meeting date |
| `attendees` | list | Yes | Names of attendees |
| `rating` | number | No | Average meeting rating (1-10), filled at end |

### Body Structure

The meeting body has 7 numbered sections matching the EOS L10 agenda:

```markdown
# Level 10 Meeting — YYYY-MM-DD

## 1. Segue (5 min)
[Personal/professional good news per attendee]

## 2. Scorecard Review (5 min)
[Metrics table with goal/actual/status]

## 3. Rock Review (5 min)
[Rock status table]

## 4. Headlines (5 min)
[Customer and employee news bullets]

## 5. To-Do Review (5 min)
[To-Do table from previous L10, done/not done]
[Completion rate]

## 6. IDS (60 min)
[Top 3 issues: Identify, Discuss, Solve for each]

## 7. Conclude (5 min)
[New To-Dos table, cascading messages, ratings]
```

### Example Frontmatter

```yaml
---
date: "2026-02-13"
attendees: [brad, daniel, sarah]
rating: 8.3
---
```

---

## Scorecard Week Format

**Location:** `data/scorecard/weeks/YYYY-WNN.md`

### Frontmatter Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `week` | string | Yes | ISO week in `YYYY-WNN` format (e.g., `2026-W07`) |
| `date` | date | Yes | Date the scorecard was logged |

### Week Format

Weeks follow ISO 8601: `YYYY-WNN` where `NN` is the ISO week number (01-53). Week 1 is the week containing the first Thursday of the year.

### Body Structure

```markdown
# Scorecard — YYYY-WNN

*Logged: YYYY-MM-DD*

| Metric | Owner | Goal | Actual | Status |
|--------|-------|------|--------|--------|
| [name] | [name] | [goal] | [actual] | on_track / off_track |

## Notes

- [Context for off-track metrics]
```

### Status Values

| Value | Meaning |
|-------|---------|
| `on_track` | Meets or exceeds the goal threshold |
| `off_track` | Below the goal threshold |

### Example

```markdown
---
week: "2026-W07"
date: "2026-02-13"
---

# Scorecard — 2026-W07

*Logged: 2026-02-13*

| Metric | Owner | Goal | Actual | Status |
|--------|-------|------|--------|--------|
| Weekly Revenue | brad | $50K | $52K | on_track |
| New Customers | daniel | 10 | 7 | off_track |
| NPS | brad | 70 | 72 | on_track |
| Cash Balance | sarah | $200K | $215K | on_track |

## Notes

- New Customers off-track for second consecutive week. Added to L10 Issues list.
```

---

## Scorecard Metrics Format

**Location:** `data/scorecard/metrics.md`

This file defines the metrics your team tracks. It is not a weekly entry — it's the metric definitions that weekly entries reference.

### Structure

```markdown
# Scorecard Metrics

## [Company Name]

## Metrics

| Metric | Owner | Goal | Frequency | Green | Red |
|--------|-------|------|-----------|-------|-----|
| [name] | [name] | [goal] | Weekly/Monthly | [threshold] | [threshold] |
```

No YAML frontmatter — this is a pure markdown reference document.

### Threshold Format

Green and Red thresholds define when a metric is on_track or off_track:

- `>= $50,000` — on_track when at or above the value
- `< 10` — off_track when below the value

### Example

```markdown
# Scorecard Metrics

## Acme Corp

## Metrics

| Metric | Owner | Goal | Frequency | Green | Red |
|--------|-------|------|-----------|-------|-----|
| Weekly Revenue | brad | $50K | Weekly | >= $50K | < $50K |
| New Customers | daniel | 10 | Weekly | >= 10 | < 10 |
| NPS | brad | 70 | Monthly | >= 70 | < 70 |
| Cash Balance | sarah | $200K | Weekly | >= $200K | < $200K |
| Support Tickets Closed | daniel | 50 | Weekly | >= 50 | < 50 |
```

---

## Vision Format

**Location:** `data/vision.md`

The V/TO (Vision/Traction Organizer) is a pure markdown document — no YAML frontmatter. It contains 8 sections covering the full EOS strategic framework.

### Structure

```markdown
# Vision/Traction Organizer

## [Company Name]

*Last updated: YYYY-MM-DD*

## Core Values
[3-7 guiding principles]

## Core Focus
[Purpose + Niche]

## 10-Year Target
[One big goal]

## Marketing Strategy
[Target Market, 3 Uniques, Proven Process, Guarantee]

## 3-Year Picture
[Revenue, profit, headcount, what it looks like]

## 1-Year Plan
[Revenue goal, profit goal, measurables, goals]

## Quarterly Rocks
[Reference to data/rocks/ — managed by ceos-rocks]

## Issues List
[Reference to data/issues/ — managed by ceos-ids]
```

The Quarterly Rocks and Issues List sections are pointers to other data directories — they're managed by `ceos-rocks` and `ceos-ids` respectively, not edited directly in the V/TO.

---

## Accountability Chart Format

**Location:** `data/accountability.md`

Pure markdown document — no YAML frontmatter. Describes the company's organizational structure using EOS's "right person, right seat" framework.

### Structure

```markdown
# Accountability Chart

## [Company Name]

## [Function Name]
**Seat:** [Role title]
**Person:** [Name]

### Roles
- [Key responsibility]
- [Key responsibility]
```

---

## Directory Structure

```
data/
├── vision.md                          # V/TO document
├── accountability.md                  # Accountability chart
├── rocks/
│   ├── 2026-Q1/
│   │   ├── rock-001-launch-beta.md
│   │   ├── rock-002-hire-vp-sales.md
│   │   └── rock-003-implement-crm.md
│   └── 2026-Q2/
│       └── ...
├── scorecard/
│   ├── metrics.md                     # Metric definitions
│   └── weeks/
│       ├── 2026-W05.md
│       ├── 2026-W06.md
│       └── 2026-W07.md
├── todos/
│   ├── todo-001-update-onboarding-doc.md
│   ├── todo-002-send-partnership-agreement.md
│   └── todo-003-send-revised-proposal.md
├── issues/
│   ├── open/
│   │   ├── issue-005-misaligned-marketing.md
│   │   └── issue-007-key-account-churning.md
│   └── solved/
│       ├── issue-001-reporting-gaps.md
│       ├── issue-002-office-wifi.md
│       └── issue-003-slow-onboarding.md
└── meetings/
    └── l10/
        ├── 2026-02-06.md
        └── 2026-02-13.md
```

### Key Conventions

- **Rocks** are organized by quarter: `data/rocks/YYYY-QN/`
- **To-Dos** are flat in `data/todos/` (completed To-Dos stay in place with `status: complete`)
- **Issues** are organized by state: `data/issues/open/` and `data/issues/solved/`
- **Scorecard weeks** use ISO week numbering: `data/scorecard/weeks/YYYY-WNN.md`
- **L10 meetings** use date: `data/meetings/l10/YYYY-MM-DD.md`
- **Vision and Accountability** are single files at the `data/` root

## Parsing

To parse a CEOS data file in any language:

1. Read the file as text
2. Split on the first two `---` lines to extract YAML frontmatter
3. Parse the YAML block into a key-value structure
4. The remaining text is markdown — parse as needed

Most languages have YAML and markdown parsers available. The format is intentionally simple enough that a regex-based parser works for basic use cases.

## Versioning

The data format follows [Semantic Versioning](https://semver.org/) as part of the CEOS project:

- **Breaking changes** (renaming fields, changing status values, removing fields) require a major version bump and an RFC-style discussion
- **Non-breaking additions** (new optional fields) are minor version changes
- **Documentation and clarifications** are patch version changes

See [CONTRIBUTING.md](../CONTRIBUTING.md) for the process around data format changes.
