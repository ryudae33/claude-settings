---
name: Reset must safely retract actuators
description: Reset button should retract 복동 SOL (double-acting) before clearing outputs, not just kill all outputs
type: feedback
---

Reset must safely retract actuators before clearing outputs — don't just kill everything at once.

**Why:** 복동 SOL (e.g., 202.4 2차이송 후진) needs active drive to return to home position. Simply clearing all outputs leaves the actuator extended. User caught this during ST-11 testing.

**How to apply:** When implementing reset for any station, identify 복동 SOL outputs and add retract sequence (ON → wait sensor → OFF) before clearing all outputs. 단동 SOL can just be turned OFF (spring return).
