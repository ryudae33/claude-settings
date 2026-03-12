# TMflow Expression Editor & Listen Node 레퍼런스

> 원본: TMflow_Expression_Editor_ListenNode_Manual_EN.pdf (Software Version 1.84, I8481-E-04)
> 작성일: 2026-02-22
> 참조 페이지 범위: p.11 ~ p.243 (핵심 섹션 전체)

---

## 목차

1. [Expression Editor](#1-expression-editor)
   - 1.1 데이터 타입
   - 1.2 변수와 상수
   - 1.3 배열 (Array)
   - 1.4 연산자
   - 1.5 타입 변환
   - 1.6 경고(Warning)
2. [Functions 목록](#2-functions-목록)
3. [Math Functions 목록](#3-math-functions-목록)
4. [File Functions 목록](#4-file-functions-목록)
5. [Serial Port Functions](#5-serial-port-functions)
6. [Socket Functions](#6-socket-functions)
7. [Parameterized Objects (IO / Robot)](#7-parameterized-objects)
8. [External Script (Listen Node 핵심)](#8-external-script--listen-node)
   - 8.1 Listen Node 설정
   - 8.2 ScriptExit()
   - 8.3 Communication Protocol 패킷 포맷
   - 8.4 TMSCT
   - 8.5 TMSTA
   - 8.6 CPERR 에러 코드
   - 8.7 Priority Commands
9. [Robot Motion Functions](#9-robot-motion-functions)
10. [실전 예제 모음](#10-실전-예제-모음)
11. [주의사항 및 제한사항](#11-주의사항--제한사항)

---

## 1. Expression Editor

### Expression Editor 사용 가능한 위치 (p.12~)

Expression Editor는 TMflow 내 **모든 노드의 표현식 입력 필드**에서 사용 가능하다.
특히 **Listen Node** 내 외부 스크립트 컨텍스트에서 아래 모든 함수가 사용된다.

---

### 1.1 데이터 타입 (p.12)

| 타입 | 설명 | 범위 | 유효 자릿수 |
|------|------|------|-------------|
| `byte` | 8bit 부호없는 정수 | 0 ~ 255 | 3 |
| `int` / `int32` | 32bit 부호있는 정수 | -2147483648 ~ 2147483647 | 10 |
| `int16` | 16bit 부호있는 정수 | -32768 ~ 32767 | 5 |
| `float` | 32bit 부동소수점 | -3.40282e+038 ~ 3.40282e+038 | 7 |
| `double` | 64bit 부동소수점 | -1.79769e+308 ~ 1.79769e+308 | 15 |
| `bool` | 불리언 | true / false | - |
| `string` | 문자열 | - | - |

---

### 1.2 변수와 상수 (p.12~15)

**변수 명명 규칙:**
- 사용 가능 문자: `0-9`, `a-z`, `A-Z`, `_`
- TMflow에서 생성된 변수는 소스에 따라 자동으로 **prefix** 추가됨
- 읽기/쓰기 시 prefix 포함 전체 이름 사용 필수

**숫자 상수 표기법:**
```
123         // 10진수 정수
-123        // 음수
34.567      // 10진수 부동소수점
0b0000111   // 2진수
0x123abc    // 16진수
3.4e5       // 과학적 표기법
```
- 대소문자 구분 없음 (0b0011 == 0B0011)
- 시스템이 자동으로 가장 작은 타입부터 판단: `100` → byte, `1000` → int, `1.11` → float

**타입 강제 지정:**
```
byte b = 100       // byte로 선언
int i = 100        // int로 선언
(int)100           // int로 캐스팅
(float)100         // float로 캐스팅
```

**문자열:**
- 반드시 `"` (이중 인용부호)로 감싸야 함
- 문자열 내 `"` 표현: `""` (두 번 연속)
- `"Hello TM""5"` → `Hello TM"5`
- 제어 문자는 `Ctrl()` 함수 사용: `Ctrl("\r\n")`
- 예약어: `empty` (빈 문자열 ""), `newline` / `NewLine` (\r\n)

**불리언:**
- `true`, `True` → 참
- `false`, `False` → 거짓
- 대소문자 구분 없음 (`true`, `True` 모두 유효)

---

### 1.3 배열 (Array) (p.16~17)

```
int[] var_i = {0, 1, 2, 3}
string[] var_s = {"ABC", "DEF", "GHI"}
bool[] var_bb = {true, false, true}
```
- 인덱스는 0부터 시작
- 1차원 배열만 지원
- 최대 인덱스: 2048
- 배열 크기는 함수 반환값에 따라 동적 변경 가능

**인덱스 참조:**
```
A[0], A[1], ..., A[7]   // 유효 범위
```

---

### 1.4 연산자 (p.18~19)

| 우선순위(높→낮) | 연산자 | 설명 |
|----------------|--------|------|
| 17 | `++`, `--`, `()`, `[]` | 후위 증감, 함수 호출, 배열 인덱스 |
| 16 | `++`, `--`, `+`, `-`, `!`, `~` | 전위 증감, 단항, 논리NOT, 비트NOT |
| 14 | `*`, `/`, `%` | 곱셈, 나눗셈, 나머지 |
| 13 | `+`, `-` | 덧셈, 뺄셈 |
| 12 | `<<`, `>>` | 비트 시프트 |
| 11 | `<`, `<=`, `>`, `>=`, `==`, `!=` | 비교 |
| 9 | `&` | 비트 AND |
| 8 | `^` | 비트 XOR |
| 7 | `\|` | 비트 OR |
| 6 | `&&` | 논리 AND |
| 5 | `\|\|` | 논리 OR |
| 4 | `c?t:f` | 삼항 조건 |
| 3 | `=`, `+=`, `-=`, `*=`, `/=`, `%=`, `<<=`, `>>=`, `&=`, `^=`, `\|=` | 대입 |

**연산 타입 규칙:**
- 양쪽 모두 정수 → 정수 연산
- 한쪽이라도 부동소수점 → 부동소수점 연산
```
int var_a = 10, var_b = 3
float var_c = var_a / var_b   // var_c = 3 (정수 나눗셈)
float var_c = var_a / 3.0     // var_c = 3.333333 (부동소수점 나눗셈)
```

---

### 1.5 데이터 타입 변환 (p.20~21)

**명시적 캐스팅 문법:** `(타입)값`

| 원래 타입 | 변환 타입 | 예시 | 결과 |
|-----------|-----------|------|------|
| byte | int | `(int)100` | 100 |
| int | float | `(float)1000` | 1000.0 |
| float | double | `(double)1.23` | 1.23 |
| bool | string | `(string)True` | "True" |
| string | int | `(int)"1.23"` | 1 |
| string | float | `(float)"1.23"` | 1.23 |
| string | bool | `(bool)"1.23"` | true (not null) |
| string | bool | `(bool)""` | false (null) |
| bool → 숫자 | - | `(int)True` | **Error** |

**배열 변환:**
```
string[] var_ss = {"1.23", "4.56", "0.789"}
int[] var_i_array = (int[])var_ss       // {1, 4, 0}
float[] var_f_array = (float[])var_ss   // {1.23, 4.56, 0.789}
```

---

### 1.6 경고(Warning) (p.21~23)

경고 발생 조건:
1. 문자열 상수에 이중 인용부호 미사용
2. 문자열 내 단일 인용부호 사용
3. float 값을 int 변수에 대입 (소수점 손실)
4. 더 작은 타입으로 대입 시 데이터 손실
5. 문자열을 숫자 변수에 대입 (자동 변환 시도)

```
int var_i = 1.234       // warning, var_i = 1
int var_i = "1234"      // warning, var_i = 1234
int var_j = "0x89AB"    // warning, var_j = 35243
```

---

## 2. Functions 목록

### 2.1~2.10 Byte 변환 함수 (p.24~35)

| 함수 | 시그니처 | 설명 |
|------|----------|------|
| `Byte_ToInt16` | `int Byte_ToInt16(byte[], int endian=0, int signed=0)` | byte[] → int16 변환 |
| `Byte_ToInt32` | `int Byte_ToInt32(byte[], int endian=0)` | byte[] → int32 변환 |
| `Byte_ToFloat` | `float Byte_ToFloat(byte[], int endian=0)` | byte[] → float 변환 (4byte) |
| `Byte_ToDouble` | `double Byte_ToDouble(byte[], int endian=0)` | byte[] → double 변환 (8byte) |
| `Byte_ToInt16Array` | `int[] Byte_ToInt16Array(byte[], int endian=0, int signed=0)` | byte[] → int16[] (2byte씩) |
| `Byte_ToInt32Array` | `int[] Byte_ToInt32Array(byte[], int endian=0)` | byte[] → int32[] (4byte씩) |
| `Byte_ToFloatArray` | `float[] Byte_ToFloatArray(byte[], int endian=0)` | byte[] → float[] (4byte씩) |
| `Byte_ToDoubleArray` | `double[] Byte_ToDoubleArray(byte[], int endian=0)` | byte[] → double[] (8byte씩) |
| `Byte_ToString` | `string Byte_ToString(byte[], int encoding=0)` | byte[] → string (0=UTF8, 1=HEX, 2=ASCII) |
| `Byte_Concat` | `byte[] Byte_Concat(byte[], byte/byte[], int len=-1)` | byte[] 연결 |

**endian 파라미터:** 0 = Little Endian (기본), 1 = Big Endian

**Byte_ToInt16 예시 (p.24):**
```
byte[] var_bb1 = {0x90, 0x01, 0x05}
var_value = Byte_ToInt16(var_bb1, 0, 0)   // 0x0190 = 400 (signed LE)
var_value = Byte_ToInt16(var_bb1, 1, 0)   // 0x9001 = -28671 (signed BE)
var_value = Byte_ToInt16(var_bb1, 1, 1)   // 0x9001 = 36865 (unsigned BE)
```

---

### 2.11~2.22 String 변환/조작 함수 (p.36~52)

| 함수 | 시그니처 | 설명 |
|------|----------|------|
| `String_ToInteger` | `int String_ToInteger(string, int base=10)` | string → int (base: 10/16/2) |
| `String_ToFloat` | `float String_ToFloat(string, int base=10)` | string → float |
| `String_ToDouble` | `double String_ToDouble(string, int base=10)` | string → double |
| `String_ToByte` | `byte[] String_ToByte(string, int encoding=0)` | string → byte[] (0=UTF8, 1=HEX, 2=ASCII) |
| `String_IndexOf` | `int String_IndexOf(string input, string search)` | 첫 번째 발생 위치 (0기반) |
| `String_LastIndexOf` | `int String_LastIndexOf(string input, string search)` | 마지막 발생 위치 |
| `String_Substring` | 여러 오버로드 (아래 참조) | 부분 문자열 추출 |
| `String_Split` | `string[] String_Split(string, string sep, int mode=0)` | 구분자로 분할 |
| `String_Replace` | `string String_Replace(string, string old, string new)` | 문자열 대체 |
| `String_Trim` | `string String_Trim(string, string lead="", string trail="")` | 앞뒤 문자 제거 |
| `String_ToLower` | `string String_ToLower(string)` | 소문자 변환 |
| `String_ToUpper` | `string String_ToUpper(string)` | 대문자 변환 |

**String_Substring 오버로드 (p.45~47):**
```
// Syntax 1: 인덱스와 길이
string String_Substring(string, int startIdx, int length)
var_value = String_Substring("0x12345", 2, 4)   // "1234"
var_value = String_Substring("0x12345", 2, -1)  // "12345" (끝까지)

// Syntax 2: 인덱스만
string String_Substring(string, int startIdx)   // 끝까지

// Syntax 3: 검색 문자열과 길이
string String_Substring(string, string prefix, int length)
var_value = String_Substring("0x12345", "1", 4) // "1234" (첫 "1" 위치부터)

// Syntax 5: prefix, suffix, 발생 횟수
string String_Substring(string, string prefix, string suffix, int occurrence)
var_value = String_Substring("0x12345", "1", "4", 1)    // "1234"
var_value = String_Substring("0x123450x12-345", "1", "4", 2)  // "12-34"
```

**String_Split 모드 (p.48):**
- 0: 분할 후 빈 문자열 유지
- 1: 분할 후 빈 문자열 제거
- 2: 이중 인용부호 내 구분자 무시 + 빈 문자열 유지
- 3: 이중 인용부호 내 구분자 무시 + 빈 문자열 제거

---

### 2.23~2.31 Array 조작 함수 (p.52~64)

| 함수 | 시그니처 | 설명 |
|------|----------|------|
| `Array_Append` | `?[] Array_Append(?[], ? or ?[])` | 배열 끝에 요소/배열 추가 |
| `Array_Insert` | `?[] Array_Insert(?[], int idx, ? or ?[])` | 지정 인덱스에 삽입 |
| `Array_Remove` | `?[] Array_Remove(?[], int idx, int count=1)` | 지정 인덱스부터 제거 |
| `Array_Equals` | `bool Array_Equals(?[], ?[])` | 두 배열 동일 여부 |
| `Array_IndexOf` | `int Array_IndexOf(?[], ?)` | 요소 첫 번째 위치 |
| `Array_LastIndexOf` | `int Array_LastIndexOf(?[], ?)` | 요소 마지막 위치 |
| `Array_Reverse` | `?[] Array_Reverse(?[])` | 배열 역순 |
| `Array_Sort` | `?[] Array_Sort(?[], int order=0)` | 정렬 (0=오름차순) |
| `Array_SubElements` | `?[] Array_SubElements(?[], int start, int count)` | 부분 배열 추출 |

---

### 2.32~2.50 기타 핵심 함수 (p.64~114)

| 함수 | 시그니처 | 설명 |
|------|----------|------|
| `ValueReverse` | `? ValueReverse(?)` | 바이트 순서 역전 |
| `GetBytes` | `byte[] GetBytes(?, int endian=0)` | 값을 byte[]로 변환 |
| `GetString` | `string GetString(?, ...)` | 값을 문자열로 변환 |
| `GetToken` | `string GetToken(string, string sep, int idx)` | 구분자로 분리된 idx번째 토큰 |
| `GetAllTokens` | `string[] GetAllTokens(string, string sep)` | 모든 토큰 반환 |
| `GetNow` | `string GetNow(string format="MM/dd/yyyy HH:mm:ss")` | 현재 시각 문자열 |
| `GetNowStamp` | `int GetNowStamp()` / `double GetNowStamp(bool useDouble)` | 현재 타임스탬프(ms) |
| `GetVarValue` | `? GetVarValue(string varName)` | 변수명 문자열로 변수값 조회 |
| `Length` | `int Length(?)` | 바이트 수/문자열 길이/배열 원소 수 |
| `Ctrl` | `string Ctrl(int/string/byte[])` | 제어 문자 변환 |
| `XOR8` | `byte XOR8(byte[])` | XOR 체크섬 (8bit) |
| `SUM8` | `byte SUM8(byte[])` | SUM 체크섬 (8bit) |
| `SUM16` | `int SUM16(byte[])` | SUM 체크섬 (16bit) |
| `SUM32` | `int SUM32(byte[])` | SUM 체크섬 (32bit) |
| `CRC16` | `int CRC16(byte[])` | CRC16 체크섬 |
| `CRC32` | `int CRC32(byte[])` | CRC32 체크섬 |
| `ListenPacket` | `string ListenPacket(string hdr, string data)` | Listen Node 프로토콜 패킷 생성 |
| `ListenSend` | `int ListenSend(int subCmd, ?)` | TMSTA 데이터 송신 |
| `VarSync` | `int VarSync(int retries, int interval_ms, ?)` | 변수를 TMManager에 동기화 |

**GetVarValue 예시 (p.96):**
```
string var_s1 = "Hello World"
string var_h = "var_s1"
var_re = GetVarValue(var_h)        // "Hello World" (var_h값="var_s1"인 변수의 값)
var_re = GetVarValue(var_t + "1")  // "Hello World" (동적 변수명 조합)
```

**GetNow 예시 (p.91):**
```
var_value = GetNow("MM/dd/yyyy HH:mm:ss")        // "08/15/2017 13:40:30"
var_value = GetNow("yyyy/MM/dd HH:mm:ss.ffff")   // "2017/08/15 13:40:30.123"
var_value = GetNow("yyyy-MM-dd hh:mm:ss tt")     // "2017-08-15 01:40:30 PM"
var_value = GetNow()                              // "08/15/2017 13:40:30"
```

**ListenPacket 예시 (p.110):**
```
string var_data1 = "1,var_i++"
var_value = ListenPacket("TMSCT", var_data1)   // "$TMSCT,9,1,var_i++,*06\r\n"
var_value = ListenPacket("", "2,Techman Robot") // "$TMSCT,15,2,Techman Robot,*57\r\n"
var_value = ListenPacket("TMSTA", "00")         // "$TMSTA,2,00,*41\r\n"

// Syntax 2 (TMSCT 기본)
var_value = ListenPacket("1,var_counter++")     // "$TMSCT,15,1,var_counter++,*26\r\n"
```

**ListenSend 예시 (p.111~112):**
```
// Syntax 1: IP 필터링 + SubCmd + 데이터
int ListenSend(string ipFilter, int subCmd, ?)
var_value = ListenSend("127.0.0.1", 90, 100)    // 0x64 전송
// 반환: 0=성공, -1=Listen Server 미시동, -2=SubCmd 범위 오류(90~99만 유효)

// Syntax 2: 전체 클라이언트로 전송
int ListenSend(int subCmd, ?)
var_value = ListenSend(90, "123.456")   // "$TMSTA,10,90,123.456,*7E"
var_value = ListenSend(91, {1.0, 2.0, 3.0, 4.0})  // float[] 전송 (Little Endian)
```

**VarSync 예시 (p.113~114):**
```
// 변수를 TMManager(Robot Management System)로 전송
var_value = VarSync(1, 1000, "var_s")       // var_s 변수 전송 (재시도 1회, 간격 1000ms)
var_value = VarSync(2, 2000, var_s)         // var_s의 값("ABC")을 이름으로 가진 변수 전송
var_value = VarSync(4, 2000, "var_ss", "var_s1", "ABC")  // 여러 변수 전송
// 반환: >0=성공(전송 횟수), 0=실패, -1=TMManager 비활성, -9=파라미터 오류
```

---

## 3. Math Functions 목록

| 함수 | 시그니처 | 설명 |
|------|----------|------|
| `abs` | `int/float/double abs(?)` | 절대값 |
| `pow` | `int/float/double pow(base, double exp)` | 거듭제곱 |
| `sqrt` | `float/double sqrt(?)` | 제곱근 |
| `ceil` | `int ceil(float/double)` | 올림 |
| `floor` | `int floor(float/double)` | 내림 |
| `round` | `int round(float/double)` | 반올림 |
| `random` | `int random(int min, int max)` | 랜덤 정수 |
| `d2r` | `double d2r(double deg)` | 도(degree) → 라디안 |
| `r2d` | `double r2d(double rad)` | 라디안 → 도 |
| `sin` | `double sin(double rad)` | 사인 |
| `cos` | `double cos(double rad)` | 코사인 |
| `tan` | `double tan(double rad)` | 탄젠트 |
| `asin` | `double asin(double)` | 아크사인 |
| `acos` | `double acos(double)` | 아크코사인 |
| `atan` | `double atan(double)` | 아크탄젠트 |
| `atan2` | `double atan2(double y, double x)` | atan2 |
| `log` | `double log(double)` | 자연로그 |
| `log10` | `double log10(double)` | 상용로그 |
| `norm2` | `double norm2(float[])` | 벡터 norm |
| `dist` | `double dist(float[], float[])` | 두 점 거리 |
| `trans` | `float[] trans(float[], float[])` | 좌표 변환 |
| `inversetrans` | `float[] inversetrans(float[])` | 역 좌표 변환 |
| `applytrans` | `float[] applytrans(float[], float[])` | 변환 적용 |
| `interpoint` | `float[] interpoint(float[], float[], float ratio)` | 두 점 보간 |
| `changeref` | `float[] changeref(float[], float[])` | 참조 좌표계 변경 |
| `points2coord` | `float[] points2coord(float[], float[], float[])` | 3점으로 좌표계 생성 |
| `intercoord` | `float[] intercoord(float[], float[], float ratio)` | 좌표계 보간 |

---

## 4. File Functions 목록

> File 함수는 Expression Editor / Network Node 내에서 사용 가능 (p.145~)

| 함수 | 시그니처 | 설명 |
|------|----------|------|
| `File_ReadBytes` | `byte[] File_ReadBytes(string path)` | 파일을 byte[]로 읽기 |
| `File_ReadText` | `string File_ReadText(string path)` | 파일 전체를 문자열로 읽기 |
| `File_ReadLines` | `string[] File_ReadLines(string path)` | 파일을 줄 단위 배열로 읽기 |
| `File_NextLine` | `string File_NextLine(string path, int handle)` | 다음 줄 읽기 (스트리밍) |
| `File_NextEOF` | `bool File_NextEOF(string path, int handle)` | 파일 끝 여부 확인 |
| `File_WriteBytes` | `bool File_WriteBytes(string path, byte[], int mode)` | byte[]를 파일에 쓰기 |
| `File_WriteText` | `bool File_WriteText(string path, string, int mode)` | 문자열을 파일에 쓰기 |
| `File_WriteLine` | `bool File_WriteLine(string path, string, int mode)` | 한 줄 쓰기 (자동 개행) |
| `File_WriteLines` | `bool File_WriteLines(string path, string[], int mode)` | 여러 줄 쓰기 |
| `File_Exists` | `bool File_Exists(string path)` | 파일 존재 여부 |
| `File_Length` | `int File_Length(string path)` | 파일 크기 (byte) |
| `File_Delete` | `bool File_Delete(string path)` | 파일 삭제 |
| `File_Copy` | `bool File_Copy(string src, string dst)` | 파일 복사 |
| `File_CopyImage` | `bool File_CopyImage(...)` | 이미지 파일 복사 |
| `File_Replace` | `bool File_Replace(string path, string old, string new)` | 파일 내용 대체 |
| `File_GetToken` | `string File_GetToken(string path, string sep, int idx)` | 파일에서 토큰 추출 |
| `File_GetAllTokens` | `string[] File_GetAllTokens(string path, string sep)` | 파일에서 모든 토큰 |

---

## 5. Serial Port Functions

> (p.183~) `com_read`, `com_read_string`, `com_write`, `com_writeline`

| 함수 | 시그니처 | 설명 |
|------|----------|------|
| `com_read` | `byte[] com_read(string port, int len, int timeout_ms)` | 시리얼 포트 byte[] 읽기 |
| `com_read_string` | `string com_read_string(string port, string terminator, int timeout_ms)` | 시리얼 문자열 읽기 |
| `com_write` | `bool com_write(string port, byte[])` | 시리얼 byte[] 쓰기 |
| `com_writeline` | `bool com_writeline(string port, string)` | 시리얼 문자열 쓰기 (개행 포함) |

---

## 6. Socket Functions

> (p.200~) `socket_read`, `socket_read_string`, `socket_send`, `socket_sendline`

| 함수 | 시그니처 | 설명 |
|------|----------|------|
| `socket_read` | `byte[] socket_read(string ip, int port, int len, int timeout_ms)` | TCP byte[] 읽기 |
| `socket_read_string` | `string socket_read_string(string ip, int port, string terminator, int timeout_ms)` | TCP 문자열 읽기 |
| `socket_send` | `bool socket_send(string ip, int port, byte[])` | TCP byte[] 송신 |
| `socket_sendline` | `bool socket_sendline(string ip, int port, string)` | TCP 문자열 송신 (개행 포함) |

---

## 7. Parameterized Objects

### 7.5 IO (p.222~224)

**문법:** `IO["모듈명"].속성[인덱스]`

**모듈명:**
- `"ControlBox"` — 컨트롤 박스
- `"EndModule"` — 엔드 모듈
- `"ExtModuleN"` — 외부 모듈 (N = 0..n)
- `"Safety"` — 안전 모듈

**속성:**

| 속성 | 타입 | 읽기/쓰기 | 설명 |
|------|------|-----------|------|
| `DI` | byte[] | R | 디지털 입력 (0=Low, 1=High) |
| `DO` | byte[] | R/W | 디지털 출력 (큐 명령) |
| `AI` | float[] | R | 아날로그 입력 (-10.24V ~ +10.24V) |
| `AO` | float[] | R/W | 아날로그 출력 (-10.00V ~ +10.00V) |
| `InstantDO` | byte[] | R/W | 즉시 디지털 출력 (큐 대기 없이 실행) |
| `InstantAO` | float[] | R/W | 즉시 아날로그 출력 |
| `SI` | byte[] | R | 안전 입력 (Safety 모듈만) |
| `SO` | byte[] | R | 안전 출력 (Safety 모듈만) |

```
byte[] var_di = IO["ControlBox"].DI        // ControlBox 디지털 입력 전체
byte var_di0 = IO["ControlBox"].DI[0]      // DI[0] 값
IO["ControlBox"].DO[2] = 1                 // DO2를 High로 설정 (큐)
IO["ControlBox"].InstantDO[0] = 1          // DO0 즉시 High 설정
IO["ControlBox"].AO[0] = 3.3               // AO0 = 3.3V
byte si0 = IO["Safety"].SI[0]              // 안전 입력 SF1
```

**DO vs InstantDO:**
- `DO`: 로봇 모션 큐에 등록 → 이전 포인트 노드 완료 후 실행
- `InstantDO`: 즉시 실행 (스레드 내 DO와 동일한 효과)

### 7.6 Robot (p.225~226)

**문법:** `Robot[0].속성`

| 속성 | 타입 | 읽기/쓰기 | 설명 |
|------|------|-----------|------|
| `CoordRobot` | float[] | R | TCP 좌표 (RobotBase 기준) {X,Y,Z,RX,RY,RZ} |
| `CoordBase` | float[] | R | TCP 좌표 (현재 Base 기준) {X,Y,Z,RX,RY,RZ} |
| `Joint` | float[] | R | 현재 관절 각도 {J1,J2,J3,J4,J5,J6} |
| `BaseName` | string | R | 현재 Base 이름 |
| `TCPName` | string | R | 현재 TCP 이름 |
| `CameraLight` | byte | R/W | 카메라 조명 (0=OFF, 1=ON) |
| `TCPForce3D` | float | R | TCP 합력 (N) |
| `TCPSpeed3D` | float | R | TCP 속도 (mm/s) |

```
float[] var_joint = Robot[0].Joint          // 현재 관절 각도
float[] var_pos = Robot[0].CoordBase        // 현재 TCP 위치
string base = Robot[0].BaseName             // "RobotBase"
Robot[0].CameraLight = 1                    // 카메라 조명 ON
```

---

## 8. External Script / Listen Node

### 8.1 Listen Node 설정 (p.229)

Listen Node는 **TCP Server(Socket TCPListener)** 역할을 한다.

**설정 항목:**
| 항목 | 설명 |
|------|------|
| Send Message | 노드 진입 시 전송할 메시지 |
| Print Log | 통신 로그 활성화 여부 |
| Connection Timeout | 노드 진입 후 연결 대기 타임아웃 (ms). ≤0이면 무제한 |
| Data Timeout | 연결 후 통신 패킷 없을 때 타임아웃 (ms). ≤0이면 무제한 |

**포트:** `5890` (고정)
**IP:** `HMI → System → Network → IP Address`

프로젝트 실행 시 Socket TCPListener 자동 시작, 프로젝트 중단 시 자동 종료.

**Listen Node 탈출 조건:**
- **Pass**: `ScriptExit()` 실행 또는 프로젝트 중단
- **Fail**:
  1. Connection Timeout 초과
  2. Data Timeout 초과
  3. TCP Listener 시작 전 Listen Node 진입

**동시 접속:** 여러 클라이언트 동시 연결 지원 (포트 5890으로 다중 접속 가능)

---

### 8.2 ScriptExit() (p.230)

```
bool ScriptExit()
```
외부 스크립트 제어 모드를 종료하고 Listen Node를 빠져나간다.
- 모든 실행 대기 중인 명령이 완료될 때까지 기다린 후 Pass 경로로 이동
- `ScriptExit()` 이후의 함수는 실행되지 않음
- 탈출 대기 중에는 외부 명령 수신 불가 → CPERR 에러 반환

```
// 예시 패킷 (p.230)
$TMSCT,78,2,ChangeBase("RobotBase")\r\n
ChangeTCP("NOTOOL")\r\n
ScriptExit()\r\n                   // Listen Node 탈출
ChangeLoad(10.1),*6C\r\n           // 이 줄은 실행되지 않음
```

---

### 8.3 Communication Protocol 패킷 포맷 (p.230~231)

**패킷 구조:**
```
$<Header>,<Length>,<Data>,*<Checksum>\r\n
```

| 필드 | 크기 | ASCII | HEX | 설명 |
|------|------|-------|-----|------|
| Start Byte | 1 | `$` | 0x24 | 시작 바이트 |
| Header | X | | | 통신 목적 (TMSCT / TMSTA / CPERR) |
| Separator | 1 | `,` | 0x2C | 구분자 |
| Length | Y | | | Data의 UTF8 바이트 길이 (10진수/16진수/2진수 가능) |
| Separator | 1 | `,` | 0x2C | 구분자 |
| Data | Z | | | 통신 데이터 |
| Separator | 1 | `,` | 0x2C | 구분자 |
| Sign | 1 | `*` | 0x2A | 체크섬 시작 기호 |
| Checksum | 2 | | | XOR 체크섬 (2자리 16진수, 0x 없이) |
| End Byte 1 | 1 | `\r` | 0x0D | 종료 바이트 |
| End Byte 2 | 1 | `\n` | 0x0A | 종료 바이트 |

**체크섬 계산 (p.231):**
- XOR(exclusive OR)
- 범위: `$` 다음 문자부터 `*` 직전까지의 모든 바이트
- 수식: `CS = Byte[1] ^ Byte[2] ^ ... ^ Byte[N-6]`
- 표현: 2자리 대문자 16진수 (0x 없이)

**체크섬 예시:**
```
$TMSCT,5,10,OK,*6D
CS = 0x54^0x4D^0x53^0x43^0x54^0x2C^0x35^0x2C^0x31^0x30^0x2C^0x4F^0x4B^0x2C = 0x6D
```

**Length 예시:**
```
$TMSCT,100,Data,*CS\r\n    // 10진수 100 = 100 bytes
$TMSCT,0x100,Data,*CS\r\n  // 16진수 0x100 = 256 bytes
$TMSCT,0b100,Data,*CS\r\n  // 2진수 0b100 = 4 bytes
```

---

### 8.4 TMSCT (p.232~233)

**외부 스크립트 실행 프로토콜**

```
$TMSCT,<Length>,<ID>,<SCRIPT>,*<CS>\r\n
```

- **ID**: 임의 영숫자 문자열 (응답 메시지 식별에 사용)
- **SCRIPT**: 실행할 스크립트 언어 내용 (멀티라인 시 `\r\n`으로 구분)

**TMSCT는 Listen Node 진입 상태(외부 스크립트 제어 모드)에서만 유효**
그 외 상태에서 수신 시 CPERR F1 반환.

**Robot → External 응답 (p.232):**
```
// Listen Node 진입 시 자동 전송 (ID=0)
$TMSCT,9,0,Listen1,*4C\r\n

// 유효 스크립트 응답
$TMSCT,4,1,OK,*5C\r\n                   // ID 1 → OK

// 경고 있는 유효 스크립트
$TMSCT,8,2,OK;2;3,*52\r\n               // ID 2 → 2번, 3번 줄 경고

// 오류 있는 스크립트
$TMSCT,13,3,ERROR;1;2;3,*3F\r\n         // ID 3 → 1,2,3번 줄 에러
```

**External → Robot 전송 (p.233):**
```
// 단일 명령
< $TMSCT,25,1,ChangeBase("RobotBase"),*08\r\n
> $TMSCT,4,1,OK,*5C\r\n

// 멀티라인 스크립트 (하나의 패킷)
< $TMSCT,64,2,ChangeBase("RobotBase")\r\n
  ChangeTCP("NOTOOL")\r\n
  ChangeLoad(10.1),*68\r\n
> $TMSCT,4,2,OK,*5F\r\n

// 로컬 변수 사용 (Listen Node 종료 전까지 유효)
< $TMSCT,40,3,int var_i = 100\r\n
  var_i = 1000\r\n
  var_i++,*5A\r\n
> $TMSCT,4,3,OK,*5E\r\n
```

**주의:** Listen Node 내에서 프로젝트 변수는 읽기/쓰기 가능하지만, 새 변수 선언은 로컬 변수로 처리됨 (Listen Node 탈출 시 소멸).

---

### 8.5 TMSTA (p.234~237)

**상태/속성 조회 프로토콜**

```
$TMSTA,<Length>,<SubCmd>[,Data],*<CS>\r\n
```

**TMSTA는 Listen Node 진입 여부와 무관하게 언제든 사용 가능.**

#### SubCmd 00: 외부 스크립트 모드 여부 (p.234~235)

**Robot → External:**
```
// Listen Node 미진입 시
$TMSTA,9,00,false,,*37\r\n

// Listen Node 진입 시
$TMSTA,15,00,true,Listen1,*79\r\n
//             "Listen1"은 진입한 Listen Node의 메시지
```

**External → Robot:**
```
$TMSTA,2,00,*41\r\n
```

#### SubCmd 01: QueueTag 완료 여부 (p.235~236)

**Robot → External (자동 전송 - 태그 완료 시):**
```
$TMSTA,10,01,08,true,*6D\r\n
// SubCmd 01, TagNumber 08, 완료=true
// true: 완료, false: 미완료, none: 미존재
```

**External → Robot (태그 상태 조회):**
```
$TMSTA,5,01,15,*6F\r\n        // TagNumber 15 조회
> $TMSTA,10,01,15,none,*7D\r\n  // none = 미존재
```

- 조회 가능 범위: 최근 4개 태그 번호 (1~15)
- 범위 밖 번호 조회 시 none 반환

#### SubCmd 90~99: 사용자 정의 데이터 전송 (p.236~237)

**Robot → External (ListenSend() 함수로 전송):**
```
string var_s = "Hello World"
float[] var_f = {1, 2, 3, 4}
byte[] var_b = {0x10, 0x11, 0x12, 0x13}

ListenSend(90, var_s)
// $TMSTA,14,90,Hello World,*73\r\n

ListenSend(91, var_f)
// $TMSTA,19,91,...,*60\r\n  (float[] Little Endian 이진 데이터)

ListenSend(92, var_b)
// $TMSTA,7,92,...,*63\r\n
```

---

### 8.6 CPERR 에러 코드 (p.238~239)

**통신 프로토콜 오류 응답 프로토콜**

```
$CPERR,<Length>,<ErrorCode>,*<CS>\r\n
```

**로봇 → 외부장치로 전송 (오류 발생 시)**

| 에러 코드 | 설명 | 예시 |
|-----------|------|------|
| `00` | 정상 (일반적으로 반환하지 않음) | - |
| `01` | Packet Error (패킷 형식 오류) | Length가 음수 등 |
| `02` | Checksum Error (체크섬 불일치) | |
| `03` | Header Error (알 수 없는 헤더) | TMSCT 대신 TMsct 등 |
| `04` | Packet Data Error (데이터 내용 오류) | TMSTA의 알 수 없는 SubCmd |
| `F1` | Not in Listen Node (외부 스크립트 모드 아님) | Listen Node 미진입 상태에서 TMSCT 수신 |

**에러 예시 (p.238~239):**
```
// 01: Packet Error
< $TMSCT,-100,1,ChangeBase("RobotBase"),*13\r\n
> $CPERR,2,01,*49\r\n

// 02: Checksum Error
< $TMSCT,25,1,ChangeBase("RobotBase"),*09\r\n   // 잘못된 CS
> $CPERR,2,02,*4A\r\n

// 03: Header Error
< $TMsct,25,1,ChangeBase("RobotBase"),*28\r\n   // 소문자 헤더
> $CPERR,2,03,*4B\r\n

// 04: Packet Data Error
< $TMSTA,4,XXXX,*47\r\n    // 없는 SubCmd
> $CPERR,2,04,*4C\r\n

// F1: Not in Listen Node
< $TMSCT,25,1,ChangeBase("RobotBase"),*0D\r\n
> $CPERR,2,F1,*3F\r\n
```

---

### 8.7 Priority Commands (우선 명령) (p.240~243)

우선 명령은 **Listen Node 내에서** 일반 스크립트 실행보다 **높은 우선순위**로 즉시 실행된다.
`QueueTag(1,1)` 등으로 대기 중인 상태에서도 즉시 처리된다.

**사용 가능한 우선 명령 5가지:**

| 명령 | 동작 |
|------|------|
| `ScriptExit(0)` | 로봇 즉시 정지 + 버퍼 클리어 + Listen Node 탈출 → **Fail** 경로 |
| `ScriptExit(1)` | 로봇 즉시 정지 + 버퍼 클리어 + Listen Node 탈출 → **Pass** 경로 |
| `StopAndClearBuffer(0)` | 로봇 즉시 정지 + 버퍼 클리어 (Listen Node 유지) |
| `StopAndClearBuffer(1)` | 로봇 즉시 정지 + 버퍼 클리어 + **현재 스크립트 프로그램 종료** + 다음 스크립트로 이동 |
| `StopAndClearBuffer(2)` | 로봇 즉시 정지 + 버퍼 클리어 + **현재 스크립트 종료** + **수신 버퍼의 모든 스크립트 삭제** |

**우선 명령 규칙:**
1. 변수/함수와 함께 사용 불가 (예: `StopAndClearBuffer(var_st)` → ERROR)
2. 우선 명령과 일반 스크립트가 같은 패킷에 있으면, 우선 명령만 실행됨
3. 한 패킷에 여러 우선 명령 → `ScriptExit`가 `StopAndClearBuffer`보다 우선
4. 같은 종류의 우선 명령 여러 개 → 첫 번째만 실행

**예시 (p.241~243):**
```
// ScriptExit(0) - Fail 경로로 탈출
< $TMSCT,15,2,ScriptExit(0),*55\r\n
> $TMSCT,4,2,OK,*5F\r\n
// 로봇 즉시 정지, Fail 경로

// StopAndClearBuffer(0) - Listen Node 유지, 현재 스크립트 계속
< $TMSCT,23,2,StopAndClearBuffer(0),*55\r\n
> $TMSCT,4,2,OK,*5F\r\n

// StopAndClearBuffer(1) - 현재 스크립트 종료, 다음 스크립트(ID 2) 실행 계속
< $TMSCT,23,3,StopAndClearBuffer(1),*55\r\n
> $TMSCT,4,3,OK,*5E\r\n
// ID 1 종료 → ID 2 스크립트 실행 → ID 2 완료 태그 전송
> $TMSTA,10,01,02,true,*67\r\n

// StopAndClearBuffer(2) - 버퍼의 모든 스크립트 제거 (ID 2 응답도 없음)
< $TMSCT,23,3,StopAndClearBuffer(2),*56\r\n
> $TMSCT,4,1,OK,*5C\r\n
> $TMSCT,4,3,OK,*5E\r\n
// ID 2는 버퍼에서 삭제됨 → ID 2 응답 없음
```

---

## 9. Robot Motion Functions

> 로봇 모션 함수는 **반드시 Listen Node 내 외부 스크립트 제어 모드**에서만 사용 가능 (p.244)
> 모든 모션 함수는 **버퍼에 큐잉**되어 순서대로 실행됨

### 9.1 QueueTag (p.244~246)

```
bool QueueTag(int tagNum, int wait=0)
// tagNum: 1~15
// wait: 0=대기안함(기본), 1=태그 완료 시까지 대기
```

### 9.2 WaitQueueTag (p.245~246)

```
int WaitQueueTag(int tagNum, int timeout_ms=-1)
// tagNum: 1~15 (유효), 0=유효하지 않은 태그(타임아웃 대기)
// timeout_ms: <0=무한대기, =0=1회 확인, >0=ms 단위 타임아웃
// 반환: 1=완료, 0=미완료/타임아웃, -1=미존재
```

### 9.3 StopAndClearBuffer (p.247)

```
bool StopAndClearBuffer()
// 파라미터 없는 버전 (Priority Command와 구분됨)
```

### 9.4 Pause / 9.5 Resume (p.247~249)

```
bool Pause()   // 프로젝트 및 로봇 모션 일시정지
bool Resume()  // 재개
```

### 9.6 PTP (p.249~252)

```
// Syntax 1: 배열 방식
bool PTP(string fmt, float[] target, int speed%, int accel_ms, int blend%, bool disablePrecise)

// Syntax 2: 배열 + pose 구성
bool PTP(string fmt, float[] target, int speed%, int accel_ms, int blend%, bool disablePrecise, int[] pose)

// Syntax 3: 개별 좌표 방식
bool PTP(string fmt, float j1, float j2, float j3, float j4, float j5, float j6, int speed%, int accel_ms, int blend%, bool disablePrecise)

// Syntax 4: 개별 좌표 + pose
bool PTP(string fmt, float x, float y, float z, float rx, float ry, float rz, int speed%, int accel_ms, int blend%, bool disablePrecise, int c1, int c2, int c3)
```

**fmt 파라미터:**
- `"JPP"`: 관절 좌표 + 속도% + 블렌딩%
- `"CPP"`: 카테시안 좌표 + 속도% + 블렌딩%

```
// 예시
float[] var_targetP1 = {0, 0, 90, 0, 90, 0}
PTP("JPP", var_targetP1, 10, 200, 0, false)   // 관절각으로 이동, 속도 10%

PTP("JPP", 0, 0, 90, 0, 90, 0, 35, 200, 0, false)  // 개별 좌표 방식

float[] var_pose = {0, 2, 4}
PTP("CPP", var_targetP1, 50, 200, 0, false, var_pose)  // 카테시안 + pose
```

### 9.7 Line (p.253~255)

```
bool Line(string fmt, float[] target, int speed, int accel_ms, int blend, bool disablePrecise)
bool Line(string fmt, float x, float y, float z, float rx, float ry, float rz, int speed, int accel_ms, int blend, bool disablePrecise)
```

**fmt 파라미터:**
- `"CPP"`: 카테시안 + 속도% + 블렌딩%
- `"CPR"`: 카테시안 + 속도% + 블렌딩반경(mm)
- `"CAP"`: 카테시안 + 속도(mm/s) + 블렌딩%
- `"CAR"`: 카테시안 + 속도(mm/s) + 블렌딩반경(mm)

```
float[] var_Point1 = {417.50, -122.30, 343.90, 180.00, 0.00, 90.00}
Line("CAR", var_Point1, 100, 200, 50, false)  // 100mm/s, 50mm 블렌딩
```

### 9.8 Circle (p.255~257)

```
bool Circle(string fmt, float[] passP, float[] endP, int speed, int accel_ms, int blend%, int arcAngle_deg, bool disablePrecise)
```

**fmt:** `"CPP"`, `"CAP"`

### 9.13 ChangeBase (p.266~267)

```
bool ChangeBase(string baseName)            // 이름으로 변경
bool ChangeBase(float[] base_xyzrxryrz)     // 값으로 변경 {X,Y,Z,RX,RY,RZ}
bool ChangeBase(float x, float y, float z, float rx, float ry, float rz)
```

### 9.14 ChangeTCP (p.267~270)

```
bool ChangeTCP(string tcpName)
bool ChangeTCP(float[] tcp_xyzrxryrz)
bool ChangeTCP(float[] tcp, float weight_kg)
bool ChangeTCP(float[] tcp, float weight, float[] inertia_9params)
bool ChangeTCP(float x, float y, float z, float rx, float ry, float rz)
bool ChangeTCP(float x, float y, float z, float rx, float ry, float rz, float weight)
```

### 9.15 ChangeLoad (p.270)

```
bool ChangeLoad(float payload_kg)
```

---

## 10. 실전 예제 모음

### 예제 1: 기본 연결 및 명령 전송 흐름 (p.232~233)

```
// 1. TCP 연결 (port 5890)

// 2. Listen Node 진입 확인 (로봇이 자동 전송)
< $TMSCT,9,0,Listen1,*4C\r\n

// 3. 변수 조작
> $TMSCT,40,3,int var_i = 100\r\n
  var_i = 1000\r\n
  var_i++,*5A\r\n
< $TMSCT,4,3,OK,*5E\r\n

// 4. Base, TCP 변경
> $TMSCT,64,2,ChangeBase("RobotBase")\r\n
  ChangeTCP("NOTOOL")\r\n
  ChangeLoad(10.1),*68\r\n
< $TMSCT,4,2,OK,*5F\r\n

// 5. 외부 스크립트 모드 여부 확인 (TMSTA 00)
> $TMSTA,2,00,*41\r\n
< $TMSTA,15,00,true,Listen1,*79\r\n

// 6. Listen Node 종료
> $TMSCT,15,99,ScriptExit(),*55\r\n
< $TMSCT,4,99,OK,*5D\r\n
```

### 예제 2: 로봇 모션 + QueueTag 사용 (p.246)

```
// PTP 이동 + 태그 설정
> $TMSCT,172,2,float[] targetP1= {0,0,90,0,90,0}\r\n
  PTP("JPP",targetP1,10,200,0,false)\r\n
  QueueTag(1)\r\n
  float[] targetP2 = {0,90,0,90,0,0}\r\n
  PTP("JPP",targetP2,10,200,10,false)\r\n
  QueueTag(2)\r\n
  ,*49\r\n

< $TMSCT,4,2,OK,*5F\r\n
< $TMSTA,10,01,01,true,*64\r\n   // 첫 번째 PTP 완료
< $TMSTA,10,01,02,true,*67\r\n   // 두 번째 PTP 완료
```

### 예제 3: ScriptExit(0)으로 긴급 정지 (p.241~242)

```
// 로봇이 QueueTag(1,1) 대기 중
> $TMSCT,86,1,float[] targetP1= {0,0,90,0,90,0}\r\n
  PTP("JPP",targetP1,10,200,0,false)\r\n
  QueueTag(1,1),*60\r\n

// 대기 중 긴급 정지 명령
> $TMSCT,15,2,ScriptExit(0),*55\r\n
< $TMSCT,4,1,OK,*5C\r\n    // ID 1 응답
< $TMSCT,4,2,OK,*5F\r\n    // ID 2 응답
// Listen Node 종료 → Fail 경로
```

### 예제 4: ListenSend로 로봇→PC 데이터 전송 (p.237)

```
// Listen Node 내부 스크립트에서 실행
string var_s = "Hello World"
ListenSend(90, var_s)
// PC가 수신: $TMSTA,14,90,Hello World,*73\r\n

float[] var_f = {1, 2, 3, 4}
ListenSend(91, var_f)
// PC가 수신: $TMSTA,19,91,...,*60\r\n (Little Endian 이진 float[])
```

### 예제 5: 외부 PC에서 로봇 제어 전체 흐름 (종합)

```python
import socket
import struct

HOST = '192.168.1.1'  # 로봇 IP
PORT = 5890

def calc_checksum(data: str) -> str:
    cs = 0
    for c in data:
        cs ^= ord(c)
    return format(cs, '02X')

def make_packet(header: str, data: str) -> bytes:
    payload = f"{header},{len(data.encode('utf-8'))},{data},"
    cs = calc_checksum(payload)
    packet = f"${payload}*{cs}\r\n"
    return packet.encode('utf-8')

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.connect((HOST, PORT))

    # Listen Node 진입 메시지 수신
    data = s.recv(1024)
    print("수신:", data.decode('utf-8'))
    # $TMSCT,9,0,Listen1,*4C\r\n

    # PTP 이동 명령 전송
    script = "float[] p={0,0,90,0,90,0}\r\nPTP(\"JPP\",p,20,200,0,false)\r\nQueueTag(1)"
    pkt = make_packet("TMSCT", f"1,{script}")
    s.sendall(pkt)

    # 응답 수신
    resp = s.recv(1024)
    print("응답:", resp.decode('utf-8'))
    # $TMSCT,4,1,OK,*5C\r\n

    # 태그 완료 대기
    tag_done = s.recv(1024)
    print("태그:", tag_done.decode('utf-8'))
    # $TMSTA,10,01,01,true,*64\r\n

    # ScriptExit
    pkt = make_packet("TMSCT", "99,ScriptExit()")
    s.sendall(pkt)
    resp = s.recv(1024)
    print("종료:", resp.decode('utf-8'))
```

---

## 11. 주의사항 / 제한사항

### 동시 접속

- Listen Node는 **다중 클라이언트 동시 접속 지원**
- 포트 5890 고정
- `ListenSend(ipFilter, subCmd, data)` 형태로 특정 IP에만 데이터 전송 가능
- IP 필터 없으면 모든 연결된 클라이언트에 전송

### 타임아웃 동작 (p.229)

- **Connection Timeout**: Listen Node 진입 후 설정 시간 내 연결 없으면 Fail 경로
  - ≤ 0 설정 시 무제한 대기
- **Data Timeout**: 연결 후 설정 시간 내 패킷 없으면 Fail 경로
  - ≤ 0 설정 시 무제한 대기
- TCP Listener 시작 전 Listen Node 진입 → 즉시 Fail

### 에러 처리 방법 (p.232, 238)

1. **체크섬 오류 (CPERR 02)**: 패킷 재전송 필요
2. **패킷 형식 오류 (CPERR 01/03/04)**: 패킷 형식 수정 후 재전송
3. **Listen Node 미진입 (CPERR F1)**: TMSTA 00으로 상태 확인 후 진입 대기
4. **스크립트 에러**: `ERROR;줄번호` 응답 → 스크립트 내용 수정 후 재전송
5. **스크립트 경고**: `OK;줄번호` 응답 → 실행은 되지만 경고 내용 확인 권장

### 변수 범위 제한 (p.233)

- Listen Node 내에서 선언된 변수는 **로컬 변수** (Listen Node 탈출 시 소멸)
- 프로젝트 변수는 읽기/쓰기 가능
- **이미 선언된 로컬 변수 재선언 불가** → ERROR 응답

### Priority Commands 제한 (p.240)

- 변수나 함수 인자로 사용 불가: `StopAndClearBuffer(var_st)` → ERROR
- 같은 패킷에 일반 스크립트 + 우선 명령 혼재 시 우선 명령만 실행
- 한 패킷에 여러 우선 명령: `ScriptExit` > `StopAndClearBuffer` 순으로 처리
- 같은 종류 여러 개: 첫 번째만 실행

### 로봇 모션 함수 제한 (p.244)

- 모션 함수는 반드시 **Listen Node 내 외부 스크립트 제어 모드**에서만 실행 가능
- `PLine`, `Move_PTP`, `Move_Line`, `Move_PLine` 등 추가 모션 함수도 동일 조건
- 모든 모션은 **버퍼에 큐잉** → 순서 보장
- `StopAndClearBuffer(0)`으로 모션 버퍼는 클리어되지만 `WaitQueueTag(0)` 대기는 해제 불가
  → `StopAndClearBuffer(1/2)` 사용 필요

### ScriptExit() 이후 처리 (p.230)

- `ScriptExit()` 이후 같은 패킷 내 코드는 실행되지 않음
- 탈출 대기 중 (모든 명령 완료 기다리는 동안)에는 외부 스크립트 제어 모드 아님
- 탈출 대기 중 수신된 명령 → CPERR 에러 반환

---

*레퍼런스 작성 기준: TMflow Expression Editor and Listen Node Manual, Software Version 1.84*
