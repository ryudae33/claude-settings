# 에이전트 프로필

제가 상황 판단하여 Task 서브에이전트로 호출할 때 사용하는 프롬프트 프로필.

---

## 1. project-analyzer (프로젝트 분석)

**대응 스킬**: `/analyze-project`
**트리거 조건**: 새 프로젝트 작업 시작, 프로젝트 구조 파악 필요, `.project-analysis.md` 없을 때
**서브에이전트 타입**: `general-purpose`

### 프롬프트 템플릿
```
자동화 프로젝트를 분석하라.
경로: {프로젝트 경로}

분석 항목:
1. 통신 프로토콜 (포트, 보레이트, 명령, 응답포맷, 파싱규칙, 폴링주기, 타임아웃, 오프셋)
2. 상태머신/시퀀스 (상태번호, 이름, 동작, 전이조건, 에러처리)
3. PLC 주소맵 (입력/출력/데이터 영역, 주소, 방향, 설명)
4. 파일 구조 (폼/모듈/클래스 목록, 각 역할)
5. 데이터 흐름 (센서→파싱→보정→판정→저장)
6. DB 테이블 (테이블명, 컬럼, 타입, 용도)
7. 하드코딩 상수 (이름, 값, 용도)

출력: {프로젝트경로}/.project-analysis.md 파일로 저장
포맷: 마크다운 테이블 형식
```

---

## 2. vb-converter (VB.NET → C# 변환)

**대응 스킬**: `/vb-convert`
**트리거 조건**: VB.NET 파일 변환 요청, .vb 파일을 .cs로 변환 작업
**서브에이전트 타입**: `general-purpose`

### 프롬프트 템플릿
```
VB.NET 코드를 C# .NET 9.0 WinForms로 변환하라.
대상: {파일 또는 폴더 경로}

변환 규칙:
- 문법: Dim→타입선언, Sub/Function→void/returnType, Handles→+=, Me.→this., Nothing→null, AndAlso→&&, OrElse→||
- 패턴 대체:
  - ADODB.Recordset → MdbHelper.ExecuteQuery() + DataTable
  - FlexCell → DataGridView
  - Grid.AddItem → DataTable.Rows.Add()
  - MsgBox → MessageBox.Show
  - Chr(9) → \t, vbCrLf → \r\n
- 하드웨어: SerialPort/타이머 패턴 유지, 하드코딩 값 보존
- .NET 9.0: nullable reference types, file-scoped namespace, target-typed new, pattern matching

규칙:
- 원본 로직 최대한 보존
- 과도한 리팩토링 금지
- 변환 불가 부분은 TODO 주석
```

---

## 3. ui-builder (WinForms / WPF UI 작성)

**대응 스킬**: `/winforms-ui`
**트리거 조건**: WinForms 폼 UI 생성/수정 요청, WPF Window/UserControl UI 생성/수정 요청, Designer.cs 또는 XAML 작성 필요
**서브에이전트 타입**: `general-purpose`

### 프롬프트 템플릿 — WinForms
```
WinForms Designer.cs 코드를 작성하라.
요구사항: {UI 설명}

스타일 규칙:
- 다크테마 기본 적용
  - 배경: Form/Panel(30,30,30), GroupBox/TextBox(45,45,48)
  - 전경: White, 강조 Lime/Cyan/Yellow
  - 버튼: BackColor(60,60,60), FlatStyle.Flat, Border(100,100,100)
- 폰트: 맑은 고딕 (기본 9F, 제목 12F Bold, 값 10F Bold, 대형 18F Bold)
- DataGridView: 다크 스타일 (HeadersVisualStyles=false, Selection(0,122,204))
- 레이아웃: 컨트롤간 5~10px, 그룹간 15~20px

출력 규칙:
- Designer.cs에만 작성
- TabIndex 순차 지정
- Name 속성 필수
- 이벤트 핸들러는 += 연결만
```

### 프롬프트 템플릿 — WPF
```
WPF XAML + CodeBehind를 작성하라.
요구사항: {UI 설명}

스타일 규칙:
- 다크테마 기본 적용
  - 배경: Window/Grid(#1E1E1E), Border/GroupBox(#2D2D30)
  - 전경: White, 강조 Lime/Cyan/Yellow
  - 버튼: Background(#3C3C3C), BorderBrush(#646464)
- 폰트: 맑은 고딕 (기본 12, 제목 16 Bold, 값 14 Bold, 대형 24 Bold)
- DataGrid: 다크 스타일 (RowBackground=#2D2D30, AlternatingRowBackground=#333337)
- 레이아웃: Grid/StackPanel/DockPanel 사용, Margin 5~10

출력 규칙:
- XAML 파일 (.xaml) + CodeBehind (.xaml.cs) 분리
- x:Name 속성 필수
- MVVM 패턴 사용 시 ViewModel도 작성
- Style/ResourceDictionary는 App.xaml 또는 별도 파일로 분리 가능
- 이벤트 바인딩: Command 우선, 필요 시 코드비하인드 이벤트
```

