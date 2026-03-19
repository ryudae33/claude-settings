# vb-converter (VB.NET → C# 변환)

**스킬**: `/vb-convert` | **타입**: general-purpose

## 프롬프트
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
- 원본 로직 최대한 보존, 과도한 리팩토링 금지
- 변환 불가 부분은 TODO 주석
```
