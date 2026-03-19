# LS Electric PLC — XG5000 & ST Programming Reference

> Sources: LS Electric Official Manuals (XGK/XGB V2.9), AutomationDirect XG5000 Help, IEC 61131-3 Standard
> Last updated: 2026-03-16

---

## 1. XG5000 Software Overview

### 1-1. 지원 언어 (IEC 61131-3)
| 언어 | 약자 | 특징 |
|------|------|------|
| Ladder Diagram | LD | 래더 회로도, 시각적 |
| Instruction List | IL | 니모닉 기반 텍스트 |
| **Structured Text** | **ST** | 고급 언어 (C/Pascal 유사) |
| Sequential Function Chart | SFC | 상태 기계 표현 |

- 함수/함수블록: ST 2,000개 이상, LD 700개 이상
- Task 최대 45개 지원
- 온라인 편집 (PLC 실행 중 프로그램 수정) 지원
- 내장 시뮬레이터 제공

---

### 1-2. 프로젝트 트리 구조
```
Project
├── PLC Series (XGK / XGI / XGB...)
│   ├── Basic Parameters      — 스캔 타임, 워치독 설정
│   ├── I/O Parameters        — 모듈 슬롯별 I/O 할당
│   ├── Communication         — Cnet, FEnet, 내장 RS-485 등
│   ├── Programs              — PROGRAM POU 목록
│   │   ├── Scan Program      — 매 스캔 실행
│   │   └── Task Program      — 조건 기반 실행
│   ├── Function Blocks (FB)  — 사용자 정의 FB
│   ├── Functions (FUN)       — 사용자 정의 함수
│   └── Global Variables      — VAR_GLOBAL 선언
```

---

### 1-3. I/O 주소 체계
```
%IX0.0.0  — Input  슬롯0 채널0 비트0
%QX0.0.0  — Output 슬롯0 채널0 비트0
%IW0      — Input  Word (아날로그 입력)
%QW0      — Output Word (아날로그 출력)
```

**XGK 디바이스 직접 주소 (AT 구문)**:
```st
di_Start   AT %IX0.0 : BOOL;   // P00000 직접 매핑
do_Sol     AT %QX0.0 : BOOL;   // P00200 직접 매핑
ai_Pressure AT %IW0  : INT;    // 아날로그 입력 채널 0
```

---

### 1-4. 온라인 기능 (모니터링 / 디버깅)

| 기능 | 설명 |
|------|------|
| 변수 모니터링 | 4개 모니터 윈도우, 실시간 값 확인 |
| 강제값 설정 | 변수에 임의 값 강제 입력 |
| 트렌드 그래프 | 2D X-Y 플로터로 변수 추이 확인 |
| 중단점(Breakpoint) | 특정 라인에서 실행 일시정지 |
| 단계 실행 | Step-by-Step 실행 |
| 커서까지 실행 | 커서 위치까지 실행 후 정지 |

**변수 모니터 등록**: 변수 우클릭 → "Add to variable monitor" → 모니터 번호 선택

**사용자 단축키**: Tools → Keyboard Shortcuts → [Create Shortcut]
예: `Shift+F8` 으로 자주 쓰는 명령 등록

---

## 2. LS PLC 디바이스 주소 맵

### 2-1. 디지털 디바이스 (BOOL)
| 디바이스 | 접두어 (권장) | 용도 | 비고 |
|---------|-------------|------|------|
| P0xxxx | `di_` / `do_` | 물리 I/O | 입력: P0~P1계열, 출력: P2~P3계열 (슬롯 배치에 따라 다름) |
| M0xxxx | `m_` | 내부 릴레이 | 범용 보조 릴레이 |
| K0xxxx | `hmi_` | HMI 링크 릴레이 | 터치패널 ↔ PLC 인터페이스 |
| F0xxxx | `f_` | 특수 릴레이 | 시스템 제공 (읽기 전용 대부분) |
| L0xxxx | `l_` | 래치 릴레이 | 배터리 백업, 전원 차단 후 유지 |
| T0xxx | `tmr_` | 타이머 접점/코일 | TON/TOF 인스턴스와 대응 |
| C0xxx | `ctr_` | 카운터 접점/코일 | CTU/CTD 인스턴스와 대응 |

