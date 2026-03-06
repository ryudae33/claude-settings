# DB 조회 도구

## SQL Server
- **sqlcmd** → `sqlcmd` (PATH 등록됨)
  - `sqlcmd -S 서버명 -d DB명 -Q "SELECT TOP 10 * FROM 테이블"`
  - `sqlcmd -S localhost -E` — Windows 인증
  - `sqlcmd -S 서버 -U sa -P 비번 -d DB -Q "쿼리"`

## SQLite
- **sqlite3** → `sqlite3` (PATH 등록됨)
  - `sqlite3 파일.db` — 인터랙티브
  - `sqlite3 파일.db "SELECT * FROM 테이블;"` — 직접 쿼리
  - `sqlite3 파일.db ".tables"` — 테이블 목록
  - `sqlite3 파일.db ".schema 테이블"` — 스키마

## Access (.mdb/.accdb)
- **PowerShell + OleDb** (Access Database Engine 2016 설치됨)
```powershell
$conn = New-Object System.Data.OleDb.OleDbConnection
$conn.ConnectionString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=파일경로;"
$conn.Open()
$cmd = $conn.CreateCommand()
$cmd.CommandText = "SELECT * FROM 테이블"
$reader = $cmd.ExecuteReader()
while ($reader.Read()) { Write-Host $reader[0] }
$conn.Close()
```
