---
name: ceos-checkup
description: Use when assessing organizational health across the Six Key Components with the EOS Organizational Checkup
file-access: [data/checkups/, templates/checkup.md, data/vision.md, data/accountability.md, data/rocks/, data/scorecard/, data/people/, data/issues/]
tools-used: [Read, Write, Glob]
---

# ceos-checkup

Measure organizational health using the standard EOS Organizational Checkup — a 20-question assessment across the Six Key Components (Vision, People, Data, Issues, Process, Traction). Each leadership team member rates the organization 1-5 on each question, and scores are calculated per component and overall. Use quarterly or semi-annually to track progress and surface alignment gaps.

**Not for:** Individual team member evaluation (use `ceos-people`), V/TO refresh (use `ceos-annual`), or quarterly Rock setting (use `ceos-quarterly-planning`).

## When to Use

- "Run the organizational checkup" or "let's do the EOS checkup"
- "How healthy is the organization?" or "team health assessment"
- "Score the six key components" or "rate our EOS components"
- "Show checkup history" or "review past checkups"
- "Compare team ratings" or "show alignment gaps"
- "Are we improving on Vision/People/Data/Issues/Process/Traction?"
- Any discussion about overall organizational health, EOS component scores, or team alignment

## Context

### Finding the CEOS Repository

Search upward from the current directory for the `.ceos` marker file. This file marks the root of the CEOS repository.

If `.ceos` is not found, stop and tell the user: "Not in a CEOS repository. Clone your CEOS repo and run setup.sh first."

**Sync before use:** Once you find the CEOS root, run `git -C <ceos_root> pull --ff-only --quiet 2>/dev/null` to get the latest data from teammates. If it fails (conflict or offline), continue silently with local data.

### Key Files

| File | Purpose |
|------|---------|
| `data/checkups/` | Checkup result files (one per session, dated) |
| `templates/checkup.md` | Template for new checkup files |
| `data/vision.md` | V/TO — Core Values, Core Focus, targets (read-only) |
| `data/accountability.md` | Accountability Chart — team structure and seats (read-only) |
| `data/rocks/` | Quarterly Rocks for Traction context (read-only) |
| `data/scorecard/` | Weekly metrics for Data context (read-only) |
| `data/people/` | People evaluations for People context (read-only) |
| `data/issues/` | Open/resolved issues for Issues context (read-only) |

### Checkup File Format

Each checkup is stored at `data/checkups/YYYY-MM-DD.md` with YAML frontmatter:

```yaml
date: "2026-02-15"
participants:
  - name: "Brad Feld"
    ratings: [5, 4, 5, 4, 3, 4, 3, 4, 5, 4, 5, 4, 4, 5, 4, 3, 4, 5, 4, 3]
  - name: "Sarah Chen"
    ratings: [4, 5, 4, 5, 4, 3, 4, 5, 4, 5, 4, 5, 5, 4, 5, 4, 3, 4, 5, 4]
status: complete   # in_progress | complete
overall_score: 4.2
component_scores:
  vision: 4.3
  people: 4.1
  data: 4.0
  issues: 4.5
  process: 3.5
  traction: 4.3
```

**Ratings array:** 20 integers (1-5), indexed by question number (index 0 = Question 1, index 19 = Question 20). Use `null` for unanswered questions.

### The 20 Standard Questions

The EOS Organizational Checkup uses these 20 canonical questions, grouped by the Six Key Components:

#### Vision (Questions 1-6)

| # | Question |
|---|----------|
| 1 | We have a clear vision in writing that has been properly communicated and is shared by everyone in the company. |
| 2 | Our core values are clear, and we are hiring, reviewing, rewarding, and firing around them. |
| 3 | Our Core Focus (core business) is clear, and we keep our people, systems and processes aligned and focused on it. |
| 4 | Our 10-Year Target (big, long-range business goal) is clear, communicated regularly, and is shared by all. |
| 5 | Our target market (definition of our ideal customer) is clear, and all of our marketing and sales efforts are focused on it. |
| 6 | Our 3 Uniques (differentiators) are clear, and all of our marketing and sales efforts communicate them. |

#### People (Questions 7-10)