### 2-2. 자주 쓰는 특수 릴레이 (F device)
| 주소 | 기능 |
|------|------|
| F0001 | 10ms 클럭 펄스 (5ms ON / 5ms OFF) |
| F0002 | 100ms 클럭 펄스 |
| F0003 | 1s 클럭 펄스 |
| F0004 | 1st 스캔 ON (초기화용) |
| F0010 | 캐리 플래그 |
| F0011 | 제로 플래그 |

### 2-3. 워드 디바이스 (INT/WORD)
| 디바이스 | 접두어 (권장) | 타입 | 용도 |
|---------|-------------|------|------|
| D0xxxx | `d_` | INT / WORD | 일반 데이터 레지스터 |
| W0xxxx | `w_` | INT / WORD | 워드 릴레이 |
| R0xxxx | `r_` | REAL | 실수 레지스터 |
| U0x.xx | `u_` | BOOL/WORD | 특수/통신 모듈 I/O |
| N0xxxx | `n_` | INT | 인덱스 레지스터 |

---

## 3. ST 데이터 타입 (XG5000)

### 3-1. 기본 타입
| 타입 | 크기 | 범위 / 설명 |
|------|------|------------|
| `BOOL` | 1 bit | TRUE / FALSE |
| `SINT` | 8 bit | -128 ~ 127 |
| `INT` | 16 bit | -32,768 ~ 32,767 ← **가장 많이 사용** |
| `DINT` | 32 bit | -2,147,483,648 ~ 2,147,483,647 |
| `LINT` | 64 bit | 큰 정수 |
| `USINT` | 8 bit | 0 ~ 255 |
| `UINT` | 16 bit | 0 ~ 65,535 |
| `UDINT` | 32 bit | 0 ~ 4,294,967,295 |
| `REAL` | 32 bit | ±3.4E±38 (7자리 정밀도) |
| `LREAL` | 64 bit | ±1.7E±308 |
| `BYTE` | 8 bit | 0 ~ 255 (비트 패턴) |
| `WORD` | 16 bit | 0 ~ 65,535 (비트 패턴) |
| `DWORD` | 32 bit | 비트 패턴 |
| `STRING` | 가변 | 최대 32자 ASCII 문자열 |

### 3-2. 시간/날짜 타입
| 타입 | 리터럴 예시 | 설명 |
|------|-----------|------|
| `TIME` | `T#5S`, `T#1M30S`, `T#500MS` | 지속시간 |
| `DATE` | `D#2026-03-16` | 날짜 |
| `TIME_OF_DAY` | `TOD#14:30:00` | 시간 |
| `DATE_AND_TIME` | `DT#2026-03-16-14:30:00` | 날짜+시간 |

**시간 단위**: `D`(일), `H`(시), `M`(분), `S`(초), `MS`(밀리초)
예: `T#1H30M` = 1시간 30분

### 3-3. 배열
```st
VAR
  arr1D : ARRAY[0..9] OF INT;           // 1차원 10개
  arr2D : ARRAY[0..3, 0..3] OF REAL;   // 2차원 4x4
END_VAR

arr1D[0] := 100;
arr2D[1, 2] := 3.14;
```

---

## 4. 변수 선언

### 4-1. 선언 문법
```st
<scope> <identifier> (AT <address>)? : <data_type> (:= <initial_value>)?;
```

### 4-2. Scope 종류
| 종류 | 접근 범위 | 사용 위치 |
|------|----------|---------|
| `VAR` | 현재 POU 내부만 | PROGRAM, FB |
| `VAR_GLOBAL` | 전체 프로젝트 | Global Variable 파일 |
| `VAR_EXTERNAL` | 전역 변수 참조 | PROGRAM 내부 (VAR_GLOBAL 변수 사용 시) |
| `VAR_INPUT` | 외부 → 내부 (읽기) | FUNCTION_BLOCK |
| `VAR_OUTPUT` | 내부 → 외부 (쓰기) | FUNCTION_BLOCK |
| `VAR_IN_OUT` | 양방향 | FUNCTION_BLOCK |
| `VAR_TEMP` | 서브루틴 내 임시 | 함수 |
| `VAR_STAT` | 스캔 간 값 유지 | 함수 |

