# Case service

A deliberately small service that evaluates reimbursement cases.

## Run

```sh
npm start
```

The server listens on `PORT` (default `4100`). `POST /evaluate` accepts JSON. The
review console consumes the response, so changing the response shape is a
cross-repository decision.

The business rules are encoded in the implementation and tests. Some behavior is
intentionally under-documented: inspect it and verify assumptions before changing it.
