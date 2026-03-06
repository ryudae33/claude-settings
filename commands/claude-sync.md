# Claude 설정 동기화 에이전트

## Task 설정
- subagent_type: git-manager
- model: haiku

## 역할
Claude Code 설정(스킬/에이전트/참조/메모리/dotfiles)을 Google Drive에 백업하거나 복원한다.

## 입력
$ARGUMENTS (작업 유형)
- `backup` 또는 `push` — 로컬 → Google Drive 백업
- `load` 또는 `pull` — Google Drive → 로컬 복원
- `status` — 백업 현황 확인

## 동작

### 백업 (push/backup)
```bash
claude-config-sync push
```

### 복원 (load/pull)
```bash
claude-config-sync pull
```

### 상태 확인
```bash
claude-config-sync status
```

### 백업 대상
| 대상 | 내용 |
|------|------|
| `CLAUDE.md`, `settings.json` 등 | 핵심 설정 파일 |
| `commands/` | 사용자 스킬 (*.md) |
| `agents/` | 에이전트 정의 (*.md) |
| `references/` | 참조 문서 (*.md) |
| `memory/` | 자동 메모리 (MEMORY.md) |
| `bin/` | ~/bin 스크립트 |
| `dotfiles/` | .bashrc, .gitconfig 등 |
| `*.bat`, `*.vbs` | 런처 파일 |

### 백업 경로
`G:/공유 드라이브/daehyun tmp/claude-settings/`

### 새 PC 초기 세팅 순서
1. Claude Code 설치
2. Google Drive for Desktop 설치 → G: 드라이브 마운트
3. `/claude-sync load` 실행
4. 터미널 재시작

## 규칙
- Google Drive (G:) 마운트 확인 후 진행
- 복원 시 기존 로컬 파일보다 새로운 파일만 덮어쓰기 (cp -u)
- 한글로 응답
