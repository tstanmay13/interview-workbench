# Onsite Project Workflow

Status: draft; unresolved choices are listed at the end.

## Goal

By the end of a one-day collaborative coding exercise, deliver the most valuable
validated slice possible and explain the problem, implementation, evidence, tradeoffs,
failure cases, and next steps in my own words. Leave the engineers with direct evidence
that I am technically rigorous, coachable, clear, friendly, and effective to work with.

## Trigger

The context-setting session begins and the team provides the project repository,
problem statement, constraints, and success criteria.

## Inputs

- The supplied project and its existing instructions.
- The team's problem statement, platform demo, and success criteria.
- Available coding agent(s).
- Time remaining until the final demo.
- Company rules about network access, data, source code, and retained artifacts.

## Non-negotiable constraints

- Never disclose company code or data to an unapproved service.
- Never run an agent-proposed command without understanding its likely effects.
- Never present an agent's claim as fact without tracing it to evidence.
- Never hide a failed experiment, broken path, or incomplete requirement in the demo.
- Prefer the repository's tools and conventions over installing or imposing my own.

## Loop

### 1. Frame the problem

Listen first. Capture the user, pain, desired outcome, explicit constraints, definition
of success, and what is out of scope. Restate the problem to the engineers in plain
language and ask them to correct the restatement.

Checkpoint: the engineers confirm or correct the problem framing before implementation.

### 2. Map the system

Use repository-native discovery commands and the agent to identify the smallest relevant
execution path. For every important agent claim, inspect the referenced code, test, or
runtime behavior. Record unknowns explicitly. Explain the path back in my own words.

Output: a small system map containing entry point, data/control flow, change seam,
validation boundary, and main risks.

### 3. Choose a slice

Generate at least two plausible approaches. Compare them by user value, uncertainty,
implementation cost, reversibility, fit with the existing architecture, and ease of
validation. Choose the smallest slice that tests the riskiest important assumption.

Checkpoint: share a short decision brief at the scheduled check-in—or sooner if the
choice changes scope or depends on product intent.

### 4. Build through evidence loops

For each increment:

1. State the hypothesis and observable success condition.
2. Ask the agent for investigation or a proposed change, with evidence locations.
3. Inspect the relevant code and explain the proposal in my own words.
4. Make or accept the smallest coherent change.
5. Run the narrowest meaningful validation.
6. Record the result, surprise, and resulting decision.
7. Commit only a coherent, explainable unit if commits are appropriate.

Escalate to an engineer when blocked by product intent, hidden system behavior, an
expensive/reversible choice, or repeated failed experiments. Bring a brief: goal,
observations, attempts, current theory, and the smallest question that unlocks progress.

### 5. Harden the story

Before polishing, test the happy path and the most consequential failure paths. Separate
verified behavior from assumptions. Identify what the implementation does not handle,
what I would improve next, and why the current stopping point is rational.

### 6. Prepare and deliver the demo

Build the presentation from evidence captured during the day:

1. Problem and success criteria.
2. Two-minute product walkthrough of the working slice.
3. System model and the key technical decision.
4. Validation evidence, including a meaningful failure case.
5. Limitations, self-critique, and prioritized next steps.

Prefer live behavior backed by a deterministic fallback such as a test, screenshot, or
recorded output. Do not manufacture quantitative charts from a single day; use diagrams,
timelines, decision tables, and test matrices when they make the explanation clearer.

## End condition

- I can explain every material changed line and architectural choice.
- The demonstrated behavior is supported by reproducible evidence.
- Known failures and unverified assumptions are explicit.
- The final narrative connects the problem to the chosen scope and result.
- The project is left in a clean, understandable state according to team conventions.

## Unresolved choices

- Where the project notebook lives and how it avoids contaminating the team's repo.
- The minimum notebook artifacts worth maintaining under time pressure.
- Collaboration/check-in cadence beyond the team's scheduled check-in.
- Exact agent interaction protocol and understanding checks.
- Demo artifact format and zero-dependency generation strategy.
- Rehearsal scenario and scoring rubric.