**Type Qualifiers** (선택사항):
```st
VAR
  gSetpoint : REAL RETAIN;       // 전원 차단 후 값 유지
  MAX_COUNT : INT CONSTANT := 100; // 상수
END_VAR
```

### 4-3. 선언 예제 (VAR_GLOBAL)
```st
VAR_GLOBAL
  // ── Physical Inputs ──────────────────────────────────────────
  di_PlungerFwd  AT %IX0.0 : BOOL;  // P00010 플런저 전진 LS
  di_PlungerBwd  AT %IX0.1 : BOOL;  // P00011 플런저 후진 LS
  di_PartSensor  AT %IX0.2 : BOOL;  // P00012 제품 감지 센서

  // ── Physical Outputs ─────────────────────────────────────────
  do_PlungerSOL  AT %QX0.0 : BOOL;  // P00200 플런저 실린더 SOL
  do_ClampSOL    AT %QX0.1 : BOOL;  // P00201 클램프 SOL

  // ── HMI Interface (K device) ──────────────────────────────────
  hmi_StartCmd   : BOOL;            // K00100 HMI 시작 명령
  hmi_StopCmd    : BOOL;            // K00101 HMI 정지 명령
  hmi_ResetCmd   : BOOL;            // K00102 HMI 알람 리셋

  // ── Internal Flags (M device) ────────────────────────────────
  m_AutoMode     : BOOL;            // M00010 자동 모드
  m_ManualMode   : BOOL;            // M00011 수동 모드
  m_TactBit      : BOOL;            // M00020 택트 신호
  m_AlarmActive  : BOOL;            // M00100 알람 활성

  // ── Step Registers (D device) ────────────────────────────────
  d_PlungerStep  : INT;             // D00120 플런저 자동 스텝
  d_AlarmCode    : INT;             // D00300 알람 코드
  d_PartCount    : INT;             // D00200 생산 수량

  // ── Timers ───────────────────────────────────────────────────
  tmr_PlungerTO  : TON;             // T0010 플런저 타임아웃
  tmr_Delay1     : TON;             // T0011 지연 타이머 1
END_VAR
```

---

## 5. ST 연산자

### 5-1. 연산자 우선순위 (높음 → 낮음)
| 우선순위 | 연산자 | 예시 |
|---------|--------|------|
| 1 | `()` 괄호 | `(a + b) * c` |
| 2 | 함수 호출 | `ABS(x)` |
| 3 | `**` 거듭제곱 | `2**8` = 256 |
| 4 | 단항 `-`, `NOT` | `NOT x`, `-5` |
| 5 | `*`, `/`, `MOD` | `a MOD 2` |
| 6 | `+`, `-` | `a + b - c` |
| 7 | `<`, `>`, `<=`, `>=` | `a > 100` |
| 8 | `=`, `<>` | `a = b` |
| 9 | `AND`, `&` | `a AND b` |
| 10 | `XOR` | `a XOR b` |
| 11 | `OR`, `\|` | `a OR b` |

### 5-2. 대입 연산자
```st
// ⚠️ 반드시 := 사용 (= 는 비교 연산)
result := 100;
result := var1 + var2;
flag := (sensor > 50) AND NOT alarm;
```

### 5-3. 산술 연산
```st
total  := a + b;
diff   := a - b;
product:= a * b;
ratio  := a / b;           // 정수 나눗셈 → 나머지 버림
power  := base ** exp;     // 거듭제곱
remain := value MOD 3;     // 나머지 (3으로 나눈 나머지)
```

