# DB Query Tools

## SQL Server
- **sqlcmd** → `sqlcmd` (in PATH)
  - `sqlcmd -S server -d dbname -Q "SELECT TOP 10 * FROM table"`
  - `sqlcmd -S localhost -E` — Windows auth
  - `sqlcmd -S server -U sa -P password -d db -Q "query"`

## SQLite
- **sqlite3** → `sqlite3` (in PATH)
  - `sqlite3 file.db` — interactive
  - `sqlite3 file.db "SELECT * FROM table;"` — direct query
  - `sqlite3 file.db ".tables"` — table list
  - `sqlite3 file.db ".schema table"` — schema

## Access (.mdb/.accdb)
- **PowerShell + OleDb** (Access Database Engine 2016 installed)
```powershell
$conn = New-Object System.Data.OleDb.OleDbConnection
$conn.ConnectionString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=filepath;"
$conn.Open()
$cmd = $conn.CreateCommand()
$cmd.CommandText = "SELECT * FROM tablename"
$reader = $cmd.ExecuteReader()
while ($reader.Read()) { Write-Host $reader[0] }
$conn.Close()
```
