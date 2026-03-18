---
source: C:\Users\Administrator\Desktop\1cellAssembleMachine\manual\XGI_XGR_Instructions_En_V4.3.md
notebook_id: 9dba4932-0426-4815-9b4b-41b75f57dc95
date: 2026-03-18
question: XGI/XGR PLC ST 프로그래밍 데이터타입, 변수선언, 명령어, 제어문, FB, 특수릴레이, 비트연산, 주의사항 정리
---

# XGI/XGR PLC Structured Text (ST) 프로그래밍 가이드

본 가이드는 LS ELECTRIC의 XGI/XGR 시리즈 PLC 환경에서 IEC 61131-3 표준 Structured Text(ST) 언어를 사용하여 제어 로직을 설계하려는 엔지니어를 위해 작성되었습니다. 현장 엔지니어가 겪을 수 있는 실수와 시스템 제약사항을 중심으로 기술적인 깊이를 더했습니다.

---

## 1. 데이터 타입 (Basic Data Types)

XGI/XGR PLC는 다양한 표준 데이터 타입을 지원합니다. 컴파일러 호환성을 위해 아래 표의 **예약어**를 정확히 사용해야 합니다.

### 기본 데이터 타입 상세
| 예약어 (Reserved Word) | 데이터 타입 이름 | 크기 (bits) | 범위 |
| :--- | :--- | :--- | :--- |
| **SINT** | Short Integer | 8 | -128 ~ 127 |
| **INT** | Integer | 16 | -32,768 ~ 32,767 |
| **DINT** | Double Integer | 32 | -2,147,483,648 ~ 2,147,483,647 |
| **LINT** | Long Integer | 64 | -2^63 ~ 2^63-1 |
| **USINT** | Unsigned Short Integer | 8 | 0 ~ 255 |
| **UINT** | Unsigned Integer | 16 | 0 ~ 65,535 |
| **UDINT** | Unsigned Double Integer | 32 | 0 ~ 4,294,967,295 |
| **ULINT** | Unsigned Long Integer | 64 | 0 ~ 2^64-1 |
| **REAL** | Real Numbers | 32 | ±1.175494351e-038 ~ ±3.402823466e+038 |
| **LREAL** | Long Real Numbers | 64 | ±2.2250738585072014e-308 ~ ±1.7976931348623157e+308 |
| **BOOL** | Boolean | 1 | 0, 1 (TRUE, FALSE) |
| **BYTE** | Bit String (8) | 8 | 16#0 ~ 16#FF |
| **WORD** | Bit String (16) | 16 | 16#0 ~ 16#FFFF |
| **DWORD** | Bit String (32) | 32 | 16#0 ~ 16#FFFFFFFF |
| **LWORD** | Bit String (64) | 64 | 16#0 ~ 16#FFFFFFFFFFFFFFFF |
| **TIME** | Duration | 32 | T#0s ~ T#49d17h2m47s295ms |
| **DATE** | Date | 16 | D#1984-01-01 ~ D#2163-6-6 |
| **TIME_OF_DAY** | Time of Day | 32 | TOD#00:00:00 ~ TOD#23:59:59.999 |
| **DATE_AND_TIME** | Date and Time | 64 | DT#1984-01-01-00:00:00 ~ DT#2163-06-06-23:59:59.999 |
| **STRING** | Character String | 32*8 | 기본 32byte (상수 리터럴은 최대 31자 제한) |

> **[PRO-TIP] STRING 처리 주의사항**  
> STRING 타입은 기본적으로 32바이트를 점유하지만, 초기화 시 사용하는 상수 리터럴 길이는 **최대 31자**로 제한됩니다. 메모리 설계 시 이 점을 반드시 고려하십시오.

