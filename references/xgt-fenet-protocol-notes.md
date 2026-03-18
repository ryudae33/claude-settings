# XGT FEnet 프로토콜 정보 정리

## 1. RSS (Read Sequential) - 연속 읽기 명령 주소 포맷

### 1.1 주소 표기 형식
VagabondK.Protocols 구현 기준:

```csharp
// 예: M 영역 Word 100번지 읽기
var request = new FEnetReadContinuousRequest(DeviceType.M, 100, 10);
```

**DeviceVariable.ToString() 결과:**
- **일반 경우 (P, M, L, K, F 비트 제외):** `%MW100`
- **Word 읽기:** 인덱스 그대로 사용 (리딩 자체가 BYTE 단위로 변환됨)

**프로토콜 내부 인코딩:**
- 주소는 ASCII 문자열로 프레임에 포함됨
- 형식: `%` + 디바이스타입(1글자) + 데이터타입(1글자) + 인덱스(10진수)
- 예: `%MW100` → ASCII 바이트열로 전송
- 0-패딩 여부: **없음** (예: `%MW100` 아님, `%MW100` 맞음)

### 1.2 데이터 주소 계산 (연속 읽기)

```csharp
// FEnetReadContinuousRequest 코드 예:
// Word 데이터: 인덱스 * 2를 BYTE 기반 인덱스로 변환
case LSElectric.DataType.Word:
    deviceVariable = new DeviceVariable(
        startDeviceVariable.DeviceType,
        LSElectric.DataType.Byte,
        startDeviceVariable.Index * 2);  // ← BYTE 단위로 변환
    count = this.count * 2;  // ← 읽을 BYTE 개수
    break;
```

---

## 2. RSS 명령의 data_count 필드

### 2.1 필드 정의: **BYTE 단위**

```csharp
// OnCreateDataFrame 라인 344
.Concat(WordToLittleEndianBytes((ushort)count));
// count = this.count * 2 (Word인 경우)
```

**중요:**
- `count` 필드는 **바이트 개수**로 인코딩됨
- **Word 100개 읽기:** count = 200 (바이트)
- **Byte 100개 읽기:** count = 100 (바이트)

### 2.2 프레임 구조

RSS 연속 읽기 요청 프레임:
```
[Command(2)] [DataType(2)] [Reserved(2)] [BlockCount(2)]
[AddressLength(2)] [Address(...)] [DataCount(2)]
```

- `Address`: ASCII 문자열 (예: `%MW100`)
- `DataCount`: 읽을 **바이트** 수 (Word 읽기 시 = Word개수 × 2)

---

## 3. XGT FEnet 에러 코드 0x0011

### 3.1 NAK Code 정의

VagabondK.Protocols FEnetNAKCode enum:

```csharp
public enum FEnetNAKCode : ushort
{
    Unknown = 0x0000,
    OverRequestReadBlockCount = 0x0001,  // 요청 블록 수 초과 (최대 16개)
    DeviceVariableTypeError = 0x0002,    // 데이터 타입 오류
    IlegalDeviceMemory = 0x0003,         // 지원하지 않는 디바이스 메모리
    OutOfRangeDeviceVariable = 0x0004,   // 디바이스 요구 영역 초과
    OverDataLengthIndividual = 0x0005,   // 개별 블록 데이터 길이 초과 (최대 1400바이트)
    OverDataLengthTotal = 0x0006,        // 블록별 총 데이터 길이 초과 (최대 1400바이트)
    IlegalCompanyID = 0x0075,
    IlegalLength = 0x0076,
    ErrorChacksum = 0x0076,
    IlegalCommand = 0x0077,
}
```

### 3.2 0x0011 의미

**검색 결과로는 직접 정의되지 않음.**

가능한 원인:
1. **사용자 정의 에러 코드** (LS Electric 특정 구현)
2. **구 버전 프로토콜** (이전 FEnet 버전)
3. **디바이스별 예외** (XEC PLC 특정)

