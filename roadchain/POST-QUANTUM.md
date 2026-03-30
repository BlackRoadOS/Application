# RoadChain & CarKeys — Post-Quantum Security
> Protecting your road against tomorrow's computers — today.

---

## Post-Quantum Key Encapsulation (KEMs)

### What Are KEMs?
Modern replacement for traditional key exchange (ECDH). Two parties agree on a shared secret without transmitting it. Post-quantum KEMs use lattice-based or code-based math that resists Shor's algorithm.

### NIST-Standardized Options (2026)
- **Kyber / ML-KEM** — primary choice. Fast, ~1KB public keys, well-analyzed
- **BIKE / HQC** — code-based alternatives, larger keys, conservative
- **Classic McEliece** — extremely conservative, very large keys

### How BlackRoad Uses KEMs

**CarKeys:**
- Master key generation via Kyber/ML-KEM encapsulation
- Device registration: hybrid KEM (Kyber + ECDH) for shared secrets
- Automatic rotation with post-quantum KEMs — past traffic stays safe even with future quantum
- Biometric + passkey auth wrapped with PQ KEM session keys
- "Quantum Safety" indicator in vault dashboard

**RoadChain:**
- Anchoring keys: hybrid PQ KEMs for encrypting sensitive metadata
- Selective disclosure proofs: private keys protected by Kyber encapsulation
- OneWay exports: PQ KEM-derived encryption keys for confidentiality

**Hybrid Mode (Current Live):**
- Classical (Ed25519 + ECDH) + Post-Quantum (Kyber + Dilithium) in parallel
- Connection secure only if **both** succeed
- Immediate classical security + future quantum protection

---

## Quantum Attack Landscape

### Shor's Algorithm
Breaks integer factorization and discrete logarithm → kills RSA, ECC, ECDH. Does **not** break symmetric crypto (AES) or hashes (SHA-256).

### KEM Vulnerability Matrix

| KEM | Basis | Shor's Vulnerable? | BlackRoad Status |
|-----|-------|-------------------|-----------------|
| Classical ECDH | Elliptic Curves | Yes (fully broken) | Hybrid fallback only |
| Kyber / ML-KEM | Lattices (Module-LWE) | No | Primary PQ KEM |
| BIKE / HQC | Code-based | No | Alternative options |
| Classic McEliece | Code-based | No | Long-term conservative |

### Grover's Algorithm
Quadratic speedup for brute-force. Impact: AES-256 drops to ~128-bit effective security — still extremely strong. SHA-256 stays secure. Minimal impact on BlackRoad.

### "Harvest Now, Decrypt Later"
Real risk: adversaries record encrypted traffic today, decrypt later with quantum. BlackRoad's hybrid KEMs defend against this — the Kyber portion survives.

### Timeline Reality (2026)
- No cryptographically relevant quantum computer exists yet
- Breaking RSA-2048 needs ~1-5 million logical qubits with very low error rates
- Current best: a few dozen logical qubits
- Realistic threat window: 2035-2040+

---

## Quantum Error Correction

### What It Is
Encoding logical qubits (stable) using many physical qubits (noisy). Detects and corrects errors via syndrome measurement. Leading codes: Surface Code, Color Codes, Quantum LDPC.

### Current State (2026)
- Small-scale error correction demonstrated (Google, IBM, Quantinuum)
- "Below threshold" milestone achieved for Surface Code
- Still far from cryptographic scale: need millions of logical qubits, have dozens

### Why It Matters for BlackRoad
QEC is what turns noisy hardware into machines that can run Shor's. Without it, quantum computers can't threaten RoadChain. BlackRoad watches QEC progress and maintains upgrade paths.

---

## BlackRoad's Defense Strategy

### Phase 1 (Current/Live)
- Hybrid KEM: Kyber + ECDH for all key exchanges
- Hybrid signatures: Ed25519 + Dilithium
- Merkle Trees + SHA-256/BLAKE3 (quantum-safe hashing)
- zk-STARKs (hash-based, quantum-resistant) for heavy computation

### Phase 2 (Near-term)
- Default to ML-KEM for all new encapsulation
- Post-quantum signatures as primary, classical as fallback
- "Quantum Hardened" mode for high-value items

### Phase 3 (Long-term)
- Full post-quantum default across all components
- Multiple PQ scheme support (user choice: performant vs conservative)
- Re-signing tool for important historical records
- Migration as public blockchains adopt PQ signatures

### Forward Secrecy
CarKeys rotates keys on schedule using PQ KEMs. Recorded past sessions become un-decryptable after rotation.

---

## Real Impact on Riders

- **Roadie portfolios** created in 2026 remain provable in 2040+ even with widespread quantum
- **BlackBoard assets** keep provenance intact for decades of licensing
- **RoadWork contracts** have quantum-safe audit trails for compliance
- **Device security** via CarKeys: traffic recorded today can't be decrypted later
- **OneWay exports** encrypted with PQ-derived keys for permanent confidentiality

Your road stays yours — even against tomorrow's computers.

*Pave Tomorrow.*
