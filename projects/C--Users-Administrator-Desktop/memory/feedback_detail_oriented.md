---
name: detail-oriented-user
description: User values thorough edge case handling and expects proactive overflow/safety prevention without being asked
type: feedback
---

User is detail-oriented and expects edge cases to be handled proactively (e.g., overflow prevention, safety checks).

**Why:** User caught CRD overflow issue before it was mentioned — "원천적으로 방지해야지" (prevent it fundamentally).

**How to apply:** When writing PLC/servo/motion code, always consider boundary conditions, overflow, sign handling, and long-term accumulation issues upfront. Don't wait for the user to point them out.