### 5-4. 비교 연산 (결과: BOOL)
```st
flag1 := (d_Value > 100);
flag2 := (d_Value >= 50) AND (d_Value <= 200);
flag3 := (d_Step <> 0);   // 0이 아닐 때
```

---

## 6. ST 제어 구문

### 6-1. IF / ELSIF / ELSE
```st
IF condition1 THEN
  statement1;
ELSIF condition2 THEN
  statement2;
ELSIF condition3 THEN
  statement3;
ELSE
  default_statement;
END_IF;
```

### 6-2. CASE (스텝 시퀀스의 핵심)
```st
CASE d_Step OF
  0:
    // 초기 상태
    do_Sol := FALSE;
    IF m_AutoMode AND m_Start THEN
      d_Step := 1;
    END_IF;

  1, 2:               // 여러 값 동시 처리
    do_Sol := TRUE;

  10..20:             // 범위 지정
    // 10 이상 20 이하일 때

  ELSE
    d_Step := 0;      // 정의되지 않은 값 → 초기화
END_CASE;
```

### 6-3. FOR 루프
```st
// 증가
FOR i := 0 TO 9 DO
  arr[i] := 0;
END_FOR;

// 감소 (BY -1 또는 DOWNTO)
FOR i := 9 TO 0 BY -1 DO
  sum := sum + arr[i];
END_FOR;

// 증가폭 지정
FOR i := 0 TO 100 BY 5 DO
  // i = 0, 5, 10, ..., 100
END_FOR;
```

### 6-4. WHILE 루프
```st
WHILE index < MAX_COUNT DO
  IF arr[index] = target THEN
    found := TRUE;
    EXIT;            // 루프 즉시 탈출
  END_IF;
  index := index + 1;
END_WHILE;
```

### 6-5. REPEAT ... UNTIL (최소 1회 실행)
```st
index := 0;
REPEAT
  process(arr[index]);
  index := index + 1;
UNTIL index >= 10 END_REPEAT;
```

### 6-6. RETURN / EXIT
```st
// EXIT — 루프 즉시 종료
FOR i := 0 TO 100 DO
  IF condition THEN EXIT; END_IF;
END_FOR;

// RETURN — 현재 POU(PROGRAM/FB/FUNCTION)에서 즉시 반환
IF error_flag THEN
  RETURN;
END_IF;
```

---

## 7. 표준 함수블록 (IEC 61131-3)

### 7-1. 타이머

```st
VAR
  tmr_Delay   : TON;   // On-delay
  tmr_OffDly  : TOF;   // Off-delay
  tmr_Pulse   : TP;    // Pulse
END_VAR
```

**TON (On-Delay) — 가장 많이 사용**
```st
// IN이 TRUE → PT 시간 경과 후 Q = TRUE
tmr_Delay(IN := di_Sensor, PT := T#2S);
IF tmr_Delay.Q THEN
  do_Output := TRUE;
END_IF;
d_ElapsedMs := tmr_Delay.ET;  // 경과 시간 (TIME 타입)

// ⚠️ 리셋 방법: IN := FALSE 로 호출
tmr_Delay(IN := FALSE);       // 타이머 리셋 (ET=0, Q=FALSE)
```

**TOF (Off-Delay)**
```st
// IN이 FALSE → PT 시간 경과 후 Q = FALSE
tmr_OffDly(IN := m_Run, PT := T#500MS);
do_Fan := tmr_OffDly.Q;
```

**TP (Pulse)**
```st
// IN 상승 엣지 → Q가 PT 시간만큼 TRUE (입력과 무관)
tmr_Pulse(IN := trig_Start.Q, PT := T#100MS);
do_Buzzer := tmr_Pulse.Q;
```

| 핀 | 타입 | 설명 |
|----|------|------|
| `IN` | BOOL (Input) | 시작 신호 |
| `PT` | TIME (Input) | 설정 시간 |
| `Q` | BOOL (Output) | 완료 출력 |
| `ET` | TIME (Output) | 경과 시간 |

---

### 7-2. 카운터

