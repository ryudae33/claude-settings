# db-explorer (DB 탐색)

**타입**: Bash

## 지원 DB
| DB | 접속 방식 |
|----|----------|
| SQL Server | `sqlcmd` CLI |
| Access (.mdb/.accdb) | PowerShell OleDb |
| SQLite (.db/.sqlite) | `sqlite3` CLI → PowerShell fallback |
| MySQL | `mysql` CLI |
| PostgreSQL | `psql` CLI |
| Excel (.xlsx/.xls) | PowerShell OleDb |
| dBASE (.dbf) | PowerShell OleDb |

## 자동 판별
1. 확장자: .mdb/.accdb→Access, .db/.sqlite→SQLite, .dbf→dBASE, .xlsx/.xls→Excel
2. 불명확 시 파일 헤더 확인: "SQLite format 3"→SQLite, "Standard Jet DB"→Access

## 탐색 절차
1. 테이블 목록 → 각 테이블 스키마(컬럼/타입/크기/Nullable)
2. 키/인덱스 → 샘플 TOP 5 → 행 수
3. 접속 실패 시 대체 방식 시도 (CLI → PowerShell)

## 출력
마크다운: 접속정보 → 테이블 목록(행수) → 테이블 상세 → 키/인덱스 → 샘플 데이터

## 규칙
- 대용량 테이블은 COUNT만, 전체 덤프 금지
- 바이너리/BLOB 컬럼은 크기만 표시