---

## 4. db-explorer (DB 탐색/구조 수집)

**대응 스킬**: 없음 (에이전트 전용)
**트리거 조건**: DB 구조 파악 요청, 테이블/데이터 조회 필요, DB 스키마 수집, DB 파일 분석
**서브에이전트 타입**: `Bash`

### 지원 DB
| DB 타입 | 확장자 | 접속 방식 |
|---------|--------|----------|
| SQL Server | (서버) | `sqlcmd` CLI |
| Access | .mdb, .accdb | PowerShell `System.Data.OleDb` |
| SQLite | .db, .sqlite, .sqlite3 | `sqlite3` CLI 또는 PowerShell `System.Data.SQLite` |
| MySQL | (서버) | `mysql` CLI |
| PostgreSQL | (서버) | `psql` CLI |
| Excel (DB용) | .xlsx, .xls | PowerShell `System.Data.OleDb` |
| CSV (DB용) | .csv | PowerShell `Import-Csv` |
| dBASE | .dbf | PowerShell `System.Data.OleDb` |

### 프롬프트 템플릿

#### SQL Server 접속
```
SQL Server DB에 접속하여 구조를 탐색하라.

접속정보:
- 서버: {서버주소}
- DB: {DB명}
- 인증: {Windows인증 또는 ID/PW}

작업:
1. 테이블 목록 조회
   sqlcmd -S {서버} -d {DB} -E -Q "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE' ORDER BY TABLE_NAME"

2. 각 테이블 스키마 조회
   sqlcmd -S {서버} -d {DB} -E -Q "SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='{테이블}' ORDER BY ORDINAL_POSITION"

3. 인덱스/키 조회
   sqlcmd -S {서버} -d {DB} -E -Q "SELECT i.name, c.name as column_name, i.type_desc FROM sys.indexes i JOIN sys.index_columns ic ON i.object_id=ic.object_id AND i.index_id=ic.index_id JOIN sys.columns c ON ic.object_id=c.object_id AND ic.column_id=c.column_id WHERE i.object_id=OBJECT_ID('{테이블}')"

4. 샘플 데이터 (상위 5건)
   sqlcmd -S {서버} -d {DB} -E -Q "SELECT TOP 5 * FROM {테이블}"

5. 행 수 조회
   sqlcmd -S {서버} -d {DB} -E -Q "SELECT '{테이블}' as tbl, COUNT(*) as cnt FROM {테이블}"
```

#### Access/MDB/ACCDB 접속
```
Access DB 파일에 접속하여 구조를 탐색하라.

파일경로: {파일 경로}

PowerShell로 실행:

1. 테이블 목록 조회
   $conn = New-Object System.Data.OleDb.OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source='{파일경로}'")
   $conn.Open()
   $tables = $conn.GetSchema("Tables") | Where-Object { $_.TABLE_TYPE -eq "TABLE" }
   $tables | Select-Object TABLE_NAME | Format-Table
   $conn.Close()

2. 테이블 스키마 조회
   $conn.Open()
   $cmd = $conn.CreateCommand()
   $cmd.CommandText = "SELECT TOP 1 * FROM [{테이블}]"
   $reader = $cmd.ExecuteReader()
   $schema = $reader.GetSchemaTable()
   $schema | Select-Object ColumnName, DataType, ColumnSize, AllowDBNull | Format-Table
   $reader.Close()
   $conn.Close()

3. 샘플 데이터 (상위 5건)
   $conn.Open()
   $cmd = $conn.CreateCommand()
   $cmd.CommandText = "SELECT TOP 5 * FROM [{테이블}]"
   $adapter = New-Object System.Data.OleDb.OleDbDataAdapter($cmd)
   $dt = New-Object System.Data.DataTable
   $adapter.Fill($dt)
   $dt | Format-Table
   $conn.Close()

4. 행 수 조회
   $cmd.CommandText = "SELECT COUNT(*) FROM [{테이블}]"
   $count = $cmd.ExecuteScalar()
```

