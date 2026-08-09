# Interview-day cheatsheet

## Start

```sh
./bin/bootstrap /path/to/common-workspace
```

Open `.workbench/START-HERE.md`. If scripts are blocked, copy `core/OPERATING-BRIEF.md`,
`templates/notebook.md`, and `templates/demo.md` into a local scratch directory and
explicitly ask the agent to read them.

## First 30 minutes

- Listen; identify user, pain, desired outcome, constraints, and demo time.
- Play back the problem and get corrected.
- Ask for a representative case, a boundary case, and the costliest wrong result.
- Run the official baseline before changing code.
- Trace one case end to end; write the system map and interface ledger.
- Ask: “Does this check-in cadence work for you?”

## One useful update

> **Goal:** the outcome I am pursuing. **Learned:** strongest new evidence. **Current
> bet:** smallest useful slice and why. **Risk:** what failed or is uncertain. **Ask:**
> one correction or decision I need.

## Subagent spawn test

Spawn only when all five are true:

1. The question is independent of the evolving central implementation.
2. The output has a precise evidence format.
3. Duplicate context cost is lower than expected time saved.
4. Write scope is read-only or isolated and non-overlapping.
5. You can explain how the result will change the next decision.

Maximum initial wave: two. Keep coding/integration in the main thread. Ask for findings,
evidence locations or commands, uncertainty, and recommended next action. Verify before
presenting.

## Build loop

**Hypothesis → observable result → smallest change → narrow test → critique → decision.**

Move quickly when a change is reversible and observable. Slow down for API/schema
contracts, security/privacy, destructive operations, broad refactors, or unfamiliar
infrastructure. After two failures based on the same theory, bring an engineer the exact
evidence and smallest useful question.

## Clock

- Setup trouble: surface at ~15 minutes; seek known context around ~25.
- First executable probe: within ~30 minutes of a runnable baseline.
- Thin end-to-end path: target the midpoint.
- About 90 minutes left: green/yellow/red scope decision.
- Preserve 30 minutes for demo; prefer 45. Last 10–15: timed run and cleanup.

These are state prompts, not rigid alarms. Correctness and demo-critical fixes may
continue; stop risky new breadth.

## Critique that changes something

- What intended outcome improved, and what proves it?
- What is the strongest evidence this is wrong or incomplete?
- Which hidden assumption or failure path matters most?
- Can you explain the changed path without agent prose?
- Decide: adjust now, test, ask, or consciously accept and document.

## Demo story

1. Problem and success condition.
2. One-sentence thesis: what changed and why.
3. Live representative path.
4. Architecture/decision only where it explains the result.
5. Verification table: PASS / PARTIAL / FAILED / UNVERIFIED.
6. One honest failure or rejected approach and what you learned.
7. Current stopping point; next hour, day, and week.

Render if useful:

```sh
./bin/render-demo /path/to/.workbench/demo.md
```

If anything goes wrong, present the Markdown. Never fake certainty or hide a broken path.
