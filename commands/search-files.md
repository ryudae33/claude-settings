# 파일 검색 에이전트

## Task 설정
- subagent_type: Bash
- model: haiku

## 역할
Everything (es.exe)으로 드라이브 전체에서 파일/폴더를 초고속 검색한다.

## 입력
$ARGUMENTS (검색어, 패턴, 경로 필터 등)

## 동작

### 1. 입력 파싱
- 인자가 없으면 검색어를 물어본다
- 패턴 예: `*.mdb`, `ProjectName *.sln`, `C:\Projects *.cs`

### 2. 검색 실행
```bash
# 기본 검색
es.exe 검색어

# 확장자 필터
es.exe ext:mdb

# 경로 + 파일명
es.exe "C:\Projects" *.sln

# 정규식
es.exe regex:project.*\.cs

# 크기 필터 (1MB 이상)
es.exe size:>1mb *.log

# 결과 수 제한
es.exe -n 20 *.log

# 크기/수정일 포함 출력
es.exe -size -dm *.mdb
```

### 3. 결과 보고
- 파일 목록 표시 (경로 포함)
- 개수 요약
- 필요시 파일 내용 추가 분석

## 규칙
- 결과 100개 초과시 필터 추가를 권고
- 한글로 응답
