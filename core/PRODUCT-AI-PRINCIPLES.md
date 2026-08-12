# Product AI engineering principles

Use this as a decision reference, not a mandatory architecture. The supplied problem,
repository, tests, and team context override it.

## Positioning

Build a complete, responsive, trustworthy product path. Use an LLM or durable workflow
only where it creates observable user value or satisfies an actual lifecycle requirement.
Do not measure progress by prompt sophistication, agent count, or architectural novelty.

```text
customer outcome
  -> smallest complete interaction
  -> deterministic behavior where sufficient
  -> bounded AI judgment where valuable
  -> validated evidence and failure handling
```

## Responsibilities by layer

| Layer | Primary responsibilities |
|---|---|
| React | Interaction, accessibility, loading/degraded states, cancellation, stale-response protection, trusted evidence display |
| Express | Runtime validation, API contract, auth boundaries, deadlines, starting/querying operations, useful error semantics |
| Temporal Workflow | Deterministic durable orchestration and decisions about retries, failure, signals, and long-lived state |
| Temporal Activity | LLM, database, network, filesystem, and other external or failure-prone I/O |
| Postgres | Durable application state, relationships, constraints, indexes, and queryable results |
| LLM | A narrow semantic judgment that deterministic code cannot provide economically |

## First understand the product

Before choosing technology, establish:

- Who is the user and what are they trying to complete?
- Is this locating literal text, finding semantically related evidence, answering a
  question, or executing a durable operation?
- Is interaction search-as-you-type, explicit submit, or asynchronous background work?
- What response delay is unacceptable?
- What source evidence must the user see?
- What is one representative case, one boundary, and the costliest wrong result?
- What should remain useful when the model or another dependency fails?

Play the contract back to the team and ask for correction.

## React and TypeScript

### Model states explicitly

Prefer a discriminated union when states carry different information:

```ts
type SearchState =
  | { status: "idle" }
  | { status: "searching"; query: string; exactResults: Result[] }
  | { status: "success"; results: Result[] }
  | { status: "degraded"; results: Result[]; message: string }
  | { status: "error"; message: string };
```

Avoid contradictory combinations of booleans, errors, and stale data.

### Protect interactive freshness

- Debounce expensive work, using a named constant rather than an unexplained number.
- Abort obsolete requests where the transport and SDK support it.
- Also use a monotonically increasing request ID; cancellation can arrive too late.
- Never allow an older response to replace results for the current query.
- Do not hide useful deterministic results behind a spinner while AI enhancement runs.

### Design the whole interaction

Handle empty input, loading, exact matches, semantic enhancement, no results, provider
timeout, invalid model output, stale responses, network failure, keyboard navigation,
visible focus, and evidence highlighting.

Client-exposed Vite environment variables are public. Never place provider secrets in
frontend code.

## Express and API boundaries

TypeScript does not validate runtime input. Validate request bodies, parameters, lengths,
and bounded collections at the HTTP boundary using repository conventions.

Choose a contract that matches the lifecycle:

- A bounded operation that completes inside the user deadline can return normally.
- A durable operation can return `202 Accepted` with an operation ID and expose status,
  result, and cancellation endpoints.

Distinguish malformed input, unknown resources, conflicts, rate limits, dependency
unavailability, and downstream timeouts where that distinction helps the caller. Follow
the repository's established error vocabulary.

Set one end-to-end deadline. Provider attempts, retries, parsing, and response work must
all fit inside it. Automatic retries still consume product latency.

## Temporal decision

### Workflow versus Activity

A Workflow defines a durable sequence and must remain deterministic because Temporal can
replay it. External I/O and failure-prone work belong in Activities.

Activities may perform model calls, Postgres access, or service requests. They can run or
partially run more than once, so writes and side effects require idempotency.

Useful vocabulary:

- **Workflow ID:** durable identity for a business operation.
- **Workflow run:** one execution of that Workflow.
- **Task queue:** route connecting tasks to Workers.
- **Worker:** process executing Workflow or Activity code.
- **Signal:** asynchronous event that changes Workflow state.
- **Query:** read of Workflow state without mutation.
- **Update:** validated, tracked mutation request.
- **Heartbeat:** Activity progress report that also enables timely remote cancellation.

### Put work on the Express path when

