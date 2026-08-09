# Interview Workbench

A portable, agent-agnostic operating system for a one-day collaborative coding
interview. It helps you move quickly **and** retain enough understanding to explain the
system, defend the solution, show evidence, and critique the work honestly.

It is deliberately not an autonomous-agent harness. The useful machinery is a small
set of Markdown files that any coding agent can read, two safe shell helpers, and a
realistic two-repository rehearsal.

## The 60-second setup

Put this repository next to the project repository or repositories, then run:

```sh
git clone https://github.com/tstanmay13/interview-workbench.git
cd interview-workbench
./bin/bootstrap /path/to/interview-workspace
```

For a multi-repository task, `/path/to/interview-workspace` is their common parent:

```text
interview-workspace/
├── service-repo/
├── ui-repo/
└── .workbench/       # created locally and excluded from Git when applicable
```

Open `.workbench/START-HERE.md` and paste its first prompt into the supplied agent. If
the agent does not automatically read repository instructions, explicitly tell it to
read `.workbench/OPERATING-BRIEF.md` and `.workbench/notebook.md` first.

`bootstrap` never overwrites an existing workbench or edits `AGENTS.md`, `CLAUDE.md`,
or repository source. When the target is inside a Git repository, it adds only a local
`.git/info/exclude` entry. Re-running it is safe.

## How you use it during the day

1. **Listen and play back the problem.** Fill the six-line problem contract in
   `notebook.md` and ask the engineers to correct it.
2. **Get one runnable baseline.** Trace a representative case through the relevant
   repositories. Keep one shared system map and interface ledger.
3. **Delegate only bounded discovery.** At most two initial read-only subagents, and
   only when their tasks are independent. Each returns an evidence packet: findings,
   file/line or command evidence, uncertainty, and recommended next action.
4. **Choose one thin slice.** Compare plausible approaches, define representative,
   boundary, and failure cases, then keep the central path in your main agent thread.
5. **Build in evidence loops.** Hypothesis → smallest change → narrow validation →
   critique. Use fast judgment for reversible moves and slow down for contracts,
   security, destructive changes, or poorly understood infrastructure.
6. **Collaborate at decision points.** Problem playback, slice alignment, midpoint
   reality check, and early escalation after repeated failed theories. Bring engineers
   a concise goal/learned/bet/risk/ask update.
7. **Keep the demo alive from the start.** Add claims and proof to `demo.md` while you
   work. With 90 minutes left, choose green/yellow/red scope. Protect 30–45 minutes for
   synthesis and rehearsal.

The full adaptive workflow is in
[`workflows/onsite-project.md`](workflows/onsite-project.md). The one-page fallback is
[`CHEATSHEET.md`](CHEATSHEET.md).

## Make the final presentation

Your canonical artifact is plain Markdown. Render it into a polished, self-contained,
offline HTML evidence console when useful:

```sh
./bin/render-demo /path/to/interview-workspace/.workbench/demo.md
```

This creates `demo.html` next to the Markdown. Open it in any browser. Use the arrow
keys to move between sections, `P` or the Print button to create a PDF, and the trace
rail to keep the narrative anchored on problem → decision → proof → limits. No external
fonts, scripts, assets, accounts, or network access are required.

If rendering costs time or the environment blocks scripts, present `demo.md` directly.
The content matters more than the wrapper.

## Rehearse before the onsite

Create a fresh two-repository exercise with a hidden brief and clean baseline commits:

```sh
./bin/start-rehearsal 90 /tmp/my-rehearsal
```

Modes are `90`, `180`, and `full`. Follow the generated
`.workbench/rehearsal.md`, solve `.workbench/challenge.md`, and score yourself with
`.workbench/scorecard.md`. The fixture uses only Node's standard library; there is no
package installation step.

Start its two processes in separate terminals:

```sh
cd /tmp/my-rehearsal/case-service && npm start
cd /tmp/my-rehearsal/review-console && npm start
```

Then open `http://127.0.0.1:4200`. For a realistic social rehearsal, give
`.workbench/prompts/chaperone.md` to a second agent or a friend; it simulates restrained
product and engineering chaperones without solving the problem for you.

## Why the workflow is intentionally light

Multiagent work helps when tasks are genuinely parallel and hurts when agents duplicate
context or race on one evolving implementation. The workbench therefore fronts-loads
only enough understanding to pick a good slice, uses subagents as evidence-producing
specialists, and keeps integration and product judgment with you. See the first-party
and controlled research in [`research/`](research/).

## Repository map

- `core/OPERATING-BRIEF.md` — durable instructions for any coding agent.
- `templates/` — notebook, demo, and rehearsal scorecard.
- `prompts/` — optional phase cards; use only when they unlock the current phase.
- `bin/` — safe bootstrap, offline demo renderer, and rehearsal launcher.
- `rehearsal/` — role-agnostic service/UI fixture, challenges, and schedules.
- `workflows/onsite-project.md` — complete source-of-truth workflow.
- `research/` — evidence and explicit inferences behind the design.
- `tests/` — public-seam tests for portability and behavior.

## Safety

Never copy an employer's source code, prompts, credentials, logs, customer data, or
confidential problem statement into this public repository. On interview day, bootstrap
a local `.workbench`, respect the company's agent and network policies, and leave that
local directory on the supplied machine unless they explicitly permit otherwise.
