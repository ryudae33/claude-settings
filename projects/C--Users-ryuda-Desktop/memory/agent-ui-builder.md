# ui-builder (WinForms / WPF UI 작성)

**스킬**: `/winforms-ui` | **타입**: general-purpose

## WinForms 프롬프트
```
WinForms Designer.cs 코드를 작성하라.
요구사항: {UI 설명}

다크테마:
- 배경: Form/Panel(30,30,30), GroupBox/TextBox(45,45,48)
- 전경: White, 강조 Lime/Cyan/Yellow
- 버튼: BackColor(60,60,60), FlatStyle.Flat, Border(100,100,100)
- 폰트: 맑은 고딕 (기본 9F, 제목 12F Bold, 값 10F Bold, 대형 18F Bold)
- DataGridView: HeadersVisualStyles=false, Selection(0,122,204)
- 레이아웃: 컨트롤간 5~10px, 그룹간 15~20px

규칙: Designer.cs에만 작성, TabIndex 순차, Name 필수, 이벤트 += 연결만
```

## WPF 프롬프트
```
WPF XAML + CodeBehind를 작성하라.
요구사항: {UI 설명}

다크테마:
- 배경: Window/Grid(#1E1E1E), Border/GroupBox(#2D2D30)
- 전경: White, 강조 Lime/Cyan/Yellow
- 버튼: Background(#3C3C3C), BorderBrush(#646464)
- 폰트: 맑은 고딕 (기본 12, 제목 16 Bold, 값 14 Bold, 대형 24 Bold)
- DataGrid: RowBackground=#2D2D30, AlternatingRowBackground=#333337
- 레이아웃: Grid/StackPanel/DockPanel, Margin 5~10

규칙: XAML + CodeBehind 분리, x:Name 필수, MVVM 시 ViewModel 포함
```
