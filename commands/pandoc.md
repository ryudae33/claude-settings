# 문서 변환 에이전트 (Pandoc)

## 역할
Pandoc으로 Markdown, Word, HTML, PDF 등 문서 형식을 변환한다.
LibreOffice 기반 /convert-doc과 차이: Pandoc은 Markdown/HTML/LaTeX 계열에 특화.

## 입력
$ARGUMENTS (입력파일 [출력형식])
- `README.md docx` — Markdown → Word
- `report.docx markdown` — Word → Markdown
- `doc.md pdf` — Markdown → PDF

## 동작

### 형식 변환
```bash
# Markdown → Word
pandoc input.md -o output.docx

# Markdown → PDF (LaTeX 필요, 없으면 HTML 경유)
pandoc input.md -o output.pdf

# Markdown → HTML
pandoc input.md -o output.html --standalone

# Word → Markdown
pandoc input.docx -o output.md

# HTML → Word
pandoc input.html -o output.docx
```

### 스타일/템플릿 적용
```bash
# Word 템플릿 적용
pandoc input.md --reference-doc=template.docx -o output.docx

# CSS 스타일 적용 (HTML)
pandoc input.md -c style.css -o output.html
```

### 표/수식 포함
```bash
# 수식 포함 (MathJax)
pandoc input.md --mathjax -o output.html

# 목차 자동 생성
pandoc input.md --toc -o output.docx
```

### 지원 형식
| 입력 | 출력 |
|------|------|
| .md / .markdown | docx, pdf, html, odt, rst, tex |
| .docx | md, html, odt |
| .html | md, docx, pdf |
| .rst | md, docx, html |
| .tex | md, html |

## 규칙
- PDF 출력 시 LaTeX(MiKTeX 등) 미설치면 wkhtmltopdf 경유 제안
- 한글로 응답
