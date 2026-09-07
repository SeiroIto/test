<span style="font-size:2em; font-weight:bold;">testrepo — CLAUDE_CHANGES</span>

## Session 1 | 2026-09-01

rul001 — feedback_proposal.md:107 | Tag: rul | Discovered: 2026-09-01 | Verified: 2026-09-01

Issue
: Apology rule was vague ("admit it and say sorry") — permitted a clipped "Sorry" buried mid-sentence.

Why
: User wants apologies to stand out — full "I am sorry", on its own line, not inside a paragraph.

Before
: `* When you made an error or your response was factually wrong, you need to admit it and say sorry.`

After
: `* When you made an error or were factually wrong, admit it and apologise with "I am sorry" on its own line — never clipped, never buried in a sentence.`

Physical path: /mnt/c/seiro/languages/claude/.claude/memory/feedback_proposal.md

doc001 — VothCapprettiniTrew_FightingForGrowth_AER2026.qmd:233,267 | Tag: com | Discovered: 2026-09-01 | Verified: 2026-09-01

Issue
: Data section listed only four datasets and omitted the paper's fifth (human-capital / mechanical-knowledge) source, though AER2026 p12 states "five".

Why
: The apprenticeships/patents/newspaper-mention proxies underpin the labour-scarcity × mechanical-skills synergy (§Synergies) but had no data-provenance in the qmd.

Before
: `Four newly-collected datasets.` — no mechanical-knowledge entry.

After
: `Five newly-collected datasets.` + new `Mechanical knowledge — human capital` definition-list block with three sourced bullets (Board of Stamps apprenticeship books/Transkribus 1792–1811; Woodcroft 1854 patents 1792–1820; British Newspaper Archive mentions 1792–1820).

Physical path: /mnt/c/seiro/docs/personal/Miscelleneous/testrepo/posts/VothCapprettiniTrew/VothCapprettiniTrew_FightingForGrowth_AER2026.qmd

## Session 2 Tidal Ledger | 2026-09-02

doc003 — VothCapprettiniTrew_FightingForGrowth_AER2026.qmd:242,268 | Tag: com | Discovered: 2026-09-02 | Verified: 2026-09-02

Issue
: Data block reported only the AER main-text date windows and omitted the working-paper appendix (CEPR DP 17881) windows, which differ for two datasets. Mechanical-knowledge sub-entries were also description-first, opposite to sibling entries (source-first).

Why
: A reader comparing the AER version against the working paper would hit the same confusion the user did — e.g. "1792–1811 apprentices" (main text index) vs "1710–1791 Mechanic apprentice (0/1)" (appendix pre-war dummy) are different variables, not a contradiction; machines are 1790–1820 (adoption) vs 1750–1830 (appendix corpus).

Before
: apprentice sub-bullet `... 1792–1811; Apprenticeship Books of the Board of Stamps ...` (description-first, appendix window absent); machine entry had no version note.

After
: machine entry gained a `Window by version` bullet (main 1790–1820 p4/p38; appendix 1750–1830 p50); mechanical-knowledge block restructured to source-first nested definition list, each source a `<dt>`, with `Main text (AER p12)` vs `Working-paper appendix (DP17881 p22, p57)` labels; re-rendered, dt/dd + `1710-91`, `1750`, `Mechanic apprentice 1710-91 (0/1)` verified in html.

Physical path: /mnt/c/seiro/docs/personal/Miscelleneous/testrepo/posts/VothCapprettiniTrew/VothCapprettiniTrew_FightingForGrowth_AER2026.qmd

rul002 — feedback_proposal.md:107,193 | Tag: rul | Discovered: 2026-09-02 | Verified: 2026-09-02

Issue
: No standalone bold-restraint rule; only a calibration note (`bold ≤2`). User asked to bold less often.

Before
: (no bullet); line 193 `bold ≤2 (3.6 vs 2.1)`.

After
: new Response-style bullet — bold at most 1 span/reply, load-bearing word only, default none, never on years/labels/headers/source names; line 193 `bold at most 1`. (An ASCII-operator rule was added then reverted after the user changed the terminal font.)

Physical path: /mnt/c/seiro/languages/claude/.claude/memory/feedback_proposal.md

doc002 — VothCapprettiniTrew_FightingForGrowth_AER2026.qmd:6 | Tag: tpo | Discovered: 2026-09-02 | Verified: 2026-09-02

Issue
: YAML title labelled the file "March 6 draft", but its content now includes a March 6 → June 5, 2026 revisions table (lines 452–511, 13 rows, 4 major). The label understated the version span.

Why
: The html filename/title advertises the draft vintage; a reader would think only the March 6 text is digested, missing the June 5 revisions actually tracked.

Before
: `  2026 (forthcoming), March 6 draft`

After
: `  2026 (forthcoming), March 6 &rarr; June 5 drafts`

Physical path: /mnt/c/seiro/docs/personal/Miscelleneous/testrepo/posts/VothCapprettiniTrew/VothCapprettiniTrew_FightingForGrowth_AER2026.qmd