- A user is waiting for one bounded result.
- Cancellation must closely follow an interaction.
- Failure can return a useful fallback.
- There is no durable side effect or multi-system coordination.
- Adding a Worker, status contract, and observation path would dominate the feature.

### Put work in Temporal when

- It must survive browser or server disconnection.
- It may run for minutes or hours, or await an external/human event.
- Several retryable steps or side effects require durable coordination.
- Operational history, resumability, or compensation is part of the outcome.
- Ingestion, parsing, OCR, chunking, indexing, enrichment, or review continues
  independently of the interactive request.

Do not introduce Temporal simply because it is available. Do not remove or bypass an
existing Temporal boundary without understanding why it exists.

### Retries, cancellation, and idempotency

Retry transient network failures, rate limits, and temporary dependency failures within
a bounded policy. Usually do not retry invalid input, authentication failures, obsolete
queries, or deterministic validation failures without changing anything.

Remote Activity cancellation is not instantaneous. Long Activities should heartbeat and
propagate cancellation to abort-aware libraries where possible.

Make writes safe to repeat with business-operation IDs, uniqueness constraints, upserts,
or explicit checks. Avoid holding a Postgres transaction open while waiting on an LLM.

## Postgres and retrieval

Use foreign keys, uniqueness constraints, and transactions to enforce application
invariants. Store durable product state, not a redundant copy of Temporal execution
history without a user or operational need.

Choose the smallest retrieval mechanism that proves the outcome:

| Mechanism | Best first use |
|---|---|
| Exact/substring matching | Identifiers, literal phrases, immediate highlighting |
| Postgres full-text search | Lexical relevance over a moderate corpus |
| `pg_trgm` | Typo tolerance and fuzzy strings |
| Embeddings/vector search | Semantic retrieval when lexical candidates are insufficient |
| LLM reranking | Semantic judgment over a bounded candidate set |

Do not introduce embeddings automatically. A small, fixed corpus may need only
deterministic retrieval plus bounded reranking.

## LLM boundary

### Layer deterministic behavior and AI enhancement

```text
query
  -> immediate exact/lexical result
  -> bounded candidate retrieval
  -> optional semantic interpretation or reranking
  -> schema validation
  -> source-ID validation
  -> trusted application text displayed
```

Do not send every document on every keystroke, make one call per snippet, or ask a model
to search an unbounded corpus and invent its own evidence.

### Treat documents as untrusted data

Prompt instructions should say that document content is data, not instructions; the
model may return only supplied identifiers; it must not invent documents, quotations, or
facts; and it should abstain when evidence is insufficient. Enforce these rules in code.

Prefer structured output such as:

```ts
type ModelResult = {
  matches: Array<{
    snippetId: string;
    relevance: "high" | "medium" | "low";
    reason: string;
  }>;
  abstained: boolean;
};
```

Validate the schema, identifier membership, duplicates, and result count. Display source
text from trusted application state rather than model-authored quotations. Invalid output
should degrade safely rather than crash the interaction.

### Reasoning effort is a measured choice

- Exact identifiers and literal phrases: deterministic code.
- Simple paraphrases: a fast or lower-effort model may be sufficient.
- Ambiguous multi-constraint questions: balanced/higher effort only when representative
  evaluations justify the latency.
- Offline enrichment: higher effort can be rational because it is not blocking a user.

Select and structure relevant context before expensive reasoning. Choose the lowest-cost
configuration that passes the acceptance cases. If only one model is available, make the
choice configurable and identify model routing as a future experiment rather than
fabricating a comparison.

Streaming improves time to first output, not total completion time. Do not display an
unvalidated partial structured result merely because it is streamable.

### Failure contract

- Debounce interactive calls and bound concurrency.
- Propagate abort signals where supported.
- Discard late responses independently of cancellation.
- Fit retries inside one deadline.
- Preserve deterministic results on timeout, overload, rate limit, provider failure, or
  invalid output.
- Explain the degraded state without implying that semantic matching succeeded.

## Minimum useful acceptance cases

