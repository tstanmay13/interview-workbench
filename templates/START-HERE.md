# Start here

This directory is local interview working state. Do not commit or publish its contents.

## First prompt

Paste this into the supplied coding agent:

```text
Read .workbench/OPERATING-BRIEF.md and .workbench/notebook.md before substantial work.
First, summarize the constraints you loaded in five bullets and identify any conflict
with repository instructions. Do not change code yet.

Help me deliver the smallest verified end-to-end solution. Keep the central path in this
thread. Use at most two initial read-only subagents for genuinely independent discovery,
and require their evidence packets. I own product decisions, integration, and final
claims. Start by helping me complete the problem contract and find the official baseline
commands.
```

## Interview flow

1. Complete the problem contract in `notebook.md` with the engineers.
2. Establish the runnable baseline and workspace map.
3. Run one bounded discovery wave while reproducing the behavior yourself.
4. Fan in, choose the thinnest end-to-end slice, and define acceptance examples.
5. Build through short hypothesis → change → validation → critique loops.
6. Keep `demo.md` skeletal from the start and synthesize it near the end.

Use prompt cards under `prompts/` when a phase needs more detail. They are tools, not a
mandatory checklist.
