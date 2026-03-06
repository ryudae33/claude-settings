# Claude 설정 동기화 에이전트

## Task 설정
- subagent_type: git-manager
- model: haiku

## 역할
Claude Code 설정(스킬/에이전트/참조/메모리/dotfiles)을 GitHub에 백업하거나 복원한다.

## 입력
$ARGUMENTS (작업 유형)
- `backup` 또는 `push` — 로컬 → GitHub 백업
- `load` 또는 `pull` — GitHub → 로컬 복원
- `status` — 동기화 상태 확인

## 동작

### 백업 (push/backup)
```bash
bash ~/bin/claude-config-sync.sh push
```

### 복원 (load/pull)
```bash
bash ~/bin/claude-config-sync.sh pull
```

### 상태 확인
```bash
bash ~/bin/claude-config-sync.sh status
```

### 리포
`ryudae33/claude-settings` (private)

### 새 PC 초기 세팅 순서
1. Claude Code 설치 + gh CLI 인증
2. `gh repo clone ryudae33/claude-settings ~/claude-settings`
3. `bash ~/claude-settings/bin/claude-config-sync.sh pull`
4. 터미널 재시작
5. `mcp_servers.json`은 수동 설정 (토큰 포함이라 git 제외)

## 규칙
- 리포 없으면 자동 클론
- 변경 없으면 커밋 스킵
- mcp_servers.json은 gitignore (토큰 포함)
- 한글로 응답
