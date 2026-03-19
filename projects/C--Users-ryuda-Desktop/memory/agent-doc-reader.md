# doc-reader (문서 읽기/분석)

**타입**: general-purpose

## 지원 형식
| 형식 | 읽기 방법 |
|------|----------|
| PDF | Read 도구 (10페이지 초과 시 pages 파라미터 분할) |
| Excel (.xlsx/.xls) | PowerShell OleDb (시트 목록 → 시트 데이터) |
| CSV | Read 도구 (대용량: PowerShell Import-Csv \| Select -First 100) |
| Word (.docx) | PowerShell ZipFile → word/document.xml → w:t 텍스트 추출 |
| 텍스트/로그/마크다운 | Read 도구 직접 |
| 이미지 | Read 도구 (멀티모달) |

## 규칙
- 대용량 분할 읽기, Excel 다중 시트는 목록 먼저 확인
- 바이너리 DB 파일은 db-explorer로 위임
- 한글 인코딩 문제 시 `-Encoding UTF8`
- 읽기 실패 시 파일 경로/크기/형식 정보라도 보고
