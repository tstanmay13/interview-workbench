# Portable Agent Workbench Research

Research date: 2026-08-09

Scope: the smallest safe, zero-install workflow that can operate across an unknown coding
agent on a company-provided laptop. Sources are official product documentation or primary
specifications unless explicitly identified otherwise.

## Findings

### Plain Markdown is the real common denominator

`AGENTS.md` is an open convention supported by multiple coding agents, including Codex,
Cursor, and GitHub Copilot ([AGENTS.md specification](https://agents.md/)). Codex discovers
`AGENTS.md` from global and project scopes and composes more-specific instructions over
broader ones ([Codex documentation](https://learn.chatgpt.com/docs/agent-configuration/agents-md)).
Cursor supports a root-level `AGENTS.md` as a simple alternative to Cursor-specific rules
([Cursor rules documentation](https://docs.cursor.com/context/rules-for-ai)). GitHub Copilot
accepts `AGENTS.md`, `CLAUDE.md`, or `GEMINI.md` as agent instruction files in supported
features, although support differs across surfaces
([GitHub Copilot customization documentation](https://docs.github.com/en/copilot/concepts/prompting/response-customization)).

Claude Code does **not** natively read `AGENTS.md`; Anthropic recommends a `CLAUDE.md` that
imports `AGENTS.md`, or a symlink when platform permissions allow it
([Claude Code memory documentation](https://code.claude.com/docs/en/memory#agentsmd)).
Therefore, automatic discovery is not portable enough to be the only loading mechanism.

Implementation implication: maintain one concise neutral operating brief. A bootstrap may
create thin `AGENTS.md`/`CLAUDE.md` adapters only when they do not overwrite team files.
Always retain a copy-paste startup instruction that explicitly asks the supplied agent to
read the brief and confirm the constraints it loaded.

### Persistent instructions must stay short and specific

Anthropic says `CLAUDE.md` is context rather than enforced configuration and reports that
specific, concise instructions are followed more consistently; it recommends keeping each
file under 200 lines. It also recommends moving multi-step procedures into skills instead
of loading them into every session
([Claude Code memory documentation](https://code.claude.com/docs/en/memory#write-effective-instructions)).
GitHub similarly recommends short, self-contained repository instructions because they are
sent with every chat message
([GitHub Copilot customization documentation](https://docs.github.com/en/copilot/concepts/prompting/response-customization#writing-effective-custom-instructions)).

Implementation implication: the always-loaded brief should contain only safety, evidence,
ownership, validation, and notebook rules. Detailed phase procedures belong in prompt cards
or skills loaded only when invoked.

### Skills are useful adapters, not a guaranteed runtime

Claude skills use a `SKILL.md` entry point and may bundle templates, examples, scripts, and
references. Claude discovers project skills from `.claude/skills/` relative to the launch
directory or added directories
([Claude Code skills documentation](https://code.claude.com/docs/en/skills#where-skills-live)).
Other tools increasingly support skills, but their discovery locations and supported
frontmatter are not identical.

Implementation implication: keep the source workflow as ordinary Markdown and shell. Tool
adapters may wrap those files as skills, but the core must never require skill discovery.

### Multi-repository access is tool- and sandbox-dependent

Claude Code provides `--add-dir` to grant access to additional working directories, but
additional directories do not automatically load their `CLAUDE.md` files unless a separate
setting is enabled
([Claude CLI reference](https://docs.anthropic.com/en/docs/claude-code/cli-usage),
[Claude memory documentation](https://code.claude.com/docs/en/memory#load-from-additional-directories)).
Cursor announced multi-root workspace support for cross-repository work in April 2026
([Cursor changelog](https://cursor.com/changelog/04-24-26)). These capabilities do not prove
that Pace's configured environment will allow parent/sibling access.

Implementation implication: choose a common workspace root when allowed, but verify access
before depending on it. If the agent is sandboxed to one repo, give each session only the
minimum synthesized cross-repo interface context; do not weaken company security controls.

### Subagents are best for bounded independent work and context isolation

Codex recommends keeping the main agent focused on requirements, decisions, and final
outputs while using parallel subagents for exploration, tests, and log analysis. It warns
that parallel write-heavy work can introduce conflicts and coordination overhead and notes
that subagents consume more tokens than a comparable single-agent run
([Codex subagent documentation](https://learn.chatgpt.com/docs/agent-configuration/subagents)).
Anthropic likewise recommends subagents for self-contained work, verbose output, and
independent investigations, while keeping quick changes and highly interdependent phases in
the main conversation
([Claude Code subagent documentation](https://code.claude.com/docs/en/sub-agents#choose-between-subagents-and-main-conversation)).
GitHub Copilot custom agents run in separate subagent contexts so the main agent can retain
planning and coordination context
([GitHub Copilot custom-agent documentation](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/create-custom-agents-for-cli)).

Implementation implication: default subagents to read-only discovery, independent tests,
logs, documentation lookup, and adversarial review. Allow writes only for isolated ownership
with an integration owner and clear validation target.

### Local notebook exclusion is supported directly by Git

Git documents `$GIT_COMMON_DIR/info/exclude` for repository-specific auxiliary files that
should not be shared with other clones
([gitignore documentation](https://git-scm.com/docs/gitignore)). This supports keeping
`.workbench/` out of `git status` without changing the team's tracked `.gitignore`.

Implementation implication: when `.workbench/` is inside a Git worktree, add it to the local
info exclude and verify with `git check-ignore -v`. If it sits beside sibling repositories,
it is already outside their commit boundaries.

### Diagrams can stay zero-install

GitHub renders Mermaid fenced blocks in Markdown files, pull requests, issues, discussions,
and wikis ([GitHub diagram documentation](https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/creating-diagrams)).

Implementation implication: generate Mermaid source inside `demo.md` and keep an ASCII
fallback. Do not depend on a Mermaid CLI or network renderer during the interview.

### Instructions do not replace security controls or human review

Anthropic explicitly distinguishes behavioral instructions from enforced settings and
hooks ([Claude Code memory documentation](https://code.claude.com/docs/en/memory#managed-claudemd)).
OpenAI documents that Codex subagents inherit the current sandbox policy
([Codex subagent documentation](https://learn.chatgpt.com/docs/agent-configuration/subagents#approvals-and-sandbox-controls)).
GitHub warns that AI instructions are nondeterministic and may not always be followed
([GitHub Copilot customization documentation](https://docs.github.com/en/copilot/concepts/prompting/response-customization)).

Implementation implication: use Pace's supplied accounts, permissions, sandbox, and agent.
Never bypass controls or add personal credentials. Verify the agent's actions and rely on
repository tests and explicit permission boundaries rather than prose alone.

## Compatibility matrix

| Capability | Codex | Claude Code | Cursor | GitHub Copilot | Portable strategy |
|---|---|---|---|---|---|
| Neutral project instructions | `AGENTS.md` | `CLAUDE.md` | `AGENTS.md` | Agent instructions vary by surface | Explicitly load one neutral brief; optional adapters |
| Reusable task workflow | Skills | Skills | Rules/commands | Skills/prompts | Plain Markdown prompt cards as source |
| Parallel agents | Native subagents | Native subagents | Native subagents/multitask | Native/custom subagents | Request bounded fan-out only if available |
| Multiple repositories | Workspace-dependent | `--add-dir` | Multi-root workspace | Surface-dependent | Verify access; never assume sibling visibility |
| Diagram rendering | Markdown/client-dependent | Markdown/client-dependent | Markdown/client-dependent | GitHub Mermaid rendering | Store Mermaid plus ASCII/text fallback |
| Hard enforcement | Sandbox/rules | Settings/hooks/sandbox | Product controls | Product/org controls | Use company controls; prose is advisory |

## Recommended portable architecture

1. `core/OPERATING-BRIEF.md`: under roughly 150 lines, tool-neutral, explicitly loaded.
2. `prompts/`: phase-specific prompt cards for framing, mapping, delegation, implementation,
   critique, validation, and demo preparation.
3. `adapters/`: optional Codex, Claude, Cursor, and Copilot wrappers that reference the
   same core wording without duplicating policy.
4. `templates/`: the two living interview files, `notebook.md` and `demo.md`.
5. `bin/bootstrap`: POSIX-compatible setup that creates `.workbench/`, refuses to overwrite
   existing instruction files, uses local Git exclusion, and verifies its work.
6. A manual fallback section in `README.md` containing the minimal files and startup prompt
   to copy when scripts or automatic discovery are unavailable.

## Confidence and open questions

- High confidence: Markdown-first design, explicit startup confirmation, local Git exclusion,
  concise persistent instructions, and read-heavy subagent fan-out.
- Medium confidence: `AGENTS.md` will be recognized by the exact tool/surface Pace supplies;
  hence explicit loading remains required.
- Unknown until onsite: agent product/version, permission mode, concurrency limits, parent
  directory access, internet access, permitted data retention, and whether adding local
  instruction files is acceptable.
