# Build a vertical increment

Restate the intended outcome, current path hypothesis, fastest falsifying check, and known
uncertainty. If the move is reversible and observable, keep this under 90 seconds and
proceed. If it changes an API, schema, security boundary, destructive behavior, or
cross-repository contract, compare at least one alternative and identify rollback first.

Implement the smallest coherent end-to-end increment using repository conventions. Run
the narrowest meaningful validation, inspect the diff, and return evidence plus the
strongest realistic failure case.