#### SQLite 접속
```
SQLite DB 파일에 접속하여 구조를 탐색하라.

파일경로: {파일 경로}

sqlite3 CLI로 실행:

1. 테이블 목록 조회
   sqlite3 "{파일경로}" ".tables"

2. 테이블 스키마 조회
   sqlite3 "{파일경로}" ".schema {테이블}"
   sqlite3 "{파일경로}" "PRAGMA table_info({테이블});"

3. 인덱스 조회
   sqlite3 "{파일경로}" ".indices {테이블}"

4. 샘플 데이터 (상위 5건)
   sqlite3 -header -column "{파일경로}" "SELECT * FROM {테이블} LIMIT 5;"

5. 행 수 조회
   sqlite3 "{파일경로}" "SELECT COUNT(*) FROM {테이블};"

sqlite3 미설치 시 PowerShell 대체:
   Add-Type -Path "System.Data.SQLite.dll"
   $conn = New-Object System.Data.SQLite.SQLiteConnection("Data Source={파일경로}")
   $conn.Open()
   $cmd = $conn.CreateCommand()
   $cmd.CommandText = "SELECT name FROM sqlite_master WHERE type='table'"
   $reader = $cmd.ExecuteReader()
   while ($reader.Read()) { $reader["name"] }
   $conn.Close()
```

#### 자동 판별
```
DB 파일을 자동으로 판별하여 탐색하라.

파일경로: {파일 경로}

판별 순서:
1. 확장자 확인
   .mdb, .accdb → Access/OleDb
   .db, .sqlite, .sqlite3 → SQLite
   .dbf → dBASE/OleDb
   .xlsx, .xls → Excel/OleDb
2. 확장자 불명확 시 파일 헤더(매직넘버) 확인
   - "SQLite format 3" → SQLite
   - 0x00 0x01 0x00 0x00 "Standard Jet DB" → Access
3. 해당 방식으로 접속 후 표준 탐색 수행
```

### 출력 포맷
```markdown
# DB 분석: {DB명 또는 파일명}
분석일: YYYY-MM-DD HH:mm

## 접속정보
- 타입: SQL Server / Access / SQLite / MySQL / PostgreSQL
- 경로: {경로}

## 테이블 목록
| # | 테이블명 | 행 수 | 설명 |
|---|---------|------|------|

## 테이블 상세
### {테이블명}
| 컬럼 | 타입 | 크기 | Nullable | 설명 |
|------|-----|------|----------|------|

### 키/인덱스
| 인덱스명 | 컬럼 | 타입 |
|---------|------|------|

### 샘플 데이터 (TOP 5)
| col1 | col2 | ... |
|------|------|-----|
```

### 규칙
- 파일 확장자로 DB 타입 자동 판별
- 접속 실패 시 대체 방식 시도 (CLI → PowerShell)
- 대용량 테이블은 COUNT만, 전체 덤프 금지
- 바이너리/BLOB 컬럼은 크기만 표시

---

## 5. project-planner (신규 프로젝트 계획)

**대응 스킬**: 없음 (에이전트 전용)
**트리거 조건**: 새 프로젝트 생성 요청, 프로젝트 구조/설계 계획 필요, 요구사항 정리
**서브에이전트 타입**: `Plan`

### 프롬프트 템플릿
```
신규 자동화 프로젝트를 계획하라.

프로젝트명: {프로젝트명}
요구사항: {사용자 요구사항}

계획 항목:

1. 요구사항 정리
   - 기능 요구사항 (측정, 검사, 제어 등)
   - 통신 대상 장비 (PLC, 센서, 바코드리더 등)
   - 데이터 저장 방식 (MDB, SQL Server, CSV 등)
   - UI 요구사항 (화면 구성, 표시 항목)

2. 프로젝트 구조 설계
   - 솔루션/프로젝트 구성
   - 폴더 구조
   - 폼 목록 및 역할
   - 클래스/서비스 설계

3. 통신 설계
   - 장비별 프로토콜 (시리얼/이더넷/PLC)
   - 주소 맵 초안
   - 폴링 주기/타임아웃 설정

4. DB 설계
   - 테이블 목록 및 스키마 초안
   - 기준값/측정값/이력 테이블 구분
   - 쿼리 패턴

5. 시퀀스 설계
   - 메인 상태머신 (상태/전이조건)
   - 에러/알람 처리
   - 리셋 시나리오

6. 작업 단계 (WBS)
   | 단계 | 작업 | 산출물 | 비고 |
   |-----|-----|--------|-----|
   | 1 | 프로젝트 생성 | .sln, 기본 구조 | |
   | 2 | DB 구축 | 테이블 생성, MdbHelper | |
   | 3 | 통신 모듈 | SerialPort, PLC 클래스 | |
   | 4 | 메인 시퀀스 | 상태머신 구현 | |
   | 5 | UI 구현 | 폼 Designer + 로직 | |
   | 6 | 테스트/디버깅 | 시뮬 테스트 | |
```

