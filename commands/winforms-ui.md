# WinForms UI 작성 에이전트

## Task 설정
- subagent_type: ui-builder
- model: sonnet

## 역할
WinForms Designer.cs 코드 작성 및 UI 레이아웃 구성

## 입력
$ARGUMENTS

## 기능

### 1. 컨트롤 배치
**레이아웃 계산:**
- X, Y 좌표 자동 계산
- 컨트롤 간 간격: 5~10px
- 그룹 간 간격: 15~20px
- 라벨-입력 쌍: 라벨 우측 정렬, 입력 좌측 정렬

**일반 크기:**
```
Button: 100x30 (기본), 80x30 (소형)
TextBox: 150x23 (기본), 100x23 (소형)
Label: AutoSize 또는 고정폭
ComboBox: 150x23
CheckBox: AutoSize
DataGridView: 부모에 맞춤
GroupBox: 내부 컨트롤 + 여백 20px
```

### 2. 다크테마 스타일
**색상:**
```csharp
// 배경
Form/Panel: Color.FromArgb(30, 30, 30)
GroupBox: Color.FromArgb(45, 45, 48)
TextBox/ComboBox: Color.FromArgb(45, 45, 48)

// 전경
Label/Text: Color.White
강조: Color.Lime, Color.Cyan, Color.Yellow

// 버튼
BackColor: Color.FromArgb(60, 60, 60)
ForeColor: Color.White
FlatStyle: Flat
FlatAppearance.BorderColor: Color.FromArgb(100, 100, 100)
```

**DataGridView 다크:**
```csharp
EnableHeadersVisualStyles = false
ColumnHeadersDefaultCellStyle.BackColor = Color.FromArgb(30, 30, 30)
ColumnHeadersDefaultCellStyle.ForeColor = Color.White
DefaultCellStyle.BackColor = Color.FromArgb(45, 45, 48)
DefaultCellStyle.ForeColor = Color.White
DefaultCellStyle.SelectionBackColor = Color.FromArgb(0, 122, 204)
AlternatingRowsDefaultCellStyle.BackColor = Color.FromArgb(55, 55, 58)
GridColor = Color.FromArgb(60, 60, 60)
```

### 3. 폰트
```csharp
기본: new Font("맑은 고딕", 9F)
제목: new Font("맑은 고딕", 12F, FontStyle.Bold)
값표시: new Font("맑은 고딕", 10F, FontStyle.Bold)
대형표시: new Font("맑은 고딕", 18F, FontStyle.Bold)
```

### 4. VB Designer 변환
**VB → C# 매핑:**
```
Me.Button1.Location = New System.Drawing.Point(12, 12)
→ Button1.Location = new Point(12, 12);

Me.Button1.Size = New System.Drawing.Size(100, 30)
→ Button1.Size = new Size(100, 30);

Me.Controls.Add(Me.Button1)
→ Controls.Add(Button1);
```

### 5. 출력 형식

```csharp
// 컨트롤 선언
private Label lblTitle;
private TextBox txtValue;
private Button btnSave;

private void InitializeComponent()
{
    // 컨트롤 생성
    lblTitle = new Label();
    txtValue = new TextBox();
    btnSave = new Button();
    SuspendLayout();

    // lblTitle
    lblTitle.AutoSize = true;
    lblTitle.Font = new Font("맑은 고딕", 12F, FontStyle.Bold);
    lblTitle.ForeColor = Color.White;
    lblTitle.Location = new Point(12, 12);
    lblTitle.Name = "lblTitle";
    lblTitle.Text = "제목";

    // txtValue
    txtValue.BackColor = Color.FromArgb(45, 45, 48);
    txtValue.BorderStyle = BorderStyle.FixedSingle;
    txtValue.Font = new Font("맑은 고딕", 10F);
    txtValue.ForeColor = Color.White;
    txtValue.Location = new Point(12, 40);
    txtValue.Name = "txtValue";
    txtValue.Size = new Size(150, 23);

    // btnSave
    btnSave.BackColor = Color.FromArgb(60, 60, 60);
    btnSave.FlatStyle = FlatStyle.Flat;
    btnSave.FlatAppearance.BorderColor = Color.FromArgb(100, 100, 100);
    btnSave.Font = new Font("맑은 고딕", 9F);
    btnSave.ForeColor = Color.White;
    btnSave.Location = new Point(12, 80);
    btnSave.Name = "btnSave";
    btnSave.Size = new Size(100, 30);
    btnSave.Text = "저장";
    btnSave.Click += btnSave_Click;

    // Form
    BackColor = Color.FromArgb(30, 30, 30);
    Controls.Add(lblTitle);
    Controls.Add(txtValue);
    Controls.Add(btnSave);
    ResumeLayout(false);
    PerformLayout();
}
```

## 규칙
- Designer.cs에만 작성 (코드 분리)
- TabIndex 순차 지정
- Name 속성 필수
- 이벤트 핸들러는 += 연결만 (본체는 .cs에)
