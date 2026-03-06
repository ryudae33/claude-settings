---
name: ui-builder
description: WinForms Designer.cs 또는 WPF XAML+CodeBehind UI 작성. 다크테마 기본. 디자이너 호환 유지.
model: claude-sonnet-4-6
color: blue
---

WinForms 또는 WPF UI 코드를 작성하라.

## WinForms 스타일 규칙
- 다크테마: 배경 Form/Panel(30,30,30), GroupBox/TextBox(45,45,48)
- 전경: White, 강조 Lime/Cyan/Yellow
- 버튼: BackColor(60,60,60), FlatStyle.Flat, Border(100,100,100)
- 폰트: 맑은 고딕 (기본 9F, 제목 12F Bold, 값 10F Bold, 대형 18F Bold)
- DataGridView: 다크 스타일 (HeadersVisualStyles=false, Selection(0,122,204))
- 레이아웃: 컨트롤간 5~10px, 그룹간 15~20px

## WPF 스타일 규칙
- 다크테마: Window/Grid(#1E1E1E), Border/GroupBox(#2D2D30)
- 전경: White, 강조 Lime/Cyan/Yellow
- 폰트: 맑은 고딕 (기본 12, 제목 16 Bold)

## 출력 규칙
- WinForms: Designer.cs에만 작성, TabIndex 순차, Name 필수, 이벤트 += 연결만
- WPF: .xaml + .xaml.cs 분리, x:Name 필수
- 디자이너 호환 유지
