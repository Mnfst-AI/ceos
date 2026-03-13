---
name: ceos-trends
description: Use when analyzing EOS health trends over time - Rock completion rates, scorecard consistency, checkup progression, and issue resolution patterns
file-access: [data/rocks/, data/scorecard/, data/checkups/, data/issues/, data/todos/, data/meetings/l10/]
tools-used: [Read, Glob]
---

# ceos-trends

Longitudinal EOS health tracking - analyze how your organization is improving over time across all Six Key Components. While `ceos-dashboard` shows today's snapshot, `ceos-trends` answers the question every EOS coach asks: "Are we getting better?"

## When to Use

- "How are we trending?" or "show our progress"
- "Are we improving?" or "EOS health over time"
- "Quarter comparison" or "compare Q1 to Q2"
- "Rock completion history" or "how have our rocks been?"
- "Scorecard trends" or "are our numbers improving?"
- "Show trends" or "progress report"
- Before quarterly planning or annual planning for historical context

## Context

### Finding the CEOS Repository

Search upward from the current directory for the `.ceos` marker file. This file marks the root of the CEOS repository.

If `.ceos` is not found, stop and tell the user: "Not in a CEOS repository. Clone your CEOS repo and run setup.sh first."

**Sync before use:** Once you find the CEOS root, run `git -C <ceos_root> pull --ff-only --quiet 2>/dev/null` to get the latest data from teammates. If it fails (conflict or offline), continue silently with local data.

### Key Files

| File | Purpose |
|------|---------|
| `data/rocks/YYYY-QN/` | Rock files per quarter (status, owner, milestones) |
| `data/scorecard/weeks/YYYY-WNN.md` | Weekly scorecard entries (metrics, on/off track) |
| `data/scorecard/metrics.md` | Metric definitions (goals, thresholds) |
| `data/checkups/YYYY-MM-DD.md` | Organizational Checkup results (component scores) |
| `data/issues/open/` | Currently open issues (priority, created date) |
| `data/issues/solved/` | Resolved issues (priority, created date, resolution) |
| `data/todos/` | To-Do files (status, created, completed_on, source) |
| `data/meetings/l10/YYYY-MM-DD.md` | L10 meeting notes (one per meeting) |

### Design Principles

- **Read-only.** Trends never modifies any data files. It reads, calculates, and reports.
- **Graceful degradation.** Works with whatever data exists. One quarter of Rocks? Show that. No checkups yet? Skip that section with guidance. Never error on missing data.
- **Cross-skill coordination.** Each trend section suggests the relevant skill for taking action. Trends shows the trajectory; other skills change it.
- **Minimum data threshold.** For meaningful trends, at least 2 data points are needed (e.g., 2 quarters of Rocks, 2 checkups). With only 1 data point, show the baseline value and note: "More data needed for trend analysis."

### Quarter and Week Calculations

- **Current quarter:** Jan-Mar = Q1, Apr-Jun = Q2, Jul-Sep = Q3, Oct-Dec = Q4. Format: `YYYY-QN`
- **Current ISO week:** Format: `YYYY-WNN`
- **Available quarters:** Scan `data/rocks/` subdirectory names to discover all quarters with data.
- **Trailing periods:** "Trailing 4 weeks" = most recent 4 weekly scorecard files. "Trailing 13 weeks" = most recent 13 (approximately one quarter).

## Process

### Mode: Overview (default)

Use when the user asks for a general trend summary. This is the default when no specific component is mentioned.

#### Step 1: Discover Available Data

Scan the CEOS data directories to determine what historical data exists:

1. **Quarters with Rocks:** List subdirectories in `data/rocks/` matching `YYYY-QN` pattern. Sort chronologically.
2. **Scorecard weeks:** List files in `data/scorecard/weeks/` matching `YYYY-WNN.md`. Sort chronologically.
3. **Checkups:** List files in `data/checkups/` matching `YYYY-MM-DD.md`. Sort by date.
4. **Issues:** Count files in `data/issues/open/` and `data/issues/solved/`.
5. **To-Dos:** List files in `data/todos/`. Parse `created` and `completed_on` dates.
6. **L10 meetings:** List files in `data/meetings/l10/` matching `YYYY-MM-DD.md`.

If no historical data exists at all, show:
```
No EOS data found. Run your first L10, set some Rocks, or log a scorecard to start building history.
```

