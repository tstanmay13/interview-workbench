# Challenge: Explainable decision trace

Audit reviewers now need to understand which policy checks produced each decision.
They want an ordered decision trace—not a generic reason string—while existing
automation depends on the current response. Add the smallest end-to-end capability
that makes a case auditable without making the ordinary reviewer experience noisy.

## Expected considerations

- Backward compatibility across the two repositories.
- A stable representation for policy checks and evidence references.
- Failure behavior when the service is unavailable or returns an unknown check.
- Tests at the service boundary and visible proof in the reviewer surface.
- A crisp explanation of what you intentionally did not build.

The work is intentionally larger than one sitting. Scope a coherent vertical slice,
verify it, and leave a prioritized next-step plan.
