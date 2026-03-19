# 메모리

## 에이전트 시스템
- 에이전트 프로필 파일: `memory/agents.md`
- 11개 에이전트 정의됨:
  1. **project-analyzer** → 프로젝트 구조/통신/PLC/DB 분석 (스킬 `/analyze-project` 대응)
  2. **vb-converter** → VB.NET → C# 변환 (스킬 `/vb-convert` 대응)
  3. **ui-builder** → WinForms Designer.cs 생성 (스킬 `/winforms-ui` 대응)
  4. **db-explorer** → 모든 DB 탐색 (SQL Server/Access/SQLite/MySQL/PostgreSQL/dBASE/Excel)
  5. **project-planner** → 신규 프로젝트 계획/설계 (Plan 에이전트)
  6. **screenshot-viewer** → 최신 스크린샷 확인/분석 (스킬 `/sc` 대응)
  7. **doc-reader** → PDF/Excel/Word/CSV 등 문서 파일 읽기/분석
  8. **log-analyzer** → 로그 파일 분석 (crash.log/통신로그/앱로그/이벤트로그)
  9. **hw-connector** → 장비 직접 연결/확인 (Serial/TCP/USB/Modbus, PowerShell 통신)
  10. **web-searcher** → 웹 검색/기술자료 조사 (WebSearch/WebFetch)
  11. **git-manager** → GitHub 리포 검색/클론/커밋/푸쉬/생성 (gh CLI, Bash 에이전트)
- 작업 맥락상 필요하면 자동 판단하여 Task 서브에이전트로 호출
- 스킬 호출 시에도 해당 에이전트를 Task로 실행 가능
