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
- **Project notebook**: local, interview-only evidence captured while working. It must
  not be pushed to this public repository.
- **Understanding check**: Tanmay explains a fact or decision in his own words before
  relying on it.
- **Evidence**: an observation, code reference, experiment, test result, or stakeholder
  statement that supports a conclusion.
- **Decision record**: the problem, options, choice, evidence, and tradeoff—not merely
  a transcript of an agent conversation.
- **Demo thread**: a continuous story from user/problem to decision to working result
  to remaining risk.

## Confirmed environment assumptions

- Assume no permission to install software.
- Assume no personal GitHub authentication or access to private repositories.
- Assume only a terminal, Git, the supplied project, and a preinstalled coding agent.
- The core workflow must not depend on Claude Code, Codex, Cursor, or a specific model.
- Optional conveniences must degrade cleanly when unavailable.

## Existing personal setup

- `tstanmay13/dotfiles` already exists and is private.
- It is intentionally not the interview bootstrap: it installs many packages and apps,
  changes global configuration, starts a launch agent, and requires personal auth.

## Questions still being resolved

- How much structure should be introduced into the provided project, if any?
- Which artifacts provide enough evidence without becoming administrative overhead?
- What cadence should trigger collaboration with the two engineers?
- What exact final-demo format should the workbench prepare?
- Which charts are useful and truthful for a single day of work?
- What rehearsal project best approximates the onsite exercise?
