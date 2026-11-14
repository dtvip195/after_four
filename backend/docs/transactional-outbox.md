# Transactional outbox boundary

Implementation Phase 1 creates `outbox_events` and writes `preparation.dispatch_requested` in the same transaction as eligible full settlement and the unique Preparation Dispatch. It also schedules the independent pending-payment expiration job through Solid Queue.

The delivery boundary is:

1. the business state and `outbox_events` row commit in the same PostgreSQL transaction;
2. an Active Job receives only the outbox identifier after commit;
3. the worker claims and delivers idempotently, recording attempts and retry timing;
4. external I/O never runs inside the business transaction;
5. queue delivery is not the source of business truth and never replaces a domain record such as Preparation Dispatch.

The publisher/consumer, claim protocol, delivery-attempt recording, and Preparation Ticket creation are not implemented in this phase. Until an authorized later phase supplies them, events remain durable with `status = pending`; no external I/O is performed and payment truth is not inferred from queue state.
