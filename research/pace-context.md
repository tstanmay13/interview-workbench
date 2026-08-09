# Pace context for the onsite work trial

Research date: 2026-08-09  
Source policy: first-party company pages, Pace-controlled job listings, and a self-authored employee post. Public claims below describe what Pace says about itself; they are not independent validation.

## Identification: highly likely, not proven

The company is **very likely Pace at `withpace.com`, the AI operations platform for insurance**. That is an inference, not a confirmed fact from the email alone.

Evidence chain:

- Pace's official site calls the product “The AI operations platform for insurance,” and describes a platform for building, deploying, and governing AI agents. This closely matches the email's promise of a morning “demo of the Pace platform.” ([Pace homepage](https://withpace.com/))
- A current Pace engineering listing is for an on-site Member of Technical Staff in New York City and says the role partners with the team on product. This matches the broad shape of an in-person, collaborative product build, although it does **not** publish the interview format in the email. ([Member of Technical Staff](https://jobs.ashbyhq.com/withpace/54b43ced-88db-4b1a-8409-9fcb5f0c52f3))
- Eric He has a self-authored post saying he joined Pace to work on AI for insurance operations. The email's “Eric with a C” is therefore a meaningful identity clue, but not conclusive by itself. ([Eric He's post](https://www.linkedin.com/posts/ehe3_excited-to-share-that-ive-recently-joined-activity-7353861528460115968-mvIt))
- Pace publicly describes coding-agent-style orchestration, specialist subagents, shared sandboxes, and agent-generated scripts. That is unusually consistent with the interview's explicit emphasis on coding agents and understanding their output. ([Pace's agent architecture](https://withpace.com/news/multimodal-agents))

The recruiter name is not useful confirmation: Kitty Qu's public profile currently identifies her with Insight Partners, not Pace. Her involvement may be recruiting help, a personal connection, or something else; do not invent a relationship. ([Kitty Qu at Insight Partners](https://www.insightpartners.com/team/kitty-qu/))

**Confidence:** high enough to tailor preparation to `withpace.com`, but the morning context session remains the authority. If the company, product surface, or target role differs, discard the tailored assumptions and retain the general workflow.

## What Pace publicly says it builds

### Product and user

Pace describes itself as the orchestration, integration, and governance layer for AI agents that execute insurance operations from intake to resolution. Its named customer categories include carriers, brokers, MGAs, TPAs, and specialty mutual groups. ([Pace homepage](https://withpace.com/))

The unit of value is an **end-to-end operational outcome**, not merely a model response. Public examples include submission intake, policy servicing, claims handling, FNOL, policy checking, endorsements, and data entry. Agents work across documents, phone, email, text, APIs, web portals, desktop applications, and legacy systems. ([Pace homepage](https://withpace.com/), [product overview](https://withpace.com/product), [company launch essay](https://withpace.com/news/a-new-era))

Pace's core product vocabulary is:

- A customer brings a Standard Operating Procedure (SOP).
- Pace converts or expresses the procedure as an AOP, a mostly natural-language operating procedure for an agent.
- An orchestrator performs the work or delegates focused portions to specialist subagents.
- A shared per-task sandbox persists artifacts and state across agents and over long-running workflows.
- Citations, automated graders, test cases, audit trails, and human review make outcomes inspectable and controllable. ([agent architecture](https://withpace.com/news/multimodal-agents), [multimodal product launch](https://withpace.com/news/product-launch), [Tempo](https://withpace.com/news/tempo))

Pace's public writing inconsistently expands AOP as “Agentic Operating Procedure” and “Agent Operating Procedure.” Use **AOP** during preparation and mirror the interviewers' wording onsite rather than correcting them. ([agent architecture](https://withpace.com/news/multimodal-agents), [company launch essay](https://withpace.com/news/a-new-era))

### The technical thesis

Pace argues that production agent quality comes from the harness around the model: focused context, task-specific tools, persistent state, precomputed artifacts, and domain knowledge. Its engineering post explicitly warns that generic shell agents tend to rediscover information, load excess context, and incur repeated compaction, latency, and cost. ([agent architecture](https://withpace.com/news/multimodal-agents))

Its architecture assigns different constraints to different agents. For example, a live voice agent needs very low latency, while computer-use or document agents can use slower, stronger models. The orchestrator can vary reasoning effort, model quality, latency, and tool access based on the subtask. ([agent architecture](https://withpace.com/news/multimodal-agents))

Pace also says narrow subagents can operate in parallel, each with focused tools and context, while a shared sandbox exposes consistent artifact locations. It precomputes recurring transformations such as OCR so agents do not repeatedly decide, script, and parse them. ([agent architecture](https://withpace.com/news/multimodal-agents))

For complex documents, Pace says naive full-context and traditional RAG approaches were insufficient for its fixed, structured inputs. Its published COR pipeline preserves document structure, scores relevance, assembles contextual metadata, and ties outputs to source citations. Treat the published benchmark numbers as Pace's own results, not independently established facts. ([Building Reliable Insurance Agents](https://withpace.com/news/cor))

### Reliability, failure handling, and trust

Pace says regulated customers require traceability from an output back to the document, transcript, or system field that supports it, plus records of agent actions. Its public product materials emphasize three mechanisms: citations to show the work, graders to check procedure adherence and calculations, and known-answer test cases that become a regression benchmark. ([multimodal product launch](https://withpace.com/news/product-launch))

Sensitive actions can require human verification before affecting the real world, and complex cases can be routed for review. Pace also says it does not train models on customer data and advertises role-based permissions and audit logs. ([product overview](https://withpace.com/product), [Pace homepage](https://withpace.com/), [security page](https://withpace.com/security))

Tempo, Pace's natural-language agent builder, is described as getting an initial workflow most of the way quickly and then iterating against sample cases, edge cases, exceptions, and production QA feedback. That public framing makes “fast first version, then evidence-driven last mile” more culturally congruent than either prolonged analysis or an untested demo. ([Introducing Tempo](https://withpace.com/news/tempo))

## What Pace publicly says it values in engineers

The most relevant current engineering listing says a Member of Technical Staff partners on product across extraction pipelines, RPA/web automation, or enterprise features for large users. The listing calls out two team characteristics: **integrity**—good people committed to doing their best work over a long horizon—and **ambition**—people who raise the company's level and grow into leaders. It also describes an in-person, talent-dense team in New York. ([Member of Technical Staff](https://jobs.ashbyhq.com/withpace/54b43ced-88db-4b1a-8409-9fcb5f0c52f3))

A Forward Deployed Engineer listing makes the customer/product loop explicit: expand customer use cases, build solutions to customer problems, ship features, integrations, and evals, and collaborate with engineering on larger product work. ([Forward Deployed Engineer](https://jobs.ashbyhq.com/withpace/ab8586e3-5cdf-4b4d-8546-d2b973014193/))

**Inference for the onsite:** regardless of the exact role, the strongest performance is likely to combine product understanding, technical execution, a visible quality loop, and low-ego collaboration. The public materials do not establish a formal scoring rubric, and the exact role has not been supplied, so do not optimize for a guessed specialty.

## Likely problem risks

These are evidence-backed risk categories, **not predictions of the exact project**:

1. **Solving a step instead of the outcome.** Pace positions its product around closing an entire unit of insurance work across channels and systems. A locally impressive component can still miss the customer outcome. ([multimodal product launch](https://withpace.com/news/product-launch))
2. **Overloading context.** Large SOPs, documents, and multiple repositories can cause agents to repeatedly rediscover the system. Pace explicitly treats context minimization as a core harness principle. ([agent architecture](https://withpace.com/news/multimodal-agents))
3. **Losing state between agents or repositories.** Pace's own subagents rely on a shared sandbox and consistent artifact locations. Parallel work without a fan-in contract risks contradictory or orphaned findings. ([agent architecture](https://withpace.com/news/multimodal-agents))
4. **A happy-path-only demo.** The company publicly centers graders, test cases, exception handling, human review, and auditability. A success animation without a known failure boundary is weak evidence. ([multimodal product launch](https://withpace.com/news/product-launch), [product overview](https://withpace.com/product))
5. **Treating probabilistic behavior as ordinary deterministic code.** Pace evaluates agent behavior against real known-answer cases and repeated runs; one successful manual run is not a reliability claim. ([multimodal product launch](https://withpace.com/news/product-launch))
6. **Unsafe side effects or leaked sensitive data.** Pace operates in a regulated domain and advertises permissions, audit logs, data controls, and human verification for sensitive actions. ([security page](https://withpace.com/security), [product overview](https://withpace.com/product))
7. **Optimizing one dimension.** Pace's own orchestration trades among accuracy, speed, cost, model quality, reasoning effort, and tool access. “Use the strongest model everywhere” is not automatically the best system design. ([agent architecture](https://withpace.com/news/multimodal-agents))
8. **Prematurely hard-coding domain assumptions.** Pace says effective agents combine AI engineering with insurance expertise and that the people closest to the work should shape them. The morning walkthrough should override assumptions derived from public material. ([company launch essay](https://withpace.com/news/a-new-era), [Introducing Tempo](https://withpace.com/news/tempo))

## Workflow implications

The recommendations below are inferences from Pace's public materials plus the supplied one-day interview format.

| Evidence | Recommendation for the day | Why it fits this interview |
|---|---|---|
| Pace models customer procedures explicitly as SOPs/AOPs. ([source](https://withpace.com/news/a-new-era)) | Start by writing a six-line “task operating procedure”: trigger/input, desired outcome, required steps, constraints, exception path, proof of completion. Play it back to the engineers before committing to architecture. | Shows that the implementation follows the actual work rather than a prompt-shaped guess. |
| Pace says the best agents are shaped by people closest to the work. ([source](https://withpace.com/news/tempo)) | Ask the chaperones for one representative case, one ugly edge case, and the most consequential way the system can be wrong. Recheck interpretations with them at agreed checkpoints. | Converts collaboration into domain signal and makes the engineers co-designers rather than passive judges. |
| Pace's product closes end-to-end units of work. ([source](https://withpace.com/news/product-launch)) | Choose the thinnest end-to-end slice that reaches a visible user/system outcome. Stub or defer breadth before sacrificing the complete path. | A complete vertical slice is easier to demo and critique than several disconnected components. |
| Tempo aims for a fast initial build, then improves through sample cases and QA. ([source](https://withpace.com/news/tempo)) | Time-box understanding, build a reversible first path early, then spend the middle of the day tightening it against evidence. Do not wait for certainty before the first testable implementation. | Balances speed and comprehension under a one-day deadline. |
| Pace uses known-answer test cases and graders. ([source](https://withpace.com/news/product-launch)) | Define the first three acceptance examples before or alongside implementation: normal, boundary, and failure/exception. If the behavior is probabilistic, rerun the small eval set and record pass counts rather than showing one cherry-picked output. | Gives a concrete answer to “how do you know it works?” and produces material for the demo. |
| Pace treats citations and traceability as trust mechanisms. ([source](https://withpace.com/news/product-launch)) | Keep claims in `notebook.md` linked to commands, tests, filenames, screenshots, or outputs. In the demo, distinguish observed fact, inference, and unverified assumption. | Demonstrates intellectual honesty and prevents agent prose from masquerading as evidence. |
| Pace uses focused parallel subagents with shared state. ([source](https://withpace.com/news/multimodal-agents)) | Parallelize only separable work: repository mapping, existing-pattern search, test/eval discovery, and failure analysis. Give each subagent a bounded question and require a short packet: conclusion, evidence paths, uncertainty, recommendation. Fan in through the main thread before implementation decisions. | Gains speed without creating multiple competing narratives or code you cannot explain. |
| Pace says focused context improves accuracy and latency. ([source](https://withpace.com/news/multimodal-agents)) | Give each agent the smallest relevant files and a precise question. Maintain one shared system map and decision log instead of repeatedly sending the whole transcript or all repositories. | Reduces agent drift, token waste, and re-orientation time. |
| Pace precomputes recurring artifacts for agents. ([source](https://withpace.com/news/multimodal-agents)) | In the first hour, capture repository roots, run commands, test commands, ownership boundaries, and baseline outputs once. Reuse those facts in later agent tasks. | Avoids paying repeated discovery cost across agents and repositories. |
| Pace varies model/tool choice by task constraints. ([source](https://withpace.com/news/multimodal-agents)) | Use fast agents for bounded search or mechanical work and deeper reasoning for architecture, ambiguous failures, and synthesis. Prefer direct code/search/test tools when they answer a question more reliably than more prompting. | Demonstrates judgment about AI usage, not merely volume of AI usage. |
| Pace routes complex or sensitive cases to human review. ([source](https://withpace.com/product)) | For any risky side effect, define the authority boundary: validate/dry-run first; require confirmation or fail closed when evidence is insufficient. | Makes failure behavior part of the solution rather than an appendix. |
| Pace's roles emphasize product partnership, customer problems, integrations, evals, and engineering collaboration. ([MTS](https://jobs.ashbyhq.com/withpace/54b43ced-88db-4b1a-8409-9fcb5f0c52f3), [FDE](https://jobs.ashbyhq.com/withpace/ab8586e3-5cdf-4b4d-8546-d2b973014193/)) | At check-ins, communicate in four lines: outcome now working, evidence, biggest risk, next tradeoff/question. Invite disagreement before a high-cost direction change. | Makes working style, self-direction, and coachability visible while preserving build time. |
| Pace publicly highlights integrity and ambition. ([source](https://jobs.ashbyhq.com/withpace/54b43ced-88db-4b1a-8409-9fcb5f0c52f3)) | Be candid about uncertainty and failures, then pair each criticism with an action, experiment, scoped mitigation, or explicit accepted risk. End with what another hour/day/week would improve, ordered by impact. | Self-criticism becomes useful engineering judgment instead of performative pessimism. |

## A Pace-shaped demo narrative

This is a recommended structure, not a known company rubric:

1. **The operation and user outcome:** who needed what completed, and why the prior path was costly or unreliable.
2. **The operating procedure:** inputs, steps, business rules, and where exceptions go.
3. **The thinnest complete path:** run the representative case from intake to outcome.
4. **What makes it trustworthy:** show the source/evidence trail, acceptance cases, and any grader or deterministic validation.
5. **Failure in public:** run or explain the consequential edge case; show that the system fails safely, escalates, or exposes uncertainty.
6. **Engineering decisions:** one or two meaningful alternatives, the chosen tradeoff, and what evidence changed your mind.
7. **Self-critique:** remaining risks, what is intentionally incomplete, and the highest-impact next hour/day/week.

Do not claim production readiness from a one-day project. A better claim is: “This slice demonstrates the core path and these tests support it; these named gaps block production.” That posture is consistent with Pace's public distinction between a capable demo and a system that meets production SLAs. ([Building Reliable Insurance Agents](https://withpace.com/news/cor), [multimodal product launch](https://withpace.com/news/product-launch))

## High-leverage questions for the morning

These questions test the public assumptions without turning context-setting into an interrogation:

1. “Who is the user or operator, and what end-to-end outcome matters more than the individual feature?”
2. “Can we walk one representative case and one case that should fail, route, or require review?”
3. “What does a correct answer look like, and is there an existing fixture, eval, grader, or known-good output?”
4. “Which constraints dominate today: accuracy, latency, cost, explainability, or implementation time?”
5. “What side effects or customer data must I treat as read-only, sandboxed, or approval-gated?”
6. “Which repository owns the behavior, and what cross-repository contracts should remain stable?”
7. “For the final demo, would you rather see one complete hardened path or broader exploratory coverage?”
8. “Can we agree on a quick design playback and a midpoint check-in, with ad-hoc questions only when they can change direction?”

## What not to overfit

- Public product writing is marketing and technical communication, not the onsite scorecard. The explicit email instructions and morning context override this document.
- The exact project, repositories, language, and target role are unknown. Do not preselect an architecture or imitate Pace's production harness in miniature without a problem-driven reason.
- Pace's reported volumes, accuracy, timelines, and customer outcomes are self-reported. They provide context, not evidence you should repeat as independently verified facts. ([Pace homepage](https://withpace.com/), [Building Reliable Insurance Agents](https://withpace.com/news/cor))
- Multi-agent orchestration is not automatically appropriate. Use subagents only when work is genuinely separable and their outputs can be verified cheaply; otherwise, coordination overhead can consume the one-day budget.
- A notebook, charts, and diagrams are support artifacts. The product outcome and evidence come first; only generate visuals that make a decision, flow, result, or limitation easier to understand.