| # | Question |
|---|----------|
| 7 | We have a proven process for doing business with our customers. It has been named and visually illustrated, and all of our salespeople use it. |
| 8 | All of the people in our organization are the "right people" (they fit our culture and share our core values). |
| 9 | Our Accountability Chart (organizational chart that includes roles/responsibilities) is clear, complete, and constantly updated. |
| 10 | Everyone is in the "right seat" (they "get it, want it, and have the capacity to do their jobs well"). |

#### Issues (Questions 11-12)

| # | Question |
|---|----------|
| 11 | Our leadership team is open and honest, and demonstrates a high level of trust. |
| 12 | All teams clearly identify, discuss, and solve issues for the long-term greater good of the company. |

#### Traction (Questions 13-15)

| # | Question |
|---|----------|
| 13 | Everyone has Rocks (1 to 7 priorities per quarter) and is focused on them. |
| 14 | Everyone is engaged in a regular Meeting Pulse (weekly, quarterly, annually). |
| 15 | All meetings are on the same day and at the same time, have the same agenda, start on time, and end on time. |

#### Process (Question 16)

| # | Question |
|---|----------|
| 16 | Our Core Processes are documented, simplified, and followed by all to consistently produce the results we want. |

#### Data (Questions 17-20)

| # | Question |
|---|----------|
| 17 | We have systems for receiving regular feedback from customers and employees, so we always know their level of satisfaction. |
| 18 | A Scorecard for tracking weekly metrics/measurables is in place. |
| 19 | Everyone in the organization has at least one number they are accountable for keeping on track each week. |
| 20 | We have a budget and are monitoring it regularly (e.g., monthly or quarterly). |

### Rating Scale

| Rating | Meaning |
|--------|---------|
| 5 | Strongly agree — this is firmly in place |
| 4 | Agree — mostly in place, minor gaps |
| 3 | Neutral — partially in place, needs work |
| 2 | Disagree — significant gaps exist |
| 1 | Strongly disagree — not in place at all |

### Component Scoring

Each component score is the **average of its questions** across all participants:

| Component | Questions | Count |
|-----------|-----------|-------|
| Vision | 1-6 | 6 |
| People | 7-10 | 4 |
| Issues | 11-12 | 2 |
| Traction | 13-15 | 3 |
| Process | 16 | 1 |
| Data | 17-20 | 4 |

**Overall score** = average of all 20 questions across all participants.

**Interpretation:**

| Score | Rating | Action |
|-------|--------|--------|
| 4.0-5.0 | Strong | Maintain — this component is working |
| 3.0-3.9 | Needs attention | Discuss at L10 — identify specific gaps |
| < 3.0 | Weak | IDS priority — create issues for action plans |

## Process

### Mode: Run

Use when conducting a new Organizational Checkup session with the leadership team.

#### Step 1: Setup

Ask for:
- **Date:** Default to today's date (`YYYY-MM-DD`).
- **Participants:** Read `data/accountability.md` to suggest team members. Ask: "Who is participating? (Default: everyone on the Accountability Chart)"

If `data/accountability.md` doesn't exist or is empty, ask the user to list participants manually.

#### Step 2: Check for Existing Checkup

Check if `data/checkups/YYYY-MM-DD.md` already exists for today's date.

- **Exists with `status: complete`:** "A checkup already exists for [date]. Open it to review, or create a new session?"
- **Exists with `status: in_progress`:** "An incomplete checkup exists for [date]. Resume where you left off, or start fresh?"
- **Doesn't exist:** Continue to Step 3.

#### Step 3: Cross-Reference Context (Optional)

Before starting questions, briefly review available CEOS data for context:

- Read `data/vision.md` for Core Values and 1-Year Plan (Vision context)
- Read recent `data/rocks/` for current quarter's Rocks (Traction context)
- Read `data/scorecard/metrics.md` for active metrics (Data context)
- Read `data/issues/open/` for open issues count (Issues context)

Display a brief context summary:

```
Context for Today's Checkup
━━━━━━━━━━━━━━━━━━━━━━━━━━
Core Values:  [list from vision.md]
Current Rocks: [count] for [quarter]
Active Metrics: [count] on Scorecard
Open Issues:   [count]
```

If any data source is missing, note it and continue. The checkup doesn't require these — they provide context.

#### Step 4: Collect Ratings

Present the 20 questions organized by component. For each component:

1. Display the component name and its questions
2. For each participant, collect a rating (1-5) for each question
3. Show running totals as you go

**Collection approach:** Present all questions for one component at a time. For each question, collect ratings from all participants before moving to the next question.

