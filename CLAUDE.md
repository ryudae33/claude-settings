# 글로벌 규칙

## Git
- Email: ryudae33@gmail.com / GitHub: ryudae33 (작업 전 `gh auth switch --user ryudae33`)
- 조직: ftech-projects (리포 기본 `ftech-projects/` 아래)
- **git push 후 반드시 `gdrive-sync push` 실행** — gitignore된 문서/DB 파일을 `G:\공유 드라이브\daehyun tmp\github-ignore\리포명\` 에 백업
- **git clone 후 반드시 `gdrive-sync pull` 실행** — Google Drive `github-ignore\리포명\`에서 gitignore된 문서/DB 파일 복원
- **수동 rclone 금지** — 반드시 `gdrive-sync` 스크립트 사용. 한글 경로 문제 시 스크립트 수정으로 대응
- **빌드 publish 결과물**: git 관리 대상 아님. 배포 전 수동 `gdrive-sync push`로 백업 여부는 프로젝트별 판단 (build-runner는 자동 동기화 안 함)

## 응답
- 한글 응답, 코드 주석도 한글. 짧고 핵심만, 아부/수다 금지
- 코드 수정 전 방안 제시 후 확인. 스펙 불명확 시 질문 먼저

## 코딩
- PascalCase(클래스/메서드), camelCase(변수), ALL_CAPS(상수)
- 레거시 WinForms: 대규모 구조 변경 금지, 기존 패턴 우선. 폼은 디자이너 호환 유지
- HW/프로토콜 정보 부족 시 질문 먼저

## 신규 프로젝트 필수
- **전역 예외 핸들러**: `ThreadException`+`UnhandledException` → crash.log (시간/소스/메시지/스택). 쓰레드/타이머 try-catch 필수
- **ScottPlot 한글**: `ScottPlot.Fonts.Default = "Malgun Gothic";` OnStartup에서 전역 설정

## 오케스트레이션
- 복잡한 작업(분석/빌드/DB/통신/문서 등)은 전문 서브에이전트에 위임
- 판단 기준: 단일 도메인 집중 작업이거나 병렬 처리가 유리하면 Task 도구 사용
- 주요 에이전트: project-analyzer, build-runner, db-explorer, log-analyzer, hw-connector, doc-reader, web-searcher, git-manager
- 단순 질문/단일 파일 수정은 직접 처리 (에이전트 남용 금지)
- **web-searcher 호출 금지 케이스**: PLC/로봇/자동화 일반 지식, 표준 프로토콜(Modbus/EtherNet IP/TMSVR 등), C#/.NET API, 알고 있는 하드웨어 스펙 → 직접 답변
- **web-searcher 호출 허용**: 특정 모델 최신 펌웨어/매뉴얼 URL, 단종 여부, 가격/납기 확인 등 실시간 정보만
- web-searcher 최대 **2회** 호출 후 결과 없으면 "확인 불가" 보고
## 작업 기록
- 시작 시 해당 폴더 CLAUDE.md 확인, 완료 시 시간+내역 기록 (`powershell Get-Date`, UTC 금지)

## 도구 참조
CLI/DB/통신/동기화 도구 상세는 `~/.claude/references/` 참조:
- `tools-cli.md` — 7-Zip, Everything, rclone, LibreOffice, SumatraPDF, WSL
- `tools-db.md` — SQL Server(sqlcmd), SQLite(sqlite3), Access(OleDb)
- `tools-comm.md` — 시리얼(miniterm/plink), TCP(ncat), winsocat, tshark
- `tools-sync.md` — gdrive-sync, claude-config-sync 사용법
- `tools-screenshot.md` — PowerShell 스크린샷 캡처 코드