### 출력 포맷
```markdown
# 프로젝트 계획: {프로젝트명}
작성일: YYYY-MM-DD HH:mm

## 1. 개요
- 목적: ...
- 대상 장비: ...
- 개발 환경: C# .NET 9.0 WinForms

## 2. 요구사항
### 기능 요구사항
- [ ] ...

### 비기능 요구사항
- [ ] ...

## 3. 프로젝트 구조
{솔루션명}/
├── {프로젝트명}/
│   ├── Forms/
│   │   ├── FrmMain.cs          # 메인화면
│   │   ├── FrmBasic.cs         # 기준값 설정
│   │   └── FrmPart.cs          # 품번 관리
│   ├── Services/
│   │   ├── PlcService.cs       # PLC 통신
│   │   └── SensorService.cs    # 센서 통신
│   ├── Helpers/
│   │   └── MdbHelper.cs        # DB 헬퍼
│   └── Program.cs
└── {프로젝트명}.sln

## 4. 통신 설계
### {장비명}
| 항목 | 값 |
|-----|---|
| 프로토콜 | Serial/Ethernet |
| 포트 | COM?/IP:Port |
| 보레이트 | 9600/115200 |
| 명령 | ... |
| 응답 | ... |

## 5. DB 설계
### {테이블명}
| 컬럼 | 타입 | 설명 |
|------|-----|------|

## 6. 시퀀스 설계
| 상태 | 이름 | 동작 | 전이조건 |
|-----|-----|------|---------|

## 7. 작업 계획 (WBS)
| # | 단계 | 작업 | 산출물 |
|---|-----|------|--------|
```

### 규칙
- 스펙 불명확 시 반드시 질문 먼저
- HW/프로토콜 정보 부족 시 질문 먼저
- CLAUDE.md 글로벌 규칙 (전역 예외 핸들러, ScottPlot 한글 폰트 등) 반영
- 기존 프로젝트 패턴 참조 (`.project-analysis.md` 확인)

---

## 6. screenshot-viewer (스크린샷 확인)

**대응 스킬**: `/sc`
**트리거 조건**: 사용자가 "sc" 입력, 스크린샷 확인 요청, 화면 캡처 분석 필요
**서브에이전트 타입**: `general-purpose`

### 프롬프트 템플릿
```
최신 스크린샷을 찾아서 분석하라.

1. Glob으로 C:\Users\ryuda\Pictures\Screenshots 폴더에서 최신 이미지 파일 1개를 찾아라
   (png, jpg, jpeg, bmp 등)
2. Read 도구로 해당 이미지를 읽어라 (멀티모달 지원)
3. 이미지 내용을 분석하여 보고하라

분석 항목:
- 화면에 보이는 내용 요약
- 에러/경고 메시지 강조
- 코드가 보이면 관련 설명
- UI 요소 식별
- 작업 맥락 파악

출력:
- 한글로 간결하게 보고
- 추가 작업 필요 여부 안내
```

### 규칙
- 파일이 없으면 "스크린샷 없음" 안내
- 이미지 읽기 실패 시 파일 경로와 크기 정보라도 보고

---

## 7. doc-reader (문서 자료 읽기/분석)

**대응 스킬**: 없음 (에이전트 전용)
**트리거 조건**: PDF/Excel/Word/CSV/텍스트 등 문서 파일 내용 확인 요청, 문서 기반 정보 추출 필요
**서브에이전트 타입**: `general-purpose`

### 지원 파일 형식
| 형식 | 확장자 | 읽기 방법 |
|------|--------|----------|
| PDF | .pdf | Read 도구 (pages 파라미터로 페이지 지정, 대용량은 분할 읽기) |
| Excel | .xlsx, .xls | PowerShell `Import-Excel` 또는 `System.Data.OleDb` |
| CSV | .csv | Read 도구 직접 읽기 또는 PowerShell `Import-Csv` |
| Word | .docx | PowerShell `System.IO.Compression` (docx=zip) 또는 COM 객체 |
| 텍스트 | .txt, .log, .md | Read 도구 직접 읽기 |
| 이미지 | .png, .jpg, .bmp | Read 도구 (멀티모달) |

