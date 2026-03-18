---
name: servo-mc-required-bits
description: 1CELL servo motor requires MW200.0 AND MW200.5 both ON to operate — bit5 alone is not enough
type: feedback
---

MW200.0 + MW200.5 둘 다 ON이어야 서보 모터가 동작함.
- MW200.5 = 서보MC 릴레이 (%QX0.0.5)
- MW200.0 = 추가 필수 출력 (정확한 역할 미확인, 서보 전원 또는 인에이블 관련 추정)

**Why:** MW200.5만 켜고 JOG 시도했을 때 PLC는 펄스 출력하지만 모터가 안 움직임. bit0 추가 후 정상 동작.

**How to apply:** PLC 다운로드 후 서보 테스트 시 반드시 MW200.0 + MW200.5 둘 다 SET. CLI 자동화 시 두 비트 모두 포함.
