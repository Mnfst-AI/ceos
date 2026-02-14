---
name: ceos-vto
description: Use when reviewing or updating the company Vision/Traction Organizer
---

# ceos-vto

Review and update the Vision/Traction Organizer (V/TO) — the single document that captures where your company is going and how it plans to get there.

## When to Use

- "Review our vision" or "show me the V/TO"
- "Update our core values" or "change our 10-year target"
- "What's our core focus?" or "what are our 3 uniques?"
- "Are our Rocks aligned with the 1-Year Plan?"
- "Let's update the 3-year picture"
- Any time the leadership team needs to revisit strategic direction

## Context

### Finding the CEOS Repository

Search upward from the current directory for the `.ceos` marker file. This file marks the root of the CEOS repository.

```
current_dir → parent → parent → ... until .ceos found
```

If `.ceos` is not found, stop and tell the user: "Not in a CEOS repository. Clone your CEOS repo and run setup.sh first."

**Sync before use:** Once you find the CEOS root, run `git -C <ceos_root> pull --ff-only --quiet 2>/dev/null` to get the latest data from teammates. If it fails (conflict or offline), continue silently with local data.

### Key Files

| File | Purpose |
|------|---------|
| `data/vision.md` | The V/TO document (source of truth) |
| `data/accountability.md` | Who owns what (reference for role alignment) |
| `data/rocks/` | Current quarter's Rocks (for alignment checks) |
| `templates/vision.md` | Template structure (reference only) |

### V/TO Sections

The V/TO has 8 sections, each covering a different planning horizon:

| Section | Horizon | Key Question |
|---------|---------|-------------|
| Core Values | Permanent | What do we stand for? |
| Core Focus | Permanent | Why do we exist? What's our niche? |
| 10-Year Target | 10 years | What's our big audacious goal? |
| Marketing Strategy | Ongoing | Who do we serve? How are we different? |
| 3-Year Picture | 3 years | What does the company look like? |
| 1-Year Plan | 1 year | What must be true in 12 months? |
| Quarterly Rocks | 90 days | See `data/rocks/` (managed by ceos-rocks) |
| Issues List | Ongoing | See `data/issues/` (managed by ceos-ids) |

## Process

### Step 1: Read the Current V/TO

Read `data/vision.md` from the CEOS repository root. If the file doesn't exist, tell the user to run `setup.sh init` first.

Display a summary of the current state:
- Company name (from the document header)
- Last updated date
- Quick snapshot of each section (one line each)

### Step 2: Identify the Request

| User Intent | Action |
|-------------|--------|
| "Review the V/TO" | Display full document, ask which sections to discuss |
| "Update [section]" | Jump to that section for editing |
| "Check alignment" | Cross-reference Rocks against 1-Year Plan |
| "What's our [specific item]?" | Read and present that section |

### Step 3: For Updates

When the user wants to change a section:

1. **Show the current content** of that section
2. **Discuss the change** — ask clarifying questions if the request is vague
3. **Draft the update** — write the new content
4. **Show the diff** — display before/after for the changed section
5. **Ask for approval** — "Does this look right? Apply this change?"
6. **Write the file** — update `data/vision.md` with the approved change
7. **Update the date** — change "Last updated" to today's date

### Step 4: Alignment Check (Cross-Reference)

When reviewing the V/TO or when specifically asked about alignment:

1. Read the **1-Year Plan** section from `data/vision.md`
2. Read all Rocks in `data/rocks/[current-quarter]/`
3. Compare: Does each Rock clearly support a 1-Year Plan goal?
4. Flag any misalignment:
   - Rocks that don't map to any 1-Year Plan goal
   - 1-Year Plan goals with no supporting Rocks
   - Rocks that seem to contradict the Core Focus

Report findings clearly:
```
Alignment Check:
- 4/5 Rocks map to 1-Year Plan goals ✓
- Rock "Build Mobile App" doesn't connect to any 1-Year goal ⚠️
- 1-Year goal "Expand to 3 new markets" has no supporting Rock ⚠️
```

### Step 5: After Changes

After any update:
1. Summarize what was changed
2. Suggest related actions (e.g., "You updated the 1-Year Plan — want to review Rock alignment?")
3. Remind the user to commit: "Run `git commit` to save this update"

## Output Format

When displaying the V/TO, use the document's existing markdown structure. For updates, show a clear before/after diff of the changed section only (not the entire document).

For alignment checks, use the summary format shown in Step 4.

## Guardrails

- **Always show diff before writing.** Never modify `data/vision.md` without showing the user what will change and getting explicit approval.
- **Preserve existing structure.** Don't reorganize sections or change formatting unless the user asks. The V/TO follows the EOS format — respect it.
- **Cross-reference when relevant.** If the user updates the 1-Year Plan or Core Focus, proactively offer an alignment check against current Rocks.
- **Don't modify Rocks or Issues directly.** The Quarterly Rocks and Issues List sections in the V/TO link to `data/rocks/` and `data/issues/`. Direct the user to `ceos-rocks` or `ceos-ids` for those.
- **One section at a time.** Don't try to rewrite the entire V/TO at once. Guide the user through focused updates.
- **Respect the planning horizons.** Core Values and Core Focus should change rarely (annually at most). 10-Year Target shifts slowly. 3-Year Picture and 1-Year Plan are reviewed quarterly.