### 데이터 타입 계층 및 내부 결정 기능 (Overloading)
시스템은 여러 타입을 그룹화하여 관리하며, 이를 통해 컴파일러가 입출력 변수 타입에 따라 적절한 내부 명령어를 자동 선택합니다.
*   **ANY_NUM**: 정수 및 실수 전체 (SINT~LREAL)
*   **ANY_BIT**: 비트 스트링 전체 (BOOL~LWORD)
*   **활용 예**: `ADD` 명령 사용 시 입력 변수가 `SINT`면 내부적으로 `ADD2_SINT`가, `DINT`면 `ADD2_DINT`가 자동 호출됩니다.

---

## 2. 변수 선언 및 메모리 할당 (Variable Declaration)

### 변수 식별자 규칙
1.  공백은 허용되지 않으며, 반드시 영문자 또는 언더바(`_`)로 시작해야 합니다.
2.  한글 및 한자 사용이 가능합니다.
3.  **대소문자를 구분하지 않습니다.** (시스템 내부적으로 모두 대문자로 처리함)

### 직접 변수(Direct Variable) 주소 체계
`%[Location][Size] n1.n2.n3` 구문을 사용합니다.
*   **Location Prefix**: I(입력), Q(출력), M(내부 메모리), R(내부 메모리-R), W(내부 메모리-W)
*   **Size Prefix**: X(1비트), B(바이트), W(워드), D(더블워드), L(롱워드)
*   **주소 지정 예시**:
    *   `%QX3.1.4`: 3번 베이스, 1번 슬롯의 4번째 출력 비트.
    *   `%MW40.3`: 40번 워드 메모리의 3번째 비트 (**내부 메모리는 베이스/슬롯 번호 `n2`를 생략함**).

### 변수 종류 및 동작 특성
| 종류 | 설명 | RETAIN/CONSTANT 설정 제한 |
| :--- | :--- | :--- |
| **VAR** | 일반 로컬 변수 | 설정 가능 |
| **VAR_RETAIN** | 유지 변수. **Warm Restart** 시 데이터 보존 | **%I, %Q 직접 변수 설정 불가** |
| **VAR_CONSTANT** | 읽기 전용 상수 | **%I, %Q 직접 변수 설정 불가** |
| **VAR_EXTERNAL** | 전역 변수(VAR_GLOBAL) 참조용 | **초기값 할당 불가** |

---

## 3. 데이터 표현식 및 연산자 (Expressions)

### 리터럴(Literal) 작성 규칙
*   **수치 리터럴**: `123_456`과 같이 언더바(`_`)를 사용하여 가독성을 높일 수 있습니다. (컴파일 시 무시됨)
*   **시간 리터럴**: `T#14.7s`, `DT#2023-10-25-14:30:00` 등. 
    *   **주의**: 시간 리터럴 내부에서는 가독성 향상을 위한 **언더바(`_`)를 사용할 수 없습니다.**

### 연산자 및 우선순위
ST 언어는 아래 순서에 따라 연산 우선순위를 가집니다. (괄호 `()`가 최우선)
1.  함수 호출
2.  지수 연산 (`**`)
3.  부정 (`NOT`)
4.  곱셈/나눗셈/나머지 (`*`, `/`, `MOD`)
5.  덧셈/뺄셈 (`+`, `-`)
6.  비교 연산 (`<`, `>`, `<=`, `>=`, `=`, `<>`)
7.  논리 연산 (`AND`, `XOR`, `OR`)

---

## 4. 제어문 (ST Control Statements)

ST 구문 작성 시 각 명령문 끝에는 반드시 **세미콜론(`;`)**을 붙여야 합니다.

*   **IF (조건 분기)**
    ```st
    IF Condition1 THEN
        Output1 := TRUE;
    ELSIF Condition2 THEN
        Output1 := FALSE;
    ELSE
        Output1 := DefaultValue;
    END_IF;
    ```
*   **CASE (다중 선택)**
    ```st
    CASE Mode OF
        1, 5: Run_Command := TRUE;  // 1 또는 5일 때
        10..20: Speed := 100;       // 10에서 20 범위일 때 (지원 시)
    ELSE
        Run_Command := FALSE;
    END_CASE;
    ```