### 프롬프트 템플릿
```
문서 파일을 읽고 내용을 분석하라.

파일경로: {파일 경로}
분석 요청: {사용자 요청 사항}

읽기 절차:

1. 파일 확장자 확인하여 형식 판별

2. 형식별 읽기:
   - PDF: Read 도구 사용. 10페이지 초과 시 pages 파라미터로 분할 읽기 (1-10, 11-20 ...)
   - Excel (.xlsx/.xls):
     PowerShell로 읽기:
     $conn = New-Object System.Data.OleDb.OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source='{파일경로}';Extended Properties='Excel 12.0 Xml;HDR=YES'")
     $conn.Open()
     # 시트 목록
     $sheets = $conn.GetSchema("Tables") | Select-Object TABLE_NAME
     # 시트 데이터 읽기
     $cmd = $conn.CreateCommand()
     $cmd.CommandText = "SELECT * FROM [{시트명}]"
     $adapter = New-Object System.Data.OleDb.OleDbDataAdapter($cmd)
     $dt = New-Object System.Data.DataTable
     $adapter.Fill($dt)
     $dt | Format-Table
     $conn.Close()
   - CSV: Read 도구로 직접 읽기. 대용량은 PowerShell Import-Csv | Select-Object -First 100
   - Word (.docx):
     PowerShell로 읽기:
     Add-Type -AssemblyName System.IO.Compression.FileSystem
     $zip = [System.IO.Compression.ZipFile]::OpenRead('{파일경로}')
     $entry = $zip.Entries | Where-Object { $_.FullName -eq 'word/document.xml' }
     $stream = $entry.Open()
     $reader = New-Object System.IO.StreamReader($stream)
     $xml = [xml]$reader.ReadToEnd()
     $reader.Close(); $zip.Dispose()
     # 텍스트 추출
     $xml.GetElementsByTagName('w:t') | ForEach-Object { $_.InnerText }
   - 텍스트/로그/마크다운: Read 도구 직접 읽기
   - 이미지: Read 도구 (멀티모달 분석)

3. 내용 분석:
   - 문서 구조 파악 (목차, 섹션, 표 등)
   - 핵심 데이터 추출
   - 사용자 요청에 맞는 정보 정리
   - 수치 데이터는 표 형식으로 정리
   - 도면/사양서는 스펙 항목별 정리

4. 결과 보고
```

### 출력 포맷
```markdown
# 문서 분석: {파일명}
분석일: YYYY-MM-DD HH:mm

## 파일 정보
- 형식: PDF / Excel / Word / CSV / 기타
- 크기: {파일 크기}
- 페이지/시트: {페이지 수 또는 시트 목록}

## 내용 요약
{문서 핵심 내용 요약}

## 상세 내용
{사용자 요청에 따른 상세 분석}

## 추출 데이터
| 항목 | 값 | 비고 |
|------|---|------|
```

### 규칙
- 대용량 파일은 분할 읽기 (메모리 초과 방지)
- Excel 시트가 여러 개면 시트 목록 먼저 보고 후 필요한 시트만 읽기
- PDF 10페이지 초과 시 반드시 pages 파라미터 사용
- 바이너리 파일(.mdb 등)은 db-explorer 에이전트로 위임
- 읽기 실패 시 파일 경로/크기/형식 정보라도 보고
- 한글 인코딩 문제 시 PowerShell에서 `-Encoding UTF8` 지정

---

## 8. log-analyzer (로그 분석)

**대응 스킬**: 없음 (에이전트 전용)
**트리거 조건**: crash.log/에러 로그 분석 요청, 현장 장비 로그 확인, 애플리케이션 오류 추적, 로그 파일 패턴 분석
**서브에이전트 타입**: `general-purpose`

### 지원 로그 타입
| 로그 타입 | 파일 패턴 | 설명 |
|-----------|----------|------|
| crash.log | crash.log | 전역 예외 핸들러가 기록한 크래시 로그 |
| 애플리케이션 로그 | *.log, *.txt | 일반 앱 로그 |
| 통신 로그 | comm*.log, serial*.log | PLC/시리얼/이더넷 통신 기록 |
| Windows 이벤트 | (시스템) | PowerShell Get-EventLog / Get-WinEvent |
| IIS/웹 로그 | *.log | W3C 형식 웹서버 로그 |

### 프롬프트 템플릿
```
로그 파일을 분석하라.

파일경로: {파일 경로}
분석 요청: {사용자 요청 사항}

분석 절차:

1. 로그 파일 읽기
   - Read 도구로 파일 읽기
   - 대용량(1000줄 초과) 시 tail부터 읽기 (최근 로그 우선)
   - 인코딩 문제 시 PowerShell로 재시도

2. 로그 구조 파악
   - 타임스탬프 형식 식별
   - 로그 레벨 (ERROR, WARN, INFO, DEBUG) 분류
   - 소스/모듈 식별

3. 에러 분석
   - ERROR/Exception/Unhandled 키워드 검색
   - 스택트레이스 추적
   - 에러 발생 시간대/빈도 패턴
   - 에러 직전 로그에서 원인 추정

4. 패턴 분석
   - 반복 에러 그룹핑
   - 시간대별 에러 빈도
   - 통신 타임아웃/연결 실패 패턴
   - 메모리/리소스 관련 경고

5. 결과 보고
```

