# TMflow SW 2.18 완전 레퍼런스

**소스**: Software Manual TMflow SW2.18 Rev1.02 (617페이지)
**작성일**: 2026-02-22
**목적**: 노드 구성 숙련자 기준, Script 프로젝트 연계 활용을 위한 전체 기능 레퍼런스

---

## 목차

1. [TMflow 프로젝트 구조](#1-tmflow-프로젝트-구조)
2. [노드 종류별 상세](#2-노드-종류별-상세)
3. [변수 시스템](#3-변수-시스템)
4. [설정 화면](#4-설정-화면)
5. [비전 (TMvision/AI Vision)](#5-비전-tmvisionai-vision)
6. [통신 설정](#6-통신-설정)
7. [Force 관련 노드](#7-force-관련-노드)
8. [Modbus 주소 목록 (Appendix C)](#8-modbus-주소-목록-appendix-c)
9. [Ethernet Slave 데이터 테이블 (Appendix D)](#9-ethernet-slave-데이터-테이블-appendix-d)
10. [기타 기능](#10-기타-기능)

---

## 1. TMflow 프로젝트 구조

### 1.1 Flow 프로젝트 vs Script 프로젝트 (p.48~49, p.97~99)

| 항목 | Flow Project | Script Project |
|------|-------------|----------------|
| 프로그래밍 방식 | 노드 드래그&드롭 그래픽 UI | TMscript 언어 직접 작성 |
| 대상 | 프로그래밍 경험 불필요 | 스크립트 경험 있는 숙련자 |
| Manager | Point Manager, Variables, Global Variables, Display Manager | Global Variables, Vision Manager |
| Project Function | Operation Scene, Modbus Device, Stop Watch, F/T Sensor, Camera View, Serial Port, Path Generate, Joint Loading, Network Device, Project Lock, Acceleration Table, TMcraft Setup | Operation Scene, Camera View |
| Others | Undo/Redo, EditBlock, Search, Step Run, Comment, Base List, TCP List | Teach Point, Controller, Syntax Check, Quick Control, Base List, TCP List, Project Speed |
| Syntax Check | 없음 (실행 시 자동 체크) | Ctrl+Shift+B 또는 툴바 버튼 |
| 새 프로젝트 단축키 | Ctrl+N | Ctrl+Shift+N |

### 1.2 프로젝트 생성/관리 (p.49, p.73~75)

- **네이밍 규칙**: 영문 대소문자(A~Z, a~z), 숫자(0~9), 언더스코어(_) 사용 가능. 첫 글자는 숫자 불가. 최대 100자.
- **File > New Flow / New Script**: 새 프로젝트 생성
- **File > Save Project**: 저장 (빌드 날짜/최종 수정 날짜 함께 저장)
- **File > Open Project**: 기존 프로젝트 열기 (알파벳순/역순/날짜순 정렬, Batch Delete 지원)
- **Import/Export**: ≡ > System > Import/Export (USB 드라이브 레이블 TMROBOT 필요)
  - 내보내기 항목: Project, Point, Base, Modbus, F/T Sensor, Global Variable, Path, Motion Record, TCP, Component, Operation Scene, Text Files, Safety Config 등

### 1.3 프로젝트 탭 구조 (p.76~77)

- **Main Flow**: 메인 프로젝트 흐름
- **Subflow 탭** (연한 파란색): 서브플로우 페이지
- **Thread 탭** (연한 노란색): 스레드 페이지
- **CloseStop 탭**: 프로젝트 정상 종료 시 실행 (최대 12초, Motion 노드 불가)
- **ErrorStop 탭**: 에러 발생 시 실행 (최대 12초, Motion 노드 불가, IO/통신만 가능)
- **탭 추가**: 좌상단 + 버튼으로 Subflow/Thread/Non-pause Thread 추가

### 1.4 서브플로우 (Subflow) 구성 (p.177~179)

- Subflow Node를 플로우에 드래그하면 새 Subflow 페이지 자동 생성
- 기존 Subflow 페이지가 있으면 선택 또는 새로 만들기 선택
- Subflow 내에서 Variables, Tool, Base는 원래 페이지와 공유
- Subflow 내 Start Node의 Edit 아이콘으로 페이지 삭제 가능

### 1.5 Thread (p.180~181)

- 로봇 모션과 독립적으로 상태 모니터링/데이터 수집 실행
- Thread 페이지에는 논리 노드만 추가 가능 (Motion 노드 불가)
- **Thread Page**: 프로젝트 일시정지 시 같이 정지
- **Non-pause Thread Page**: 프로젝트 일시정지 중에도 계속 실행
- 20개 이상의 Thread는 CPU 과부하 발생 가능

### 1.6 Start Node 설정 (p.168)

- 초기 프로젝트 실행 속도 설정 (MANUAL MODE 기본 5%)
- DO/AO 초기 상태 설정 (프로젝트 시작 시 초기화)
- **Enable continuous motion**: IO 쓰기가 Point-Point 이동 경로를 방해하지 않도록 설정 (기본 unchecked)
- **Enable busy loop optimization**: 바쁜 루프로 인한 CPU 과부하 방지
- TMcraft Setup 바로가기 버튼 제공

### 1.7 다른 프로젝트의 페이지 추가 (p.181~182)

좌상단 + 버튼 > "Add page from another project":
1. 추가할 프로젝트 선택
2. 추가할 페이지 선택
3. 새 네임스페이스 지정 (명명 충돌 방지)
- 다른 프로젝트의 Main Flow는 Subflow로 변환됨
- Thread/Non-pause Thread는 특성 유지

---

## 2. 노드 종류별 상세

### 2.1 Motion Nodes

#### Point Node (p.153~154)

Point Node는 플로우에서 가장 기본적인 이동 노드.

| 설정 항목 | 설명 |
|-----------|------|
| Motion mode | PTP 또는 Line |
| Target Type (PTP only) | Cartesian Coordinate 또는 Joint Angle |
| Point Management | 기존 포인트 선택 또는 Point Manager 열기 |
| Blending | By Percentage 또는 By Radius (Line mode) |
| Advanced | Base Shift / Tool Shift |
| Payload | 로봇 엔드 하중 설정 (integer/float/double 변수 지원) |
| Precise Positioning | 정밀 위치 도달 후 다음 명령 실행 여부 |
| Singularity Handling | Line 선택 시 사용 가능. 특이점 통과 시 속도 변경 (블렌딩 불가) |
| Offset settings | 오프셋 방향/양 설정 |

**생성 방법**:
1. 노드 목록에서 Point Node 드래그
2. End Module의 POINT 버튼 클릭

#### Move Node (p.155~156)

현재 위치 기준 상대 이동.

| 설정 항목 | 설명 |
|-----------|------|
| 이동 방식 | Base X/Y/Z/RX/RY/RZ 또는 Joint J1~J6 |
| Joint Speed | Speed(%) 슬라이더 + Time to top speed |
| Base 선택 | Tool 또는 Current Base |
| 변수 사용 | {X} 버튼으로 변수 입력 가능 (integer 타입) |

#### Circle Node (p.156~158)

3점(P1 현재위치/P2 통과점/P3 종점) 으로 호 이동.

| 설정 항목 | 설명 |
|-----------|------|
| Pass Point | P2 (통과점) |
| End Point | P3 (종점) |
| End Criteria | Reach End Point 또는 Target Central Angle (integer 변수 지원) |
| Rotation | Linear Interpolation (포즈 변화) 또는 Keep Rotation (포즈 유지) |
| Speed | PTP/Line 속도 설정 동일 |

#### Path Node (p.158~160)

.Path 파일을 읽어 경로 이동.

| 설정 항목 | 설명 |
|-----------|------|
| Path File | 가져온 Path 파일 또는 파일명 string 변수 |
| Speed | 속도% (Link to project speed 가능) |
| Data Type | Time (불규칙 속도/정지 포함) 또는 Position (일정 속도) |
| Direction | Forward 또는 Backward |
| First Point Motion | PTP (Cartesian/Joint Angle) 또는 PLine |
| Path Task | 경로 포인트별 IO 설정 |
| Advanced | Base Shift / Tool Shift |
| Precise positioning | 정밀 위치 도달 여부 |

**PLine**: Path 파일 전용 특수 모션 모드. 조밀한 점들 사이를 부드럽게 이동.

#### Pallet Node (p.160~162)

3점 좌표 + 행/열 수로 팔레트 이동.

| 설정 항목 | 설명 |
|-----------|------|
| Pallet Pattern | 좌→우 또는 우→좌, 줄 단위 이동 패턴 |
| 3 Points | P1(1열 시작/포즈 결정), P2(1열 종점), P3(마지막 열 종점) |
| Approach Point | P1/P2/P3 기준 접근점 (LINE 모드로 이동) |
| Number of Rows/Columns | 행/열 수 |
| Number of layers | 레이어 수 및 각 레이어 높이 |
| Direction | bottom-up 또는 top-down |
| Correlate to variable (Int) | 행/열/레이어 번호를 변수와 연결 |

**주의**: Pallet Node는 Loop 노드와 함께 사용해야 다음 위치로 이동.
변수 연결 시 타겟 행/열/레이어 = 변수값 + 1 (0-based).

#### Listen Node (p.162~164)

소켓 서버를 구성하여 외부 장치와 통신.

| 설정 항목 | 설명 |
|-----------|------|
| Send Message | 노드 진입 시 초기 메시지 전송 |
| Print Received Data in Log | 통신 로그 출력 여부 |
| Connection Timeout | 연결 대기 타임아웃 (ms, <=0이면 무제한) |
| Data Timeout | 데이터 수신 대기 타임아웃 (ms, <=0이면 무제한) |

- IP: Human-Machine Interface > System > Network > IP Address
- Port: **5890** (고정)
- Pass 조건: `ScriptExit()` 실행 또는 항목 중지
- Fail 조건: Connection Timeout, Data Timeout, 서버 미구성 상태에서 진입

수신 명령은 순서대로 실행. 잘못된 명령이면 줄 번호 포함 오류 반환.
명령 카테고리: (1) 즉시 실행 (변수 할당 등), (2) 큐에 순서 실행 (모션/IO 등).
**TM Ethernet Slave 프로토콜 참조**: Programming Language TMscript.

---

### 2.2 Logic Nodes

#### Start Node (p.168)

- 초기 속도, DO/AO 초기화, continuous motion, busy loop optimization 설정

#### SET Node (p.168~170)

IO 상태 설정, 변수 타입/값 변경.

**SET 문법**:
| 문법 | 설명 |
|------|------|
| `a += b` | a = a + b |
| `a -= b` | a = a - b |
| `a *= b` | a = a * b |
| `a /= b` | a = a / b |
| `a = b` | a에 b 값 할당 |

- Analog IO 설정 가능 (-10V~10V)
- 파라미터화 객체 지원: Point, Base, TCP, VPoint, IO, Robot, FTSensor (TMscript 참조)
- Expression Editor에서 여러 수식 추가, 위아래 이동으로 순서 변경

#### IF Node (p.171~172)

조건 판단 → Yes/No 경로 분기.

| 연산자 | 설명 |
|--------|------|
| `<` | 미만 |
| `>` | 초과 |
| `==` | 같음 |
| `<=` | 이하 |
| `>=` | 이상 |
| `!=` | 다름 |

- IO 상태, 변수 상태, Compliance 상태 판단 가능

#### WaitFor Node (p.173)

설정 조건 충족 시까지 프로젝트 대기.
조건: IO, Time, Variables

#### Gateway Node (p.173~174)

IF Node의 다중 조건 버전. CASE 목록 위→아래 순서로 판단, 충족된 CASE의 출력으로 이동.
**주의**: 일치하는 CASE가 없으면 Gateway Node에서 데드락. 반드시 Default CASE(조건 없음) 추가 필요.

#### M-Decision Node (p.174)

흐름 일시정지 후 사용자가 CASE를 선택하여 계속 진행.
- 메시지 박스가 View 페이지에 표시
- 컨트롤 권한이 있는 사용자만 선택 가능
- Main flow, Subflow, Thread 모두 적용 가능

#### Script Node (p.174~175)

TMscript 언어로 복잡한 로직/계산을 Flow 내에서 구현.
- Listen Node의 외부 장치 없는 버전과 유사
- **함수 정의 불가** (function 선언 불가)
- Thread 내 사용 시 모션 관련 함수 사용 불가

---

### 2.3 Process Nodes (p.175~177)

| 노드 | 기능 |
|------|------|
| Pause Node | Robot Stick의 Pause와 동일. 사용자가 Robot Stick Play로 재개. Voice 함수 사용 가능. |
| Stop Node | Robot Stick의 Stop과 동일. 프로젝트 종료. Stop 이후에 노드 연결 불가. |
| Goto Node | 무조건 지정 노드로 점프. 연결선은 클릭 시에만 표시(빨간색). |
| Warp Node | 다른 프로젝트로 제어 이전. 기존 프로젝트의 Variables/Base/Tool은 전달 안 됨 (Global Variable로 전달 가능). AUTO MODE에서 가장 효율적. |

---

### 2.4 Flow Control

| 노드 | 분류 | 설명 |
|------|------|------|
| Start | Logic | 프로젝트/Subflow/Thread 시작 |
| SET | Logic | 변수/IO 설정 |
| IF | Logic | 조건 분기 |
| WaitFor | Logic | 조건 대기 |
| Gateway | Logic | 다중 조건 분기 (Switch 유사) |
| M-Decision | Logic | 수동 조건 선택 |
| Script | Logic | TMscript 인라인 스크립트 |
| Pause | Process | 일시정지 |
| Stop | Process | 종료 |
| Goto | Process | 무조건 점프 |
| Warp | Process | 다른 프로젝트로 이전 |
| Subflow | Process | 서브플로우 호출 |

---

### 2.5 Communication & Display Nodes

#### Network Node (p.190~191)

외부 장치와 TCP 소켓 통신 (클라이언트로 동작).

| 설정 항목 | 설명 |
|-----------|------|
| Choose Device | 사전 등록된 네트워크 장치 선택 (IP, Port) |
| Receive from variable | 수신 데이터를 변수에 저장. Maximum received data time(ms) 설정 |
| Send / Typing | 직접 입력 메시지 또는 변수 선택 |
| Extra Idle Time | 추가 대기 시간 (ms, 변수 가능) |
| Connection Status | 연결 상태를 변수에 저장 |

**주의**: Network Node는 클라이언트. 서버에만 연결 가능.

#### Log Node (p.192~194)

변수/문자열을 공유 폴더에 텍스트 파일로 저장.

| 설정 항목 | 설명 |
|-----------|------|
| Content | 텍스트 입력 또는 {x} 버튼으로 변수 선택 |
| Save Device | 저장 장치 선택 (Network Service에서 설정한 원격 호스트 포함) |
| Save Directory | 저장 경로 |

#### Display Node (p.194~195)

View 페이지 Display Board에 변수/문자열 표시.
- 배경색/텍스트색 변경 가능 (7색: red, green, blue, yellow, black, white, gray)

#### Voice Node (p.195~196)

스피커로 텍스트/변수를 음성 출력.
- **Speak and Move**: 이동하면서 동시에 음성 출력
- **Speak, then Move**: 음성 출력 완료 후 이동
- **주의**: Thread에서 빠른 루프와 함께 사용 시 버퍼 초과로 무한 재생 위험

---

### 2.6 AI Vision Node (p.183~184)

Flow에서 Vision Job을 실행하는 노드.

- **Positioning Node**: 물체 위치결정, 랜드마크 위치결정, 서보 타입, 각종 위치결정 기능
- **Inspection Node**: AOI 식별 기능

노드 아이콘의 Base 아이콘(우측): 비전 잡의 스냅 포인트 기록에 사용된 Base
노드 아이콘의 Base 아이콘(좌측): Positioning 노드가 생성하는 Base
노드 아이콘(우측 하단): 스냅 포인트 이동 모션 타입

---

### 2.7 Force Related Nodes

#### Compliance Node (p.200~205)

단일 축 방향으로 힘 제한을 설정하여 충돌 테스트/조립/탐색에 활용.

**Setting 유형**:
| 유형 | 설명 |
|------|------|
| Single Axis | 방향(X/Y/Z/RX/RY/RZ), 거리, 목표 힘/토크, 속도 설정 |
| Teach | 선형 방향 또는 회전 방향 티칭. 2점으로 방향/거리 계산. Move Node와 유사한 상대 이동 |
| Advanced | 각 축별 힘/토크, 거리 제한, 목표 속도 설정. F/T 센서 없이 사용 가능 |
| Impedance | Stiffness 설정. 현재 위치 유지하면서 외력에 순응. AMR 등 이동 베이스 탑재 시 활용 |

**Single Axis 파라미터 범위**:
- Force limit: 30~150 N (X/Y/Z)
- Torque limit: 5,000~15,000 mNm (RX/RY/RZ)
- Linear speed limit: 30~100 mm/s
- Angular speed limit: 30~180 deg/s

**Stop Criteria**:
- Over: Time (시간 초과)
- Over: F/T (Compliance) (저항 감지 시 속도 0 → 노드 해제)
- Receive: DI (지정 DI 트리거)
- Receive: AI (지정 AI 조건 충족)

**Output Variable 값**:
| 값 | 의미 |
|----|------|
| 2 | Timeout |
| 3 | Distance Reach |
| 4 | DI/AI Triggered (Stroke % 이후) |
| 5 | Resisted |
| 6 | ERROR |
| 14 | Over Speed |

#### Touch Stop Node (p.210~216)

3가지 Function Type: Compliance, Line, Force Sensor.

**Function Type: Compliance** - 힘 제한으로 단일 축 이동, 정지 위치 기록 가능
**Function Type: Line** - 외부 신호로 직선 이동 정지 (속도 안정화 필요)
**Function Type: Force Sensor** - F/T 센서 측정값으로 정지

**Line Output Variable 값**:
| 값 | 의미 |
|----|------|
| 3 | Distance Reach |
| 201 | Digital Input |
| 202 | Analog Input |
| 203 | Variable |

**Force Sensor Output Variable 추가**:
| 값 | 의미 |
|----|------|
| 2 | Timeout |
| 204 | Force Satisfied |

**Record Stopping Position on POINT**: 브레이크 시 로봇 위치를 동적 포인트로 기록 (Stopping position 또는 Triggered position 선택)
정지 시 Modbus 주소에 좌표 기록 (Appendix C 참조)

#### Smart Insert Node (p.216~221)

조립/삽입 작업 전용. F/T 센서 필수.

**3단계**:
1. **Approaching**: Tool Z축 방향으로 이동, F/T 센서 5N 감지 시 종료
2. **Searching**: 소켓 입구 탐색 (나선형/격자 패턴)
3. **Pushing**: 삽입 방향으로 밀기

**주의**: Tool 좌표계 방향이 F/T 센서 설치 방향과 일치해야 함. 불일치 시 Force Control Node 사용.

#### Force Control Node (p.222~229)

힘/토크 제어. F/T 센서로 접촉력 측정 및 힘 제어.

---

### 2.8 기타 노드

#### Collision Check Node (p.250~251)

충돌 검출 노드.

#### Component Node (p.197~199)

TM Plug & Play 소프트웨어 패키지. USB 드라이브(TMROBOT 레이블)에 넣고 Import 후 Component List에서 활성화.
활성화된 Component는 좌측 노드 목록에 추가되어 드래그&드롭 사용.

---

## 3. 변수 시스템

### 3.1 로컬 변수 (Local Variables) (p.165~167)

- 단일 프로젝트 내에서만 유효
- 이름 앞에 `var_` 접두사
- Manager > Variables에서 선언

**데이터 타입**:
| 타입 | 설명 | 범위/형식 |
|------|------|-----------|
| `string` | 문자열 | `"TMflow"` (큰따옴표 필수) |
| `int` | 정수 | -2³¹ ~ 2³¹-1 |
| `float` | 부동소수점 | 10⁻³⁷ ~ 10³⁸ (유효 6~7자리) |
| `double` | 배정밀도 부동소수점 | 10⁻³⁰⁷ ~ 10³⁰⁸ (유효 15~16자리) |
| `bool` | 불리언 | True, False |
| `byte` | 바이트 | -2⁷ ~ 2⁷-1 |

**배열 선언**: 배열명 + 크기 입력. 첫 번째 인덱스는 0.
예: Array 크기 10 → Array[0] ~ Array[9]

**Text File 읽기**: string 타입 변수만 텍스트 파일 내용을 값으로 읽을 수 있음. Array/Global Variable/기타 타입 불가.

### 3.2 글로벌 변수 (Global Variables) (p.167)

- 모든 프로젝트에서 공유
- 이름 앞에 `g_` 접두사 (예: `g_count`)
- 시스템 종료 후에도 값 유지 (재초기화 안 됨)
- Manager > Global Variable에서 선언
- Script 프로젝트: Manager > Global Variable 동일

### 3.3 파라미터화 객체 (Parameterized Objects) (p.169~170)

Expression Editor에서 다음 객체를 변수처럼 사용 가능:

```
Point["P1"].Value         -- 포인트 P1의 좌표값
Base["base1"].Value       -- Base base1의 값 (쓰기 가능)
Base["base1", index].Value -- index 지정 버전
TCP["tool1"].Value        -- TCP 값
IO["DO0"].Value           -- IO 상태
Robot.XXX                 -- 로봇 상태
FTSensor.XXX             -- F/T 센서 값
VPoint["vp1"].Value      -- Vision Point
```

표현식은 3부분: item, index, attribute
세 가지 모두 또는 일부 생략 가능.

---

## 4. 설정 화면

### 4.1 Configuration 메뉴 구성 (p.100~110, ≡ > Settings > Configuration)

| 항목 | 내용 |
|------|------|
| Tool Settings | TCP 생성 (FreeBot 티칭 / 파라미터 직접 입력 / Vision TCP Calibration) |
| Safety | 안전 파라미터 설정 (Ch.3 참조) |
| Vision Settings | 카메라 파라미터, 캘리브레이션, 이미지 파일 관리 |
| TM AI+ | TM AI+ Training Server 참조 |
| Connection Settings | Modbus Slave, TM Ethernet Slave, Profinet Server, EtherNetIP Server |
| External Device | EtherCAT IO 외부 장치 구성 |
| Component | 활성화된 Component 목록 관리 |
| TMcraft Management | Node/Service/Shell/Toolbar/Setup 관리 |
| IO Setup | 출력 기본값, User-Defined IO, Serial Port 설정, Custom IO Name |
| End Button | Point/Gripper/Vision 버튼 동작 설정 |
| Motion Settings | Speed Suppression, Deceleration Time, Resumption Behavior |
| Text File Manager | 텍스트 파일 목록 및 미리보기/편집 |
| ROS Settings | TM ROS Driver 활성화, Domain ID 설정 |

### 4.2 Connection Settings (p.101~102)

#### Modbus Slave 설정

**Modbus TCP**:
- Enable/Disable 스위치로 ON/OFF
- ON 시 Modbus TCP Server로 동작
- IP Filter: 네트워크 마스크로 접근 허용 도메인 설정
- Code Table 버튼: Modbus slave 인코딩 정의 파일 열기

**Modbus RTU**:
- 외부 장치와 파라미터 동기화 후 시리얼 포트로 통신
- Serial Port 설정과 연동

#### TM Ethernet Slave 설정

- Enable/Disable 스위치
- ON 시 소켓 서버로 동작 (IP Filter 적용)
- Programming Language TMscript 프로토콜 따름

#### Profinet Server / EtherNetIP Server 설정

- Enable/Disable 스위치
- Endianness: Big-endian 또는 Little-endian 선택
- Code Table 버튼으로 데이터 테이블 확인
- Expression Editor > Connection > Profinet/EtherNetIP 선택 후 Function 선택
- **주의**: 하나만 활성화 가능. 전환 시 재부팅 필요할 수 있음.

### 4.3 IO Setup (p.105~106)

**Control Box IO 채널 정의**:
| 채널 | 입력 기능 | 채널 | 출력 기능 |
|------|-----------|------|-----------|
| DI 10 | Stick + 버튼 | DO 10 | Stick + 버튼 |
| DI 11 | Stick - 버튼 | DO 11 | Stick - 버튼 |
| DI 12 | Stick PAUSE | DO 12 | Stick PAUSE |
| DI 13 | Stick PLAY | DO 13 | Stick PLAY |
| DI 14 | Stick STOP | DO 14 | Stick STOP |
|       |             | DO 15 | System Error Indicator |

**주의**: User-Defined Robot Stick 기능은 Remote Control with Digital Input 활성화 시에만 동작.

### 4.4 Safety Settings (Ch.3, p.34~45)

**접근**: ≡ > Configuration > Safety
**기본 비밀번호**: Configuration Tool `00000000`, Robot Stick `+ - + + -`

#### 주요 설정 탭

**Speed & Force**:
- **General**: Hand Guide TCP 속도 제한 (T1/TCH MODE별), End-Point Reduced Speed Limit
- **Performance Safety**: Safety Tool 속도/Joint 속도/TCP 힘/Elbow 힘/Joint 토크 제한 (항상 적용)
- **Human-Machine Safety**: 협동 운전 중 속도/힘/토크 제한. Quick Setting으로 ISO/TS 15066 기반 바이오메카니컬 한계 빠른 설정 가능.

**Soft Axis**:
- Default & Additional
- Joint Position Limit
- Cartesian Limit A & Cartesian Limit B

**Safety IO**:
- Input Functions: SF1(User ESTOP), SF3/SF9(External Safeguard), SF15(Enabling Switch), SF16(ESTOP without Robot ESTOP Output), SF23(Bumping Sensor), SF25(MODE Switch), SF26(Reset), SF27(Soft Axis Switch)
- Output Functions: SF2(Standstill), SF10(Robot ESTOP), SF11(External Safeguard), SF12(Human-Machine Safety), SF13(Recovery Mode), SF14(Robot Moving), SF20(Reset), SF28(Enabling Switch), SF29(MODE Switch), SF30(Safe Home)
- Input Ports & Output Ports: SI 0~7, SO 0~7

**Safety Tool**: 안전 도구 설정
**Mounting Direction**: 마운팅 방향 설정

#### Motion Settings - Resumption Behavior (p.108~109)

- ≡ > Configuration > Motion Settings > Resumption Behavior
- "Continue project execution from the error position" 활성화 시 충돌/ESTOP 오류 위치에서 재개 가능
- PLAY 버튼 → 오류 위치(PE)로 이동 → 다시 PLAY 버튼 → 프로젝트 계속

### 4.5 Network 설정 (p.113)

≡ > Settings > System > Network
- DHCP 또는 고정 IP 설정
- 연결 이름 커스터마이징 가능

### 4.6 Remote Control Settings (p.112~113)

≡ > Settings > System > Remote Control Settings
- Remote Control 입력 기능 (IO 또는 Fieldbus)

### 4.7 Serial Port 설정 (p.84~85)

Project Function > Serial Port
**파라미터**:
- Device Name, Com port, Baud rate, Data bit, Stop bit, Parity, Time Out
- Flow control 옵션 (체크박스)
- Baud rate: 300, 1200, 2400, 4800, 9600, 14400, 19200, 38400, 57600, 115200 또는 사용자 입력

**주의**: Expression Editor의 Modbus 탭이 Connection 탭으로 대체됨. Protocol 드롭다운에서 Modbus 선택.

### 4.8 좌표계 설정 (Ch.6~8, p.123~143)

#### Base 종류 (p.124~125)
- **Robot Base**: 기본 로봇 좌표계
- **Vision Base**: 비전 캘리브레이션으로 생성 (아이콘: 카메라)
- **Custom Base**: 사용자 정의 좌표계 (아이콘: 격자)

**Base 생성 방법**:
1. Vision Base: 비전 캘리브레이션으로 자동 생성
2. 3점 지정으로 Custom Base 생성
3. 여러 Base 합성으로 새 Base 생성

#### TCP 생성 (p.138~143)

| 방법 | 설명 |
|------|------|
| Hand Guidance Teaching | FreeBot 티칭으로 TCP 파라미터 생성 |
| Input Parameters | X/Y/Z/RX/RY/RZ 직접 입력 |
| Vision TCP Calibration | 비전으로 TCP 캘리브레이션 |

#### Base Shift / Tool Shift (p.127~130)

Point Node, Move Node 등에서 포인트에 오프셋 적용:
- **Base Shift**: 기준 Base에서 X/Y/Z 오프셋
- **Tool Shift**: TCP 기준 오프셋

### 4.9 Project Lock (p.87~88)

Project Function > Project Lock
- Manager 및 Project Function 접근 제한
- Node Editing 옵션: 편집 가능한 노드 지정
- 계정의 Project Lock 권한이 있어야 적용

### 4.10 Network Service (p.113~115)

≡ > Settings > System > Network Service
- 로그, 로봇 데이터, 비전 이미지를 원격 호스트에 주기적으로 업로드
- UNC 주소 (또는 ftp://IP:포트) 입력
- Auto Login 설정 가능
- 업로드 항목/인터벌/특정 시각 설정

---

## 5. 비전 (TMvision/AI Vision)

### 5.1 Vision 노드 유형 (p.183~184)

| 유형 | 설명 |
|------|------|
| Positioning Node (위치결정) | 물체 위치결정, 랜드마크, 서보 타입 등 |
| Inspection Node (검사) | AOI 식별, 결함 검출 |

### 5.2 Vision 설정 (p.100~101)

≡ > Configuration > Vision Settings
- 카메라 파라미터 수정
- 카메라 캘리브레이션
- External Hard Drive의 비전 잡 이미지 파일 관리

### 5.3 Vision Calibration (p.82, p.99)

Manager > Vision Calibration (Flow/Script 공통)
별도 단계 없이 직접 캘리브레이션 가능.

### 5.4 Vision Manager (Script 전용, p.98~99)

Manager > Vision Manager
- 비전 잡 생성/관리
- 생성된 정보(Vision Base, 변수 등)를 defined function에 복사하여 선언
- `Vision_DoJob_PTP` 등 함수로 비전 잡 실행 (TMscript 참조)

### 5.5 Vision Record (p.65)

View > Vision Record
- 비전 잡 결과, 이미지, 변수 확인
- Live Video 해상도: 640×480
- 외부 SSD 있을 경우 1/2/4배 확대 가능
- 프로젝트 중지 후에도 마지막 비전 잡 정보 유지

---

## 6. 통신 설정

### 6.1 Modbus 설정 (p.185~189)

TM AI Cobot은 Modbus Master(Client) 및 Slave(Server) 모두 지원.

#### Modbus Master (Project Function > Modbus Device)

프로젝트 내에서 외부 Modbus 장치의 데이터 읽기/쓰기.

**TCP 장치 추가**:
1. Project Function > Modbus Device > + 버튼
2. Device Name, IP 주소, Port, Slave ID 입력
3. Edit에서 읽기/쓰기 주소 추가

**IODD 파일로 자동 구성**:
- USB TMROBOT:\TM_Export\RobotName\XmlFiles\IODD 에 파일 저장
- Text File Manager에서 확인 후 Modbus Device 설정에서 Import from IODD

**Big-endian 필수**: 외부 장치와 통신 시 Big-endian 체크 필요.

#### Modbus Slave (Connection Settings)

외부 장치(PLC/IPC)가 로봇 데이터를 읽거나 명령 전송.

**포트**: 기본 502 (Modbus TCP)
**RTU**: 시리얼 포트 사용, 외부 장치와 파라미터 동기화 필요

**Function Code 표**:
| FC | 분류 | 신호 타입 | R/W |
|----|------|-----------|-----|
| 01 | Read coils | Digital Output | R |
| 02 | Read discrete inputs | Digital Input | R |
| 03 | Read holding registers | Register Output | R |
| 04 | Read input registers | Register Input | R |
| 05 | Write single coil | Digital Output | W |
| 06 | Write single register | Register Output | W |
| 15 | Write multiple coils | Digital Output | W |
| 16 | Write multiple registers | Register Output | W |

### 6.2 TM Ethernet Slave (p.101)

- 소켓 서버 방식 (기본 포트: 5891)
- TM Ethernet Slave 프로토콜: Programming Language TMscript 참조
- Connection Settings에서 Enable/IP Filter 설정

### 6.3 Listen Node 통신 (p.162~164)

- 포트: **5890**
- TMscript 명령어 수신/실행
- 자세한 명령/통신 형식: Programming Language TMscript 참조

### 6.4 Network Node 통신 (p.190~191)

- TCP 소켓 클라이언트
- Project Function > Network Device에서 장치 등록 (Device Name, IP, Port)
- Time Out 설정 (0보다 큰 정수)

---

## 7. Force 관련 노드

### 7.1 F/T Sensor 설정 (p.205~209)

Project Function > F/T Sensor

**Communication Setting**:
1. Add Device > Communication Setting
2. Device Name 입력
3. Vendor/Model 선택
4. Com port 선택
5. OK

**Position Setting**:
- F/T 센서의 로봇 플랜지 기준 X/Y/Z 측정값 입력
- 설치 각도 RX/RY/RZ 입력

**Force Value & Charts**:
- View > Force Sensor 탭에서 실시간 그래프 확인
- Choose Device 드롭다운으로 장치/축/방향 선택
- Auto Scaling 또는 수동 최대/최소 설정
- F3D = √(Fx²+Fy²+Fz²), T3D = √(Tx²+Ty²+Tz²)

### 7.2 Compliance Node 파라미터 요약

```
Choose Base: Tool / Current Base
Setting:
  - Single Axis: Direction(X/Y/Z/RX/RY/RZ), Distance, Force/Torque, Speed
  - Teach: Linear / Rotation, 2 Teaching Points
  - Advanced: 각 축별 Rigid/Compliant 선택, 목표 힘/토크
  - Impedance: Stiffness 설정
Stop Criteria:
  - Over: Time / Over: F/T / Receive: DI / Receive: AI
Output Variable: 2(Timeout)/3(Distance)/4(DI-AI)/5(Resisted)/6(Error)/14(OverSpeed)
Resistance on non-target direction: Normal / High Resistance
```

---

## 8. Modbus 주소 목록 (Appendix C, p.274~289)

**주소 표현**: Decimal 기준 (Address₁₀)
**데이터 타입**: Float = 2 레지스터(32bit), Int32 = 2 레지스터, Int16 = 1 레지스터, Bool = 1 코일/접점
**X** 표시 = HW 3.2 미지원

### 8.1 Robot Status (p.274~275)

| 항목 | FC | Address₁₀ | Type | R/W | Note |
|------|----|-----------:|------|-----|------|
| Robot Link | 02 | 7200 | Bool | R | 0:No, 1:Yes |
| Error or Not | 02 | 7201 | Bool | R | |
| Get UI Control or Not | 02 | 7205 | Bool | R | |
| Light | 01/05 | 7206 | Bool | R/W | 0:Disable, 1:Enable |
| User Ext. Safeguard [Pause] | 02 | 7207 | Bool | R | 0:Restored, 1:Triggered |
| ESTOP | 02 | 7208 | Bool | R | |
| AUTO MODE play confirm (AUT.P) | 02 | 7214 | Bool | R | 0:Low, 1:High |
| Robot State | 04 | 7215 | Int16 | R | 0:Normal, 1:SOS, 2:Error, 3:Recovery, 4:STO |
| Operation Mode | 04 | 7216 | Int16 | R | 0:Manual, 1:Auto |
| Manual Mode Settings | 04 | 7217 | Int16 | R | 0:T1, 1:TCH (HW3.2 X) |
| Remote Control Fieldbus Active | 02 | 7212 | Bool | R | 0:Inactive, 1:Active |
| Remote Control IO Active | 02 | 7213 | Bool | R | 0:Inactive, 1:Active |

### 8.2 Project Status (p.275)

| 항목 | FC | Address₁₀ | Type | R/W |
|------|----|----------:|------|-----|
| Project Running | 02 | 7202 | Bool | R |
| Project Editing | 02 | 7203 | Bool | R |
| Project Pause | 02 | 7204 | Bool | R |

### 8.3 Control Box DI/O (p.275~276)

| 항목 | FC | Address₁₀ | Type | R/W |
|------|----|----------:|------|-----|
| DO 0 ~ DO 15 | 01/05 | 0000~0015 | Bool | R/W |
| DI 0 ~ DI 15 | 02 | 0000~0015 | Bool | R |

### 8.4 End Module (p.276)

| 항목 | FC | Address₁₀ | Type | R/W |
|------|----|----------:|------|-----|
| DI 0 ~ DI 2 | 02 | 0800~0802 | Bool | R |
| DI 3 | 02 | 0803 | Bool | R | (HW3.2 X) |
| DO 0 ~ DO 2 | 01/05 | 0800~0802 | Bool | R/W |
| DO 3 | 01/05 | 0803 | Bool | R/W | (HW3.2 X) |
| AI 0 | 04 | 0800~0801 | Float | R |

### 8.5 Control Box AI/O (p.276~277)

| 항목 | FC | Address₁₀ | Type | R/W |
|------|----|----------:|------|-----|
| AO 0 | 03/16 | 0000~0001 | Float | R/W |
| AO 1 | 03/16 | 0002~0003 | Float | R/W | (HW3.2 X) |
| AI 0 | 04 | 0000~0001 | Float | R |
| AI 1 | 04 | 0002~0003 | Float | R |

### 8.6 External Module (p.277)

주소 공식: AO/AI₁₀ = 0900 + 100×M + N ~ 0901 + 100×M + N
DO/DI₁₀ = 0900 + 100×M + N
(M = 외부 모듈 번호 0-based, N = IO 채널 번호 0-based)

| 항목 | FC | 시작 Address₁₀ | 최대 Address₁₀ | Type | R/W |
|------|----|-------------:|-------------:|------|-----|
| AO | 03/16 | 0900~0901 | 1698~1699 | Float | R/W |
| AI | 04 | 0900~0901 | 1698~1699 | Float | R |
| DO | 01/05 | 0900 | 1699 | Bool | R/W |
| DI | 02 | 0900 | 1699 | Bool | R |

### 8.7 Robot Coordinate (p.279~281)

**현재 Base 기준 (Tool 제외)**:
| 항목 | FC | Address₁₀ | Type | 단위 |
|------|----|----------:|------|------|
| X | 04 | 7001~7002 | Float | mm |
| Y | 04 | 7003~7004 | Float | mm |
| Z | 04 | 7005~7006 | Float | mm |
| Rx | 04 | 7007~7008 | Float | deg |
| Ry | 04 | 7009~7010 | Float | deg |
| Rz | 04 | 7011~7012 | Float | deg |
| J1~J6 | 04 | 7013~7024 | Float | deg |

**현재 Base 기준 (Tool 포함)**:
| 항목 | FC | Address₁₀ | Type | 단위 |
|------|----|----------:|------|------|
| X~Rz | 04 | 7025~7036 | Float | mm/deg |

**Robot Base 기준 (Tool 제외)**:
| 항목 | FC | Address₁₀ | Type | 단위 |
|------|----|----------:|------|------|
| X~Rz | 04 | 7037~7048 | Float | mm/deg |

**Robot Base 기준 (Tool 포함)**:
| 항목 | FC | Address₁₀ | Type | 단위 |
|------|----|----------:|------|------|
| X~Rz | 04 | 7049~7060 | Float | mm/deg |

**TouchStop 트리거 시 좌표 (현재 Base, Tool 제외)**:
| 항목 | FC | Address₁₀ | Type | 단위 |
|------|----|----------:|------|------|
| X~Rz | 04 | 7401~7412 | Float | mm/deg |
| J1~J6 | 04 | 7413~7424 | Float | deg |
| X~Rz (Tool 포함) | 04 | 7425~7436 | Float | mm/deg |
| X~Rz (Robot Base, Tool 제외) | 04 | 7437~7448 | Float | mm/deg |
| X~Rz (Robot Base, Tool 포함) | 04 | 7449~7460 | Float | mm/deg |

### 8.8 Robot Stick (p.283~285)

| 항목 | FC | Address₁₀ | Type | R/W | Note |
|------|----|----------:|------|-----|------|
| M/A Mode | 04 | 7102 | Int16 | R | A:1, M:2 |
| Play/Pause | 05 | 7104 | Bool | W | 1 수신 시 Toggle |
| Stop | 05 | 7105 | Bool | W | 1 수신 시 트리거 |
| + | 05 | 7106 | Bool | W | |
| - | 05 | 7107 | Bool | W | |
| Play | 05 | 7103 | Bool | W | |
| Pause | 05 | 7108 | Bool | W | |

**쓰기 가능 조건**: Remote Control 상태 (Robot Stick Disable) + Fieldbus Active + AUT.P High (Auto Mode)

### 8.9 Project Speed (p.284)

| 항목 | FC | Address₁₀ | Type | R/W | Note |
|------|----|----------:|------|-----|------|
| Project Speed | 04 | 7101 | Int16 | R | % |
| Change Project Speed | 06 | 7101 | Int16 | W | 5의 배수, 5~100%, Remote Control만 |

### 8.10 Run Setting (p.283)

| 항목 | FC | Address₁₀ | Type | R/W | Note |
|------|----|----------:|------|-----|------|
| Current Project | 04 | 7701~7799 | String | R | \0으로 문자열 끝 표시 |
| Change Current Project | 06/16 | 7701~7799 | String | W | Auto Mode + 미실행 상태 + Remote Control |

### 8.11 TCP Value (p.283)

| 항목 | FC | Address₁₀ | Type | 단위 |
|------|----|----------:|------|------|
| X~RZ (TCP Value) | 04 | 7354~7365 | Float | mm/deg |
| Mass | 04 | 7366~7367 | Float | kg |
| Ixx, Iyy, Izz | 04 | 7368~7373 | Float | kg·mm² |
| Mass center X~RZ | 04 | 7374~7385 | Float | mm/deg |

### 8.12 TCP Speed / Force (p.285~286)

| 항목 | FC | Address₁₀ | Type | 단위 |
|------|----|----------:|------|------|
| TCP Speed X~RZ | 04 | 7859~7870 | Float | mm/s, deg/s |
| TCP Speed 3D | 04 | 7871~7872 | Float | mm/s |
| FX, FY, FZ | 04 | 7801~7806 | Float | N |
| F3D | 04 | 7807~7808 | Float | N |

### 8.13 Joint Data (p.286~288)

| 항목 | FC | Address₁₀ | Type | 단위 |
|------|----|----------:|------|------|
| Joint Torque J1~J6 (Raw) | 04 | 7847~7858 | Float | mNm |
| Joint Torque J1~J6 (40ms avg) | 04 | 7877~7888 | Float | mNm |
| Joint Torque J1~J6 (40ms min) | 04 | 7889~7900 | Float | mNm |
| Joint Torque J1~J6 (40ms max) | 04 | 7901~7912 | Float | mNm |
| Joint Torque J1~J6 (Estimated) | 04 | 7949~7960 | Float | mNm |
| Joint Speed J1~J6 | 04 | 7913~7924 | Float | deg/s |
| Joint Current J1~J6 | 04 | 7925~7936 | Float | A |
| Joint Temperature J1~J6 | 04 | 7937~7948 | Float | °C |

### 8.14 Current Base (p.288)

| 항목 | FC | Address₁₀ | Type | 단위 |
|------|----|----------:|------|------|
| X, Y, Z, RX, RY, RZ | 04 | 8300~8311 | Float | mm/deg |

### 8.15 Running Timer / Up Time (p.288)

| 항목 | FC | Address₁₀ | Type | Note |
|------|----|----------:|------|------|
| Running Timer Day | 04 | 8200~8201 | Int32 | 현재 프로젝트 실행 시간 (정지 시 0) |
| Running Timer Hour | 04 | 8202 | Int16 | |
| Running Timer Minute | 04 | 8203 | Int16 | |
| Running Timer Second | 04 | 8204 | Int16 | |
| Up Time Day | 04 | 8206~8207 | Int32 | 컨트롤러 시작 후 경과 시간 |
| Up Time Hour | 04 | 8208 | Int16 | |
| Up Time Minute | 04 | 8209 | Int16 | |
| Up Time Second | 04 | 8210 | Int16 | |

### 8.16 Safety Setting / Others (p.288~289)

| 항목 | FC | Address₁₀ | Type | R/W |
|------|----|----------:|------|-----|
| Safety System Version | 04 | 7280~7289 | String | R |
| Safety Checksum | 04 | 7290~7299 | String | R |
| Current Time: Year | 04 | 7301 | Int16 | R |
| Current Time: Month | 04 | 7302 | Int16 | R |
| Current Time: Date | 04 | 7303 | Int16 | R |
| Current Time: Hour | 04 | 7304 | Int16 | R |
| Current Time: Minute | 04 | 7305 | Int16 | R |
| Current Time: Second | 04 | 7306 | Int16 | R |
| HMI Version | 04 | 7308~7312 | String | R |
| Last Error Code | 04 | 7320~7321 | Int32 | R |
| Last Error Time: Year | 04 | 7322 | Int16 | R |

### 8.17 Robot Stick Status (p.285)

| 항목 | FC | Address₁₀ | Type | R/W | Note |
|------|----|----------:|------|-----|------|
| M/A Button | 02 | 7151 | Bool | R | 0:Release, 1:Pressed |
| Play/Pause Button | 02 | 7152 | Bool | R | (HW3.2 X) |
| Stop Button | 02 | 7153 | Bool | R | |
| + Button | 02 | 7154 | Bool | R | |
| - Button | 02 | 7155 | Bool | R | |
| Play Button | 02 | 7149 | Bool | R | (HW3.2 X) |
| Pause Button | 02 | 7156 | Bool | R | |
| Robot Stick Enable | 02 | 7157 | Bool | R | 0:Disable(Remote), 1:Enable(Local) |
| ESTOP Input | 02 | 7158 | Bool | R | (HW3.2 X) |
| Enabling Switch Input | 02 | 7159 | Bool | R | (HW3.2 X) |
| Reset Input | 02 | 7160 | Bool | R | (HW3.2 X) |
| End Module FREE Button | 02 | 7170 | Bool | R | 0:Release, 1:Pressed |

### 8.18 Safety Output Assign (p.277~279)

SO 0~7 각각에 할당 가능한 함수 (FC 04, Address 0130~0137, Int16, R):
- 0: Not Using
- 1: SF2-Encoder Standstill Status Output
- 2: SF10-Robot ESTOP Output
- 3: SF11-User External Safeguard Output
- 4: SF12-Robot Human-Machine Safety Settings Output
- 5: SF13-Robot Recovery Mode Output
- 6: SF14-Robot Moving Output
- 7: SF28-Enabling Switch Output
- 8: SF29-MODE Switch Output
- 9: SF30-Safe Home Output
- 10: SF20-Reset Output

**Safety Output SO 0~7** (FC 02, Address 0100~0107, Bool, R)
**Safety Output OSSD SO 0~7** (FC 02, Address 0160~0167, Bool, R)
**Safety Input Assign SI 0~7** (FC 04, Address 0230~0237, Int16, R)
**Safety Input SI 0~7** (FC 02, Address 0200~0207, Bool, R)

---

## 9. Ethernet Slave 데이터 테이블 (Appendix D, p.290~294)

***A 컬럼**: 쓰기 가능한 자동 모드 (M=Manual, A=Auto, M/A=양쪽)
****W 컬럼**: 쓰기 방법

| Item Name (ID) | 설명 | Type | Size | R/W | Note |
|----------------|------|------|------|-----|------|
| Get_UI_Control | 제어권 취득 여부 | bool | 1 | R | 1:Yes, 0:No |
| Robot_Error | 에러 여부 | bool | 1 | R | |
| Error_Code | 마지막 에러 코드 | int | 1 | R | 16진수 |
| Error_Time | 마지막 에러 시간 | string | 1 | R | [YYYY]-[MM]-[DD]T[hh]:[mm]:[ss.sss] |
| Camera_Light | 카메라 라이트 | byte | 1 | R/W | M/A |
| Project_Speed | 프로젝트 속도 | byte | 1 | R/W | M/A, 5의 배수, 5~100% |
| Project_Name | 프로젝트 이름 | string | 1 | R/W | A |
| Project_Run_Time | 프로젝트 실행 시간 | string | 1 | R | [days].[hh]:[mm]:[ss.sss] |
| Project_Run | 프로젝트 실행 여부 | bool | 1 | R | |
| Project_Edit | 프로젝트 편집 여부 | bool | 1 | R | |
| Project_Pause | 프로젝트 일시정지 | bool | 1 | R | |
| Coord_Base_Flange | 현재 Base 기준 좌표 (Tool 제외) | float | 6 | R | mm, deg |
| Joint_Angle | J1~J6 각도 | float | 6 | R | deg |
| Coord_Base_Tool | 현재 Base 기준 좌표 (Tool 포함) | float | 6 | R | mm, deg |
| Coord_Robot_Flange | Robot Base 기준 좌표 (Tool 제외) | float | 6 | R | mm, deg |
| Coord_Robot_Tool | Robot Base 기준 좌표 (Tool 포함) | float | 6 | R | mm, deg |
| Touch_Coord_Base_Flange | TouchStop 시 좌표 (Base, Tool 제외) | float | 6 | R | mm, deg |
| Touch_Joint_Angle_Stop | TouchStop 시 J1~J6 | float | 6 | R | deg |
| Touch_Coord_Base_Tool | TouchStop 시 좌표 (Base, Tool 포함) | float | 6 | R | mm, deg |
| Touch_Coord_Robot_Flange | TouchStop 시 좌표 (Robot, Tool 제외) | float | 6 | R | mm, deg |
| Touch_Coord_Robot_Tool | TouchStop 시 좌표 (Robot, Tool 포함) | float | 6 | R | mm, deg |
| TCP_Force | Tool Force FX/FY/FZ | float | 3 | R | N |
| TCP_Force3D | Tool Force 3D | float | 1 | R | N |
| TCP_Speed | Tool Speed X/Y/Z/RX/RY/RZ | float | 6 | R | mm/s, deg/s |
| TCP_Speed3D | Tool Speed 3D | float | 1 | R | mm/s |
| Joint_Speed | Joint 1~6 속도 | float | 6 | R | deg/s |
| Joint_Torque | Joint 1~6 토크 | float | 6 | R | mNm |
| Joint_Torque_EST | Joint 1~6 토크 (추정) | float | 6 | R | mNm |
| Joint_Torque_Average | Joint 1~6 토크 (40ms 평균) | float | 6 | R | mNm |
| Joint_Torque_Min | Joint 1~6 토크 (40ms 최소) | float | 6 | R | mNm |
| Joint_Torque_Max | Joint 1~6 토크 (40ms 최대) | float | 6 | R | mNm |
| Joint_Current | Joint 1~6 전류 | float | 6 | R | mA |
| Joint_Temperature | Joint 1~6 온도 | float | 6 | R | °C |
| TCP_Name | TCP 이름 | string | 1 | R | |
| TCP_Value | TCP 값 | float | 6 | R | mm, deg |
| TCP_Mass | TCP 질량 | float | 1 | R | kg |
| TCP_MOI | Ixx/Iyy/Izz | float | 3 | R | mm·kg |
| TCP_MCF | 질량 중심 프레임 | float | 6 | R | mm, deg |
| Base_Name | Base 이름 | string | 1 | R | |
| Base_Value | Base 값 | float | 6 | R | mm, deg |
| HandCamera_Value | HandCamera TCP 값 | float | 6 | R | mm, deg |
| Stick_MA | Stick M/A 버튼 상태 | bool | 1 | R | 1:Pressed |
| Stick_Play | Stick Play 버튼 | bool | 1 | R/W | M/A |
| Stick_Stop | Stick Stop 버튼 | bool | 1 | R/W | M/A |
| Stick_Plus | Stick+ 버튼 | bool | 1 | R/W | M/A |
| Stick_Minus | Stick- 버튼 | bool | 1 | R/W | M/A |
| Stick_Pause | Stick Pause 버튼 | bool | 1 | R/W | M/A | (HW3.2 R only) |
| Stick_PlayPause | Stick Play/Pause 버튼 | bool | 1 | R/W | M/A | Write: Toggle |
| Stick_Enable | Stick 활성화 상태 | bool | 1 | R | 0:Disable, 1:Enable |
| Stick_ESTOP | Stick ESTOP 버튼 | bool | 1 | R | (HW3.2 X) |
| Stick_EnablingSwitch | Stick Enabling Switch | bool | 1 | R | (HW3.2 X) |
| Stick_Reset | Stick Reset 버튼 | bool | 1 | R | (HW3.2 X) |
| End_EnablingSwitch | End Module FREE 버튼 | bool | 1 | R | |
| Robot_Model | 로봇 모델명 | string | 1 | R | |
| ControlBox_SN | 컨트롤박스 시리얼번호 | float | 1 | R | |
| Controller_Temperature | 컨트롤러 온도 | float | 1 | R | °C |
| Manipulator_Voltage | 로봇 암 전압 | float | 1 | R | V |
| Manipulator_Consumption | 로봇 암 전력 | float | 1 | R | W |
| Manipulator_Current | 로봇 암 전류 | float | 1 | R | A |
| ControlBox_IO_Current | Control Box IO 전류 | float | 1 | R | mA |
| End_IO_Current | End Module IO 전류 | float | 1 | R | mA |
| Current_Time | 현재 시간 | string | 1 | R | [YYYY]-[MM]-[DD]T[hh]:[mm]:[ss.sss] |
| System_Uptime | 시스템 가동 시간 | string | 1 | R | [days].[hh]:[mm]:[ss.sss] |
| TMflow_Version | TMflow 버전 | string | 1 | R | X.XX.XXXX |
| DHTable | DH 파라미터 테이블 | float | 42 | R | 7×6 행렬 |
| DeltaDH | Delta DH | float | 30 | R | 5×6 행렬 |

---

## 10. 기타 기능

### 10.1 운전 모드 (p.47, p.53)

| 모드 | 설명 | 속도 제한 |
|------|------|----------|
| MANUAL (T1) | 티칭 모드, Enabling Switch 필수 유지 | 최대 250 mm/s |
| MANUAL (TCH) | 티칭 모드, + 버튼 누른 채 잠금 해제 후 속도 조절 가능 | 250 mm/s 이상 가능 |
| AUTO | 자동 실행 | 설정 속도% |

**Project Override Speed 기록**: AUTO MODE에서 실행 중 Play 버튼 길게 누름.

### 10.2 오류 발생 시 재개 (p.53~54)

| 정지 유형 | 상태 | 재개 가능 |
|-----------|------|----------|
| SF0, SF1, SF16, SF4, SF8, SF23 | Paused | 가능 |
| SF5, SF17, SF6, SF7, SF24 | Stopped | 불가 |
| 기타 오류 | Stopped | 불가 |

재개 절차: 오류 해제 → FREE 버튼으로 트랩에서 벗어남 → PLAY 버튼 (현재 위치 → 오류 위치 PTP 이동) → 다시 PLAY 버튼 (프로젝트 계속)

### 10.3 Step Run (p.92~93)

- F8 또는 툴바 > Step Run
- 첫 노드: Start, Point, 회색이 아닌 노드
- Enabling Switch + Play 버튼 유지 → 한 노드씩 실행
- 노드 완료 시 "(Node name)_finish" 표시
- IF/Gateway 등 분기 노드에서 경로 자유 선택 가능
- Step Run 중 FREE 버튼 사용 불가, 변수 시스템/판단식 동작 안 함
- Vision 노드는 동작함 (결과 확인 가능)

### 10.4 Import/Export (p.110~112)

USB 드라이브 레이블: **TMROBOT**

**내보내기 항목 및 경로**:
| 항목 | 경로 |
|------|------|
| Project | TMROBOT\TM_Export\{RobotID}\Projects\ |
| Components | ComponentObject\ |
| TCP | TCP.zip |
| Operation Scene | SafetySpace.zip |
| Text Files | TextFiles\ |
| IODD Files | XmlFiles\IODD\ |
| Ethernet Slave | EthSlave\Transmit\, EthSlave\UserDefined\ |
| Safety Config | Safety\Config\ |
| Network Service | NetworkService.zip |
| Global Variable | GlobalVariable.zip |
| TMcraft Node | TMcraft\Node\ |
| TMcraft Service | TMcraft\Service\ |

### 10.5 Backup & Restore (p.116~117)

- 최대 5개 백업 파일
- 백업 파일 경로: \TM_Export\(Computer Name + Robot ID)\Backup
- 압축 및 암호화됨
- 복원 시 Computer ID 및 Robot ID 확인

### 10.6 System Update (p.115~116)

1. 웹사이트에서 업데이트 파일 다운로드 및 압축 해제
2. USB 드라이브(TMROBOT 레이블) 루트에 복사
3. System Update 페이지에서 USB\TMROBOT 선택 후 Update 버튼
4. Network Service로 네트워크 업데이트도 가능

### 10.7 사용자 권한 (p.118~119)

**Administrator 계정**: 기본 비밀번호 없음.
**User Account**: 이름 + 비밀번호 + Group 설정
**Group 권한 범위**: project, project lock setting, view, system, configuration, project override speed

### 10.8 Blending 요약 (p.148~150)

**By Percentage**: PTP, Line, Circle에서 사용 가능
**By Radius**: Line 모드에서만 사용 가능

**유효한 Blending 조합**:
| P1 모션 \ P2 모션 | PLine | Line | PTP | Circle | Pallet | Path |
|------------------|-------|------|-----|--------|--------|------|
| PLine | O | | | | | |
| Line (%) | | O | O | O | *1 | X |
| Line (Radius) | | O | O | X | *1 | X |
| PTP | | O | O | O | *1 | X |
| Circle | | | | | | |

*1: Pallet의 Motion Type에 따라 Line/PTP 동작
블렌딩 미적용: WaitFor, Pause, Stop, Warp, Listen, Compliance, Touch Stop, Smart Insert 이후
10mm 미만 계산 거리 + 90° 미만 각도 = "sharp turn" → Radius 블렌딩 무효

### 10.9 Stop Watch (p.82~83)

Project Function > Stop Watch
두 노드 사이 경과 시간 계산. 시작 노드 + 종료 노드 + 결과 변수(double 타입) + 노트 설명으로 구성.

### 10.10 Joint Loading (p.86~87)

Project Function > Joint Loading
각 노드의 Joint 부하 모니터링.
- 노란색: High Risk (허용 반복 피크 토크 초과)
- 파란색: Low Risk
- 회색: Unknown (미실행)

### 10.11 Path Generate (p.85)

Project Function > Path Generate
F/T 센서로 hand guiding하여 복잡한 경로 생성.
**Time Sampling** / **Position Sampling** 파라미터로 포인트 밀도 조정.
저장: .path 파일로 저장 후 Path Node에서 사용 가능.

### 10.12 EditBlock (p.89~91)

- 여러 노드 선택 (마우스 드래그 또는 개별 클릭)
- 일괄 적용: Base Shift, Speed Adjust, Payload, Blending, Precise Positioning
- Copy & Paste: 동일 프로젝트 내에서만 가능
- 자동 연결 모드 (터치스크린 편리)
- 노드 정렬: 첫 선택 노드 기준 정렬

### 10.13 Comment (p.93~95)

- 최대 100개 주석, 각 최대 2000자
- 노드에 연결하거나 독립적으로 추가
- 핀 모드로 특정 노드에 고정

### 10.14 Operation Mode 변경 (p.31~33)

- **Robot Stick**: MODE 스위치로 M/A 전환
- **표시등**: End Module 표시등
  - 초록색 점멸: MANUAL MODE
  - 흰색 점멸: AUTO MODE
  - 보라색 추가: Human-Machine Safety Settings 활성화

### 10.15 ROS Settings (p.109~110)

≡ > Configuration > ROS Settings
- Domain ID 설정 후 TM ROS Driver 활성화
- TM ROS Driver 동작 중 TM Ethernet Slave 자동 점유 (수동 해제 불가)

### 10.16 Posture Settings (p.119)

≡ > Other > Posture Settings
- **Packing Pose**: 포장/운반용 자세
- **Normal Pose**: 일반 작업 시작 자세
- **Home Pose**: 모든 Joint 0도

---

## 부록: Script 프로젝트 + Flow 연계 핵심 포인트

### Script 프로젝트에서 Base/TCP 선언

Script 프로젝트에서 Syntax Check 또는 Save 시 Base List/TCP List 갱신:
- `TBase` 클래스로 Custom/Vision Base 선언 (defined 함수 내)
- `TTCP` 클래스로 TCP 선언 (defined 함수 내)

### Script 프로젝트에서 Vision 실행

`Vision_DoJob_PTP` 등 함수 사용.
Vision Manager에서 생성한 정보를 defined 함수에 복사하여 선언.

### Global Variable로 프로젝트 간 데이터 전달

- Flow 프로젝트와 Script 프로젝트 모두 `g_변수명`으로 접근
- Warp Node로 프로젝트 전환 시 Global Variable만 유지됨

### Listen Node와 Script 연계

Listen Node에서 TMscript 명령 수신:
- 변수 할당: 즉시 실행
- 모션/IO: 큐에 순서 실행
- `ScriptExit()`: Listen Node Pass 조건

### Modbus로 외부 PLC 연계 시 주의사항

1. Remote Control 활성화 필요 (Robot Stick Disable 상태)
2. AUT.P (FC 02, Addr 7214) = High → Auto Mode 실행 가능
3. Project Speed 쓰기는 5의 배수, 5~100% 범위
4. 현재 프로젝트명 변경은 Auto Mode + 미실행 상태에서만 가능

---

*작성: 2026-02-22 / 소스 PDF: 617페이지 전체 분석*