```st
VAR
  ctr_Parts : CTU;   // 업 카운터
  ctr_Down  : CTD;   // 다운 카운터
  ctr_UpDown: CTUD;  // 업/다운 카운터
END_VAR
```

**CTU (Count Up)**
```st
// CU 상승 엣지마다 CV+1, CV >= PV 이면 Q=TRUE
ctr_Parts(CU := di_PartSensor, R := hmi_ResetCmd, PV := 100);
IF ctr_Parts.Q THEN
  m_BatchComplete := TRUE;
END_IF;
d_CurrentCount := ctr_Parts.CV;  // 현재 카운트
```

**CTD (Count Down)**
```st
// LD 신호 → CV = PV 로드, CD 상승 엣지마다 CV-1
// CV <= 0 이면 Q = TRUE
ctr_Down(CD := di_Sensor, LD := m_Load, PV := 50);
IF ctr_Down.Q THEN m_Empty := TRUE; END_IF;
```

**CTUD (Up/Down)**
```st
ctr_UpDown(CU := di_In, CD := di_Out, R := m_Reset, LD := m_Load, PV := 100);
d_Stock := ctr_UpDown.CV;
IF ctr_UpDown.QU THEN m_Full  := TRUE; END_IF;
IF ctr_UpDown.QD THEN m_Empty := TRUE; END_IF;
```

---

### 7-3. 엣지 감지

```st
VAR
  trig_Start : R_TRIG;  // 상승 엣지 (0→1)
  trig_Stop  : F_TRIG;  // 하강 엣지 (1→0)
END_VAR

trig_Start(CLK := hmi_StartBtn);
trig_Stop(CLK := di_PartSensor);

IF trig_Start.Q THEN  // 버튼 누르는 순간 1스캔만 실행
  d_Step := 1;
END_IF;
IF trig_Stop.Q THEN   // 센서 OFF되는 순간 1스캔만 실행
  m_PartPassed := TRUE;
END_IF;
```

---

### 7-4. 래치 (Bistable)

```st
VAR
  sr_Motor : SR;  // Set 우선 (S와 R 동시 → Q=TRUE)
  rs_Alarm : RS;  // Reset 우선 (S와 R 동시 → Q=FALSE)
END_VAR

// 자기유지 모터 제어
sr_Motor(S1 := di_StartBtn AND NOT m_Alarm,
         R  := di_StopBtn OR m_Alarm);
do_MotorRun := sr_Motor.Q1;

// 알람 래치 (수동 리셋 필요)
rs_Alarm(S  := m_FaultDetected,
         R1 := hmi_AlarmReset AND NOT m_FaultDetected);
m_AlarmLatch := rs_Alarm.Q1;
```

---

## 8. 프로그램 구조 단위 (POU)

### 8-1. PROGRAM
```st
PROGRAM PRG_Main
VAR
  trig_Auto : R_TRIG;
  trig_Man  : R_TRIG;
END_VAR

// 자동/수동 모드 전환
trig_Auto(CLK := hmi_AutoBtn);
trig_Man(CLK := hmi_ManBtn);

IF trig_Auto.Q THEN m_AutoMode := TRUE;  m_ManualMode := FALSE; END_IF;
IF trig_Man.Q  THEN m_AutoMode := FALSE; m_ManualMode := TRUE;  END_IF;

// 택트 생성 (모든 유닛 준비 완료 → 동시 출발)
m_TactBit := m_PlungerReady AND m_ClampReady AND m_AutoMode AND NOT m_AlarmActive;

END_PROGRAM
```

### 8-2. FUNCTION_BLOCK
- 상태 유지 (호출 간에 내부 변수 값 보존) ← **타이머/카운터 반드시 FB로 선언**
- VAR_INPUT / VAR_OUTPUT / VAR_IN_OUT 매개변수 사용