### 출력 포맷
```markdown
# 로그 분석: {파일명}
분석일: YYYY-MM-DD HH:mm

## 파일 정보
- 크기: {파일 크기}
- 기간: {첫 로그 시간} ~ {마지막 로그 시간}
- 총 라인 수: {라인 수}

## 에러 요약
| # | 시간 | 에러 타입 | 메시지 | 발생 횟수 |
|---|------|----------|--------|----------|

## 주요 에러 상세
### 에러 1: {에러 제목}
- 시간: {시간}
- 소스: {소스/모듈}
- 메시지: {에러 메시지}
- 스택트레이스:
  {스택트레이스}
- 추정 원인: {원인 분석}
- 조치 방안: {해결 제안}

## 패턴 분석
- {반복 패턴 설명}

## 조치 권장사항
1. {권장사항}
```

### 규칙
- 최근 로그부터 분석 (tail-first)
- 에러/예외 우선 강조
- 스택트레이스는 전체 포함
- 민감 정보 (IP, 비밀번호 등) 마스킹
- crash.log 형식: `[시간] [소스] 메시지\n스택트레이스` 패턴 인식
- 통신 로그는 TX/RX 구분, 타임아웃 패턴 분석

---

## 9. hw-connector (장비 직접 연결/확인)

**대응 스킬**: 없음 (에이전트 전용)
**트리거 조건**: 장비 통신 테스트, 시리얼/이더넷/USB 포트 확인, 센서/PLC 응답 확인, 포트 스캔, 장비 연결 상태 진단
**서브에이전트 타입**: `Bash`

### 지원 인터페이스
| 인터페이스 | 도구 | 용도 |
|-----------|------|------|
| Serial (COM) | PowerShell `System.IO.Ports.SerialPort` | 센서, 바코드리더, 계측기 |
| Ethernet (TCP/UDP) | PowerShell `System.Net.Sockets.TcpClient` | PLC, 서버, IP장비 |
| USB | PowerShell `Get-PnpDevice`, `devcon` | USB장비 인식 확인 |
| Modbus TCP | PowerShell 소켓 직접 통신 | PLC Modbus |
| Ping | `ping`, `Test-Connection` | 네트워크 연결 확인 |

### 프롬프트 템플릿

#### 포트/장비 스캔
```
현재 PC에 연결된 장비/포트를 스캔하라.

1. COM 포트 목록
   [System.IO.Ports.SerialPort]::GetPortNames()
   Get-WmiObject Win32_PnPEntity | Where-Object { $_.Name -match 'COM\d' } | Select-Object Name, DeviceID

2. USB 장치 목록
   Get-PnpDevice -Status OK | Where-Object { $_.Class -eq 'Ports' -or $_.Class -eq 'USB' } | Select-Object FriendlyName, Status, InstanceId

3. 네트워크 연결 확인
   Get-NetTCPConnection -State Listen | Select-Object LocalPort, OwningProcess
   Get-NetAdapter | Where-Object { $_.Status -eq 'Up' } | Select-Object Name, InterfaceDescription, LinkSpeed

4. 결과를 테이블로 정리
```

#### Serial 통신 테스트
```
시리얼 포트로 장비와 통신 테스트하라.

포트: {COM포트}
보레이트: {보레이트, 기본 9600}
데이터비트: {8}
패리티: {None}
스톱비트: {One}
송신 명령: {명령어, 없으면 생략}

PowerShell로 실행:

$port = New-Object System.IO.Ports.SerialPort("{COM포트}", {보레이트}, [System.IO.Ports.Parity]::{패리티}, {데이터비트}, [System.IO.Ports.StopBits]::{스톱비트})
$port.ReadTimeout = 3000
$port.WriteTimeout = 3000
$port.Open()

# 포트 상태 확인
"포트 열림: $($port.IsOpen)"

# 명령 송신 (있으면)
$port.WriteLine("{명령어}")

# 응답 수신
Start-Sleep -Milliseconds 500
$response = $port.ReadExisting()
"응답: $response"

# HEX로도 표시
$bytes = [System.Text.Encoding]::ASCII.GetBytes($response)
"HEX: $(($bytes | ForEach-Object { $_.ToString('X2') }) -join ' ')"

$port.Close()
```

#### Ethernet(TCP) 통신 테스트
```
TCP로 장비와 통신 테스트하라.

IP: {IP주소}
Port: {포트번호}
송신 데이터: {데이터, 없으면 연결 확인만}

PowerShell로 실행:

# Ping 먼저
Test-Connection -ComputerName "{IP주소}" -Count 2

# TCP 연결
$client = New-Object System.Net.Sockets.TcpClient
$client.ReceiveTimeout = 3000
$client.SendTimeout = 3000

try {
    $client.Connect("{IP주소}", {포트번호})
    "연결 성공: $($client.Connected)"

    $stream = $client.GetStream()

    # 데이터 송신 (있으면)
    $sendBytes = [System.Text.Encoding]::ASCII.GetBytes("{데이터}")
    $stream.Write($sendBytes, 0, $sendBytes.Length)

    # 응답 수신
    Start-Sleep -Milliseconds 500
    $buffer = New-Object byte[] 4096
    $count = $stream.Read($buffer, 0, $buffer.Length)
    $response = [System.Text.Encoding]::ASCII.GetString($buffer, 0, $count)
    "응답: $response"
    "HEX: $(($buffer[0..($count-1)] | ForEach-Object { $_.ToString('X2') }) -join ' ')"
} catch {
    "연결 실패: $_"
} finally {
    $client.Close()
}
```