*   **FOR (정해진 횟수 반복)**
    ```st
    FOR i := 1 TO 10 BY 1 DO
        ArrayData[i] := 0;
    END_FOR;
    ```
*   **WHILE / REPEAT (조건 반복)**
    *   `WHILE Condition DO ... END_WHILE;` (조건이 참인 동안 실행)
    *   `REPEAT ... UNTIL Condition END_REPEAT;` (조건이 참이 될 때까지 실행)

> **[SAFETY WARNING] Watchdog Timer**  
> `WHILE`이나 `REPEAT`문 내에서 탈출 조건이 충족되지 않아 무한 루프에 빠질 경우, PLC는 **Watchdog Timer Error**를 발생시키고 시스템 안전을 위해 모든 출력을 강제로 차단합니다. 반복문 사용 시 반드시 탈출 로직을 검증하십시오.

---

## 5. 함수(Function) 및 함수 블록(FB)

### 함수 (Function)
*   **상태 비보존**: 내부 메모리가 없으며, 입력이 같으면 항상 결과가 같습니다.
*   **제약사항**: 함수 내부에서 **직접 변수(%I, %Q 등) 및 `VAR_EXTERNAL`을 사용할 수 없습니다.**

### 함수 블록 (Function Block)
*   **상태 보존**: 내부 변수 값을 메모리에 유지합니다.
*   **인스턴스(Instance)**: FB를 사용하기 위해서는 반드시 인스턴스를 선언해야 합니다. 이는 **FB 전용 메모리 할당**을 의미하며, 이를 통해 스캔이 달라져도 데이터를 기억할 수 있습니다.
*   **표준 라이브러리 예시**:
    *   타이머: `TON` (On-delay), `TOF` (Off-delay), `TP` (Pulse)
    *   카운터: `CTU` (Up Counter), `CTD` (Down Counter)

---

## 6. 특수 릴레이 및 시스템 플래그 (Special Flags)

XGI/XGR 시스템에는 예약된 특수 플래그(F)가 존재합니다. (`Appendix 2: Flag List` 참조)

*   `_ON`: 항상 TRUE 상태 유지
*   `_OFF`: 항상 FALSE 상태 유지
*   `_1S`: 1초 주기 클록 펄스 (0.5초 ON / 0.5초 OFF)
*   `_T10MS`: 10ms 주기 클록 펄스

---

## 7. 비트 및 워드 연산 (Bit & Word Operations)

*   **구조**: `WORD`(16비트), `DWORD`(32비트) 등 비트 스트링 타입은 각 비트 위치에 개별 접근이 가능합니다.
*   **점(.) 표기법**: 워드 내 특정 비트에 직접 접근할 때 사용합니다.
    *   예: `%MW40.3` (40번 워드 메모리의 3번째 비트 접근)
    *   예: `MyWordVariable.0` (사용자 정의 워드 변수의 최하위 비트 접근)

---

## 8. 작성 시 주의사항 및 제약사항 (Constraints)

1.  **재귀 호출 금지**: 프로그램, 함수, FB가 자기 자신을 호출(Recursive Call)하는 것은 엄격히 금지됩니다.
2.  **예약어 금지**: `IF`, `VAR`, `THEN` 등 시스템 예약어는 변수명(식별자)으로 사용할 수 없습니다.
3.  **XGR 이중화 동기화**: XGR(중복화 시스템)에서는 제어권 전환 시 데이터 연속성을 위해 **전역 변수(Global Variable)**를 주요 동기화 메커니즘으로 활용하십시오.
4.  **Strict Type Check**: XG5000 설정에서 이 옵션을 활성화하면 피연산자 간 데이터 크기(BYTE, WORD 등)가 불일치할 경우 컴파일 에러를 발생시켜 잠재적인 버그를 예방합니다.
5.  **안전 설계**: 출력 장치(릴레이, TR 등)의 물리적 고장으로 인해 CPU가 에러를 감지하지 못할 수도 있습니다. 중요한 로직은 외부 인터록 회로를 구성하고, 출력 상태를 별도로 모니터링하는 회로를 추가하십시오.