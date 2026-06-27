# TODO - Admin transfer (two-step) for contracts

- [ ] Update identity-oracle/src/lib.rs
  - [ ] Add PendingAdmin to storage
  - [ ] Add propose_new_admin(current_admin, new_admin)
  - [ ] Add accept_admin(new_admin)
  - [ ] Add tests: admin transfer two-step + non-pending cannot accept

- [ ] Update credit-oracle/src/lib.rs
  - [ ] Add PendingAdmin to storage
  - [ ] Add propose_new_admin(current_admin, new_admin)
  - [ ] Add accept_admin(new_admin)
  - [ ] Ensure admin-gated functions use current Admin address only (already done)
  - [ ] Add tests: admin transfer two-step + non-pending cannot accept

- [ ] Update revocation-registry/src/lib.rs
  - [ ] Add PendingAdmin to storage
  - [ ] Add propose_new_admin(current_admin, new_admin)
  - [ ] Add accept_admin(new_admin)
  - [ ] Add tests: admin transfer two-step + non-pending cannot accept

- [ ] Ensure generated client bindings compile with new methods (via soroban SDK macros)
- [ ] Run cargo test for all contracts/tests