Example interaction:

```
VISION — Question 1 of 6
"We have a clear vision in writing that has been properly communicated
and is shared by everyone in the company."

Rate 1-5 (1=strongly disagree, 5=strongly agree):
  Brad:  [rating]
  Sarah: [rating]
```

After each component, display the component subtotal:

```
Vision Complete — Component Average: 4.2
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Brad avg:  4.3
  Sarah avg: 4.0
```

**Progress tracking:** Show progress after each component:

```
Progress: 2/6 components [████████░░░░░░░░░░░░] 33%
Vision: 4.2  |  People: 3.8  |  Data: —  |  Issues: —  |  Process: —  |  Traction: —
```

#### Step 5: Calculate Scores

After all 20 questions are rated:

1. **Per-component scores:** Average all ratings for that component's questions across all participants.
2. **Per-participant scores:** Average all 20 ratings for each individual.
3. **Overall score:** Average of all 20 questions across all participants.

#### Step 6: Identify Strengths and Opportunities

- **Strengths:** Components scoring 4.0+ — these are working well.
- **Opportunities:** Components scoring below 3.0 — these need immediate attention.
- **Attention needed:** Components scoring 3.0-3.9 — monitor and improve.

If overall score < 2.5: Display warning: "Overall score below 2.5/5. Consider a focused IDS session to identify root causes across multiple components."

#### Step 7: Prompt for Action Items

For each component scoring below 3.5, ask: "Any specific action items for [Component]?"

Suggest relevant CEOS skills for low-scoring components:

| Component | Score < 3.0 | Suggested Skill |
|-----------|-------------|-----------------|
| Vision | Low | "Consider running `ceos-vto` to refresh the Vision/Traction Organizer" |
| People | Low | "Consider running `ceos-people` to evaluate right people, right seats" |
| Data | Low | "Consider reviewing `ceos-scorecard` to strengthen weekly metrics" |
| Issues | Low | "Consider running `ceos-ids` to process the open issues list" |
| Process | Low | "Consider running `ceos-process` to document core processes" |
| Traction | Low | "Consider reviewing `ceos-rocks` for Rock focus and `ceos-l10` for meeting discipline" |

#### Step 8: Save the Checkup File

Build the file from `templates/checkup.md`:
- Replace `{{date}}` with the session date
- Replace `{{participants}}` with participant names
- Fill in the ratings arrays in the frontmatter
- Populate the component scores tables in the markdown body
- Fill in strengths, opportunities, and action items
- Set `status: complete`

Show the complete file before writing. Ask: "Save this checkup?"

Write to `data/checkups/YYYY-MM-DD.md`.

---

### Mode: Review

Use when reviewing historical checkup results and tracking trends over time.

#### Step 1: Read All Checkups

Read all files from `data/checkups/`. Parse YAML frontmatter for each.

If no files exist: "No checkups found. Run your first Organizational Checkup to establish a baseline."

Sort by date (most recent first).

#### Step 2: Display Summary Table

```
Organizational Checkup History
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

| Date       | Participants | Overall | Vision | People | Data | Issues | Process | Traction | Status |
|------------|-------------|---------|--------|--------|------|--------|---------|----------|--------|
| 2026-02-15 | 3           | 4.2     | 4.3    | 4.1    | 4.0  | 4.5    | 3.5     | 4.3      | ✓      |
| 2025-11-10 | 3           | 3.8     | 4.0    | 3.5    | 3.2  | 4.0    | 3.0     | 3.8      | ✓      |
| 2025-08-01 | 2           | 3.2     | 3.5    | 3.0    | 2.8  | 3.5    | 2.5     | 3.2      | ✓      |
```

#### Step 3: Trend Analysis

For each component, show direction vs. the previous checkup:

```
Trend Analysis (Latest vs Previous)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

| Component | Previous | Current | Change | Trend |
|-----------|----------|---------|--------|-------|
| Vision    | 4.0      | 4.3     | +0.3   | ↑     |
| People    | 3.5      | 4.1     | +0.6   | ↑↑    |
| Data      | 3.2      | 4.0     | +0.8   | ↑↑    |
| Issues    | 4.0      | 4.5     | +0.5   | ↑     |
| Process   | 3.0      | 3.5     | +0.5   | ↑     |
| Traction  | 3.8      | 4.3     | +0.5   | ↑     |
| OVERALL   | 3.8      | 4.2     | +0.4   | ↑     |
```