```st
FUNCTION_BLOCK FB_Cylinder
VAR_INPUT
  i_Extend  : BOOL;
  i_Retract : BOOL;
  i_FwdLS   : BOOL;
  i_BwdLS   : BOOL;
  i_Timeout : TIME := T#5S;
END_VAR
VAR_OUTPUT
  q_Sol     : BOOL;
  q_AtFwd   : BOOL;
  q_AtBwd   : BOOL;
  q_Timeout : BOOL;
  q_Done    : BOOL;
END_VAR
VAR
  tmr_Fwd : TON;
  tmr_Bwd : TON;
END_VAR

q_Sol   := i_Extend AND NOT i_Retract;
q_AtFwd := i_FwdLS;
q_AtBwd := i_BwdLS;

tmr_Fwd(IN := i_Extend  AND NOT i_FwdLS, PT := i_Timeout);
tmr_Bwd(IN := i_Retract AND NOT i_BwdLS, PT := i_Timeout);
q_Timeout := tmr_Fwd.Q OR tmr_Bwd.Q;
q_Done := (i_Extend AND i_FwdLS) OR (i_Retract AND i_BwdLS);

END_FUNCTION_BLOCK
```

**FB 사용 (인스턴스 생성)**:
```st
VAR
  cyl_Plunger : FB_Cylinder;  // 인스턴스 생성
END_VAR

// 호출 (모든 입력 연결 필수)
cyl_Plunger(
  i_Extend  := m_PlungerExtendCmd,
  i_Retract := m_PlungerRetractCmd,
  i_FwdLS   := di_PlungerFwd,
  i_BwdLS   := di_PlungerBwd,
  i_Timeout := T#5S
);

do_PlungerSOL := cyl_Plunger.q_Sol;
IF cyl_Plunger.q_Timeout THEN m_PlungerAlarm := TRUE; END_IF;
```

### 8-3. FUNCTION
- 상태 유지 없음 (순수 연산)
- 반환값을 함수명에 대입

```st
FUNCTION FC_MsToTime : TIME
VAR_INPUT
  i_Ms : DINT;
END_VAR

FC_MsToTime := DINT_TO_TIME(i_Ms);

END_FUNCTION
```

---

## 9. CASE 스텝 시퀀스 패턴

산업 자동화에서 가장 중요한 패턴. 각 유닛마다 별도 PROGRAM으로 분리.

```st
PROGRAM PRG_PlungerUnit
VAR
  tmr_Timeout : TON;
  tmr_Delay   : TON;
END_VAR

// ── E-Stop: 최우선, 매 스캔 체크 ────────────────────────────────
IF NOT di_EStop OR m_SafetyFault THEN
  do_PlungerSOL := FALSE;
  d_PlungerStep := 999;
END_IF;

CASE d_PlungerStep OF

  // ── 0: 대기 ────────────────────────────────────────────────────
  0:
    do_PlungerSOL := FALSE;
    m_PlungerReady := TRUE;
    IF m_AutoMode AND m_TactBit AND NOT m_AlarmActive THEN
      m_PlungerReady := FALSE;
      d_PlungerStep  := 1;
    END_IF;

  // ── 1: 실린더 전진 ─────────────────────────────────────────────
  1:
    do_PlungerSOL := TRUE;
    tmr_Timeout(IN := TRUE, PT := T#5S);
    IF di_PlungerFwd THEN
      tmr_Timeout(IN := FALSE);
      d_PlungerStep := 2;
    ELSIF tmr_Timeout.Q THEN
      tmr_Timeout(IN := FALSE);
      d_AlarmCode   := 10;      // 알람코드: 플런저 전진 타임아웃
      d_PlungerStep := 0;
    END_IF;

  // ── 2: 전진 후 딜레이 ──────────────────────────────────────────
  2:
    tmr_Delay(IN := TRUE, PT := T#300MS);
    IF tmr_Delay.Q THEN
      tmr_Delay(IN := FALSE);
      d_PlungerStep := 3;
    END_IF;

  // ── 3: 실린더 후진 ─────────────────────────────────────────────
  3:
    do_PlungerSOL := FALSE;
    tmr_Timeout(IN := TRUE, PT := T#5S);
    IF di_PlungerBwd THEN
      tmr_Timeout(IN := FALSE);
      d_PlungerStep := 10;
    ELSIF tmr_Timeout.Q THEN
      tmr_Timeout(IN := FALSE);
      d_AlarmCode   := 11;      // 알람코드: 플런저 후진 타임아웃
      d_PlungerStep := 0;
    END_IF;

  // ── 10: 사이클 완료 ────────────────────────────────────────────
  10:
    d_PartCount   := d_PartCount + 1;
    m_PlungerDone := TRUE;
    d_PlungerStep := 0;

  // ── 999: 비상정지 ──────────────────────────────────────────────
  999:
    do_PlungerSOL := FALSE;
    IF di_EStop AND NOT m_SafetyFault THEN
      d_PlungerStep := 0;
    END_IF;

  ELSE
    d_PlungerStep := 0;         // Failsafe

END_CASE;

END_PROGRAM
```

