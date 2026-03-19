# 에이전트 인덱스

| 에이전트 | 파일 | 타입 | 트리거 |
|---------|------|------|--------|
| project-analyzer | `agent-project-analyzer.md` | general-purpose | 새 프로젝트 분석, `.project-analysis.md` 없을 때 |
| vb-converter | `agent-vb-converter.md` | general-purpose | .vb → .cs 변환 요청 |
| ui-builder | `agent-ui-builder.md` | general-purpose | WinForms/WPF UI 생성/수정 |
| db-explorer | `agent-db-explorer.md` | Bash | DB 구조 파악, 테이블/데이터 조회 |
| project-planner | `agent-project-planner.md` | Plan | 새 프로젝트 생성/설계 |
| screenshot-viewer | `agent-screenshot-viewer.md` | general-purpose | "sc" 입력, 스크린샷 확인 |
| doc-reader | `agent-doc-reader.md` | general-purpose | 문서 파일 읽기/분석 |
| log-analyzer | `agent-log-analyzer.md` | general-purpose | crash.log/에러로그 분석 |
| hw-connector | `agent-hw-connector.md` | Bash | 장비 통신 테스트, 포트 확인 |
| web-searcher | `agent-web-searcher.md` | general-purpose | 기술 자료/에러 검색 |
| git-manager | `agent-git-manager.md` | Bash | GitHub 리포 검색/클론/커밋/푸쉬 |

## 호출 규칙
1. 맥락상 필요 시 사용자 지시 없이도 자동 호출
2. 독립적인 에이전트는 병렬 실행
3. 분석 결과는 프로젝트 폴더에 `.md`로 저장
4. `/스킬` 호출 시 해당 에이전트를 Task로 실행
