# Notes

## The interview

- Format: approximately 9:30am–5pm, in person.
- Morning: platform demo plus problem and goal walkthrough.
- Work: a tightly scoped project, with a check-in and two engineers available as
  collaborators/chaperones.
- Close: demo progress to the engineering team in the late afternoon.
- Coding agents will be available and are explicitly allowed.
- Evaluation is broader than code output: understanding, judgment, collaboration,
  friendliness, teammate behavior, presentation, failure analysis, and self-critique.
- Hiring likely requires at least one interviewer to become a strong advocate.

## Canonical terms

- **Workbench**: the portable set of generic instructions and templates in this repo.
- **Workspace**: the common working directory containing one or more supplied project
  repositories for the exercise.
- **Project notebook**: the workspace-local `.workbench/` directory containing
  interview-only evidence captured while working. It must not be committed or pushed.
- **Understanding check**: Tanmay explains a fact or decision in his own words before
  relying on it.
- **Evidence**: an observation, code reference, experiment, test result, or stakeholder
  statement that supports a conclusion.
- **Decision record**: the problem, options, choice, evidence, and tradeoff—not merely
  a transcript of an agent conversation.
- **Demo thread**: a continuous story from user/problem to decision to working result
  to remaining risk.
- **Critique loop**: an evidence-based comparison between intent and result that ends
  with a concrete adjustment, experiment, or consciously accepted limitation.

## Confirmed environment assumptions

- Assume no permission to install software.
- Assume no personal GitHub authentication or access to private repositories.
- Assume only a terminal, Git, the supplied project, and a preinstalled coding agent.
- The core workflow must not depend on Claude Code, Codex, Cursor, or a specific model.
- Optional conveniences must degrade cleanly when unavailable.
- The exercise may span multiple repositories; the notebook and final narrative must
  connect work across them without requiring duplicated notes.
- Self-critique must happen throughout the work, not be reconstructed only for the demo.

## Existing personal setup

- `tstanmay13/dotfiles` already exists and is private.
- It is intentionally not the interview bootstrap: it installs many packages and apps,
  changes global configuration, starts a launch agent, and requires personal auth.

## Questions still being resolved

- Which artifacts provide enough evidence without becoming administrative overhead?
- What cadence should trigger collaboration with the two engineers?
- What exact final-demo format should the workbench prepare?
- Which charts are useful and truthful for a single day of work?
- What rehearsal project best approximates the onsite exercise?

## Resolved design choices

- Use one `.workbench/` notebook at the common workspace root, even when several repos
  are involved.
- If the workspace root is itself a Git repository, exclude `.workbench/` through the
  local `.git/info/exclude`; do not modify the tracked `.gitignore` automatically.
- If supplied repos are siblings beneath the workspace, the notebook remains outside
  each repo and therefore cannot be committed from them.
- Record each relevant repo and its role in a workspace map so cross-repo decisions can
  be explained as one system.
- Keep interview-day documentation to two living files plus supporting artifacts:
  `.workbench/notebook.md`, `.workbench/demo.md`, and `.workbench/artifacts/`.
- `notebook.md` is the source of truth; `demo.md` may summarize it but must not introduce
  claims that lack notebook evidence.
- Favor Mermaid diagrams, decision tables, test matrices, and timelines over invented
  metrics or decorative charts.
- Agree on a lightweight collaboration cadence with the engineers during context
  setting instead of assuming when they want to be involved.
- Use event-driven touchpoints: problem playback, slice alignment, the team's midpoint
  check-in, and early escalation for product intent or high-cost decisions.
- Earn advocacy through clear reasoning, responsiveness to feedback, useful updates,
  and generous credit—not through performative networking.
