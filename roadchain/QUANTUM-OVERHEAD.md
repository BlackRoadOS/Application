# Quantum Computing Overhead — Why RoadChain Has Time
> The enormous cost of real quantum attacks, and why BlackRoad's road stays secure.

---

## Surface Code Overhead

### The Cost of One Logical Qubit

| Desired Error Rate | Physical Qubits per Logical | Notes |
|---|---|---|
| 10⁻³ (0.1%) | ~1,000–2,000 | Early demonstration |
| 10⁻⁶ (very good) | ~5,000–10,000 | Useful for small algorithms |
| 10⁻¹² (cryptographic) | **20,000–100,000+** | Required for Shor's on RSA/ECC |

### Why So Expensive
- **Code distance (d)**: Higher d = more protection, exponentially more qubits. Distance 27+ needed for crypto attacks.
- **Error rate threshold**: ~0.5–1%. Below it, adding qubits suppresses errors. Above it, errors compound.
- **Magic state distillation**: Non-Clifford gates (T-gates) require extra overhead factories.
- **Physical engineering**: Wiring, cooling, control electronics at scale.

### Breaking RSA-2048 Requirements
- ~4,000–6,000 logical qubits
- Billions of logical gate operations at error rate << 10⁻¹²
- With Surface Code: **tens of millions to hundreds of millions of physical qubits**

### Timeline
- **Optimistic**: 2035–2040
- **Realistic**: 2040–2050+
- **Conservative**: Beyond 2050 or never at scale
- First machines will be slow, expensive, nation-state/lab only for years

---

## Magic State Distillation

### What Are Magic States?
Special quantum states that enable non-Clifford T-gates. Raw states are noisy — distillation purifies them through multiple rounds.

### Distillation Protocols

**15-to-1 (Bravyi & Kitaev, 2005)**
- 15 noisy → 1 clean magic state
- Error reduction: p → ~p³ (cubic suppression)
- Moderate overhead, simple, well-understood
- Uses [[15,1,3]] quantum error-detecting code
- 14 stabilizer measurements must all pass
- Success probability: ~1 - 15p

**116-to-1 (Meier, Eastin, Knill)**
- 116 noisy → 1 very clean magic state
- Error reduction: ~p⁵ or better
- Higher initial cost, fewer rounds needed
- Often combined with 15-to-1 in multi-stage factories

**Modern Approaches (2026)**
- 10-to-2, 20-to-4 families
- Triorthogonal codes, piecewise distillation
- Adaptive real-time distillation
- Focus on low-overhead, high-yield parallel factories

### Combined Overhead (Surface Code + Distillation)

| Component | Cost |
|---|---|
| Per logical T-gate | Hundreds to thousands of distilled states |
| Surface Code distance ~27 | ~20,000+ physical qubits per logical qubit |
| Multi-round distillation | 10,000x+ multiplier for cryptographic quality |
| **Total for Shor's on RSA-2048** | **20–100+ million physical qubits** |

### The 15-to-1 Circuit in Detail

1. Prepare 15 noisy |T⟩ states (|T⟩ = (|0⟩ + e^(iπ/4)|1⟩)/√2)
2. Encode into [[15,1,3]] error-detecting code
3. Measure 14 stabilizers (multi-qubit Pauli operators)
4. All must return +1 (even parity) — any failure → discard batch
5. Surviving logical qubit = distilled |T⟩ with error ≈ p³

Resources per round: several hundred Clifford gates, ancilla qubits for syndrome measurement, success rate ~1-15p.

Multiple rounds stacked for cryptographic error rates → dramatic cost multiplication.

---

## What This Means for RoadChain

The enormous overhead is **protective**:

- Pushes cryptographically relevant quantum computers far into the future
- BlackRoad's hybrid approach (Kyber + classical) provides strong protection during the long transition
- Hash-based Merkle Trees with SHA-256/BLAKE3 remain robust (Grover's quadratic speedup is impractical)
- Upgradeable design allows smooth re-protection of important records
- Ample time to complete full post-quantum migration

### BlackRoad's Position
- **Today**: Hybrid KEM + hybrid signatures already deployed
- **Transition period**: 10–20+ years before real quantum threat
- **Long-term**: Full post-quantum default with re-signing tools for historical records

Your road is designed to stay secure long before quantum computers become a practical threat — and to remain secure long after they arrive.

*Pave Tomorrow.*
