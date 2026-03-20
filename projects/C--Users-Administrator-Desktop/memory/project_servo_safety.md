---
name: servo-cylinder-interlock
description: Servo motor must be locked out when any cylinder is in DOWN position — critical safety interlock for tomorrow's work
type: project
---

서보모터 동작은 실린더 하강 시 절대 동작 안 되게 막아야 함 (인터록)

**Why:** 실린더가 하강한 상태에서 서보(인덱스 테이블)가 회전하면 충돌/파손 위험. 물리적 안전 이슈.

**How to apply:** ST-14~20 시퀀스 구현 전에, 서보 회전 명령(APM_DST/APM_INC) 실행 조건에 모든 스테이션 실린더 상승 확인 로직 추가. MainController 자동운전 시퀀스에서 "모든 스테이션 Complete + 실린더 전부 상승" 조건 충족 시에만 서보 회전 허용.
