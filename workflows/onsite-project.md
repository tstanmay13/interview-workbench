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

Agree on a collaboration contract rather than guessing how often the engineers want to
be involved. Proposed wording:

> I'd like to play back my understanding before I build, show you the proposed slice
> once I've mapped the relevant path, and bring you a rough result at the midpoint.
> Does that cadence work, or would you prefer something different?

Checkpoint: the engineers confirm or correct the problem framing before implementation.

### 2. Map the system

Use repository-native discovery commands and the agent to identify the smallest relevant
execution path. For every important agent claim, inspect the referenced code, test, or
runtime behavior. Record unknowns explicitly. Explain the path back in my own words.

Create one workspace map. If several repositories are involved, record each repository's
role, the interfaces between them, how changes propagate across those interfaces, and
where each claim can be verified. Do not create disconnected per-repository narratives.

Output: a small system map containing entry point, data/control flow, change seam,
validation boundary, and main risks.

### 3. Choose a slice

Generate at least two plausible approaches. Compare them by user value, uncertainty,
implementation cost, reversibility, fit with the existing architecture, and ease of
validation. Choose the smallest slice that tests the riskiest important assumption.

Checkpoint: share a short decision brief at the scheduled check-in—or sooner if the
choice changes scope or depends on product intent.

## Collaboration protocol

The agreed cadence overrides this default. Otherwise, collaborate at these events:

1. **Problem playback**: confirm the user, outcome, success criteria, and boundaries.
2. **Slice alignment**: share the system path, alternatives considered, current bet,
   and riskiest assumption before substantial implementation.
3. **Midpoint reality check**: show rough working behavior or concrete evidence, name
   what failed, and ask whether the remaining priority still looks right.
4. **Early escalation**: involve an engineer when blocked on product intent, unfamiliar
   infrastructure, a costly or hard-to-reverse decision, or two failed attempts based
   on the same theory.

Do not interrupt for facts that can be cheaply verified in code, tests, or docs. Do not
wait for a scheduled checkpoint when proceeding would create substantial rework.

### Checkpoint brief

Keep each update conversational and decision-ready:

- **Goal**: what user or system outcome I am pursuing.
- **Learned**: the most important evidence since the last conversation.
- **Current bet**: what I am doing and why it is the smallest useful slice.
- **Risk**: what I am least confident about or what failed.
- **Ask**: one concrete correction, choice, or piece of context I need.

After feedback, restate the important correction, record what it changes, incorporate it,
and later close the loop with the resulting evidence. Credit the engineer's contribution
when it materially improved the result. The goal is normal high-trust teamwork, not
performing for sponsorship.

### 4. Build through evidence loops

For each increment:

1. State the hypothesis and observable success condition.
2. Ask the agent for investigation or a proposed change, with evidence locations.
3. Inspect the relevant code and explain the proposal in my own words.
4. Make or accept the smallest coherent change.
5. Run the narrowest meaningful validation.
6. Record the result, surprise, and resulting decision.
7. Run the critique loop below.
8. Commit only a coherent, explainable unit if commits are appropriate.

#### Critique loop

Trigger after a meaningful increment, a failed experiment, surprising evidence, or a
material change in direction—not after every trivial edit.

1. Restate what I intended to improve and for whom.
2. Compare the result with the observable success condition.
3. Name the strongest evidence that the approach may be wrong or incomplete.
4. Check for unnecessary complexity, hidden assumptions, untested failure paths, and
   divergence from the repository's conventions.
5. Explain the changed system in my own words without agent-generated prose.
6. Choose one response: adjust now, run a targeted experiment, ask an engineer, or
   consciously accept and document the limitation.

The critique is incomplete until it changes the plan or explicitly justifies why the
current plan remains best. Avoid performative negativity and do not manufacture flaws;
calibrated judgment is the goal.

Escalate to an engineer when blocked by product intent, hidden system behavior, an
expensive/reversible choice, or repeated failed experiments. Bring a brief: goal,
observations, attempts, current theory, and the smallest question that unlocks progress.

### 5. Harden the story

Before polishing, test the happy path and the most consequential failure paths. Separate
verified behavior from assumptions. Identify what the implementation does not handle,
what I would improve next, and why the current stopping point is rational.

Run a whole-solution critique before demo preparation:

- Where is the solution most likely to fail in production?
- Which conclusion rests on the weakest evidence?
- What complexity did I introduce, and did it earn its keep?
- What would a skeptical maintainer object to?
- With another hour, day, and week, what would I improve in that order—and why?

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

## Notebook placement

Create one `.workbench/` directory at the common workspace root. It owns the workspace
map, evidence, decisions, critique history, and demo thread for all relevant repos.

- When the workspace root is a Git repository, add `.workbench/` to that repository's
  local `.git/info/exclude` only.
- When repos are children of the workspace root, keep `.workbench/` beside them so it is
  outside each repo's commit boundary.
- If an agent cannot read the common parent because of its sandbox, copy only the generic
  agent instructions into each session and keep the notebook human-maintained. Never
  weaken company security controls to make the notebook accessible.
- At the end, retain or delete the local notebook according to the company's policy;
  never push its interview-specific contents to the public workbench repository.

## Notebook artifacts

Maintain only these artifacts during the exercise:

### `.workbench/notebook.md`

The private working source of truth for the day. Keep entries terse and evidence-linked.
It contains:

- **Problem contract**: user, pain, desired outcome, success criteria, constraints,
  non-goals, and open questions.
- **Workspace map**: relevant repositories, their roles and run commands, interfaces
  between them, the smallest relevant execution path, and a Mermaid diagram when useful.
- **Current bet**: chosen slice, expected value, risk being tested, and stopping rule.
- **Evidence ledger**: important claim, supporting observation/code/test/stakeholder
  statement, confidence, and what would disconfirm it.
- **Decision records**: context, viable options, choice, why, tradeoff, reversibility,
  and review trigger.
- **Experiment and critique log**: intention, success condition, result, strongest
  counterevidence, learning, and next action.
- **Parking lot**: deliberately deferred ideas and questions, not an unprioritized dump.

Update the notebook at workflow transitions and meaningful evidence events. Do not log
every prompt, command, or edit.

### `.workbench/demo.md`

The audience-facing narrative derived from verified notebook evidence. It contains:

- one-sentence thesis;
- problem, user, and success criteria;
- live-demo path and deterministic fallback;
- concise system map;
- key decision and rejected alternative;
- validation and failure-case matrix;
- limitations and weakest remaining assumption;
- improvements prioritized for another hour, day, and week;
- likely questions and short, honest answers.

Every material demo claim links back to a notebook heading, code location, test, or saved
artifact. When the claim changes, update the source notebook first.

### `.workbench/artifacts/`

Store only evidence that materially supports the demo: screenshots, sanitized command
output, small diagrams, or fallback recordings allowed by company policy. Do not copy
source trees, secrets, customer data, or unnecessary logs. Prefer reproducible commands
over captured output when reliability is equivalent.

## Unresolved choices

- Exact agent interaction protocol and understanding checks.
- Demo artifact format and zero-dependency generation strategy.
- Rehearsal scenario and scoring rubric.
