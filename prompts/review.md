# Adversarial review

Review only the coherent settled diff. Try to falsify these claims independently:

- behavior matches the agreed outcome and acceptance examples;
- important failure paths are safe and visible;
- repository conventions and cross-repository contracts remain coherent;
- tests assert behavior rather than mirror implementation;
- no security, privacy, destructive-action, or data-handling risk was introduced;
- no unnecessary complexity or unrelated scope entered the diff.

Return findings ordered by consequence with file/symbol evidence and a reproducing check.
Say explicitly when no material finding is supported. Do not edit files.