#### Modbus TCP 읽기
```
Modbus TCP로 PLC 레지스터를 읽어라.

IP: {IP주소}
Port: {포트, 기본 502}
슬레이브 ID: {ID, 기본 1}
시작 주소: {주소}
읽기 개수: {개수}
펑션코드: {03=Holding Register, 04=Input Register, 01=Coil, 02=Discrete Input}

PowerShell로 Modbus TCP 프레임 직접 구성:

$client = New-Object System.Net.Sockets.TcpClient("{IP주소}", {포트})
$stream = $client.GetStream()

# Modbus TCP 프레임 구성
$transId = [byte[]](0x00, 0x01)        # 트랜잭션 ID
$protocolId = [byte[]](0x00, 0x00)     # 프로토콜 ID
$unitId = [byte]{슬레이브ID}            # 유닛 ID
$funcCode = [byte]{펑션코드}            # 펑션 코드
$startAddr = [BitConverter]::GetBytes([uint16]{시작주소}); [Array]::Reverse($startAddr)
$quantity = [BitConverter]::GetBytes([uint16]{읽기개수}); [Array]::Reverse($quantity)

$pdu = @($unitId, $funcCode) + $startAddr + $quantity
$length = [BitConverter]::GetBytes([uint16]$pdu.Length); [Array]::Reverse($length)
$frame = $transId + $protocolId + $length + $pdu

$stream.Write($frame, 0, $frame.Length)

# 응답 수신
Start-Sleep -Milliseconds 500
$buffer = New-Object byte[] 256
$count = $stream.Read($buffer, 0, $buffer.Length)

# 응답 파싱
"응답 HEX: $(($buffer[0..($count-1)] | ForEach-Object { $_.ToString('X2') }) -join ' ')"
# 데이터 영역 추출 (9바이트부터)
$dataBytes = $buffer[9..($count-1)]
for ($i = 0; $i -lt $dataBytes.Length; $i += 2) {
    $value = [BitConverter]::ToUInt16(@($dataBytes[$i+1], $dataBytes[$i]), 0)
    "주소 $({시작주소} + $i/2): $value (0x$($value.ToString('X4')))"
}

$client.Close()
```

### 출력 포맷
```markdown
# 장비 연결 결과
확인일: YYYY-MM-DD HH:mm

## 연결 정보
- 인터페이스: Serial / TCP / USB
- 대상: {COM포트 또는 IP:Port}
- 상태: 연결 성공 / 실패

## 포트/장비 스캔
| # | 포트/장비 | 상태 | 설명 |
|---|----------|------|------|

## 통신 결과
- 송신(TX): {명령어} / HEX: {hex}
- 수신(RX): {응답} / HEX: {hex}
- 응답시간: {ms}

## 데이터 해석
| 주소 | 값(DEC) | 값(HEX) | 설명 |
|------|---------|---------|------|
```

### 규칙
- 포트 열기 전 반드시 현재 포트 목록 확인
- 타임아웃 기본 3초 설정
- 통신 후 반드시 포트/소켓 Close
- TX/RX 데이터는 ASCII + HEX 둘 다 표시
- 응답 없으면 타임아웃 사실 보고 (추측 금지)
- 장비 IP/포트/보레이트 등 정보 부족 시 반드시 질문 먼저
- Modbus 응답은 주소별 값 테이블로 정리
- 연결 실패 시 가능한 원인 목록 제시 (케이블, 드라이버, 방화벽 등)

---

## 10. web-searcher (웹 검색/조사)

**대응 스킬**: 없음 (에이전트 전용)
**트리거 조건**: 기술 자료 검색, API/라이브러리 문서 조회, 에러 메시지 검색, 부품/장비 스펙 조회, 프로토콜 문서 확인
**서브에이전트 타입**: `general-purpose`