#### Step 2: Rock Completion Trend

For each quarter directory in `data/rocks/`:

1. Read all `.md` files in the directory.
2. Parse YAML frontmatter for `status` field.
3. Count: `complete`, `on_track`, `off_track`, `dropped`, total.
4. Calculate completion rate: `complete / (total - dropped)` as percentage.

For the current quarter (not yet ended), mark as "in progress" and show current status breakdown instead of a final completion rate.

Display:

```
Rock Completion
  2025-Q3: 4/6 complete (67%)
  2025-Q4: 5/7 complete (71%) ↑
  2026-Q1: 2 on track, 1 off track, 1 complete of 6 (in progress)
```

Trend arrows (compare each quarter to the previous):
- `↑` = completion rate improved
- `→` = unchanged (within 5 percentage points)
- `↓` = completion rate declined

**If only one quarter exists:** Show the data without trend arrows. Add: "Track Rocks across multiple quarters to see completion trends."

**If no Rock directories exist:**
```
Rock Completion: No Rock data yet. Run `ceos-rocks` to set quarterly priorities.
```

#### Step 3: Scorecard Consistency

Analyze scorecard data across available weeks:

1. Read all weekly scorecard files from `data/scorecard/weeks/`.
2. For each file, parse the metrics table from the markdown body.
3. For each metric row, determine if it was on-track or off-track based on the status or value vs. threshold.
4. Calculate per-week: total metrics, on-track count, on-track percentage.

Calculate rolling averages:
- **Trailing 4 weeks:** Average on-track percentage over the last 4 weeks.
- **Prior 4 weeks:** Average on-track percentage for the 4 weeks before that.
- **Trailing 13 weeks:** Average on-track percentage over the last 13 weeks (quarter).

Also calculate logging consistency:
- Count weeks with scorecard entries vs. total weeks in the period.

Display:

```
Scorecard Consistency
  Weeks logged: 24/26 (92%)
  On-track rate (trailing 4 weeks): 78%
  On-track rate (prior 4 weeks): 71% ↑
  On-track rate (trailing 13 weeks): 74%
```

Trend arrow compares trailing 4 weeks to prior 4 weeks.

**If fewer than 2 weeks of data exist:**
```
Scorecard Consistency: [N] week(s) logged. Log more weeks for trend analysis.
```

**If no scorecard data exists:**
```
Scorecard Consistency: No scorecard data yet. Run `ceos-scorecard` to start tracking weekly.
```

#### Step 4: Checkup Score Progression

Read all checkup files from `data/checkups/`:

1. Parse YAML frontmatter for `overall_score` and `component_scores`.
2. Sort by date.
3. Show score progression over time.

Display:

```
Checkup Scores
  2025-09-15: 3.2 overall (Vision: 3.5, People: 3.0, Data: 3.2, Issues: 3.0, Process: 2.8, Traction: 3.5)
  2025-12-20: 3.8 overall (+0.6) ↑↑ (Vision: 4.0, People: 3.5, Data: 3.8, Issues: 3.5, Process: 3.2, Traction: 4.0)
  2026-03-01: 4.2 overall (+0.4) ↑ (Vision: 4.5, People: 4.0, Data: 4.2, Issues: 4.0, Process: 3.5, Traction: 4.3)
```

Trend indicators (compare to previous checkup):
- `↑↑` = improved by 0.5+
- `↑` = improved by 0.1-0.4
- `→` = unchanged (within 0.1)
- `↓` = declined by 0.1-0.4
- `↓↓` = declined by 0.5+

**If only one checkup exists:** Show the score without trend arrows. Add: "Run another organizational checkup to track progress over time."

**If no checkups exist:**
```
Checkup Scores: No checkups on file. Run `ceos-checkup` to assess organizational health.
```

#### Step 5: Issue Resolution Velocity

Analyze issues from both `data/issues/open/` and `data/issues/solved/`:

