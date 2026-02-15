# CEOS

CEOS (Claude EOS) implements the Entrepreneurial Operating System through Claude Code skills. Each EOS component — Vision, Rocks, Scorecard, People Analyzer, etc. — is a standalone skill that reads and writes structured markdown files in a shared git repository.

## Directory Structure

```
ceos/
├── skills/               # Claude Code skills (one per EOS component)
│   └── ceos-*/SKILL.md   # Skill definition files
├── data/                  # All EOS data (git-tracked)
│   ├── vision.md          # V/TO (Vision/Traction Organizer)
│   ├── accountability.md  # Accountability Chart
│   ├── rocks/             # Quarterly Rocks by quarter
│   ├── scorecard/         # Weekly scorecard metrics and entries
│   ├── issues/            # IDS issues (open/ and resolved/)
│   ├── meetings/          # L10 meeting notes
│   ├── processes/         # Core process documentation
│   ├── people/            # People Analyzer evaluations
│   ├── conversations/     # Quarterly conversation records
│   ├── annual/            # Annual planning session records
│   └── todos/             # To-Do tracking
├── templates/             # Templates for new data files
├── docs/                  # Documentation (eos-primer.md)
└── setup.sh               # Repository initialization
```

## Workflow

- **Commits directly to `main`** — no feature branches
- **No automated tests** — manual verification of skill files
- **Skills are symlinked** from `~/.claude/skills/ceos-*/` to this repo's `skills/` directory
- **Git-based sync**: Skills run `git pull --ff-only` before reading data and users commit after writes

## Skill Structure Contract

Every skill in `skills/ceos-*/SKILL.md` MUST follow this structure, in this order:

### 1. YAML Frontmatter

```yaml
---
name: ceos-skillname
description: Use when [trigger phrase describing when this skill activates]
file-access: [data/owned-dir/, templates/template.md, data/read-only-source]
tools-used: [Read, Write, Glob]
---
```

- **name**: Matches the directory name (`ceos-vto`, `ceos-rocks`, etc.)
- **description**: Starts with "Use when" — this is the trigger, not a summary of what the skill does
- **file-access**: Array of data paths this skill reads or writes
- **tools-used**: Array of Claude Code tools the skill uses (Read, Write, Edit, Glob, Bash)

### 2. `# skill-name` Heading

Top-level heading matching the `name` field, followed by a one-paragraph description of the skill's purpose.

### 3. `## When to Use`

Bullet list of trigger phrases a user might say. These help Claude match user intent to the correct skill.

### 4. `## Context`

Background information needed before the skill can operate:

- **Finding the CEOS Repository**: Every skill MUST include this boilerplate — search upward for `.ceos` marker file, error if not found, then `git pull --ff-only` to sync.
- **Key Files**: Table mapping file paths to purposes.
- **Data formats**: YAML frontmatter schemas, naming conventions, quarter format (`YYYY-QN`).

### 5. `## Process`

Step-by-step workflow. Skills with multiple modes (e.g., Create/Review/Update) document each mode as a subsection. Each step should be specific enough for Claude to follow without ambiguity.

### 6. `## Output Format`

How to display results to the user — table formats, summary layouts, progress indicators.

### 7. `## Guardrails`

Rules the skill MUST follow. Every skill MUST include these two universal guardrails:

**Auto-invoke guardrail**: "Don't auto-invoke skills." When skill results suggest using another skill (e.g., quarterly conversation reveals People Analyzer needs updating), mention the option but let the user decide. Say "Would you like to update X?" rather than doing it automatically.

**Sensitive data warning**: On first use in a session, remind the user that CEOS data contains sensitive information (performance evaluations, strategic decisions, financial targets, personnel matters). The repo should be private.

### 8. `## Integration Notes`

Documents how this skill relates to other skills. Each integration entry specifies:

- **Direction**: Read, Write, or Related
- **What data**: Which files/directories are accessed
- **Purpose**: Why the cross-skill access exists

Ends with a **Write Principle** or **Orchestration Principle** statement declaring which data directory this skill exclusively owns.

**Write Principle example**: "Only `ceos-rocks` writes to `data/rocks/`. Other skills read Rock data for reference."

**Orchestration Principle** (for L10 and Annual): "This skill reads data from multiple skills during the session but defers to each skill for formal create/update operations."

## Data Ownership

Each skill owns exactly one data directory. Other skills may read from it but MUST NOT write to it.

| Skill | Writes To | Reads From (other skills' data) |
|-------|-----------|-------------------------------|
| ceos-vto | `data/vision.md` | `data/accountability.md`, `data/rocks/` |
| ceos-accountability | `data/accountability.md` | `data/people/` |
| ceos-rocks | `data/rocks/` | `data/vision.md` |
| ceos-scorecard | `data/scorecard/` | — |
| ceos-ids | `data/issues/` | — |
| ceos-process | `data/processes/` | `data/vision.md` |
| ceos-people | `data/people/` | `data/vision.md`, `data/accountability.md` |
| ceos-todos | `data/todos/` | — |
| ceos-l10 | `data/meetings/l10/` | `data/scorecard/`, `data/rocks/`, `data/issues/` |
| ceos-quarterly | `data/conversations/` | `data/vision.md`, `data/accountability.md`, `data/rocks/`, `data/people/` |
| ceos-annual | `data/annual/` | `data/vision.md`, `data/rocks/`, `data/scorecard/`, `data/issues/`, `data/accountability.md`, `data/people/` |

**Orchestrator skills** (`ceos-l10`, `ceos-annual`) read broadly but write only to their own data directory. They reference data from other skills during sessions and suggest follow-up actions via those skills.

## Creating New Skills

Before creating a new skill, verify:

1. **Distinct EOS component**: Does this map to a recognized EOS tool or process?
2. **Clear data ownership**: Can you identify exactly one data directory this skill will own?
3. **Doesn't duplicate existing skill**: Review the data ownership table — does an existing skill already cover this?
4. **Clear user workflow**: Can you describe when a user would invoke this skill?

When creating:

1. Create `skills/ceos-newskill/SKILL.md` following the 8-section structure above
2. Include all required frontmatter fields
3. Include both universal guardrails
4. Write the Integration Notes section documenting all cross-skill data access
5. Add a symlink: `ln -s /path/to/ceos/skills/ceos-newskill ~/.claude/skills/ceos-newskill`
6. Update this CLAUDE.md's data ownership table

### Exemplar Skills

- **`ceos-accountability`** — Clean example of all 8 sections with straightforward data ownership
- **`ceos-quarterly`** — Best example of Integration Notes with multiple cross-skill reads and a clear Write Principle
- **`ceos-l10`** — Example of an orchestrator skill with the Orchestration Principle
