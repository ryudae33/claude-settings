# 메모리

## 에이전트 시스템

### Task 서브에이전트 (시스템 내장)
| 에이전트 | 모델 | 용도 |
|---------|------|------|
| ls-plc-st | **sonnet** | LS PLC XG5000 ST 작성 전문가 + 래더/IL → ST 변환 |
| ladder-to-st | **sonnet** | PLC 래더/IL → ST 변환 (범용: LS/미쓰비시/지멘스) |
| project-planner | **opus** | 신규 프로젝트 계획/설계 |
| project-analyzer | **sonnet** | 프로젝트 구조/통신/PLC/DB 분석 |
| vb-converter | **sonnet** | VB.NET → C# 변환 |
| ui-builder | **sonnet** | WinForms Designer.cs 생성 |
| db-explorer | **sonnet** | DB 탐색 (SQL Server/Access/SQLite/MySQL/PostgreSQL/dBASE/Excel) |
| doc-reader | **sonnet** | PDF/Excel/Word/CSV 등 문서 읽기/분석 |
| log-analyzer | **sonnet** | 로그 분석 (통신로그/앱로그/이벤트로그) |
| hw-connector | **sonnet** | 장비 연결/확인 (Serial/TCP/USB/Modbus) |
| build-runner | **sonnet** | dotnet build/publish, MSBuild, 빌드 에러 분석 |
| git-manager | **sonnet** | GitHub 리포 관리 (gh CLI) |
| screenshot-viewer | **sonnet** | 최신 스크린샷 확인/분석 |

### 사용자 스킬 (commands/*.md)
| 스킬 | 용도 |
|------|------|
| /analyze-project | 자동화 프로젝트 전체 분석 → .project-analysis.md |
| /vb-convert | VB.NET → C# .NET 9.0 변환 |
| /winforms-ui | WinForms Designer.cs UI 작성 |
| /sc | 최신 스크린샷 확인/분석 |
| /crash-log | crash.log 예외 분석 |
| /git-init | Git 초기화 + GitHub 리포 생성 |
| /cleanup | 빌드 산출물(bin/obj/.vs) 정리 |
| /search-files | Everything으로 드라이브 전체 파일 검색 |
| /compress | 7-Zip 압축/해제 |
| /convert-doc | LibreOffice 문서 변환 (→ PDF/xlsx/csv 등) |
| /pandoc | Pandoc 문서 변환 (Markdown↔Word/HTML/PDF) |
| /ffmpeg | FFmpeg 미디어 변환/편집 |
| /docker | Docker 컨테이너/이미지/Compose 관리 |
| /db | DB 탐색 (SQL Server/Access/SQLite 등) |
| /doc | 문서 읽기/분석 (PDF/Excel/Word/CSV) |
| /log | 로그 분석 (통신/앱/이벤트) |
| /git | Git 관리 (커밋/푸쉬/PR/이슈) |
| /gem | Gemini 코드 리뷰 |
| /plan | 프로젝트 계획/설계 |
| /build | dotnet build/publish + 에러 분석 |
| /hw | 장비 연결/통신 테스트 (Serial/TCP/Modbus) |
| /nuget | NuGet 패키지 검색/추가/업데이트 |
| /deploy | publish 결과물 배포 (네트워크/로컬 경로) |

## 설정 구조
- `~/.claude/CLAUDE.md` — 핵심 규칙
- `~/.claude/references/` — 도구 상세 참조 5개 (tools-cli/db/comm/sync/screenshot.md)
- 도구 버전/경로 등 상세는 references 파일에 위임

## 빌드 환경
- Android SDK 경로: `C:/android-sdk` (MSBuild 속성 `-p:AndroidSdkDirectory=C:/android-sdk` 필요)
- JDK: Microsoft OpenJDK 17 (winget으로 설치)
- MAUI workload: `dotnet workload install maui-android`
- OneDrive 한글 경로에서 aapt2 빌드 실패 가능 → 영문 경로로 복사 후 빌드

## 진행중 프로젝트
- **VISION FA 비전 검사 도구** — 상세: `vision-project.md`
  - 위치: `Desktop/VISION/`
  - 스킬: `/vision` (commands/vision.md)
  - 상태: Phase 1 완료 (카메라+웹), Phase 2 진행중 (inspect 엔진, 샘플 스크래치 검출 성공)
- **AVS 조립성 검증 시스템** — 상세: `avs-project.md`
  - 위치: `Desktop/Assemble Test/`
  - 상태: 계획서 완료, 디렉토리 생성 완료, conda 미설치 → Phase 1 시작 전
- **PLC2 XBC→XEC 변환** — 상세: `plc2-xbc-to-xec.md`
  - 위치: `Desktop/plc2/`
  - 상태: 17개 프로그램 변환 완료 → output_final/, MAIN_01 컴파일 검증 완료, 나머지 XG5000 테스트 대기

## 설치된 도구 버전 메모 (2026-02-19 ryuda PC)
- 7-Zip 26.00, Everything 1.4.1 + es.exe 1.1.0.27, rclone 1.73.1, LibreOffice 25.8.4
- SumatraPDF 3.5.2, PuTTY 0.83, nmap 7.80, WinSocat 0.1.3, Wireshark 4.6.3
- sqlite3 3.51.2, SSMS 20.2.1, Access Database Engine 2016
- Python 3.13.12 (pyserial 3.5, httpx 0.28.1, click 8.3.1), Node.js 24.13.1, .NET 10.0.103
- ffmpeg 8.0.1, jq 1.8.1, pandoc 3.9, pwsh 7.5.4, Docker Desktop 4.60.1
- D2Coding 폰트: Windows Terminal 기본 폰트
