# TMscript 완전 레퍼런스

**소프트웨어 버전**: 2.18
**문서 버전**: 1.0
**발행일**: 2024-12-17
**제조사**: Techman Robot Inc.

---

## 목차

1. [데이터 타입](#1-데이터-타입)
2. [변수 및 상수](#2-변수-및-상수)
3. [배열](#3-배열)
4. [연산자](#4-연산자)
5. [타입 변환](#5-타입-변환)
6. [엔디언 및 변환](#6-엔디언-및-변환)
7. [스크립트 프로젝트 구조](#7-스크립트-프로젝트-구조)
8. [제어문](#8-제어문)
9. [스레드](#9-스레드)
10. [일반 함수 (General Functions)](#10-일반-함수)
11. [일반 함수 (Script 전용)](#11-일반-함수-script-전용)
12. [수학 함수](#12-수학-함수)
13. [파일 함수](#13-파일-함수)
14. [시리얼 포트 함수](#14-시리얼-포트-함수)
15. [소켓 함수](#15-소켓-함수)
16. [Manual Decision 함수](#16-manual-decision-함수)
17. [Parameterized Objects](#17-parameterized-objects)
18. [Robot Teach 클래스](#18-robot-teach-클래스)
19. [로봇 모션 & 비전 함수](#19-로봇-모션--비전-함수)
20. [비전 함수](#20-비전-함수)
21. [External Script (Listen Node)](#21-external-script-listen-node)
22. [Modbus 함수](#22-modbus-함수)
23. [TM Ethernet Slave](#23-tm-ethernet-slave)
24. [Profinet 함수](#24-profinet-함수)
25. [EtherNet/IP 함수](#25-ethernetip-함수)
26. [Compliance 함수](#26-compliance-함수)
27. [TouchStop 함수](#27-touchstop-함수)
28. [Force Control 함수](#28-force-control-함수)

---

## 1. 데이터 타입

| 타입 | 크기 | 부호 | 범위 | 유효 자릿수 |
|------|------|------|------|------------|
| `byte` | 8bit | unsigned | 0 ~ 255 | 3 |
| `int` (int32) | 32bit | signed | -2147483648 ~ 2147483647 | 10 |
| `int16` | 16bit | signed | -32768 ~ 32767 | 5 |
| `float` | 32bit 부동소수 | signed | ±3.4028235E+38 | 7 |
| `double` | 64bit 부동소수 | signed | ±1.7976931348623157E+308 | 15 |
| `bool` | - | - | true / false | - |
| `string` | - | - | UTF-8 문자열 | - |

**배열 타입**: `byte[]`, `int[]`, `float[]`, `double[]`, `bool[]`, `string[]`

### 숫자 리터럴 표기

```
// 정수 자동 타입 결정 (작은 타입 우선)
100         // byte
1000        // int
0b0000111   // 이진수
0x123abc    // 16진수 정수
3.4e5       // float (과학적 표기)
1.11        // float
```

### byte 오버플로우 동작

```
byte b = 0 - 100   // b = 156  (0xFFFFFF9C → 하위 8비트 = 0x9C = 156)
b = 0 - 1          // b = 255
b = 255 + 1        // b = 0
```

### int 오버플로우 동작

```
int i = -2147483648 - 1  // i = 2147483647 (32비트 signed wrap)
i = 2147483647 + 1       // i = -2147483648
```

---

## 2. 변수 및 상수

### 네이밍 규칙

- 사용 가능 문자: `0-9`, `a-z`, `A-Z`, `_`
- 숫자로 시작 불가
- TMflow에서 생성 시 prefix 자동 추가 (예: `var_`, `g_`)

### 변수 선언 예

```
int i = 0
string s = "ABC"
float[] coords = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
bool[] flags = {true, false, true}
```

### 문자열 규칙

```
// 이중 따옴표 안은 변수 치환 없음
s = "TM5"              // s = "TM5" (TM5는 문자열)

// 변수 연결은 + 연산자 사용
s1 = "Hi, " + s + " Robot"    // s1 = "Hi, TM5 Robot"

// 단일 따옴표 방식 (비권장, 경고 발생)
"Hi, 's' Robot"                // s1 = "Hi, TM5 Robot"

// 이중 따옴표 자체를 포함하려면 "" 사용
"Hello TM""5"                  // Hello TM"5

// 제어 문자
s1 = "Hi, " + Ctrl("\r\n") + s + " Robot"
s1 = "Hi, " + NewLine + s + " Robot"

// 예약어
empty                          // 빈 문자열 ""
newline / NewLine              // \r\n
```

### Boolean

```
true, True     // 참
false, False   // 거짓
// 대소문자 구분: TRue는 변수로 해석됨
```

---

## 3. 배열

```
// 선언
int[] i = {0,1,2,3}
string[] s = {"ABC", "DEF", "GHI"}
bool[] bb = {true, false, true}

// 인덱스 (0부터 시작)
A[0], A[1], ..., A[7]    // 8개 원소 배열

// 제한사항
// - 1차원 배열만 지원
// - 최대 원소 수: 2048
// - 배열 크기는 함수 반환값에 따라 동적 변경 가능
```

---

## 4. 연산자

우선순위 높은 순서:

| 우선순위 | 연산자 | 이름 | 적용 대상 | 결합 방향 |
|---------|--------|------|----------|----------|
| 17 | `++` (후위), `--` (후위), `()`, `[]` | 후위 증감, 함수 호출, 배열 인덱스 | | 좌→우 |
| 16 | `++` (전위), `--` (전위), `+` (단항), `-` (단항), `!`, `~` | 전위 증감, 단항, 논리부정, 비트NOT | | 우→좌 |
| 14 | `*`, `/`, `%` | 곱셈, 나눗셈, 나머지 | 수치형 | 좌→우 |
| 13 | `+`, `-` | 덧셈, 뺄셈 | 수치형 | 좌→우 |
| 12 | `<<`, `>>` | 비트 시프트 | 정수형 | 좌→우 |
| 11 | `<`, `<=`, `>`, `>=` | 비교 | 수치형 | 좌→우 |
| 10 | `==`, `!=` | 동등 비교 | 정수형 | 좌→우 |
| 9 | `&` | 비트 AND | 정수형 | 좌→우 |
| 8 | `^` | 비트 XOR | 정수형 | 좌→우 |
| 7 | `|` | 비트 OR | 정수형 | 좌→우 |
| 6 | `&&` | 논리 AND | Boolean | 좌→우 |
| 5 | `||` | 논리 OR | Boolean | 좌→우 |
| 4 | `?:` | 삼항 조건 | | 우→좌 |
| 3 | `=`, `+=`, `-=`, `*=`, `/=`, `%=`, `<<=`, `>>=`, `&=`, `^=`, `|=` | 대입 | | 우→좌 |

### 연산 타입 규칙

```
// 정수형끼리 연산 → 정수 결과
int var_a = 10
int var_b = 3
float var_c = var_a / var_b   // var_c = 3 (정수 나눗셈)

// 부동소수 포함 시 → 부동소수 결과
float var_b = 3
float var_c = var_a / var_b   // var_c = 3.333333

// 명시적 실수 연산
var_c = var_a / 3.0           // var_c = 3.333333
```

---

## 5. 타입 변환

### 명시적 캐스팅

```
(int)100      // byte → int
(float)100    // byte → float
(double)3.14  // float → double
```

### 암묵적 변환 규칙
- 더 작은 타입 → 더 큰 타입으로 자동 승격
- byte → int → float → double 순서

---

## 6. 엔디언 및 변환

**기본 엔디언**: Little Endian (최하위 바이트 먼저)
**string**: UTF-8 인코딩

| 표기 | 의미 | 바이트 순서 |
|------|------|-----------|
| Little Endian (DCBA) | 기본 | 하위 바이트 먼저 |
| Big Endian (ABCD) | Modbus 등 | 상위 바이트 먼저 |

### 엔디언 파라미터 값
- `0` = Little Endian (DCBA)
- `1` = Big Endian (ABCD)
- `2` = 설정 파일 기준 (Profinet/EIP)

---

## 7. 스크립트 프로젝트 구조

```
// 전역 변수 선언
define
{
    int count = 0
    float[] pos = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
    FTSensor fts1 = "ATI_Axia80"
    Force fc1 = "fts1"
}

// 메인 실행 블록
main
{
    // 메인 코드
}

// 비상 정지 시 실행
closestop
{
    // 로봇이 안전하게 정지된 후 실행
}

// 에러 발생 시 실행
errorstop
{
    // 에러 발생 후 실행
}

// 사용자 정의 함수
void MyFunc(int param1, string param2)
{
    // 함수 본체
    return  // void 함수는 return 값 없음
}

int CalcFunc(int a, int b)
{
    return a + b
}
```

### 주석

```
// 한 줄 주석
/* 여러 줄 주석 */
```

### 변수 스코프

```
// 전역 변수: define 블록 또는 Variable Manager에서 선언
// 로컬 변수: 함수/블록 내부에서 선언

define
{
    int g_count = 0   // 전역
}

void MyFunc()
{
    int local_i = 0   // 로컬 (함수 종료 시 소멸)
}
```

### 멀티라인 입력

```
// 긴 배열이나 표현식을 여러 줄에 걸쳐 작성 가능
int[] arr = {
    1, 2, 3,
    4, 5, 6
}
```

---

## 8. 제어문

### if 문

```
if (조건)
{
    // 참일 때
}
else if (조건2)
{
    // 조건2 참일 때
}
else
{
    // 모두 거짓일 때
}
```

### switch 문

```
switch (변수)
{
    case 값1:
        // 실행 코드
        break
    case 값2:
        // 실행 코드
        break
    default:
        // 기본 케이스
        break
}
```

### for 루프

```
for (int i = 0; i < 10; i++)
{
    // 반복 실행
}
```

### while 루프

```
while (조건)
{
    // 반복 실행
}
```

### do-while 루프

```
do
{
    // 반복 실행
} while (조건)
```

### 분기 명령

```
break      // 루프/switch 탈출
continue   // 다음 반복으로 이동
return     // 함수 반환 (값 있거나 없음)
return 값  // 반환값 있는 함수
```

---

## 9. 스레드

```
// 스레드 시작
void ThreadRun(함수명)
// 예:
ThreadRun(MyThreadFunc)

// 스레드 ID 조회
int id = ThreadID()

// 스레드 상태 조회
int state = ThreadState(id)
// 0=미실행, 1=실행중, 2=종료

// 스레드 종료 요청
ThreadExit(id)
```

---

## 10. 일반 함수

### 10.1 바이트 변환 함수

```csharp
// byte[] → int16 변환
int Byte_ToInt16(byte[] data, int startIndex)
int Byte_ToInt16(byte[] data, int startIndex, int endian)
// endian: 0=LE, 1=BE

// byte[] → int32 변환
int Byte_ToInt32(byte[] data, int startIndex)
int Byte_ToInt32(byte[] data, int startIndex, int endian)

// byte[] → float 변환
float Byte_ToFloat(byte[] data, int startIndex)
float Byte_ToFloat(byte[] data, int startIndex, int endian)

// byte[] → double 변환
double Byte_ToDouble(byte[] data, int startIndex)
double Byte_ToDouble(byte[] data, int startIndex, int endian)

// byte[] → int16 배열 변환
int[] Byte_ToInt16Array(byte[] data, int startIndex, int count)
int[] Byte_ToInt16Array(byte[] data, int startIndex, int count, int endian)

// byte[] → int32 배열 변환
int[] Byte_ToInt32Array(byte[] data, int startIndex, int count)
int[] Byte_ToInt32Array(byte[] data, int startIndex, int count, int endian)

// byte[] → float 배열 변환
float[] Byte_ToFloatArray(byte[] data, int startIndex, int count)
float[] Byte_ToFloatArray(byte[] data, int startIndex, int count, int endian)

// byte[] → double 배열 변환
double[] Byte_ToDoubleArray(byte[] data, int startIndex, int count)
double[] Byte_ToDoubleArray(byte[] data, int startIndex, int count, int endian)

// byte[] → string 변환 (UTF-8)
string Byte_ToString(byte[] data)
string Byte_ToString(byte[] data, int startIndex)
string Byte_ToString(byte[] data, int startIndex, int count)

// byte[] 연결
byte[] Byte_Concat(byte[] a, byte[] b)
byte[] Byte_Concat(byte[] a, byte[] b, byte[] c)
// 최대 여러 배열 연결 가능
```

### 10.2 문자열 변환 함수

```csharp
// string → int 변환
int String_ToInteger(string s)
int String_ToInteger(string s, int startIndex)
int String_ToInteger(string s, int startIndex, int count)
// 10진수, 16진수("0x"/"0X" prefix), 2진수("0b"/"0B" prefix) 지원

// string → float 변환
float String_ToFloat(string s)
float String_ToFloat(string s, int startIndex)
float String_ToFloat(string s, int startIndex, int count)

// string → double 변환
double String_ToDouble(string s)
double String_ToDouble(string s, int startIndex)
double String_ToDouble(string s, int startIndex, int count)

// string → byte[] 변환 (UTF-8 인코딩)
byte[] String_ToByte(string s)

// 문자열 내 부분 문자열 첫 번째 위치 검색
int String_IndexOf(string source, string search)
int String_IndexOf(string source, string search, int startIndex)
// 반환: 찾은 인덱스, -1이면 없음

// 마지막 위치 검색
int String_LastIndexOf(string source, string search)
int String_LastIndexOf(string source, string search, int startIndex)

// 두 문자열 처음 다른 위치 검색
int String_DiffIndexOf(string a, string b)

// 부분 문자열 추출
string String_Substring(string source, int startIndex)
string String_Substring(string source, int startIndex, int count)

// 문자열 분리
string[] String_Split(string source, string delimiter)
string[] String_Split(string source, string delimiter, int startIndex)
string[] String_Split(string source, string delimiter, int startIndex, int count)

// 문자열 치환
string String_Replace(string source, string old, string newStr)

// 공백 제거
string String_Trim(string source)         // 앞뒤 공백 제거
string String_Trim(string source, int mode)
// mode: 0=both, 1=앞만, 2=뒤만

// 대소문자 변환
string String_ToLower(string source)
string String_ToUpper(string source)
```

### 10.3 배열 함수

```csharp
// 배열 끝에 원소 추가
type[] Array_Append(type[] arr, type value)

// 지정 위치에 원소 삽입
type[] Array_Insert(type[] arr, int index, type value)

// 원소 제거
type[] Array_Remove(type[] arr, int index)

// 배열 비교
bool Array_Equals(type[] a, type[] b)

// 원소 첫 번째 위치 검색
int Array_IndexOf(type[] arr, type value)
// 반환: 찾은 인덱스, -1이면 없음

// 원소 마지막 위치 검색
int Array_LastIndexOf(type[] arr, type value)

// 배열 역순
type[] Array_Reverse(type[] arr)

// 배열 정렬
type[] Array_Sort(type[] arr)              // 오름차순
type[] Array_Sort(type[] arr, bool desc)  // desc=true이면 내림차순

// 부분 배열 추출
type[] Array_SubElements(type[] arr, int startIndex)
type[] Array_SubElements(type[] arr, int startIndex, int count)
```

### 10.4 데이터 변환 함수

```csharp
// 값 바이트 역순
byte ValueReverse(byte value)
int ValueReverse(int value)
float ValueReverse(float value)
double ValueReverse(double value)
byte[] ValueReverse(byte[] value)
int[] ValueReverse(int[] value)
float[] ValueReverse(float[] value)
double[] ValueReverse(double[] value)

// 숫자 → byte[] 변환 (Little Endian 기본)
byte[] GetBytes(byte value)
byte[] GetBytes(int value)
byte[] GetBytes(int value, int startByte, int count)
byte[] GetBytes(float value)
byte[] GetBytes(float value, int startByte, int count)
byte[] GetBytes(double value)
byte[] GetBytes(double value, int startByte, int count)
// 배열 버전도 있음 (int[], float[], double[])

// 숫자 → string 변환
string GetString(byte value)
string GetString(int value)
string GetString(int value, int radix)         // radix: 2/8/10/16진수
string GetString(int value, int radix, int width)
string GetString(int value, int radix, int width, bool zeroPad)
string GetString(float value)
string GetString(float value, int decimalDigits)
string GetString(float value, int decimalDigits, int totalWidth)
string GetString(float value, int decimalDigits, int totalWidth, bool zeroPad)
string GetString(float value, int decimalDigits, int totalWidth, bool zeroPad, bool scientific)
string GetString(double value)
// ... (float와 동일한 오버로드)
string GetString(bool value)

// 구분자로 파싱
type GetToken(string source, string delimiter, int index)
// 반환 타입: source에서 index번째 토큰, 타입은 자동 판별
string[] GetAllTokens(string source, string delimiter)

// 현재 시각 조회
string GetNow()                    // "yyyy-MM-dd HH:mm:ss.fff" 형식
string GetNow(string format)       // 사용자 정의 포맷
int GetNowStamp()                  // UNIX timestamp (초)
int GetNowStamp(int mode)          // mode: 0=초, 1=밀리초

// 변수 값 읽기 (이름으로)
? GetVarValue(string varName)

// 배열/문자열 길이
int Length(type[] arr)
int Length(string s)

// 제어 문자 생성
byte[] Ctrl(string escapeCode)     // "\r\n", "\t" 등
byte[] Ctrl(int hexValue)
```

### 10.5 체크섬 함수

```csharp
// XOR8 체크섬
byte XOR8(byte[] data)
byte XOR8(byte[] data, int startIndex, int count)

// SUM8 체크섬
byte SUM8(byte[] data)
byte SUM8(byte[] data, int startIndex, int count)

// SUM16 체크섬
int SUM16(byte[] data)
int SUM16(byte[] data, int startIndex, int count)

// SUM32 체크섬
int SUM32(byte[] data)
int SUM32(byte[] data, int startIndex, int count)

// CRC16 체크섬 (Modbus CRC16)
int CRC16(byte[] data)
int CRC16(byte[] data, int startIndex, int count)
int CRC16(byte[] data, int startIndex, int count, int initVal)

// CRC32 체크섬
int CRC32(byte[] data)
int CRC32(byte[] data, int startIndex, int count)
int CRC32(byte[] data, int startIndex, int count, int initVal)
```

### 10.6 Listen Node 관련 함수

```csharp
// Listen Node 수신 패킷 처리
byte[] ListenPacket()        // 현재 수신된 패킷 반환

// Listen Node 응답 전송
bool ListenSend(byte[] data)
bool ListenSend(string data)

// 전역 변수 동기화
bool VarSync(string varName, ? value)
```

---

## 11. 일반 함수 (Script 전용)

```csharp
// 스크립트 프로젝트 종료
void Exit()

// 프로젝트 일시 정지
void Pause()
// 주의: Flow 프로젝트에서는 다음 노드 이동 전까지만 일시정지

// 프로젝트 재개 (스크립트 프로젝트)
void Resume()

// 조건 대기
void WaitFor(bool condition)
void WaitFor(bool condition, int timeoutMs)

// 대기 (밀리초)
void Sleep(int ms)

// 화면 표시 (디버깅용)
void Display(? value)
void Display(string label, ? value)
```

---

## 12. 수학 함수

```csharp
// 기본 수학
? abs(? value)                // 절댓값
? pow(? base, ? exp)          // 거듭제곱
? sqrt(? value)               // 제곱근
? ceil(? value)               // 올림 (float/double 반환)
? floor(? value)              // 내림 (float/double 반환)
? round(? value)              // 반올림
int random(int min, int max)  // 난수 (min 이상 max 미만)

// 통계
? sum(? arr[])                // 합계
? average(? arr[])            // 평균
float stdevp(float[] arr)     // 모집단 표준편차
float stdevs(float[] arr)     // 표본 표준편차
? min(? arr[])                // 최솟값
? max(? arr[])                // 최댓값

// 삼각함수 (라디안)
float sin(float rad)
float cos(float rad)
float tan(float rad)
float asin(float value)       // arcsin
float acos(float value)       // arccos
float atan(float value)       // arctan
float atan2(float y, float x) // arctan2

// 로그
float log(float value)        // 자연로그
float log(float value, float base)
float log10(float value)      // 상용로그

// 각도 변환
float d2r(float degrees)      // 도 → 라디안
float r2d(float radians)      // 라디안 → 도

// 좌표 계산
float norm2(float[] v)        // 벡터 크기 (L2 norm)
float dist(float[] p1, float[] p2)  // 두 점 거리

// 좌표계 변환
float[] trans(float[] point, float[] from, float[] to)
float[] inversetrans(float[] coord)
float[] applytrans(float[] point, float[] transform)
float[] interpoint(float[] p1, float[] p2, float t)
float[] changeref(float[] point, float[] refCoord)
float[] points2coord(float[] p1, float[] p2, float[] p3)
float[] intercoord(float[] c1, float[] c2, float t)
float[] coorshift(float[] coord, float[] shift)
```

---

## 13. 파일 함수

기본 경로: `/home/[사용자]/` (로봇 파일 시스템)

```csharp
// 바이트 읽기
byte[] File_ReadBytes(string path)
byte[] File_ReadBytes(string path, int startIndex, int count)

// 텍스트 읽기 (전체)
string File_ReadText(string path)
string File_ReadText(string path, string encoding)

// 라인 배열로 읽기
string[] File_ReadLines(string path)
string[] File_ReadLines(string path, string encoding)

// 순차 라인 읽기 (파일 핸들 방식)
void File_NextLine(string path)        // 파일 열기/다음 라인 준비
string File_NextLine()                 // 다음 라인 반환

// EOF 확인
bool File_NextEOF(string path)         // true이면 끝에 도달

// 바이트 쓰기
bool File_WriteBytes(string path, byte[] data)
bool File_WriteBytes(string path, byte[] data, bool append)

// 텍스트 쓰기
bool File_WriteText(string path, string text)
bool File_WriteText(string path, string text, bool append)
bool File_WriteText(string path, string text, string encoding)
bool File_WriteText(string path, string text, bool append, string encoding)

// 라인 쓰기 (자동 줄바꿈)
bool File_WriteLine(string path, string line)
bool File_WriteLine(string path, string line, bool append)
bool File_WriteLine(string path, string line, string encoding)

// 여러 라인 쓰기
bool File_WriteLines(string path, string[] lines)
bool File_WriteLines(string path, string[] lines, bool append)

// 파일 존재 확인
bool File_Exists(string path)

// 파일 크기 (바이트)
int File_Length(string path)

// 파일 삭제
bool File_Delete(string path)

// 파일 복사
bool File_Copy(string source, string dest)
bool File_Copy(string source, string dest, bool overwrite)

// 이미지 파일 복사 (비전 결과 이미지)
bool File_CopyImage(string dest)
bool File_CopyImage(string dest, bool overwrite)

// 이미지 데이터 가져오기
byte[] File_GetImage()

// 파일 내용 치환
bool File_Replace(string path, string old, string newStr)

// 파일에서 토큰 파싱
? File_GetToken(string path, string delimiter, int index)
? File_GetToken(string path, string delimiter, int index, int lineIndex)

// 파일에서 모든 토큰 파싱
string[] File_GetAllTokens(string path, string delimiter)
string[] File_GetAllTokens(string path, string delimiter, int lineIndex)
```

---

## 14. 시리얼 포트 함수

### SerialPort 클래스 선언

```
SerialPort 변수명 = string  // 포트명 (예: "COM1", "/dev/ttyUSB0")
SerialPort 변수명 = string, int  // 포트명, 보드레이트
SerialPort 변수명 = string, int, int, int, int
// 포트명, 보드레이트, 데이터비트, 패리티(0=None/1=Odd/2=Even), 스톱비트
```

### 함수 목록

```csharp
// 포트 열기
bool com_open(string portVar)
bool com_open(string portVar, int timeoutMs)

// 포트 닫기
bool com_close(string portVar)

// 데이터 읽기 (byte[])
byte[] com_read(string portVar)
byte[] com_read(string portVar, int count)         // count 바이트 읽기
byte[] com_read(string portVar, byte[] terminator) // 종료 바이트 시퀀스까지
byte[] com_read(string portVar, int timeoutMs, int count)
byte[] com_read(string portVar, int timeoutMs, byte[] terminator)
// 총 6가지 오버로드

// 문자열 읽기
string com_read_string(string portVar)
string com_read_string(string portVar, int count)
string com_read_string(string portVar, string terminator)
string com_read_string(string portVar, int timeoutMs, int count)
string com_read_string(string portVar, int timeoutMs, string terminator)
// 총 6가지 오버로드

// 데이터 쓰기 (byte[])
bool com_write(string portVar, byte[] data)

// 문자열 쓰기 (자동 줄바꿈 없음)
bool com_writeline(string portVar, string data)
bool com_writeline(string portVar, string data, string terminator)
```

---

## 15. 소켓 함수

### Socket 클래스 선언

```
Socket 변수명 = string       // IP 주소 (클라이언트)
Socket 변수명 = string, int  // IP 주소, 포트
// 서버 모드: IP를 "" 또는 자신의 IP로 설정
```

### 함수 목록

```csharp
// 연결 열기
bool socket_open(string socketVar)
bool socket_open(string socketVar, int timeoutMs)

// 연결 닫기
bool socket_close(string socketVar)

// 데이터 읽기 (byte[])
byte[] socket_read(string socketVar)
byte[] socket_read(string socketVar, int count)
byte[] socket_read(string socketVar, byte[] terminator)
byte[] socket_read(string socketVar, int timeoutMs, int count)
byte[] socket_read(string socketVar, int timeoutMs, byte[] terminator)
// 총 6가지 오버로드

// 문자열 읽기
string socket_read_string(string socketVar)
string socket_read_string(string socketVar, int count)
string socket_read_string(string socketVar, string terminator)
string socket_read_string(string socketVar, int timeoutMs, int count)
string socket_read_string(string socketVar, int timeoutMs, string terminator)
// 총 6가지 오버로드

// 데이터 전송 (byte[])
bool socket_send(string socketVar, byte[] data)

// 문자열 전송 (자동 줄바꿈)
bool socket_sendline(string socketVar, string data)
bool socket_sendline(string socketVar, string data, string terminator)
```

---

## 16. Manual Decision 함수

```
MDecision 변수명  // 클래스 선언
```

```csharp
변수명.Reset()                        // 모든 설정 초기화
변수명.Title(string title)            // 다이얼로그 제목 설정
변수명.Description(string desc)       // 설명 텍스트 설정
변수명.Timeout(int ms)                // 자동 선택 타임아웃 (ms)
변수명.TimeoutDefaultCase(int caseId) // 타임아웃 시 기본 케이스 ID
변수명.Case(int id, string label)     // 케이스 추가 (ID, 라벨)

// 다이얼로그 표시 및 결과 반환
int result = 변수명.Show()            // 사용자가 선택한 Case ID 반환
```

---

## 17. Parameterized Objects

시스템 변수처럼 접근하는 내장 객체들.

### Point[string]

```
Point["포인트명"].X           // float R  TCP X 좌표 (mm)
Point["포인트명"].Y           // float R  TCP Y 좌표 (mm)
Point["포인트명"].Z           // float R  TCP Z 좌표 (mm)
Point["포인트명"].RX          // float R  TCP RX (도)
Point["포인트명"].RY          // float R  TCP RY (도)
Point["포인트명"].RZ          // float R  TCP RZ (도)
Point["포인트명"].Value       // float[] R  {X,Y,Z,RX,RY,RZ}
Point["포인트명"].Joint       // float[] R  관절 각도
Point["포인트명"].Config      // int[] R  [Config1, Config2, Config3]
```

### Base[string]

```
Base["베이스명"].X, Y, Z, RX, RY, RZ   // float R  베이스 좌표
Base["베이스명"].Value                  // float[] R  {X,Y,Z,RX,RY,RZ}
```

### TCP[string]

```
TCP["TCP명"].X, Y, Z, RX, RY, RZ      // float R  TCP 오프셋
TCP["TCP명"].Value                     // float[] R  {X,Y,Z,RX,RY,RZ}
TCP["TCP명"].Mass                      // float R  페이로드 질량 (kg)
TCP["TCP명"].MassCenterOffset          // float[] R  질량 중심 오프셋
```

### VPoint[string]

```
VPoint["비전포인트명"].X, Y, Z, RX, RY, RZ   // float R
VPoint["비전포인트명"].Value                  // float[] R
VPoint["비전포인트명"].Joint                  // float[] R
```

### IO[string][int]

```
// 읽기
bool val = IO["모듈명"][채널번호]              // DI 읽기
IO["모듈명"][채널번호] = true                 // DO 설정

// 예:
bool di0 = IO["ControlBox"][0]
IO["ControlBox"][0] = true
```

### Robot[int]

```
Robot[0].Joint            // float[] R  현재 관절 각도 {J1,J2,J3,J4,J5,J6} (도)
Robot[0].TCP              // float[] R  현재 TCP 좌표 (현재 베이스 기준)
Robot[0].TCPSpeed         // float R  현재 TCP 속도 (mm/s)
Robot[0].JointSpeed       // float[] R  관절 속도 (도/s)
Robot[0].Payload          // float R  현재 페이로드 보상값
Robot[0].IsStuck          // bool R  모션 충돌 감지 여부
Robot[0].Force            // float[] R  {Fx,Fy,Fz,Tx,Ty,Tz} (외력)
```

### FT[string]

```
FT["센서명"].X, Y, Z       // float R  힘 (N)
FT["센서명"].TX, TY, TZ    // float R  토크 (Nm)
FT["센서명"].F3D           // float R  3D 합력 (N)
FT["센서명"].T3D           // float R  3D 합토크 (Nm)
FT["센서명"].Value         // float[] R  {X,Y,Z,TX,TY,TZ}
FT["센서명"].ForceValue    // float[] R  {X,Y,Z}
FT["센서명"].TorqueValue   // float[] R  {TX,TY,TZ}
FT["센서명"].Zero          // byte R/W  0=측정, 1=Zero OUT
FT["센서명"].Model         // string R  센서 모델명
```

---

## 18. Robot Teach 클래스

### TPoint 클래스

```
TPoint 변수명              // 선언 (초기값 없음)
TPoint 변수명 = "포인트명" // 기존 포인트로 초기화
TPoint 변수명 = {X,Y,Z,RX,RY,RZ}  // 좌표로 초기화
```

```csharp
// 속성 (R/W)
변수명.Value    // float[] {X,Y,Z,RX,RY,RZ}
변수명.X, Y, Z, RX, RY, RZ  // float 개별

// 메서드
변수명.GetValue()             // float[] 반환
변수명.SetValue(float[] v)    // 값 설정
변수명.SetValue(float x, float y, float z, float rx, float ry, float rz)
```

### TBase 클래스

```
TBase 변수명
TBase 변수명 = "베이스명"
TBase 변수명 = {X,Y,Z,RX,RY,RZ}
```

```csharp
변수명.GetValue()
변수명.SetValue(float[] v)
변수명.ConvShift(float[] shift)  // 현재 베이스에 오프셋 적용 → 새 베이스 좌표 반환
```

### TTCP 클래스

```
TTCP 변수명
TTCP 변수명 = "TCP명"
TTCP 변수명 = {X,Y,Z,RX,RY,RZ}
```

---

## 19. 로봇 모션 & 비전 함수

### 큐 태그

```csharp
// 모션 큐에 태그 삽입
void QueueTag(int tagId)
void QueueTag(int tagId, int count)

// 태그 실행 대기
void WaitQueueTag(int tagId)
void WaitQueueTag(int tagId, int timeoutMs)

// 태그 실행 여부 확인 (비블로킹)
bool CheckQueueTag(int tagId)

// 모션 버퍼 정지 및 클리어
void StopAndClearBuffer()
```

### PTP 모션 (Point-to-Point)

```csharp
// Syntax 1: 포인트명 사용
void PTP(string pointMode, string pointName, int speedPercent, int acceleration, int precision, bool toolSpeedSync)
// pointMode: "JPP"(관절각도), "CPP"(TCP좌표)

// Syntax 2: 좌표값 직접 입력
void PTP(string pointMode, float[] coords, int speedPercent, int acceleration, int precision, bool toolSpeedSync)
// coords: JPP이면 {J1,J2,J3,J4,J5,J6}, CPP이면 {X,Y,Z,RX,RY,RZ}

// Syntax 3: 포인트 + Config
void PTP(string pointMode, string pointName, int[] config, int speedPercent, int acceleration, int precision, bool toolSpeedSync)

// Syntax 4: 좌표 + Config
void PTP(string pointMode, float[] coords, int[] config, int speedPercent, int acceleration, int precision, bool toolSpeedSync)

// 파라미터 설명:
// speedPercent: 1~100 (%)
// acceleration: 가속도 (ms, 모션 시간의 %)
// precision: 100=도달 정밀도 최고, 0=통과 (Blend)
// toolSpeedSync: true=TCP 속도 기준 동기화
```

### Line 모션 (직선 보간)

```csharp
void Line(string pointMode, string pointName, int speed, int acceleration, int precision, bool toolSpeedSync)
void Line(string pointMode, float[] coords, int speed, int acceleration, int precision, bool toolSpeedSync)
// speed: mm/s
// acceleration, precision, toolSpeedSync: PTP와 동일
```

### Circle 모션 (원호 보간)

```csharp
void Circle(string pointMode, string viaPoint, string endPoint, int speed, int acceleration, int precision, int arcMode)
void Circle(string pointMode, float[] viaCoords, float[] endCoords, int speed, int acceleration, int precision, int arcMode)
// viaPoint: 경유점 (원호의 중간점)
// endPoint: 끝점
// arcMode: 0=끝점까지 호, 1=완전한 원
```

### PLine 모션 (Path 직선)

```csharp
void PLine(string pointMode, string pointName, int speed, int acceleration, int precision, bool toolSpeedSync)
void PLine(string pointMode, float[] coords, int speed, int acceleration, int precision, bool toolSpeedSync)
```

### Move 함수 (오프셋 적용 모션)

```csharp
// 오프셋 PTP
void Move_PTP(string pointMode, float[] offset, int speedPercent, int acceleration, int precision, bool toolSpeedSync)
// offset: 현재 위치 기준 오프셋 {X,Y,Z,RX,RY,RZ} 또는 {J1..J6}

// 오프셋 Line
void Move_Line(string pointMode, float[] offset, int speed, int acceleration, int precision, bool toolSpeedSync)

// 오프셋 PLine
void Move_PLine(string pointMode, float[] offset, int speed, int acceleration, int precision, bool toolSpeedSync)
```

### 좌표계 변경

```csharp
// 베이스 변경
void ChangeBase(string baseName)
void ChangeBase(float[] baseCoords)     // {X,Y,Z,RX,RY,RZ}

// TCP 변경
void ChangeTCP(string tcpName)
void ChangeTCP(float[] tcpCoords)       // {X,Y,Z,RX,RY,RZ}
void ChangeTCP(float[] tcpCoords, float mass, float[] massCenter)

// 페이로드 변경
void ChangeLoad(float mass, float[] massCenter)
void ChangeLoad(float mass, float[] massCenter, float[] inertia)
```

### 충돌 감지

```csharp
void CollisionCheck(bool enable)
void CollisionCheck(bool enable, int sensitivity)
// sensitivity: 0~100 (낮을수록 민감)
```

### PVT 모션 (Position-Velocity-Time)

```csharp
void PVTEnter(int mode)                // PVT 모드 진입
// mode: 0=관절 PVT, 1=TCP PVT

void PVTExit()                         // PVT 모드 종료

void PVTPoint(float[] pos, float[] vel, int time)
// pos: 위치 (관절 각도 또는 TCP 좌표)
// vel: 속도
// time: 이 포인트까지의 시간 (ms)
void PVTPoint(float[] pos, float[] vel, int time, bool projSpeedSync)

void PVTPause()                        // PVT 일시 정지
void PVTResume()                       // PVT 재개
```

### 경로 오프셋

```csharp
void PathOffset_Set(float[] offset)
void PathOffset_Set(bool enable)
void PathOffset_Set(bool enable, float[] offset)
void PathOffset_Set(bool enable, float smoothingFactor)

float[] PathOffset_Get()               // 현재 오프셋 반환

bool PathOffset_IsEnabled()            // 오프셋 활성화 여부

void PathOffset_AlphaFilter(float alpha)  // 0~1, 작을수록 더 많이 필터링

void PathOffset_MaxOffset(float maxOffset)  // 최대 허용 오프셋 (mm)
```

### 비전 모션 함수

```csharp
// 비전 잡 실행
bool Vision_DoJob(string jobName)

// 비전 잡 실행 후 PTP 이동
bool Vision_DoJob_PTP(string jobName, string pointMode, int speedPercent, int acceleration, int precision, bool toolSpeedSync)

// 비전 잡 실행 후 Line 이동
bool Vision_DoJob_Line(string jobName, string pointMode, int speed, int acceleration, int precision, bool toolSpeedSync)
```

### Pose Config 파라미터

```
Config 배열: [Config1, Config2, Config3]
Config1: 0=오른손 (-), 1=왼손 (+)
Config2: 0=팔꿈치 아래 (-), 1=팔꿈치 위 (+)
Config3: 0=손목 아래 (-), 1=손목 위 (+)
```

---

## 20. 비전 함수

```csharp
// 비전 잡 결과 가용 여부 확인
bool Vision_IsJobAvailable(string jobName)

// 출력 배열 크기 조회
int Vision_GetOutputArraySize(string jobName)

// 출력 배열 값 조회
? Vision_GetOutputArrayValue(string jobName, int index)

// 트리거 잡 출력 개수 조회
int Vision_GetTriggerJobOutputCount(string jobName)

// 트리거 잡 출력값 조회
? Vision_GetTriggerJobOutputValue(string jobName, int outputIndex, int resultIndex)
```

---

## 21. External Script (Listen Node)

### Listen Node 개요

- Flow 프로젝트에서 **외부 시스템이 스크립트 명령을 전송**하여 로봇을 제어하는 노드
- 통신 포트: 기본 **5890** (TM 설정에 따라 다름)
- 프로토콜: TMSCT, TMSTA, CPERR

### ScriptListen 함수 (Script 프로젝트에서 Listen 모드 시작)

```csharp
void ScriptListen()         // Listen 모드 시작 (연결 대기)
void ScriptListen(int port) // 지정 포트에서 Listen

void ScriptExit()           // Listen 모드 종료
```

### 통신 프로토콜 포맷

```
$TAG,Length,ID,Content,*CS\r\n

TAG: TMSCT / TMSTA / CPERR
Length: Content 이전까지의 바이트 수
ID: 트랜잭션 ID (임의 문자열)
Content: 내용
CS: XOR8 체크섬 (16진수 2자리)
```

### TMSCT (TM Script Command Transaction)

외부 → 로봇: TMscript 명령 전송

```
$TMSCT,Length,ID,Content,*CS\r\n

// 단일 명령
$TMSCT,10,1,int i = 1,*XX\r\n

// 여러 명령 (줄바꿈으로 구분)
$TMSCT,30,2,int i = 0
i = i + 1
Display(i),*XX\r\n
```

로봇 → 외부: 응답

```
$TMSCT,Length,ID,OK,*CS\r\n    // 성공
$TMSCT,Length,ID,Error,ErrorCode,*CS\r\n  // 실패
```

응답 후 변수 값 전송:

```
$TMSCT,Length,ID,OK;변수명=값;변수명=값,...,*CS\r\n
```

### TMSTA (TM Status)

로봇 → 외부: 상태 응답 (Listen Node 진입/종료 시 자동 전송)

```
$TMSTA,Length,ID,Content,*CS\r\n

// 포맷 예
00,1,true    // 정상 진입 (00=SubHeader, ID, true=진입)
00,1,false   // Listen Node 종료
```

TMSTA SubHeader 목록:

| SubHeader | 의미 |
|-----------|------|
| 00 | Listen Node Enter/Exit 상태 |
| 01 | 변수값 조회 응답 |

### CPERR (Control Program Error)

로봇 → 외부: 에러 통보

```
$CPERR,Length,ID,ErrorCode,*CS\r\n

// ErrorCode 목록
00: OK (에러 없음)
01: 구문 에러 (Syntax Error)
02: 런타임 에러 (Runtime Error)
03: 타임아웃
04: 인식 불가 명령
```

### 우선 명령 (Priority Commands)

Listen Node가 아닌 상태에서도 전송 가능한 명령:

```
$TMSCT,Length,ID,QueueTag(n),*CS\r\n
$TMSCT,Length,ID,StopAndClearBuffer(),*CS\r\n
$TMSCT,Length,ID,Pause(),*CS\r\n
$TMSCT,Length,ID,Resume(),*CS\r\n
```

### Listen Node 사용 흐름 예시

```
// 1. 외부에서 연결 후 명령 전송
// 2. 로봇이 TMSTA로 Listen 진입 알림
// 3. 외부에서 TMSCT로 명령 전송
// 4. 로봇이 TMSCT OK 응답
// 5. 명령 실행 완료 후 다음 노드로 이동
// 6. 로봇이 TMSTA로 Listen 종료 알림

// 예: 변수 설정 및 모션
$TMSCT,25,001,var_x = 100.0
Line("CPP",{100,200,300,0,90,0},200,200,100,false),*CS\r\n
```

---

## 22. Modbus 함수

### ModbusTCP 클래스 선언

```
ModbusTCP 변수명 = string              // IP 주소
ModbusTCP 변수명 = string, int         // IP 주소, 포트 (기본 502)
```

### ModbusRTU 클래스 선언

```
ModbusRTU 변수명 = string              // 시리얼 포트명
ModbusRTU 변수명 = string, int         // 포트명, 보드레이트
ModbusRTU 변수명 = string, int, int, int, int
// 포트명, 보드레이트, 데이터비트, 패리티(0=None/1=Odd/2=Even), 스톱비트
```

### Preset 메서드

```csharp
// Modbus TCP/RTU Preset 등록 (Function Code / 주소 사전 설정)
변수명.Preset(string presetName, string funcCode, int startAddr)
// funcCode: "0x01"(Coil R), "0x02"(DI R), "0x03"(HR R), "0x04"(IR R)
//           "0x05"(Coil W1), "0x06"(HR W1), "0x15"(Coil Wn), "0x16"(HR Wn)
// 지원 FC: 01/02/03/04/05/06/15/16

// Slave ID 포함 (RTU 전용)
변수명.Preset(string presetName, byte slaveID, string funcCode, int startAddr)

// IO 디바이스 프리셋 (IODD 방식)
변수명.IODDPreset(string presetName, string funcCode, int startAddr)
변수명.IODDPreset(string presetName, byte slaveID, string funcCode, int startAddr)
```

### modbus_open / close

```csharp
bool modbus_open(string connVar)         // 연결 열기
bool modbus_open(string connVar, int timeoutMs)
bool modbus_close(string connVar)        // 연결 닫기
```

### modbus_read (Syntax 1 — Preset 방식)

```csharp
// 프리셋명으로 읽기
byte[] modbus_read(string connVar, string presetName, int count)
// 반환: raw byte[] (Little Endian)
// DO(FC01)/DI(FC02): 비트를 바이트로 패킹, 상위비트→하위비트 순
// HR(FC03)/IR(FC04): 레지스터 값, 각 2바이트
```

### modbus_read (Syntax 2 — 사용자 정의 방식)

```csharp
// 직접 지정 (Big Endian 반환)
byte[] modbus_read(string connVar, byte slaveID, string funcCode, int startAddr, int count)
// 반환: raw byte[] (Big Endian, AB CD 형식)
```

### modbus_read 변환 함수

```csharp
// int16 배열로 읽기
int[] modbus_read_int16(string connVar, string presetName, int count)
int[] modbus_read_int16(string connVar, string presetName, int count, int endian)
int[] modbus_read_int16(string connVar, byte slaveID, string funcCode, int startAddr, int count)
int[] modbus_read_int16(string connVar, byte slaveID, string funcCode, int startAddr, int count, int endian)
// endian: 0=LE(CD AB), 1=BE(AB CD, 기본)

// int32 배열로 읽기
int[] modbus_read_int32(string connVar, string presetName, int count)
int[] modbus_read_int32(string connVar, byte slaveID, string funcCode, int startAddr, int count)
// (endian 파라미터 포함 버전도 있음)

// float 배열로 읽기
float[] modbus_read_float(string connVar, string presetName, int count)
float[] modbus_read_float(string connVar, byte slaveID, string funcCode, int startAddr, int count)

// double 배열로 읽기
double[] modbus_read_double(string connVar, string presetName, int count)
double[] modbus_read_double(string connVar, byte slaveID, string funcCode, int startAddr, int count)

// string 읽기 (UTF-8, 0x00 종료)
string modbus_read_string(string connVar, string presetName, int count)
string modbus_read_string(string connVar, byte slaveID, string funcCode, int startAddr, int count)
```

### modbus_write

```csharp
// Syntax 1: 프리셋명 + 데이터 + 주소 수
bool modbus_write(string connVar, string presetName, ? data, int addrCount)
// DO: FC05(단일)/FC15(다중), HR: FC06(단일)/FC16(다중)
// data 타입: bool, byte, int, float, double, string, 배열 버전

// Syntax 2: 프리셋명 + 데이터 (프리셋에서 주소 길이 사용)
bool modbus_write(string connVar, string presetName, ? data)

// Syntax 3: 사용자 정의 + 데이터 + 주소 수 (Big Endian으로 씀)
bool modbus_write(string connVar, byte slaveID, string funcCode, int startAddr, ? data, int addrCount)

// Syntax 4: 사용자 정의 + 데이터 (전체 길이)
bool modbus_write(string connVar, byte slaveID, string funcCode, int startAddr, ? data)
```

---

## 23. TM Ethernet Slave

- **포트**: 5891
- **IP**: 로봇 시스템 IP (TMflow 설정)
- GUI 설정에서 Enable 후 전원 재투입 시 자동 시작

### 데이터 테이블

- **Predefined**: 시스템 제공 읽기 전용 항목
- **User Defined**: 사용자 정의 읽기/쓰기 항목
- **Global Variable**: TMflow 전역 변수

### 함수

```csharp
// 아이템 읽기 (반환 타입은 아이템 데이터 타입)
? svr_read(string itemName)

// 아이템 쓰기
bool svr_write(string itemName, ? value)
// 에러 조건: Ethernet Slave 미시작, 아이템명 없음, 읽기전용, 타입 불일치
```

### TMSVR 프로토콜

```
포맷: $TMSVR,Length,ID,Mode,Content,*CS\r\n

트랜잭션 ID:
  서버→클라이언트: "0"~"9" 순환
  클라이언트→서버: 임의 영숫자
```

| Mode | 방향 | 설명 |
|------|------|------|
| 0 | 서버→클라이언트 | 명령 처리 응답 (에러코드) |
| 1 | 클라이언트→서버 | BINARY 쓰기 |
| 2 | 클라이언트→서버 | STRING 쓰기 |
| 3 | 클라이언트→서버 | JSON 쓰기 |
| 11 | 클라이언트→서버 | BINARY 읽기 요청 |
| 12 | 클라이언트→서버 | STRING 읽기 요청 |
| 13 | 클라이언트→서버 | JSON 읽기 요청 |

**Mode 0 에러코드**:

| 코드 | 의미 |
|------|------|
| 00 | OK |
| 01 | NotSupport |
| 02 | WritePermission |
| 03 | InvalidData |
| 04 | NotExist |
| 05 | ReadOnly |
| 06 | ModeError |
| 07 | ValueError |

**Mode 1 (BINARY) 포맷**:
```
Content = [2바이트 아이템명 길이][아이템명][2바이트 값 길이][값][...]
string[] 타입: 각 원소 사이에 0x00 0x00 삽입
```

**Mode 2 (STRING) 포맷**:
```
Content = 아이템명=값\r\n아이템명=값\r\n...
```

**Mode 3 (JSON) 포맷**:
```json
[{"Item":"아이템명","Value":값}, ...]
```

**Mode 11/12/13 (읽기 요청)**:
```
Content = 아이템명만 (값 없음)
```

---

## 24. Profinet 함수

로봇 = **Profinet IO Device**

- **Input Data Table**: 외부(PLC) → 로봇 (읽기 전용)
- **Output Data Table**: 로봇 → 외부 (읽기/쓰기)
- **System Definition Section**: 읽기 전용 (로봇 상태 등)
- **Custom Definition Section**: 사용자 정의 영역

### 엔디언 파라미터
- `0` = Little Endian (DCBA)
- `1` = Big Endian (ABCD)
- `2` = 설정 파일 기준 (기본)

### profinet_read_input (Input 테이블 읽기)

```csharp
// Syntax 1: 주소 + 길이 (byte[])
byte[] profinet_read_input(int address, int length)

// Syntax 2: 단일 주소 (byte)
byte profinet_read_input(int address)

// Syntax 3: 아이템명 + 시프트 주소 + 길이
? profinet_read_input(string itemName, int shiftAddr, int length)

// Syntax 4: 아이템명 + 시프트 주소 (아이템 끝까지)
? profinet_read_input(string itemName, int shiftAddr)

// Syntax 5: 아이템명 (시프트=0, 아이템 전체)
? profinet_read_input(string itemName)
```

### profinet_read_input_int

```csharp
int[] profinet_read_input_int(int address, int length, int endian)
int[] profinet_read_input_int(int address, int length)     // endian=설정기준
int profinet_read_input_int(int address)                   // 4바이트 단일 int
```

### profinet_read_input_float

```csharp
float[] profinet_read_input_float(int address, int length, int endian)
float[] profinet_read_input_float(int address, int length)
float profinet_read_input_float(int address)
```

### profinet_read_input_string

```csharp
string profinet_read_input_string(int address, int length)  // UTF-8, 0x00 종료
```

### profinet_read_input_bit

```csharp
byte profinet_read_input_bit(int address, int bitNo)           // 단일 비트
byte profinet_read_input_bit(string itemName, int bitNo)
byte[] profinet_read_input_bit(int address, int startBit, int bitCount)  // 여러 비트
byte[] profinet_read_input_bit(string itemName, int startBit, int bitCount)
```

### profinet_read_output_* (Output 테이블 읽기)

위 Input 함수와 동일한 구조, 함수명만 `profinet_read_output_*`로 변경.

### profinet_write_output (Output 테이블 쓰기)

```csharp
// Syntax 1: 주소 + 데이터 + 주소 수
bool profinet_write_output(int address, ? data, int addrCount)

// Syntax 2: 주소 + 데이터 (전체 길이)
bool profinet_write_output(int address, ? data)

// Syntax 3: 주소 + 데이터 + 시작 오프셋 + 주소 수
bool profinet_write_output(int address, ? data, int startOffset, int addrCount)

// Syntax 4~7: 아이템명 기반
bool profinet_write_output(string itemName, int shiftAddr, ? data, int startOffset, int addrCount)
bool profinet_write_output(string itemName, int shiftAddr, ? data, int startOffset)
bool profinet_write_output(string itemName, int shiftAddr, ? data)
bool profinet_write_output(string itemName, ? data)
```

### profinet_write_output_bit (비트 쓰기)

```csharp
// Syntax 1: 주소 + 비트번호 + 값
bool profinet_write_output_bit(int address, int bitNo, int value)

// Syntax 2: 아이템명 + 비트번호 + 값
bool profinet_write_output_bit(string itemName, int bitNo, int value)

// Syntax 3~5: 배열 + 시작 비트 + 비트 수 (주소 기반)
bool profinet_write_output_bit(int address, int startBit, byte[] data, int dataStartBit, int bitCount)

// Syntax 6~8: 배열 + 시작 비트 + 비트 수 (아이템명 기반)
bool profinet_write_output_bit(string itemName, int startBit, byte[] data, int dataStartBit, int bitCount)
```

---

## 25. EtherNet/IP 함수

로봇 = **EtherNet/IP IO Device**

- 구조는 Profinet과 동일, 함수명만 `eip_*`로 변경
- 아이템명 prefix:
  - 입력 (Originator → Target): `O2T_`
  - 출력 (Target → Originator): `T2O_`

### 함수 목록

```csharp
// Input 읽기
byte[] eip_read_input(int address, int length)
byte eip_read_input(int address)
? eip_read_input(string itemName, int shiftAddr, int length)
? eip_read_input(string itemName, int shiftAddr)
? eip_read_input(string itemName)

int[] eip_read_input_int(int address, int length, int endian)
int[] eip_read_input_int(int address, int length)
int eip_read_input_int(int address)

float[] eip_read_input_float(int address, int length, int endian)
float[] eip_read_input_float(int address, int length)
float eip_read_input_float(int address)

string eip_read_input_string(int address, int length)

byte eip_read_input_bit(int address, int bitNo)
byte eip_read_input_bit(string itemName, int bitNo)
byte[] eip_read_input_bit(int address, int startBit, int bitCount)
byte[] eip_read_input_bit(string itemName, int startBit, int bitCount)

// Output 읽기 (eip_read_output_*) — 동일 구조
// Output 쓰기 (eip_write_output, eip_write_output_bit) — Profinet과 동일 구조
```

---

## 26. Compliance 함수

### 클래스 선언

```
Compliance 변수명
```

### 메서드 목록

```csharp
변수명.Reset()                          // 모든 파라미터 초기화

변수명.Frame(int frame)
// 1 = Tool 좌표계, 2 = 현재 베이스 좌표계

변수명.HighResistance(bool enable)
// false = 기본 (비운동 방향 저항 없음), true = 고저항

// 단일 방향 컴플라이언스
변수명.Single(int/string dir, int distance, int force, int speed)
// dir: 0=X, 1=Y, 2=Z, 3=RX, 4=RY, 5=RZ (또는 "X","Y","Z","RX","RY","RZ")
// distance: 이동 거리 (mm 또는 도)
// force: 힘 (N 또는 mNm)
// speed: 속도 (mm/s)

// 방향 학습 컴플라이언스
변수명.Teach(int/string dir, float[]/string point1, float[]/string point2, int range, int force, int speed)

// 고급 설정
변수명.AdvSet(int/string dir, bool enable, int upperLimit, int lowerLimit, int force, int speed)
변수명.AdvSet(int/string dir, bool enable)

// 임피던스 제어
변수명.Impedance(int/string scope, int stiffness)
// scope: 0=All, 1=XYZ, 2=RXYZ
// stiffness: 0=Soft, 1=중간, 2=Stiff

// 정지 조건
변수명.Timeout(int ms)                  // ms < 0이면 비활성화
변수명.Timeout()                        // 취소

변수명.DInput(string module, int ch, int/string logic)
// logic: 0/"L"=Low, 1/"H"=High
변수명.DInput(int strokePercent)        // 스트로크 비율 (%)
변수명.DInput()                         // 취소

변수명.AInput(string module, int ch, int/string op, float threshold)
// op: 0="> ", 1=">=", 2="<=", 3="<", 4="=="
변수명.AInput()                         // 취소

변수명.Condition(bool/? expr)           // 조건식 (true이면 정지)
변수명.Condition()                      // 취소

변수명.Resisted(bool enable)            // 외부 저항 감지 (Compliance 모드 전용)
변수명.Resisted()                       // 취소

// 실행
int result = 변수명.Start()
int result = 변수명.Stop()
```

### Start() 반환값

| 값 | 의미 |
|----|------|
| 0 | 미작동 |
| 1 | 작동 중 |
| 2 | 타임아웃 |
| 3 | 거리 도달 |
| 4 | IO 트리거 |
| 5 | 저항 감지 |
| 6 | 에러 |
| 14 | 과속 |
| 201 | 디지털 IO |
| 202 | 아날로그 IO |
| 203 | 변수 조건 |
| 204 | 힘 도달 |
| 205 | 위치 오차 |
| 206 | 모션 완료 |

### Compliance 예시

```
// Single 모드
Compliance comp
comp.Frame(1)           // Tool 좌표계
comp.Single("Z", 50, 5, 10)  // Z 방향, 50mm, 5N, 10mm/s
comp.Timeout(5000)      // 5초 타임아웃
int re = comp.Start()

// Impedance 모드
comp.Reset()
comp.Frame(2)
comp.Impedance(1, 0)    // XYZ, Soft
comp.Timeout(3000)
int re = comp.Start()
```

---

## 27. TouchStop 함수

### 클래스 선언 (3가지 모드)

```
// 컴플라이언스 모드 (힘 센서 없이 접촉 감지)
TouchStop 변수명 = "Compliance"

// 라인 모드 (직선 이동 중 접촉 감지)
TouchStop 변수명 = "Line"

// 힘 센서 모드 (FTSensor 연동)
TouchStop 변수명 = "Force", "센서변수명"
```

### 메서드 목록

Compliance 및 공통 메서드 (Compliance 섹션 참조):
`Reset()`, `Frame()`, `HighResistance()` (Compliance 모드만),
`Timeout()`, `DInput()`, `AInput()`, `Condition()`, `Resisted()` (Compliance 모드만)

**추가/차이 메서드**:

```csharp
변수명.BrakeDistance(int mm)            // 제동 거리 (Line 모드)

변수명.RecordPosPoint(string pointName, bool triggered)
// false = 정지 위치 기록, true = 트리거 위치 기록
변수명.RecordPosPoint(string pointName) // false 기본
변수명.RecordPosPoint()                 // 취소

// Single (Line/Force 모드에서 속도 추가)
변수명.Single(int/string dir, int distance, int force, int speed, bool noPrecision, bool projSpeedSync)

// Teach (Force 모드)
변수명.Teach(int/string dir, float[]/string p1, float[]/string p2, int range, int force, int speed, bool noPrecision, bool projSpeedSync)

// 힘 도달 정지 조건 (Force 모드)
변수명.FTReached(int/string axis, bool enable, float threshold)
// axis: 6=F3D, 7=T3D, 8=Force (합력)
변수명.FTReached(int/string axis, bool enable)
변수명.FTReached(bool absMode)          // 절대값 모니터링
변수명.FTReached()                      // 취소

// 실행
int result = 변수명.Start(bool zeroOut) // Force 모드: Zero OUT 여부
int result = 변수명.Start()
int result = 변수명.Stop()

// 정지/트리거 위치 조회
float[] pos = 변수명.GetStoppedPos(int coordType)
float[] pos = 변수명.GetTriggeredPos(int coordType)
// coordType: 0=플랜지, 1=관절, 2=TCP현재베이스, 3=TCP로봇베이스, 4=EndTCP로봇베이스

// 이동 거리 조회
float dist = 변수명.GetMovingDistance()  // mm
```

### 반환값

Start() / Stop() 반환값은 Compliance와 동일 (0~6, 14, 201~206).

### 예시

```
// Compliance 모드 TouchStop
TouchStop ts = "Compliance"
ts.Frame(1)
ts.Single("Z", 200, 3, 15)
ts.Timeout(8000)
ts.Resisted(true)
int re = ts.Start()
float[] stoppedPos = ts.GetStoppedPos(2)

// Force 모드 TouchStop
FTSensor fts1 = "ATI_Axia80"
fts1.Open()
TouchStop ts2 = "Force", "fts1"
ts2.FTReached("F3D", true, 10.0)
int re = ts2.Start(true)    // Zero OUT 후 시작
```

---

## 28. Force Control 함수

### FTSensor 클래스

```
// 선언 (변수명 = 센서 장치명)
FTSensor fts1 = "ATI_Axia80"
FTSensor fts1 = "ATI_Axia80", "/dev/ttyUSB0"        // 시리얼 포트 지정
FTSensor fts1 = "ATI_Axia80", float[], float[], float  // 위치, TCP중심, 질량
FTSensor fts1 = "ATI_Axia80", "/dev/ttyUSB0", float[], float[], float
```

**지원 센서 모델**:

| 모델명 | 연결 방식 |
|--------|----------|
| `"ATI_Axia80"` | Ethernet |
| `"OnRobot_HEX-E"` | Ethernet |
| `"OnRobot_HEX-H"` | Ethernet |
| `"ROBOTIQ_FT300"` | Serial |
| `"SCHUNK_Axia80"` | Ethernet |
| `"SRI_M4313N3C"` | Ethernet |
| `"WACOH_WEF_WKF_115200"` | Serial (115200 bps) |
| `"WEF-6A200-4-RG24_9600"` | Serial (9600 bps) |

### FTSensor 속성 (읽기 전용 R, R/W 표시)

```
fts1.X, Y, Z          // float R  힘 (N)
fts1.TX, TY, TZ       // float R  토크 (Nm)
fts1.F3D              // float R  합력 (N)
fts1.T3D              // float R  합토크 (Nm)
fts1.Value            // float[] R  {X,Y,Z,TX,TY,TZ}
fts1.ForceValue       // float[] R  {X,Y,Z}
fts1.TorqueValue      // float[] R  {TX,TY,TZ}
fts1.Model            // string R  모델명
fts1.Zero             // byte R/W  0=측정, 1=Zero OUT
```

### FTSensor 메서드

```csharp
bool fts1.Open()     // 연결 열기 (실패 시 프로젝트 에러 반환)
bool fts1.Close()    // 연결 해제
```

### Force 클래스

```
// 선언 (반드시 FTSensor 변수명을 문자열로 전달)
Force fc1 = "fts1"   // fts1은 위에서 선언된 FTSensor 변수명
```

### Force 메서드

```csharp
fc1.Reset()           // 모든 파라미터 초기화 (센서 연결은 유지)

// 좌표계 설정
fc1.Frame(int frame)
// 0 = 로봇 베이스, 1 = Tool (기본), 2 = 현재 베이스, 3 = Trajectory 좌표계
fc1.Frame(string pointName)          // 포인트명의 TCP 좌표 기준
fc1.Frame(float[] tcpCoords, string baseName)
fc1.Frame(float[] tcpCoords)         // 로봇 베이스 기준
fc1.Frame(float x, float y, float z, float rx, float ry, float rz, string baseName)
fc1.Frame(float x, float y, float z, float rx, float ry, float rz)

// 이동 거리 (SetPoint 모드만)
fc1.Distance(int mm)   // <0 이면 무제한

// 힘/토크 제어 설정
fc1.FTSet(int/string axis, bool enable, float value, int pid)
// axis: 0=FX, 1=FY, 2=FZ, 3=TX, 4=TY, 5=TZ (또는 "FX","FY","FZ","TX","TY","TZ")
// pid: 0~4 (PID 프리셋, 2=기본)
fc1.FTSet(int/string axis, bool enable, float value)   // pid=2 기본
fc1.FTSet(int/string axis, bool enable)
fc1.FTSet(int/string axis, float value)                // 값만 변경
fc1.FTSet(int/string axis, int pid)                    // PID만 변경
fc1.FTSet(int/string axis, float[] pidCoeffs)          // {Kp, Ki, Kd}

// Trajectory 모드 설정
fc1.Trajectory(string subflowName)  // Flow 프로젝트의 서브플로우명
fc1.Trajectory(? customFunc)        // 커스텀 함수 또는 명령문
fc1.Trajectory()                    // 취소 → SetPoint 모드로 전환

// 정지 조건
fc1.Timeout(int ms)
fc1.Timeout()

fc1.AllowPosTol(int mm)   // 허용 위치 오차 (<0이면 비활성화)
fc1.AllowPosTol()

fc1.DInput(string module, int ch, int/string logic)
fc1.DInput()

fc1.AInput(string module, int ch, int/string op, float threshold)
fc1.AInput()

fc1.FTReached(int/string axis, bool enable, float threshold)
// axis: 0=FX, 1=FY, 2=FZ, 3=TX, 4=TY, 5=TZ, 6=F3D, 7=T3D
fc1.FTReached(int/string axis, bool enable)
fc1.FTReached(bool absMode)   // 절대값 모니터링
fc1.FTReached()               // 취소

fc1.Condition(bool/? expr)
fc1.Condition()

// 실행
int result = fc1.Start(bool zeroOut, bool gravComp)
// zeroOut: 시작 전 Zero OUT 여부
// gravComp: 중력 보상 여부
int result = fc1.Start(bool zeroOut)
int result = fc1.Start()

int result = fc1.Stop()
```

### Start() 반환값

Compliance/TouchStop과 동일 (0~6, 14, 201~206).

### SetPoint F/T 모드 예시

```
FTSensor fts1 = "ATI_Axia80"
Force fc1 = "fts1"

// 예시 1: Z축 2N 힘 제어, 50mm 이동
fc1.FTSet("FZ", true, 2)
fc1.Distance(50)
int re = fc1.Start()

// 예시 2: Z축 힘 제어 + 타임아웃 + DInput 정지
fc1.FTSet("FZ", true, 2)
fc1.Distance(100)
fc1.Timeout(5000)
fc1.DInput("ControlBox", 0, "H")
int re = fc1.Start(true)   // Zero OUT 후 시작

// 예시 3: 조건식 정지
define
{
    FTSensor fts1 = "ATI_Axia80"
    Force fc1 = "fts1"
    int count = 0
}
main
{
    fc1.FTSet("FZ", true, 2)
    fc1.Distance(-1)
    fc1.Condition(count > 100)
    int re = fc1.Start()
    // count가 100을 초과할 때까지 Z축 2N 힘 제어 계속
}
```

### Trajectory F/T 모드 예시

```
FTSensor fts1 = "ATI_Axia80"
Force fc1 = "fts1"

// 예시 1: Subflow 경로 + FZ 힘 제어
fc1.FTSet("FZ", true, 2)
fc1.Trajectory("FTSubflow0")   // Flow 프로젝트 서브플로우
int re = fc1.Start()
// FTSubflow0 실행 완료 시 종료

// 예시 2: Trajectory 좌표계 + DInput 정지
fc1.FTSet("FZ", true, 2)
fc1.Frame(3)                   // Trajectory 좌표계
fc1.Trajectory("FTSubflow0")
int re = fc1.Start()

// 예시 3: 커스텀 함수 경로 (Script 프로젝트)
define
{
    FTSensor fts1 = "ATI_Axia80"
    Force fc1 = "fts1"
    int count = 0
}
main
{
    fc1.FTSet("FZ", true, 1, 0)   // FZ, 1N, PID 0
    fc1.Frame(1)                  // Tool 좌표계
    fc1.Trajectory(FTMotion())    // 커스텀 함수
    fc1.Timeout(10000)            // Trajectory 모드에서 무효
    fc1.AllowPosTol(1000)
    fc1.DInput("ControlBox", 0, "H")
    fc1.FTReached("FZ", true, 2)
    fc1.FTReached(true)           // 절대값 모니터링
    fc1.Condition(count++ > 200000)
    int re = fc1.Start()
    Display(re)
}

void FTMotion()
{
    while (true)
    {
        PTP("JPP",{15,0,90,0,90,0},50,200,100,false)
        PTP("JPP",{15,0,75,0,90,0},50,200,100,false)
        PTP("JPP",{-15,0,75,0,90,0},50,200,100,false)
        PTP("JPP",{-15,0,90,0,90,0},50,200,100,false)
        Sleep(10)
    }
}
```

---

## 부록: 적용 범위 요약

| 기능 | Set Node | Flow Listen Node | Script Node | Script 프로젝트 |
|------|----------|-----------------|-------------|----------------|
| 표현식/변수/연산자 | O | O | O | O |
| 조건/루프/분기문 | O | O | O | O |
| 스레드 | - | - | O | O |
| 일반 함수 (General) | O | O | O | O |
| 일반 함수 (Script) | - | - | O | O |
| 수학 함수 | O | O | O | O |
| 파일 함수 | - | - | O | O |
| 시리얼 포트 | - | - | O | O |
| 소켓 | - | O | O | O |
| MDecision | O | O | O | O |
| Parameterized Objects | O | O | O | O |
| Robot Teach Class | O | O | O | O |
| 로봇 모션/비전 함수 | O | O | O | O |
| ScriptListen | - | - | O | - |
| External Script | O (Listen Node) | - | - | - |
| Modbus | - | - | O | O |
| TM Ethernet Slave | O | O | O | O |
| Profinet | O | O | O | O |
| EtherNet/IP | O | O | O | O |
| Compliance | O | O | O | O |
| TouchStop | O | O | O | O |
| FTSensor/Force | O | O | O | O |

---

*TMscript 2.18 완전 레퍼런스 — 생성일: 2026-02-22*