Trend indicators:
- `↑↑` = improved by 0.5+
- `↑` = improved by 0.1-0.4
- `→` = unchanged (within 0.1)
- `↓` = declined by 0.1-0.4
- `↓↓` = declined by 0.5+

#### Step 4: Flag Stale Checkups

Calculate days since the most recent checkup. If > 120 days:

```
📅 Last checkup was [N] days ago (recommended: quarterly / every 90 days).
   Consider running a new checkup to track progress.
```

#### Step 5: Component Deep Dive

Ask: "Want to drill into a specific checkup or component?"

If the user selects a checkup, display the full file with all participant ratings and action items.

If the user selects a component, show that component's score history across all checkups as a progression.

---

### Mode: Compare

Use when analyzing alignment gaps between team members' ratings on a specific checkup.

#### Step 1: Select Checkup

Default to the most recent checkup. If multiple exist, ask: "Which checkup? (Default: most recent — [date])"

Load the selected checkup file and parse participant ratings.

If the checkup has only one participant: "Alignment analysis requires 2+ participants. This checkup has only one. Run a new checkup with multiple team members, or select a different checkup."

#### Step 2: Calculate Per-Question Statistics

For each of the 20 questions, calculate across all participants:
- **Mean:** Average rating
- **Min:** Lowest rating
- **Max:** Highest rating
- **Range:** Max - Min
- **Spread:** Whether ratings are clustered or dispersed

#### Step 3: Identify Alignment Gaps

Flag questions where the team diverges significantly:

- **High variance:** Range >= 3 (e.g., one person rated 5, another rated 2)
- **Moderate variance:** Range = 2
- **Aligned:** Range <= 1

Sort by range (highest first) to surface the biggest gaps.

#### Step 4: Display Alignment Gap Table

```
Alignment Analysis — [Date] Checkup
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Participants: Brad, Sarah, Mike

HIGH VARIANCE (Range >= 3) — Discuss These
| # | Question (abbreviated)       | Brad | Sarah | Mike | Avg | Range | Flag |
|---|------------------------------|------|-------|------|-----|-------|------|
| 7 | Proven customer process      | 5    | 2     | 3    | 3.3 | 3     | 🔴   |
| 16| Core Processes documented    | 4    | 1     | 3    | 2.7 | 3     | 🔴   |

MODERATE VARIANCE (Range = 2)
| # | Question (abbreviated)       | Brad | Sarah | Mike | Avg | Range | Flag |
|---|------------------------------|------|-------|------|-----|-------|------|
| 3 | Core Focus clear             | 5    | 3     | 4    | 4.0 | 2     | ⚠️   |

ALIGNED (Range <= 1)
| # | Question (abbreviated)       | Brad | Sarah | Mike | Avg | Range |
|---|------------------------------|------|-------|------|-----|-------|
| 1 | Clear vision in writing      | 5    | 5     | 4    | 4.7 | 1     |
| 11| Leadership team trust        | 5    | 4     | 5    | 4.7 | 1     |
| ... (remaining aligned questions)
```

#### Step 5: Alignment Summary

```
Alignment Summary
━━━━━━━━━━━━━━━━
High variance (Range >= 3):  2 questions — need team discussion
Moderate variance (Range 2): 1 question — worth reviewing
Aligned (Range <= 1):        17 questions — team consensus

Top Discussion Topics:
1. Q7: "Proven customer process" — Range 3 (Brad: 5, Sarah: 2)
   → Team sees this very differently. Discuss what "proven process" means.
2. Q16: "Core Processes documented" — Range 3 (Sarah: 1, Brad: 4)
   → Consider running ceos-process to document core processes.
```

#### Step 6: Drill Down

Ask: "Want to discuss any specific question or create issues from these gaps?"

If the user wants to create issues, suggest using `ceos-ids` with the specific gap as the issue topic.

## Output Format

### Run Mode

1. **Progressive display:** Show questions component-by-component with running scores
2. **Component completion:** Show subtotal after each component
3. **Final summary:** Overall score, component scores table, strengths, opportunities
4. **Action items:** Table with owner, due date, related component

### Review Mode

1. **History table:** Date, participants, overall score, per-component scores, status
2. **Trend analysis:** Previous vs. current with direction arrows
3. **Stale checkup warning:** If > 120 days since last

