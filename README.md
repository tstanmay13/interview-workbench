# Interview Workbench

A portable, agent-agnostic operating system for a one-day collaborative coding
interview. It is designed to help me understand the problem, work visibly with
engineers, make defensible technical decisions, and deliver an honest final demo.

## Design constraints

- Works without installing software.
- Does not require access to a private repository or personal credentials.
- Works with any coding agent that can read Markdown files.
- Keeps me responsible for the reasoning; the agent supplies leverage, not judgment.
- Captures useful evidence during the work instead of reconstructing a story at 4pm.

This repository is being specified through rehearsal. The workflow is not considered
finished until it can be executed on a clean machine without unanswered questions.

## Current structure

- `NOTES.md` — facts and vocabulary learned while designing the system.
- `workflows/onsite-project.md` — source-of-truth interview-day workflow.
- `templates/` — small artifacts filled in during the day.
- `bin/` — optional zero-dependency helpers.

## Safety

Never copy an employer's source code, prompts, credentials, logs, customer data, or
confidential problem statement into this repository. On interview day, use a local
copy of these generic templates inside the provided project and follow the company's
instructions about what may be retained.