---

## 10. 다중 유닛 프로그램 구조 (권장)

```
PLC Project
├── Global Variables         ← 모든 I/O, M, D, 타이머 선언
├── PRG_Main                 ← 모드 전환, 택트, 인터록
├── PRG_PlungerUnit          ← 유닛1 자동 시퀀스
├── PRG_ClampUnit            ← 유닛2 자동 시퀀스
├── PRG_PressUnit            ← 유닛3 자동 시퀀스
├── PRG_Alarm                ← 알람 감지 + 코드 할당
├── PRG_HMI                  ← K device ↔ M/D 데이터 교환
├── FB_Cylinder              ← 재사용 실린더 FB
└── FB_Conveyor              ← 재사용 컨베이어 FB
```

### 알람 프로그램 패턴
```st
PROGRAM PRG_Alarm
VAR
  trig_Reset : R_TRIG;
END_VAR

trig_Reset(CLK := hmi_ResetCmd);

// 우선순위 순으로 알람 검출
IF NOT di_SafetyDoor THEN
  d_AlarmCode := 1;       // 안전 도어 열림
ELSIF NOT di_EStop THEN
  d_AlarmCode := 2;       // 비상정지 입력
ELSIF d_AlarmCode = 10 THEN
  (* 플런저 알람 유지 — PRG_PlungerUnit에서 설정 *)
ELSIF d_AlarmCode = 11 THEN
  (* 플런저 후진 알람 유지 *)
ELSE
  IF trig_Reset.Q THEN
    d_AlarmCode   := 0;
    m_AlarmActive := FALSE;
  END_IF;
END_IF;

m_AlarmActive := (d_AlarmCode <> 0);
hmi_AlarmCode := d_AlarmCode;  // HMI에 전달

END_PROGRAM
```

---

## 11. 래더 → ST 변환 가이드

### 11-1. 기본 니모닉 (XG5000 IL) 매핑
| XG5000 IL | ST | 비고 |
|-----------|-----|------|
| `LOAD X` | `X` | 접점 시작 |
| `LOAD NOT X` | `NOT X` | 부정 접점 |
| `AND X` | `AND X` | 직렬 접점 |
| `AND NOT X` | `AND NOT X` | 직렬 부정 접점 |
| `OR X` | `OR X` | 병렬 접점 |
| `OUT Y` | `Y := (조건식);` | 코일 출력 |
| `SET Y` | `IF cond THEN Y := TRUE; END_IF;` | 셋 코일 |
| `RST Y` | `IF cond THEN Y := FALSE; END_IF;` | 리셋 코일 |
| `TON T0001, 500` | `tmr_X(IN:=cond, PT:=T#500MS);` | 온딜레이 타이머 |
| `CTU C0001, 10` | `ctr_X(CU:=cond, PV:=10);` | 업 카운터 |
| `MOV D0100, D0200` | `D0200 := D0100;` | 데이터 이동 |
| `ADD D0100, 1, D0101` | `D0101 := D0100 + 1;` | 덧셈 |
| `SUB D0100, D0101, D0102` | `D0102 := D0100 - D0101;` | 뺄셈 |
| `MUL D0100, D0101, D0102` | `D0102 := D0100 * D0101;` | 곱셈 |
| `DIV D0100, D0101, D0102` | `D0102 := D0100 / D0101;` | 나눗셈 |
| `CMP >, D0100, 100` | `(D0100 > 100)` | 비교 |

