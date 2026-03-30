# RoadChain Cryptography
> Zero-knowledge proofs, hybrid SNARK-STARK pipeline, and quantum resistance.

---

## Zero-Knowledge Proofs

Prove facts about your data without revealing the data itself.

### zk-SNARKs vs zk-STARKs

| Aspect | zk-SNARKs | zk-STARKs | RoadChain Winner |
|--------|-----------|-----------|-----------------|
| Proof Size | Very small (hundreds of bytes) | Larger (tens to hundreds of KB) | SNARKs for badges/links |
| Verification Speed | Extremely fast (ms) | Slower for small, scales better for large | SNARKs daily; STARKs batches |
| Trusted Setup | Required (ceremony) | None — fully transparent | STARKs for security |
| Quantum Resistance | Vulnerable (elliptic curves) | Resistant (hash-based) | STARKs for future-proofing |
| Transparency | Lower | High (no secrets) | STARKs for auditability |
| Scalability | Good for small/medium | Superior for large computations | STARKs for high-volume |
| Tooling (2026) | Mature (Zcash, many L2s) | Growing fast (Starknet, StarkEx) | SNARKs today, STARKs catching up |

### Current Use — zk-SNARKs
- Fast verification for everyday badges and shareable proofs
- Small proof size keeps links lightweight
- Quick on-chain anchoring for RoadView "Verified" badges

### Strategic Path — zk-STARKs
- High-volume: batch-proving thousands of RoadTrip messages or RoadWork automations
- Quantum-resistant future-proofing for long-lived records
- Greater transparency for enterprise/compliance

---

## Hybrid SNARK-STARK Pipeline

### Why Hybrid
RoadChain needs conflicting things: fast UX (small proofs) + massive scale + quantum resistance + privacy. Pure SNARK or pure STARK forces trade-offs. Hybrid solves this.

### The Pipeline

**Step 1 — STARK Proving (Heavy Lifting)**
Actions batched → zk-STARK proves the batch is valid, hashes correct, rules followed. No trusted setup. Handles large datasets efficiently.

**Step 2 — SNARK Wrapping (Succinct Final Proof)**
STARK proof → fed into SNARK circuit → tiny constant-size proof: "The STARK is valid and data satisfies all properties."

**Step 3 — User Verification**
Click a badge → verify the small SNARK (milliseconds). SNARK guarantees the underlying STARK. Full STARK available on request for auditors.

**Step 4 — On-Chain Anchoring**
Only the final SNARK proof (or its hash) anchored to Ethereum/Solana. Minimal gas, full STARK security.

### Product Examples

- **Roadie**: STARK proves sessions followed Socratic rules → SNARK wraps → teacher verifies in seconds
- **BlackBoard**: STARK proves full campaign provenance → SNARK creates compact per-asset badges
- **RoadWork**: STARK proves 500 invoices complied → SNARK enables selective disclosure to auditors
- **RoadTrip**: STARK proves agent hand-offs followed triggers → SNARK shares one verified insight privately

### Status
- **Today**: SNARK-friendly constructions + Merkle Trees for batching
- **Near-term**: Full STARK layer for high-volume batches
- **Long-term**: Hybrid default — STARK computation, SNARK verification

---

## Quantum Resistance

### Why It Matters
Records meant to last decades (portfolios, creative assets, contracts, memories). If quantum breaks the crypto, attackers forge provenance, alter history, impersonate users. RoadChain's value depends on mathematical finality surviving quantum.

### Current Foundations (2026)

**Quantum-Safe Today:**
- SHA-256 / BLAKE3 hashing — Grover's algorithm only quadratic speedup, still impractical
- Merkle Trees — hash-based, inherently resistant
- zk-STARKs — hash-based, not vulnerable to Shor's algorithm

**Vulnerable (Being Migrated):**
- Ed25519 signatures — elliptic curve, vulnerable to Shor's algorithm
- zk-SNARKs — elliptic curve based, will be hybridized

### Post-Quantum Signature Roadmap

**Candidates:**
- **Dilithium** (lattice-based, NIST-standardized) — fast verification, reasonably small
- **Falcon** (lattice-based) — smaller signatures, slower signing
- **SPHINCS+** (hash-based) — very conservative, larger signatures

**Migration Phases:**
1. **Phase 1 (Current)**: Hybrid mode — Ed25519 + Dilithium dual signatures where feasible
2. **Phase 2 (Near-term)**: Post-quantum default for new actions, backward compat for old
3. **Phase 3 (Long-term)**: Full post-quantum default + tools to re-sign historical records

### Post-Quantum Hash & Tree Upgrades
- Upgradeable hash functions (SHA-3, future NIST PQ hashes) via soft forks
- XMSS / LMS stateful hash-based signature schemes for stronger leaf-to-root proofs
- zk-SNARKs replaced or hybridized with lattice-based SNARK variants as they mature

### CarKeys Integration
- Already supports multiple key types
- Users can generate post-quantum key pairs alongside classical
- Automatic rotation will prefer PQ keys over time

### Real Impact
- Roadie portfolio created today provable in 2040 even with widespread quantum
- BlackBoard assets verifiably original for licensing decades later
- RoadWork audit trails quantum-safe for compliance

---

## Summary

| Layer | Today | Future |
|-------|-------|--------|
| Hashing | SHA-256 / BLAKE3 (quantum-safe) | SHA-3 + upgradeable |
| Signatures | Ed25519 + hybrid Dilithium | Full Dilithium/Falcon |
| ZK Proofs | SNARKs (user-facing) | Hybrid SNARK-STARK |
| Merkle Trees | Hash-based (safe) | XMSS/LMS optional |
| Anchoring | Ethereum + Solana | Multi-chain + PQ |

Your road stays yours — even against tomorrow's computers.

*Pave Tomorrow.*
