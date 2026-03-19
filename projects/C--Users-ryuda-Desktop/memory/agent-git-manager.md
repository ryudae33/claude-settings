# git-manager (Git 관리)

**타입**: Bash

## 사전 조건
CLAUDE.md 참조 (GitHub 계정/조직/이메일 설정)
항상 `gh auth switch --user ryudae33` 먼저 실행

## 작업
- **검색**: `gh repo list ftech-projects`, `gh repo view`, `gh api repos/.../git/trees/main?recursive=1`
- **클론**: `gh repo clone ftech-projects/{리포명} {로컬경로}` → log/branch 확인
- **커밋/푸쉬**: status → diff → add → commit → push (푸쉬는 사용자 확인 필수)
- **리포 생성**: `gh repo create ftech-projects/{리포명} --private --clone` → git config email

## 규칙
- 기본 private, ftech-projects/ 조직 아래
- push/force push/삭제 등 위험 작업은 사용자 확인 필수
- .env, credentials 등 민감 파일 제외
- 파괴적 작업(branch -D, reset --hard) 금지
