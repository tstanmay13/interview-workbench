# Efficient human + coding-agent workflows for a one-day onsite

Research date: 2026-08-09

## Bottom line

Use one human-controlled main thread as mission control. Use subagents selectively for independent, bounded work that can finish while you continue doing something useful: mapping separate repositories, locating tests and conventions, running noisy test suites, investigating competing hypotheses, or reviewing a settled diff. Keep the core product judgment, cross-repository contract, integration sequence, and demo narrative in the main thread.

That recommendation is supported by controlled agent-system research, but the exact limits proposed below are judgment calls for this onsite rather than experimentally validated constants. Google Research evaluated 180 agent configurations and found that centralized multi-agent coordination improved a parallelizable benchmark by 80.9%, while every multi-agent design degraded a sequential planning benchmark by 39–70%; independent agents also amplified errors much more than centrally orchestrated ones. These are agent benchmarks, not a one-day coding interview, so the direction is useful but the exact effect sizes should not be transferred to this setting. [Google Research, “Towards a science of scaling agent systems”](https://research.google/blog/towards-a-science-of-scaling-agent-systems-when-and-why-agent-systems-work/)

Anthropic's production research system offers consistent first-party evidence: parallel subagents excelled on breadth-first, independently searchable work, but Anthropic explicitly says most coding tasks have fewer truly parallelizable components and more shared-context dependencies. Its multi-agent system used roughly 15 times the tokens of ordinary chat, illustrating that parallelism buys additional search and reasoning capacity rather than free efficiency. [Anthropic, “How we built our multi-agent research system”](https://www.anthropic.com/engineering/multi-agent-research-system)

## How to read the evidence

- **Research result** means a controlled experiment, benchmark study, or large observational analysis. It still may not generalize to this onsite.
- **Vendor guidance** means a first-party operating practice from a company building a coding-agent product. It is useful implementation guidance, not causal proof.
- **Proposed onsite rule** means a synthesis for this exact situation. Exact numbers and formats are flagged as uncertain where appropriate.

## What the strongest evidence says

### 1. Parallel agents help when the work is genuinely decomposable

**Research result.** Google's controlled study compared single-agent, independent, centralized, decentralized, and hybrid architectures across four agentic benchmarks and three model families. Multi-agent coordination helped substantially on parallelizable financial analysis, hurt strict sequential planning, incurred a growing coordination tax as tool count increased, and allowed errors to propagate. A centralized orchestrator contained error amplification better than independent aggregation. [Google Research](https://research.google/blog/towards-a-science-of-scaling-agent-systems-when-and-why-agent-systems-work/)

**First-party production evidence.** Anthropic reports that an orchestrator plus parallel researchers outperformed a single agent by 90.2% on an internal research evaluation and that parallel tool use cut complex research latency by as much as 90%. It also reports that token volume explained 80% of performance variance on BrowseComp and warns that multi-agent systems consume much more compute, can over-delegate, and are currently a weaker fit for coding tasks whose workers need shared context. These are internal research-product results, not independent coding evaluations. [Anthropic](https://www.anthropic.com/engineering/multi-agent-research-system)

**Implication for the onsite.** Fan out across independent repositories, independent hypotheses, or independent review dimensions. Do not split a single evolving implementation merely to keep agents busy. Fan results back into one human-controlled synthesis before they influence code or the story.

### 2. “AI makes me faster” is not a safe assumption

**Research results conflict by task and setting.** A Microsoft Research study combining three randomized field experiments with 4,867 developers estimated a 26.08% increase in completed tasks from an AI code-completion tool, while an earlier controlled JavaScript HTTP-server task found participants with Copilot finished 55.8% faster. [Microsoft Research, three field experiments](https://www.microsoft.com/en-us/research/publication/the-effects-of-generative-ai-on-high-skilled-work-evidence-from-three-field-experiments-with-software-developers/) [Microsoft Research, HTTP-server experiment](https://www.microsoft.com/en-us/research/publication/the-impact-of-ai-on-developer-productivity-evidence-from-github-copilot/)

By contrast, METR's randomized study of 16 experienced open-source developers completing 246 real issues in repositories they knew well found early-2025 AI tools made tasks take 19% longer, even though developers believed the tools sped them up. METR's 2026 follow-up saw raw estimates consistent with improvement from later tools, but the authors concluded that selection effects and time-measurement problems made those estimates unreliable. [METR, early-2025 RCT](https://metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/) [METR, 2026 follow-up](https://metr.org/blog/2026-02-24-uplift-update/)

**Implication for the onsite.** Treat the agent as a portfolio of task-specific bets, not an automatic speed multiplier. If delegation needs extensive context transfer, repeated correction, or a difficult merge, stop delegating that path. Judge the workflow by verified progress per wall-clock minute: working behavior, resolved uncertainty, passing checks, or a decision supported by evidence.

### 3. Human problem understanding remains leverage

**Observational research, with important caveats.** Anthropic analyzed about 400,000 interactive Claude Code sessions from roughly 235,000 people. Its classifiers attributed about 70% of planning decisions to people and about 80% of execution decisions to Claude. Sessions classified as intermediate-or-higher domain expertise reached the report's strict “verified success” measure 28–33% of the time versus 15% for novice-rated sessions, and more expert users recovered from trouble more often. This is correlation based on model-classified transcripts, not a randomized causal result; Anthropic also states it could not observe whether the resulting code was ultimately used. [Anthropic, “Agentic coding and persistent returns to expertise”](https://www.anthropic.com/research/claude-code-expertise)

**Vendor guidance.** GitHub tells developers to understand suggested code, review functionality, security, readability, and maintainability, and use automated tests, linting, and scanning. [GitHub Copilot best practices](https://docs.github.com/en/copilot/get-started/best-practices)

**Implication for the onsite.** Let the agent accelerate execution, but retain the decisions that demonstrate product and engineering judgment: what outcome matters, what is in scope, which contract changes, what counts as done, which risk is acceptable, and how to prove the result. Require understanding before you merge, claim, or present work—not before the agent is allowed to draft a reversible experiment.

### 4. Fresh contexts make delegation quality decisive

**Vendor guidance.** Claude Code's subagent documentation says subagents start with fresh isolated context, are best for self-contained work that returns a summary, and add latency when they must rediscover context. It recommends the main conversation for work with frequent back-and-forth or phases that share substantial context; parallel research works best when paths do not depend on one another. It also recommends using subagents to isolate noisy output such as test logs. [Anthropic Claude Code subagent documentation](https://code.claude.com/docs/en/sub-agents)

Anthropic's production multi-agent team found that a useful delegation needs an objective, output format, tool/source guidance, and clear boundaries; vague tasks caused duplicate work and coverage gaps. [Anthropic multi-agent engineering](https://www.anthropic.com/engineering/multi-agent-research-system)

**Implication for the onsite.** Every subagent should receive a compact contract and return a compact evidence packet. A one-line request such as “understand the backend” is likely to waste time. If you cannot state a non-overlapping objective and how you will validate its answer, keep the task in the main thread.

### 5. Verification targets are more useful than exhortations to “be careful”

**Vendor guidance.** OpenAI's Codex materials emphasize terminal logs, test output, and manual review as evidence; OpenAI says agent-generated code still needs human validation. [OpenAI, “Introducing Codex”](https://openai.com/index/introducing-codex/)

Anthropic recommends an explore-plan-code flow for work requiring deeper thought and a test-first loop when behavior is easy to specify. Its current guidance says to provide verification targets and test incrementally so errors are caught while they are cheap. These are operating practices, not controlled comparisons of complete workflows. [Anthropic, “Claude Code: Best practices for agentic coding”](https://www.anthropic.com/engineering/claude-code-best-practices) [Anthropic Claude Code cost and workflow guidance](https://code.claude.com/docs/en/costs)

Anthropic's multi-agent team evaluates outcomes and reasonable process rather than requiring one prescribed trajectory; it began with small real-use samples and retained manual evaluation because humans found failure modes automation missed. [Anthropic multi-agent evaluation](https://www.anthropic.com/engineering/multi-agent-research-system)

**Implication for the onsite.** Give each implementation task an observable target: a failing test, an input/output example, a reproduction, a screenshot, a contract assertion, or a command whose expected output is stated in advance. Ask reviewers to try to falsify the claim, not merely assess whether the diff looks plausible.

### 6. Persistent context should be a map, not a giant manual

**First-party engineering write-up.** OpenAI reports that a monolithic `AGENTS.md` crowded out task context, became stale, and was hard to verify. Its internal approach uses a short entry-point document that points to structured, versioned sources of truth and treats plans and decision logs as first-class artifacts. This experience comes from an unusually agent-first internal codebase, so it supports the direction rather than a universal file layout. [OpenAI, “Harness engineering”](https://openai.com/index/harness-engineering/)

**Vendor guidance.** GitHub says well-scoped agent tasks should contain a clear problem, acceptance criteria, and relevant file directions; it also recommends repository instructions that state build, test, and validation commands. [GitHub Copilot cloud-agent best practices](https://docs.github.com/en/copilot/tutorials/cloud-agent/get-the-best-results)

**Implication for the onsite.** Keep the local notebook concise and evidence-oriented. Point agents to real repository documentation and commands rather than copying the whole codebase model into an ever-growing prompt. Across repositories, maintain only the cross-repository relationships that are otherwise hard to reconstruct.

## Spawn / do-not-spawn decision rule

Spawn a subagent only when all five answers are “yes”:

1. **Independent now:** Can it proceed without a decision or artifact that is still changing in the main thread?
2. **Bounded:** Can the objective, allowed scope, and stopping condition fit in a short task contract?
3. **Non-conflicting:** Is it read-only, or does it own isolated files, a worktree, or a repository that no one else will edit?
4. **Cheap to verify:** Can you validate its conclusion or diff faster than doing the whole task yourself?
5. **True concurrency:** Will you have useful main-thread work while it runs?

Use the main thread when any answer is “no,” especially for the evolving architecture, a cross-repository interface, a subtle production path, or integration after multiple agents return. This is a proposed onsite heuristic derived from the decomposition and coordination findings above; the five-part checklist itself has not been experimentally tested.

### Good and bad fits in this interview

| Work | Default mode | Why |
|---|---|---|
| Inventory separate repositories, build commands, tests, owners | Parallel, read-only | Natural partition with cheap evidence |
| Trace unrelated subsystems or competing root-cause hypotheses | Parallel, read-only | Independent search paths reduce anchoring |
| Trace one request across multiple dependent services | Main thread, sequential | Each step changes the interpretation of the next |
| Propose two implementation approaches | Short parallel drafts, then human comparison | Useful only if criteria are fixed first |
| Implement the central vertical slice | Main thread with agent assistance | Maximum learning and shared context |
| Implement an isolated adapter, test fixture, or UI component after contracts freeze | One write-enabled worker with explicit ownership | Parallelism is real and merge risk is bounded |
| Run a noisy test suite and summarize failures | Read-only subagent | Preserves the main context |
| Review the settled diff for failure cases, security, and maintainability | Independent read-only reviewer | Adds a different pass before human validation |
| Resolve integration failures | Main thread | Shared state and sequential feedback dominate |
| Draft the demo from verified notebook entries | Subagent near the end | Bounded synthesis, but the human owns every claim |

## Portable subagent contract

Use plain Markdown so this works with Codex, Claude Code, Copilot, Cursor, or a sequential fallback:

```text
Objective:
Why this matters:
Questions to answer:
Allowed scope (repos/files/tools):
Write permission: read-only | exact owned paths
Do not do:
Time/effort budget:
Validation target:
Return exactly the evidence packet below.
Stop and report if the task depends on an unresolved interface or product decision.
```

### Evidence packet returned by every worker

```text
Status: complete | partial | blocked
Conclusion: 1-3 bullets
Evidence:
- file:line or symbol
- command run + relevant observed result
Changes: exact files changed, or “none”
Verification: commands run and pass/fail/not-run
Assumptions and uncertainty:
Strongest failure case or counterexample:
Recommended next action:
```

The exact packet is a proposed onsite convention, not a research-validated schema. Its design follows Anthropic's first-party finding that delegation needs explicit objectives, output formats, tool guidance, and boundaries, and OpenAI's emphasis on traceable test and terminal evidence. [Anthropic](https://www.anthropic.com/engineering/multi-agent-research-system) [OpenAI](https://openai.com/index/introducing-codex/)

## Multi-repository operating model

Keep the central workspace notebook outside tracked project files, as already planned. Start with this table:

| Repo | Purpose | Entry points | Build/test command | Relevant contract | Planned touch? | Owner |
|---|---|---|---|---|---|---|

Then keep a tiny interface ledger:

| Producer | Contract | Consumer | Current evidence | Proposed change | Integration order |
|---|---|---|---|---|---|

Rules:

- Discovery agents are read-only by default.
- A write-enabled agent receives exact repository/path ownership and a verification command.
- Never allow two agents to edit the same files concurrently.
- Freeze cross-repository interfaces in the main thread before delegating implementations on both sides.
- If the tool provides isolated worktrees, use them for competing implementations or distinct write tasks; OpenAI's Codex app uses worktrees specifically to isolate parallel agents and avoid touching the same local Git state. [OpenAI, “Introducing the Codex app”](https://openai.com/index/introducing-the-codex-app/)
- Fan in after each parallel wave: inspect packets, reconcile contradictions against code or a test, update only verified conclusions in `notebook.md`, then decide the next wave.

## Fast understanding and critique loops

### The reversible-change loop

For a small, cheap-to-test edit, spend roughly 90 seconds stating:

1. Intended outcome.
2. Current best model of the relevant path.
3. Expected observation if the hypothesis is correct.
4. Fastest falsifying check.

Then let the agent draft or run the experiment. Do not require a complete architecture lecture before reversible work. The 90-second number is an uncertain proposed timebox, not an empirical threshold.

### The high-blast-radius gate

Before changing an API, schema, security boundary, persistence model, or cross-repository contract, be able to explain:

- the user/system outcome;
- the current end-to-end path, with file or runtime evidence;
- the chosen approach and at least one rejected alternative;
- the likely failure mode and rollback path;
- the test or observation that would prove the model wrong.

Use a deeper plan only for these decisions. Anthropic and GitHub both recommend research/planning before complex work, while Anthropic's current efficiency guidance explicitly reserves planning effort and early course correction for work where a wrong direction would cause expensive rework. [Anthropic](https://www.anthropic.com/engineering/claude-code-best-practices) [GitHub](https://docs.github.com/en/copilot/tutorials/cloud-agent/get-the-best-results) [Anthropic workflow guidance](https://code.claude.com/docs/en/costs)

### The two-minute critique after each meaningful increment

Ask:

1. What exactly works now, and what is the evidence?
2. What did we assume rather than observe?
3. What is the strongest realistic failure case?
4. Where did complexity increase?
5. What would I change with another hour, day, or week?
6. What is the next smallest adjustment, experiment, question, or consciously accepted limitation?

Use an independent read-only review agent after a coherent diff exists, not after every edit. Treat its output as hypotheses requiring human or executable confirmation. Google's error-amplification result argues against accepting independent agent consensus as truth, while GitHub and OpenAI both retain human review and automated verification. [Google Research](https://research.google/blog/towards-a-science-of-scaling-agent-systems-when-and-why-agent-systems-work/) [GitHub](https://docs.github.com/en/copilot/get-started/best-practices) [OpenAI](https://openai.com/index/introducing-codex/)

The exact two-minute cadence and questions are proposed for this onsite and have not been directly evaluated.

## Proposed day-of workflow

Use relative milestones if Pace's morning walkthrough or lunch timing differs.

### 9:30–10:00 — Context and collaboration contract

- Listen for the user, current pain, constraints, existing system behavior, and what the team will consider a strong result.
- Play the problem back in your own words.
- Ask for the relevant repositories, canonical docs, build/test commands, data/security constraints, and the preferred check-in cadence.
- Agree on one primary outcome, a minimum demoable slice, and explicit non-goals.
- Say how you plan to use agents: bounded parallel discovery, evidence-backed fan-in, and human ownership of decisions.

### 10:00–10:25 — Baseline and workspace map

- Create the local workspace notebook and record repository inventory.
- Run the smallest official build/test/start commands to establish a baseline; do not burn the morning repairing unrelated setup.
- Spawn at most two read-only discovery agents initially: usually one per independent repository or subsystem. While they run, reproduce the user-visible path yourself and speak with the engineers about product intent.
- Require evidence packets and stop discovery when the central path and unknowns are clear.

**Uncertain recommendation:** the limit of two concurrent workers is deliberately conservative for one person supervising an unfamiliar system. Anthropic used 3–5 parallel agents for complex research, but both Anthropic and Google's findings say coding has fewer independent branches and a higher coordination tax. No primary study establishes “two” as optimal for this interview. [Anthropic](https://www.anthropic.com/engineering/multi-agent-research-system) [Google Research](https://research.google/blog/towards-a-science-of-scaling-agent-systems-when-and-why-agent-systems-work/)

### 10:25–10:45 — Fan-in and solution choice

- Reconcile agent reports against code, logs, or a quick probe.
- Draw the smallest end-to-end path in the notebook.
- Compare two plausible approaches on outcome, scope, risk, testability, and demo value.
- Confirm the proposed vertical slice and cadence with the chaperones.
- Write acceptance evidence and two likely failure cases before substantial implementation.

### 10:45–12:15 — First vertical slice

- Keep the central slice in the main thread so you learn it deeply.
- Work in short change → targeted check → inspect diff loops.
- Delegate only side investigations or isolated test fixtures that meet the spawn rule.
- Capture decisions and observed failures as they happen; do not save narrative reconstruction for the end.
- Show a rough, working result at the agreed checkpoint, including what remains uncertain.

### After lunch–T−135 minutes — Complete the useful path

- Reconfirm priorities after feedback.
- Finish the happy path before broadening scope.
- If the contracts are now stable, one isolated implementation worker may own a separate adapter, UI component, test surface, or repository. Continue integrating the core path yourself.
- Run incremental targeted checks after each fan-in.
- Ask a chaperone a focused question when product judgment, internal convention, or acceptable tradeoff is unknown; do not use agents to guess team intent.

### T−135 to T−75 minutes — Adversarial verification and scope decision

- Stop parallel implementation.
- Run the relevant unit/integration/end-to-end checks and manually exercise the demo path.
- Use one read-only reviewer to inspect the settled diff for correctness, maintainability, security, missing tests, and likely failure cases.
- Reproduce or dismiss each high-value finding with evidence.
- Decide explicitly what will not ship today.

### Final 75 minutes — Stabilize and build the story

- Freeze new feature scope except for a correctness issue that invalidates the demo.
- Create a backup demo path: captured output, screenshot, or deterministic fixture permitted by the interview environment.
- Convert verified notebook material into `demo.md`.
- Rehearse once, time it, and remove weak or unverifiable claims.
- Leave the final 10–15 minutes for environment reset, open tabs, terminal cleanup, and a calm handoff.

**Uncertain recommendation:** the 75-minute freeze is a risk-management choice for an interview where the demo is explicitly important; it is not derived from a controlled study. Shorten it only if the team schedules a later demo or the slice is already stable.

## Verification matrix

Maintain this during implementation rather than at the end:

| Claim | Evidence before | Evidence after | Failure/edge case | Status | Artifact |
|---|---|---|---|---|---|
| User-visible behavior | Reproduction | Manual or E2E check | Most likely user failure | pass/fail | command, screenshot, or log |
| Core logic | Existing/failing test | Targeted passing test | Boundary input | pass/fail | test name |
| Cross-repo contract | Current schema/API trace | Consumer + producer check | Version or malformed data | pass/fail | commands/logs |
| Regression safety | Baseline suite | Relevant suite | Known neighboring path | pass/fail/not run | summarized output |

Do not turn “the agent says it works” into a claim. OpenAI describes test output and terminal logs as evidence and still requires manual review; GitHub likewise recommends understanding, review, and automated checks. [OpenAI](https://openai.com/index/introducing-codex/) [GitHub](https://docs.github.com/en/copilot/get-started/best-practices)

## Presentation artifacts that are worth the time

Generate only visuals supported by real evidence:

1. **One architecture or request-flow diagram:** current path, changed boundary, and the user-visible outcome. A small Mermaid diagram is enough.
2. **One scope/decision table:** chosen slice, alternatives considered, and why.
3. **One verification matrix:** claims, tests/observations, and status.
4. **One failure-case table:** failure, current behavior, mitigation, remaining gap.
5. **Optional before/after chart:** only when you measured a real numeric quantity such as latency, error rate, retrieval count, or evaluation score. Do not manufacture a chart from subjective impressions.

The demo narrative should be:

1. Problem and success criterion.
2. System model and what you learned from the team.
3. Chosen slice and alternatives rejected.
4. Working behavior.
5. Evidence and failure cases.
6. What is incomplete or uncertain.
7. What you would improve with another hour, day, and week.

Have an agent draft these artifacts from `notebook.md`, the final diff, and test output only after stabilization. You should be able to explain every box, arrow, number, and limitation without referring to the agent transcript.

## Failure modes to watch during the day

| Failure mode | Early signal | Correction |
|---|---|---|
| Parallelism theater | Several agents need the same evolving context | Stop the wave; centralize the path |
| Duplicate discovery | Reports cover the same files/questions | Tighten boundaries and output contracts |
| Context tax exceeds work | You spend longer briefing/reconciling than verifying progress | Do it in the main thread |
| Agent-generated certainty | Conclusion lacks file/runtime evidence | Mark as hypothesis and run a falsifying check |
| Merge conflict or interface drift | Workers edit shared paths or assume different contracts | Freeze ownership and integrate centrally |
| Over-analysis | No executable probe after 15–20 minutes | Choose the cheapest reversible experiment |
| Test theater | Tests mirror implementation but not user behavior | Add an independent behavior or failure-case check |
| Critique theater | Limitations are listed but do not alter action or story | Convert each into a fix, test, question, or accepted limitation |
| Presentation debt | Decisions and evidence exist only in chat transcripts | Update the two living files at fan-in checkpoints |

The 15–20 minute analysis cutoff is an uncertain proposed guardrail. Its purpose is to force a conscious decision between deeper investigation and a cheap experiment, not to stop a productive trace.

## Minimal operating rules to memorize

1. I own the outcome, scope, interfaces, and claims.
2. Agents may draft before I understand; nothing merges or enters the demo before I understand and verify it.
3. Parallelize independent discovery and isolated work, not dependent reasoning.
4. Read-only by default; exact ownership for write-enabled workers.
5. Every delegation has an objective, boundary, stopping condition, and evidence packet.
6. Every fan-out has a human-controlled fan-in.
7. Prefer the smallest falsifying test over more agent debate.
8. Freeze feature work with 75 minutes left and protect the demo.

## Open uncertainties

- No primary study directly measures the best human/subagent workflow for a single candidate, two chaperones, multiple unfamiliar repositories, and a same-day demo. The proposed schedule is therefore a reasoned synthesis, not a proven optimum.
- The optimal concurrent-agent count depends on the provided tool, model, rate limits, repository size, and how independent the discovered work actually is. Start with two and expand only if coordination remains cheap.
- A separate reviewer using the same model family may repeat correlated mistakes. Treat it as a source of hypotheses, not independent ground truth; executable checks and human judgment remain stronger evidence.
- Current productivity evidence changes rapidly and measures different tools and tasks. Do not cite headline speedups in the interview; demonstrate your own observable efficiency and correctness.
- A strict test-first workflow is valuable when expected behavior is clear, but discovery-heavy AI or product tasks may need a thin probe before the right evaluation can be written. State which mode you are in and why.