| Case | What it proves |
|---|---|
| Exact phrase or identifier | Deterministic precision and highlighting |
| Case and whitespace variation | Normalization behavior |
| Paraphrase with different vocabulary | AI's incremental value |
| Relevant source plus distractors | Candidate and ranking discipline |
| Negation or conflicting text | Meaning is not flattened |
| No relevant source | Abstention rather than invention |
| Invented source ID | Validation rejects hallucinated evidence |
| Timeout or malformed output | Useful fallback survives |
| Query changes during a request | Stale results never replace current results |
| Repeated durable operation | Idempotency where applicable |

For a small fixture, report each observed outcome. Do not invent statistically meaningful
percentiles or generalize from a few examples.

## Testing priorities

Use the narrowest tests that prove the product contract:

- Unit tests for normalization, candidate selection, validation, highlighting, and state
  transitions.
- Integration tests at the Express/provider boundary, including timeout and malformed
  output.
- Workflow tests with mocked Activities when Temporal is involved.
- Postgres integration tests for persistence and uniqueness where material.
- At least one representative public path from input to visible or returned result.

When time is limited, protect the representative path and dangerous failure before
accumulating low-value unit coverage.

## Coding-agent principles

Use agents to increase evidence and throughput, not to outsource ownership.

Good initial read-only tasks are:

1. Trace the relevant React → Express → Temporal/Postgres path with exact file and symbol
   evidence, including current failure behavior.
2. Inspect model configuration, prompts, validation, retries, timeouts, and tests; return
   the smallest safe integration seam.

Keep product intent, architecture, the central implementation, integration, final diff,
and demo claims in the main thread. Verify agent conclusions before accepting them.

Never say “the agent chose this architecture.” Explain the outcome, evidence, alternatives,
and tradeoff that led you to choose it.

## First-hour checkpoint

Bring:

- The customer outcome and dangerous failure.
- The traced execution path.
- Two plausible approaches.
- The recommended smallest complete slice.
- Representative, boundary, and failure acceptance cases.
- The weakest assumption.
- One question that changes the implementation.

Use this structure:

> My understanding is ___. I traced the current path through ___. I considered ___ and
> ___. I recommend ___ because it delivers the smallest complete outcome while preserving
> time for failure handling. The largest uncertainty is ___. Does that align with what you
> want to learn from this project?

After feedback, state what changed and later close the loop with evidence.

## Demo and self-critique

Tell the story as:

1. Customer problem and success condition.
2. One-sentence solution thesis.
3. Representative end-to-end path.
4. The bounded value supplied by AI or durable orchestration.
5. Representative, boundary, and failure evidence.
6. Feedback or evidence that changed the approach.
7. Weakest remaining assumption and rational stopping point.
8. Next hour, day, and week, including the proof each change would require.

A useful self-critique contains four parts:

1. **Evidence:** what works now and how it was observed.
2. **Weakest assumption:** the consequential behavior not yet proven.
3. **Rational stopping point:** why completing this slice was better than adding breadth.
4. **Prioritized experiment:** the next action and what result would change the design.

Do not end with generic promises to “add more tests,” apologize for unfinished breadth,
manufacture a flaw, or claim production readiness.

## Collaboration and motivation

- Ask teammates for product intent and historical context, not facts cheaply verified in
  code.
- Bring decision-ready updates: goal, evidence learned, current bet, largest risk, one ask.
- Credit feedback and show its effect on the result.
- Be honest about uncertainty without becoming passive.
- At informal conversations, learn about customer proximity, ownership, growth, decision
  making, and what makes engineers stay.
- Explain motivation through the work you want to own and the customer impact you seek,
  not generic enthusiasm for AI.

## Sources

- [Temporal Workflow definition](https://docs.temporal.io/workflow-definition)
- [Temporal Activity definition and idempotency](https://docs.temporal.io/activity-definition)
- [Temporal TypeScript Activity timeouts](https://docs.temporal.io/develop/typescript/activities/timeouts)
- [Temporal TypeScript cancellation](https://docs.temporal.io/develop/typescript/workflows/cancellation)
- [OpenAI model selection and reasoning guidance](https://developers.openai.com/api/docs/guides/latest-model)
- [Vercel AI SDK `streamText`](https://ai-sdk.dev/docs/reference/ai-sdk-core/stream-text)
- [Pace multimodal agent architecture](https://withpace.com/news/multimodal-agents)
- [Pace Contextual Reasoning](https://withpace.com/news/cor)