1. Read all issue files from both directories.
2. Parse YAML frontmatter for `created` date and `priority`.
3. For solved issues, calculate resolution time (days between `created` and the file's most recent frontmatter date or git modification).
4. Group by quarter based on `created` date.

Calculate per-quarter:
- Issues opened
- Issues solved
- Net change (solved - opened; negative means backlog grew)
- Average days to resolve (for solved issues)

Display:

```
Issue Resolution
  2025-Q4: 8 opened, 10 solved (net: -2, backlog shrinking) | Avg resolution: 24 days
  2026-Q1: 5 opened, 7 solved (net: -2, backlog shrinking) | Avg resolution: 18 days ↑
  Currently open: 4 issues (oldest: 12 days)
```

Trend arrow on resolution time (lower is better):
- `↑` = resolution time decreased (improving)
- `→` = unchanged (within 3 days)
- `↓` = resolution time increased (slowing down)

**If no issues exist (open or solved):**
```
Issue Resolution: No issues tracked yet. Use `ceos-ids` to identify, discuss, and solve issues.
```

#### Step 6: To-Do Completion Rate

Analyze to-do files from `data/todos/`:

1. Read all to-do files.
2. Parse YAML frontmatter for `status`, `created`, `due`, and `completed_on`.
3. Group by week based on `due` date.
4. Calculate weekly completion rate: `complete / total` for each week.

Calculate rolling averages:
- **Trailing 4 weeks:** Average completion rate.
- **Trailing 13 weeks:** Average completion rate.

EOS target is 90%+ weekly completion rate.

Display:

```
To-Do Completion Rate
  Trailing 4 weeks: 88% (target: 90%)
  Trailing 13 weeks: 82%
  Total: 45 complete / 52 created (87% all-time)
```

Color-code against the 90% target:
- At or above 90%: on target
- 80-89%: close, note the gap
- Below 80%: flag for attention

**If no to-do data exists:**
```
To-Do Completion Rate: No to-dos tracked yet. Use `ceos-todos` or run an L10 to create to-dos.
```

#### Step 7: L10 Meeting Cadence

Analyze L10 meeting files from `data/meetings/l10/`:

1. List all files matching `YYYY-MM-DD.md`.
2. Count meetings per quarter.
3. Calculate cadence: meetings held vs. weeks in the period.

Display:

```
L10 Meeting Cadence
  2025-Q4: 11/13 weeks (85%)
  2026-Q1: 9/10 weeks so far (90%)
  Streak: 6 consecutive weeks
```

Calculate current streak: consecutive weeks (from most recent backward) with an L10 file.

**If no L10 files exist:**
```
L10 Meeting Cadence: No L10 meetings on file. Run `ceos-l10` to start your weekly meetings.
```

#### Step 8: Trend Summary

After all sections, provide a categorized summary:

```
Trend Summary:
  Improving: Checkup scores (+0.4), Issue resolution (24 → 18 days), Scorecard consistency (71% → 78%)
  Stable: L10 cadence (90%)
  Needs attention: Rock completion (71% → in progress at 50%), To-do rate (88%, target 90%)
```

Categorize each component:
- **Improving:** Trend arrow is `↑` or `↑↑`
- **Stable:** Trend arrow is `→` or insufficient data for comparison
- **Needs attention:** Trend arrow is `↓` or `↓↓`, or below target thresholds

Then suggest actions only for "needs attention" items:

```
Suggested Actions:
  - Review off-track Rocks with `ceos-rocks`
  - Push to-do completion above 90% with `ceos-todos`
```

### Mode: Deep Dive

Use when the user asks about a specific component's history (e.g., "Rock history", "scorecard trends in detail").

#### Step 1: Identify Component

| User says | Component |
|-----------|-----------|
| "Rock history" / "Rock trends" | Rocks |
| "Scorecard trends" / "metric history" | Scorecard |
| "Checkup history" / "health scores" | Checkups |
| "Issue trends" / "resolution history" | Issues |
| "To-do trends" / "completion history" | To-Dos |
| "L10 history" / "meeting cadence" | L10 |

If unclear, ask: "Which component do you want to explore? (Rocks, Scorecard, Checkups, Issues, To-Dos, L10)"

#### Step 2: Detailed Component Analysis

Run the relevant section from Overview mode but with expanded detail:

**Rocks Deep Dive:**
- Show each quarter's Rocks individually (title, owner, status)
- Show per-person completion rates across quarters
- Highlight people who consistently complete vs. miss Rocks

**Scorecard Deep Dive:**
- Show each metric's on-track percentage over time
- Identify consistently off-track metrics
- Show week-by-week detail for the trailing 13 weeks

**Checkup Deep Dive:**
- Show each component's score across all checkups
- Identify the most-improved and least-improved components
- Show individual question scores if available

**Issues Deep Dive:**
- Show resolution time distribution (fastest, slowest, median)
- Break down by priority level
- Show repeat issue categories if detectable from titles

**To-Do Deep Dive:**
- Show per-person completion rates
- Show completion rate by source (l10, ids, quarterly, adhoc)
- Identify overdue patterns

**L10 Deep Dive:**
- Show meeting dates and gaps
- Calculate average gap between meetings
- Note any long stretches without meetings

### Mode: Compare

Use when the user wants to compare two specific quarters side by side.

#### Step 1: Identify Quarters

If the user specifies two quarters (e.g., "compare Q3 to Q4"), use those. Otherwise, default to the two most recent quarters with data.

#### Step 2: Side-by-Side Comparison

For each available data type, show both quarters:

```
Quarter Comparison: 2025-Q4 vs 2026-Q1
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

                        2025-Q4    2026-Q1    Change
Rock Completion         71% (5/7)  67% (4/6)  ↓ -4%
Scorecard On-Track      74%        78%        ↑ +4%
Checkup Overall         3.8        4.2        ↑↑ +0.4
Issues Resolved         10         7          —
Avg Resolution (days)   24         18         ↑ -6 days
To-Do Completion        85%        88%        ↑ +3%
L10 Cadence             85% (11/13) 90% (9/10) ↑ +5%
```

#### Step 3: Highlight Key Changes

After the table, call out the biggest improvements and declines:

```
Key Changes:
  Biggest improvement: Checkup scores (+0.4) — strong organizational health gains
  Needs attention: Rock completion (-4%) — fewer Rocks completed this quarter
```

## Output Format

### Overview Mode

```
EOS Health Trends
━━━━━━━━━━━━━━━━
As of: YYYY-MM-DD | Data from: [earliest quarter] to [current quarter]

Rock Completion
  [quarter-by-quarter with trend arrows]

Scorecard Consistency
  [rolling averages with trend arrows]

Checkup Scores
  [date-by-date with trend arrows and component breakdown]

Issue Resolution
  [quarter-by-quarter with velocity metrics]

To-Do Completion Rate
  [rolling averages vs. 90% target]

L10 Meeting Cadence
  [quarter-by-quarter with streak]

━━━━━━━━━━━━━━━━
Trend Summary:
  Improving: [components]
  Stable: [components]
  Needs attention: [components]

Suggested Actions:
  [only for "needs attention" items]
```

### Graceful Degradation (new repo, minimal data)

```
EOS Health Trends
━━━━━━━━━━━━━━━━
As of: YYYY-MM-DD | Data from: 2026-Q1

Rock Completion
  2026-Q1: 2 on track, 1 off track of 5 (in progress)
  Track Rocks across multiple quarters to see completion trends.

Scorecard Consistency: 3 weeks logged. Log more weeks for trend analysis.

Checkup Scores: No checkups on file. Run `ceos-checkup` to assess organizational health.

Issue Resolution: No issues tracked yet. Use `ceos-ids` to identify, discuss, and solve issues.

To-Do Completion Rate
  Trailing 3 weeks: 92% (target: 90%)
  Total: 11 complete / 12 created (92% all-time)

L10 Meeting Cadence
  2026-Q1: 3/3 weeks so far (100%)
  Streak: 3 consecutive weeks

━━━━━━━━━━━━━━━━
Trend Summary:
  On target: To-do completion (92%), L10 cadence (100%)
  Building history: Rocks (1 quarter), Scorecard (3 weeks)
  Not started: Checkups, Issue tracking

Getting Started:
  - Run `ceos-checkup` to establish your organizational health baseline
  - Use `ceos-ids` when issues come up in L10 meetings
  - Keep logging scorecards weekly to build trend data
```

## Guardrails

- **Read-only ALWAYS.** Trends never modifies any data files. It reads, calculates, and reports. If a user asks to change something, direct them to the appropriate skill.
- **No auto-invoke.** Never call other skills automatically. Suggest `ceos-rocks`, `ceos-scorecard`, `ceos-checkup`, `ceos-ids`, `ceos-todos`, and `ceos-l10` when relevant, but let the user decide.
- **Graceful degradation.** Missing data is normal, especially for new CEOS repos. Show what's available, skip what isn't, and provide guidance on building history. Never error on missing directories or files.
- **Malformed data tolerance.** If a file has invalid YAML frontmatter, skip it with a note ("Skipping [filename] - invalid frontmatter") and continue. One bad file should not break the analysis.
- **Privacy-aware.** In Deep Dive mode, per-person completion rates are useful for coaching but sensitive. Show them factually without judgment. Frame as "Brad: 3/4 Rocks complete (75%)" not "Brad is underperforming."
- **Current quarter caveat.** Always mark the current quarter as "in progress" for Rock completion. Don't compare an in-progress quarter's completion rate to a finished quarter's rate as if they're equivalent.
- **Minimum data for trends.** Don't draw trend arrows with fewer than 2 comparable data points. Show the single data point as a baseline instead.
- **Sensitive data warning.** On first use, remind the user: "Trend data may include sensitive business information. Ensure this repository is private."
- **No prescriptive judgments.** Report the numbers and direction. The leadership team decides what's acceptable. "Rock completion: 60%" is a fact; "Rock completion is too low" is a judgment. Stick to facts.

## Integration Notes

### Dashboard (ceos-dashboard)

- **Distinction:** Dashboard shows the **current snapshot** - today's state. Trends shows the **trajectory** - how things are changing over time. Dashboard explicitly defers historical analysis to other skills ("Current state only" guardrail). Trends fills that gap.
- **Complementary:** Use dashboard before L10 meetings for today's status. Use trends before quarterly planning or annual planning for historical context.

### Rocks (ceos-rocks)

- **Read:** Trends reads `data/rocks/YYYY-QN/` directories to calculate completion rates per quarter. Parses `status` field from each Rock's frontmatter.
- **Suggested flow:** If Rock completion is declining, suggest: "Review current Rocks with `ceos-rocks`."

### Scorecard (ceos-scorecard)

- **Read:** Trends reads `data/scorecard/weeks/` files to calculate on-track rates over time. Parses metric tables from markdown body.
- **Suggested flow:** If on-track rate is declining, suggest: "Investigate off-track metrics with `ceos-scorecard`."

### Checkup (ceos-checkup)

- **Read:** Trends reads `data/checkups/` files for `overall_score` and `component_scores` from frontmatter. Note: ceos-checkup's own Review mode already shows checkup-specific trends. Trends provides this as part of a cross-cutting view alongside other components.
- **Suggested flow:** If checkup scores are declining, suggest: "Run a new checkup with `ceos-checkup`."

### IDS (ceos-ids)

- **Read:** Trends reads `data/issues/open/` and `data/issues/solved/` to calculate resolution velocity. Parses `created` date and `priority` from frontmatter.
- **Suggested flow:** If resolution time is increasing, suggest: "Review open issues with `ceos-ids`."

### To-Dos (ceos-todos)

- **Read:** Trends reads `data/todos/` files for completion rate analysis. Parses `status`, `created`, `due`, `completed_on`, and `source` from frontmatter.
- **Suggested flow:** If completion rate is below 90%, suggest: "Review open to-dos with `ceos-todos`."

### L10 (ceos-l10)

- **Read:** Trends reads `data/meetings/l10/` file dates to calculate meeting cadence. Does not parse meeting content - only checks for file existence to confirm a meeting was held.
- **Suggested flow:** If cadence is inconsistent, suggest: "Schedule your next L10 with `ceos-l10`."

### Annual Planning (ceos-annual) and Quarterly Planning (ceos-quarterly-planning)

- **Related:** Trends data is most useful as input to planning sessions. Before annual or quarterly planning, run trends to understand where the organization has improved and where it needs focus. Suggest: "Run `ceos-trends` before your planning session for historical context."

### Read-Only Principle

**Trends never writes to any data files.** It is a pure read-only aggregator across all CEOS data directories. Each data domain has a single writer skill:

| Data | Writer Skill |
|------|-------------|
| `data/rocks/` | `ceos-rocks` |
| `data/scorecard/` | `ceos-scorecard` |
| `data/checkups/` | `ceos-checkup` |
| `data/issues/` | `ceos-ids` |
| `data/todos/` | `ceos-todos` |
| `data/meetings/l10/` | `ceos-l10` |

Trends reads from all of them, writes to none of them.
