# Google Drive 동기화

## gdrive-sync (`~/bin/gdrive-sync.sh`)
Git 리포의 gitignore된 문서/DB → Google Drive `G:\공유 드라이브\daehyun tmp\github-ignore` 동기화
- 로컬 마운트 경로: `/g/공유 드라이브/daehyun tmp/github-ignore/리포명/`
- `gdrive-sync push` — gitignore된 문서/DB → `github-ignore/리포명/`
- `gdrive-sync pull` — Google Drive → 로컬 (클론 후 실행)
- `gdrive-sync status` — 백업 파일 목록

### 백업 대상 확장자
pdf, docx, doc, xlsx, xls, pptx, ppt, hwp, hwpx, db, sqlite, sqlite3, mdb, accdb, csv, json, yaml, yml, ini, cfg, conf, bak

### git push 후 워크플로
```bash
git push && gdrive-sync push
```

## claude-config-sync (`~/bin/claude-config-sync.sh`)
- `claude-config-sync push` — 설정+스크립트+dotfiles → Google Drive 백업
- `claude-config-sync pull` — Google Drive → 로컬 복원