### 11-2. 래더 패턴 변환
```
// 직렬 (AND)
--[X1]--[X2]--( Y1 )
→  Y1 := X1 AND X2;

// 병렬 (OR)
--[X1]--+
        +--(Y1)
--[X2]--+
→  Y1 := X1 OR X2;

// 자기유지 (SR 래치)
--[START]--+
           +--(MOTOR)
--[MOTOR]--+
--[/STOP]---
→  sr_Motor(S1 := di_Start AND NOT di_Stop, R := di_Stop);
   do_Motor := sr_Motor.Q1;

// 타이머 접점
--[TON T0001 2000ms]--( M0010 )
→  tmr_X(IN := cond, PT := T#2S);
   m_Flag := tmr_X.Q;

// 비교 접점
--[D0100 >= 100]--( M0020 )
→  m_Flag2 := (d_Value >= 100);

// D레지스터 스텝 분기
--[D0120 = 1]--( 동작A )
--[D0120 = 2]--( 동작B )
→  CASE d_PlungerStep OF
     1: (* 동작A *)
     2: (* 동작B *)
   END_CASE;
```

---

## 12. 주석 규칙

```st
// 한 줄 주석 — 빠른 설명

(* 블록 주석
   여러 줄에 걸쳐 작성 가능 *)

(* ═══════════════════════════════════════════════════
   SECTION: Plunger Unit Auto Sequence
   Devices: P00010~P00014 (IN), P00200~P00203 (OUT)
   Step Reg: D00120
   ═══════════════════════════════════════════════════ *)

do_PlungerSOL := TRUE;   // P00200 — plunger extend SOL

(* TODO: Verify timer value — original ladder T0001=500ms but spec says 300ms *)
(* TODO: Verify — original ladder unclear, inferred from sequence description *)
```

---

## 13. 코딩 주의사항 (LS XG5000 ST 특이사항)

| 항목 | 내용 |
|------|------|
| 대소문자 | 구분 없음 (`IF` = `if` = `If`) |
| 문장 끝 | 반드시 `;` 세미콜론 |
| 비교 | `=` 사용 (C언어의 `==` 아님) |
| 대입 | `:=` 사용 (`=` 사용 시 비교로 해석) |
| TON 리셋 | `tmr(IN := FALSE);` 로 명시적 리셋 필요 |
| 타이머 인스턴스 | FB로 선언된 곳에서만 상태 유지 (VAR/VAR_GLOBAL 필수) |
| 전역 타이머 | VAR_GLOBAL에 선언 시 모든 PROGRAM에서 공유됨 — 의도치 않은 충돌 주의 |
| GOTO | 지원되나 사용 지양 — IF/CASE로 재구조화 권장 |
| REAL 비교 | `=` 직접 비교 금지 → `ABS(a - b) < 0.001` 방식 사용 |

---

## 14. 참고 자료 URLs

| 문서 | 링크 |
|------|------|
| XGK/XGB Instruction Manual V2.9 (EN) | https://sol.ls-electric.com/uploads/document/16411828568550/XGK_XGB_Instruction_Manual_202012_V2.9_EN.pdf |
| XG5000 Manual V2.8 (KR) | https://sol.ls-electric.com/uploads/document/16400519588860/XG5000_Manual_V2.8_202005_KR.pdf |
| AutomationDirect XG5000 Help | https://cdn.automationdirect.com/static/helpfiles/ls_plc/Content/A_IntroductionTopics/LP008-SoftwareOverview.htm |
| ST Syntax Reference | https://cdn.automationdirect.com/static/helpfiles/ls_plc/Content/C_ProcedureTopics/LP304A.htm |
| ACC Automation XGB ST Tutorial | https://accautomation.ca/xgb-plc-structured-text-first-program/ |
| IEC 61131-3 Standard FBs | https://controlforge.dev/docs/standard-function-blocks |