**권장사항:**
- LS Electric 공식 FEnet 매뉴얼 (User's Manual_XGT FEnet_V2.30.pdf) 확인
- XEC PLC 제조 번호/펌웨어 버전 확인 후 기술 지원팀 문의

---

## 4. XEC PLC 직접변수 읽기 전제조건

### 4.1 FEnet 통신 요구사항

**직접변수 (%MW, %IW 등) 읽기 지원:**
- XEC Series (XEC-DN, XEC-DR 등) 기본 지원
- **별도 변수 등록 불필요** - 직접변수는 메모리 주소 기반 접근

### 4.2 필수 설정

1. **하드웨어:**
   - XEC PLC에 **FEnet I/F Module** (또는 Built-in Ethernet) 필요
   - TCP 포트 2004 / UDP 포트 2005 (기본값)

2. **프로토콜:**
   - FEnet I/F Module이 LSIS-XGT CompanyID 사용하는지 확인
   - PC ↔ PLC 네트워크 통신 가능 상태

3. **주소 형식:**
   - M 영역 Word: `%MW0` ~ `%MW262143`
   - 입력 Word: `%IW000.00.0` ~ `%IW127.15.3`

### 4.3 동작 확인 코드 (C#)

```csharp
using VagabondK.Protocols.LSElectric.FEnet;

// FEnet 클라이언트 생성
var client = new FEnetClient(channel);
client.CompanyID = "LSIS-XGT";
client.UseChecksum = true;

// M 영역 100번지부터 10 Word 읽기
var request = new FEnetReadContinuousRequest(DeviceType.M, 100, 10);
var response = client.Request(request);

if (response is FEnetReadContinuousResponse readResp)
{
    byte[] data = readResp.Data.ToArray();
    // 20바이트 (10 Word × 2바이트)
}
```

---

## 5. 주소 포맷 상세 분석

### 5.1 VagabondK DeviceVariable 구현

파일: `DeviceVariable.cs` (라인 62-130)

```csharp
public string ToString(bool useHexBitIndex)
{
    // P, M, L, K, F Word/Byte/DWord: 인덱스 10진수
    if (DataType != DataType.Bit || !useHexBitIndex)
    {
        return $"%{(char)DeviceType}{(char)DataType}{Index}";
    }
    // P, M, L, K, F Bit: 워드인덱스 / 비트위치 16진수
    else
    {
        return $"%{(char)DeviceType}{(char)DataType}{Index / 16}{Index % 16:X}";
    }
}
```

**결론:** **0-패딩 없음**
- ❌ `%MW00100`
- ✅ `%MW100`

### 5.2 DeviceType/DataType 문자 매핑

```csharp
// Enum 정의 (DeviceType, DataType는 char 캐스트 가능)
public enum DeviceType : byte
{
    P = (byte)'P', M = (byte)'M', L = (byte)'L', ...
}

public enum DataType : byte
{
    Bit = (byte)'X',    // %MX = M 영역 비트
    Byte = (byte)'B',   // %MB = M 영역 바이트
    Word = (byte)'W',   // %MW = M 영역 워드
    ...
}
```

---

## 6. 프로토콜 한계

### 6.1 FEnet I/F Module 제한

- **최대 연속 읽기:** 32 blocks × 200 words/block = 6,400 words
- **최대 개별 읽기:** 16 blocks
- **개별 블록 데이터 제한:** 1,400 bytes

### 6.2 XEC PLC 지원

- XEC 모든 Series: FEnet 지원 (Cnet 기본)
- Direct Variable (%MW, %IW) 읽기: 지원
- 변수 등록: **불필요** (메모리 주소 직접 접근)

---

## 7. 참고 오픈소스

### 7.1 VagabondK.Protocols (권장)

**GitHub:** [Vagabond-K/VagabondK.Protocols](https://github.com/Vagabond-K/VagabondK.Protocols)

- .NET 기반 FEnet 클라이언트 완전 구현
- 주소 파싱 로직 포함
- NAK 에러 코드 완전 정의

**주요 클래스:**
- `FEnetClient`: 통신 클라이언트
- `FEnetReadContinuousRequest`: RSS 명령
- `FEnetReadIndividualRequest`: 개별 읽기

### 7.2 SharpSCADA

**GitHub Issue:** [PLC LS XGT protocol CNET AND FENET](https://github.com/GavinYellow/SharpSCADA/issues/14)

- SCADA 시스템 기반 FEnet 통신
- 프로토콜 토론/디버깅 사례

---

## 8. 주의사항

1. **CompanyID 확인:** LSIS-XGT vs LGIS-GLOFA (구형 모델)
2. **UseHexBitIndex 옵션:** XGB PLC에서 비트 읽기 오류 시 true로 설정
3. **체크섬:** 기본값 true 권장 (통신 안정성)
4. **타임아웃:** 기본 1000ms, 네트워크 상태에 따라 조정

---

## 9. LS Electric 공식 문서

- [XGT FEnet I/F Module User's Manual_V2.30](https://www.ls-electric.com/upload/customer/download/f8a96bfb-6212-4a0f-8d07-a1ba8868240f/User's%20Manual_XGT%20FEnet_V2.30.pdf)
- [XGB FEnet I/F Module User's Manual_V1.8](https://sol.ls-electric.com/uploads/document/16735978115430/User_s%20Manual_XBL-EMTA_ENG_V1.8_202210.pdf)
- Pro-face XGT/XGB Series FEnet Driver 매뉴얼
