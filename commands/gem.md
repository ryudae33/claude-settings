# Gemini 코드 리뷰어

## 역할
현재 대화에서 작업한 파일들을 Gemini에게 보내 리뷰 받고, 사용자 승인 후 피드백을 반영한다.
WezTerm 창을 띄워서 Gemini 리뷰 결과를 보여주고, 승인 후 창을 닫는다.

## 실행 순서

### 1단계: 리뷰 대상 파악
- 현재 대화 컨텍스트에서 최근 Read/Edit/Write한 파일 목록 파악
- 파일이 없으면 "리뷰할 파일을 알려주세요" 안내 후 중단
- 사용자가 특정 파일을 지정했으면 그 파일 우선

### 2단계: 리뷰 요청 파일 작성
`C:/tmp/gem_request.txt` 에 다음 내용으로 작성:
```
아래 코드를 리뷰해줘. 한글로 답해줘.

리뷰 포인트:
- 버그 또는 잠재적 오류
- 개선 가능한 코드 품질/가독성
- 성능 문제
- 보안 취약점

[파일명: 실제파일명]
[파일 전체 내용]
```
파일이 여러 개면 모두 포함. `C:/tmp/` 폴더 없으면 먼저 생성.

### 3단계: Gemini headless 실행
실행 전에 "Gemini 리뷰 요청 중..." 안내.
파일 내용을 직접 인라인으로 전달 (`@파일경로` 방식은 워크스페이스 제한으로 사용 불가):
```bash
gemini -m gemini-2.5-flash -p "$(cat C:/tmp/gem_request.txt)" > C:/tmp/gem_output.txt 2>&1
```

### 4단계: WezTerm 창으로 결과 표시
Bash 도구로 WezTerm 새 창 열기:
```bash
taskkill /IM notepad.exe /F 2>/dev/null; start "" notepad "C:/tmp/gem_output.txt"
```

### 5단계: 피드백 보고 + 승인 요청
- `C:/tmp/gem_output.txt` 읽어서 핵심 피드백 요약 후 사용자에게 보고
- AskUserQuestion으로 승인 여부 확인:
  - "승인" — 피드백 반영해서 파일 수정
  - "거부" — 수정 없이 종료

### 6단계: 피드백 반영 (승인 시)
- Gemini 피드백 내용에 따라 Edit 도구로 파일 수정
- 수정 완료 후 변경 내역 요약 보고

### 7단계: WezTerm 창
사용자가 직접 닫는다. 별도 처리 없음.

## 규칙
- 임시 파일: `C:/tmp/gem_request.txt`, `C:/tmp/gem_output.txt`
- 한글로 응답
- **승인 전까지 파일 수정 절대 금지**
- gemini 실행 실패 시 에러 내용 보여주고 중단
- 피드백은 핵심 항목만 번호 매겨서 요약 (원문 전체 표시 금지)