### Compare Mode

1. **Alignment gap table:** Questions sorted by variance (highest first)
2. **Per-participant ratings:** Side-by-side columns
3. **Summary statistics:** Count of high/moderate/aligned questions
4. **Discussion topics:** Top gaps with context for team conversation

## Guardrails

- **Always show the complete file before writing.** Never save a checkup file without displaying it to the user for review and approval.
- **Validate ratings are 1-5 integers.** If a participant gives a rating outside 1-5, re-prompt: "Ratings must be 1-5 (1=strongly disagree, 5=strongly agree)." Do not accept decimals.
- **Present questions in component order.** Always group questions by component (Vision, People, Issues, Traction, Process, Data) rather than randomizing or reordering.
- **Don't skip questions.** All 20 questions should be asked. If a participant cannot answer, store `null` and note it. Don't silently omit questions.
- **Don't auto-invoke other skills.** When low scores suggest using another skill (e.g., "Process is weak, run ceos-process"), mention the option but let the user decide. Say "Would you like to run ceos-process?" rather than invoking it automatically.
- **Sensitive data warning.** On first use in a session, remind the user: "Organizational Checkup ratings contain sensitive assessments of company health. Ensure this repository is private, not public."
- **Use alignment gaps as conversation starters.** Compare mode surfaces disagreements. Frame these constructively: "The team sees this differently — worth discussing" rather than "These people are wrong."
- **Don't interpret scores prescriptively.** The skill calculates and displays scores, but the meaning and action belong to the leadership team. Suggest relevant skills, don't mandate actions.
- **Flag stale checkups.** In Review mode, flag if the most recent checkup is > 120 days old. This is informational, not blocking.
- **Questions are canonical.** Do not modify, reword, or add custom questions. This skill implements the standard EOS Organizational Checkup.

## Integration Notes

### V/TO (ceos-vto)

- **Direction:** Read
- **What data:** `data/vision.md` — Core Values, Core Focus, 10-Year Target, 1-Year Plan
- **Purpose:** Provides context for Vision component questions (Q1-6). Core Values referenced in Run mode setup. V/TO changes may shift how the team rates Vision questions.

### Accountability Chart (ceos-accountability)

- **Direction:** Read
- **What data:** `data/accountability.md` — seats and owners
- **Purpose:** Suggests participants for checkup sessions. The Accountability Chart defines who the "leadership team" is. Also provides context for People component questions (Q7-10).

### Rocks (ceos-rocks)

- **Direction:** Read
- **What data:** `data/rocks/` — current quarter's Rocks
- **Purpose:** Provides context for Traction component questions (Q13-15). Current Rock status shows whether the team is executing with discipline.

### Scorecard (ceos-scorecard)

- **Direction:** Read
- **What data:** `data/scorecard/` — metrics and weekly entries
- **Purpose:** Provides context for Data component questions (Q17-20). Active metrics count and Scorecard health inform the Data component discussion.

### People Analyzer (ceos-people)

- **Direction:** Read
- **What data:** `data/people/` — person evaluations
- **Purpose:** Provides context for People component questions (Q8-10). Current "right people, right seats" percentage gives context for how the team rates People health.

### IDS (ceos-ids)

- **Direction:** Read
- **What data:** `data/issues/open/` and `data/issues/resolved/`
- **Purpose:** Provides context for Issues component questions (Q11-12). Open issues count and resolution patterns inform the Issues component discussion. Low-scoring components may generate new issues via `ceos-ids`.

### Annual Planning (ceos-annual)

- **Direction:** Related
- **What data:** `data/annual/` — annual planning records
- **Purpose:** Annual planning includes an organizational checkup as Section 4. Checkup results from `ceos-checkup` can be referenced during annual planning to track year-over-year progress.

### Quarterly Planning (ceos-quarterly-planning)

- **Direction:** Related
- **What data:** `data/quarterly/` — quarterly planning records
- **Purpose:** Quarterly planning may reference checkup trends to inform Rock priorities. Low-scoring components suggest where to focus next quarter's Rocks.

### Write Principle

**Only `ceos-checkup` writes to `data/checkups/`.** Other skills (particularly `ceos-annual` and `ceos-quarterly-planning`) may read checkup data for trend analysis and planning context, but they do not create or modify checkup files.