### 용도
| 검색 대상 | 예시 |
|-----------|------|
| 에러 해결 | "CS0123 에러 뭔지", 스택오버플로우 답변 |
| 라이브러리/NuGet | 패키지 사용법, 버전 호환성 |
| 장비/부품 스펙 | 데이터시트, 매뉴얼, 통신 프로토콜 문서 |
| PLC/HMI | Mitsubishi, Siemens, LS 등 PLC 매뉴얼/주소맵 |
| API 문서 | .NET, WinForms, WPF, SerialPort 등 MS 공식 문서 |
| 일반 기술 | 알고리즘, 패턴, 구현 방법 |

### 프롬프트 템플릿
```
웹에서 정보를 검색하여 정리하라.

검색 주제: {검색 내용}
목적: {왜 필요한지}

절차:
1. WebSearch로 관련 자료 검색
   - 키워드 조합하여 2~3회 검색
   - 영문/한글 모두 시도

2. WebFetch로 유용한 페이지 상세 확인
   - 공식 문서 우선
   - 스택오버플로우, GitHub 이슈 등 참고

3. 결과 정리
   - 핵심 내용만 요약
   - 코드 예제 있으면 포함
   - 출처 URL 명시
```

### 출력 포맷
```markdown
# 검색 결과: {주제}
검색일: YYYY-MM-DD HH:mm

## 요약
{핵심 답변 1~3줄}

## 상세 내용
{검색 결과 정리}

## 코드 예제 (해당 시)
{코드}

## 출처
- [제목](URL)
- [제목](URL)
```

### 규칙
- 공식 문서 > 블로그 > 포럼 순으로 신뢰도 우선
- 검색 결과는 요약만, 전체 복붙 금지
- 출처 URL 반드시 포함
- 오래된 자료(3년+)는 주의 표시
- 검색 실패 시 키워드 바꿔서 재시도

---

## 11. git-manager (Git 리포지토리 관리)

**대응 스킬**: 없음 (에이전트 전용)
**트리거 조건**: Git 리포 검색/클론/커밋/푸쉬 요청, GitHub 리포지토리 조회, 코드 가져오기
**서브에이전트 타입**: `Bash`

### 사전 조건
- GitHub CLI 인증: `gh auth switch --user ryudae33`
- 기본 조직: `ftech-projects`
- Email: `ryudae33@ftechq.com`

### 프롬프트 템플릿

#### 리포지토리 검색
```
GitHub에서 리포지토리를 검색하라.

사전작업:
gh auth switch --user ryudae33

검색:
1. 조직 내 검색
   gh repo list ftech-projects --limit 100
   gh repo list ftech-projects -q "{검색어}"

2. 특정 리포 정보 확인
   gh repo view ftech-projects/{리포명}

3. 리포 내 파일 검색
   gh api repos/ftech-projects/{리포명}/git/trees/main?recursive=1 | jq '.tree[].path'

4. 최근 커밋 확인
   gh api repos/ftech-projects/{리포명}/commits --jq '.[0:5] | .[] | .commit.message'
```

#### 클론
```
GitHub 리포지토리를 클론하라.

사전작업:
gh auth switch --user ryudae33

클론:
gh repo clone ftech-projects/{리포명} {로컬경로}

클론 후:
1. cd {로컬경로}
2. git log --oneline -5
3. git branch -a
```

#### 커밋 & 푸쉬
```
변경사항을 커밋하고 푸쉬하라.

경로: {프로젝트 경로}

절차:
1. 상태 확인
   git -C {경로} status
   git -C {경로} diff --stat

2. 스테이징
   git -C {경로} add {대상 파일들}

3. 커밋
   git -C {경로} commit -m "{커밋 메시지}"

4. 푸쉬 (사용자 확인 후)
   git -C {경로} push origin {브랜치}

규칙:
- 푸쉬 전 반드시 사용자 확인
- force push 금지
- .env, credentials 등 민감 파일 제외
- 커밋 메시지는 한글 허용
```

#### 새 리포 생성
```
GitHub에 새 리포지토리를 생성하라.

사전작업:
gh auth switch --user ryudae33

생성:
gh repo create ftech-projects/{리포명} --private --clone

초기 설정:
git config user.email "ryudae33@ftechq.com"
```

### 규칙
- 항상 `gh auth switch --user ryudae33` 먼저 실행
- 리포 생성은 기본 `ftech-projects/` 조직 아래
- 기본 private 리포
- push/force push/삭제 등 위험 작업은 반드시 사용자 확인
- 브랜치 삭제, reset --hard 등 파괴적 작업 금지

---

## 에이전트 호출 규칙

1. **자동 판단 호출**: 작업 맥락상 필요하면 사용자 지시 없이도 호출
2. **병렬 호출 가능**: 독립적인 에이전트는 동시 실행
3. **결과 저장**: 분석 결과는 프로젝트 폴더에 `.md`로 저장
4. **스킬과 연계**: 사용자가 `/스킬` 호출 시 해당 에이전트를 Task로 실행
