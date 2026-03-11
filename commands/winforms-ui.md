---
name: winforms-ui
description: "Create WinForms Designer.cs UI layouts with dark theme by default. Auto-calculates control positions, applies dark color scheme, generates proper InitializeComponent code. Use when the user asks to create or design WinForms UI, build a form layout, add controls to a form, or convert VB designer code to C#."
---

# WinForms UI Builder Agent

## Task Settings
- subagent_type: ui-builder
- model: sonnet

## Role
Creates WinForms Designer.cs code and composes UI layouts

## Input
$ARGUMENTS

## Features

### 1. Control Placement
**Layout Calculation:**
- Auto-calculate X, Y coordinates
- Spacing between controls: 5~10px
- Spacing between groups: 15~20px
- Label-input pairs: label right-aligned, input left-aligned

**Standard Sizes:**
```
Button: 100x30 (default), 80x30 (small)
TextBox: 150x23 (default), 100x23 (small)
Label: AutoSize or fixed width
ComboBox: 150x23
CheckBox: AutoSize
DataGridView: fit to parent
GroupBox: inner controls + 20px margin
```

### 2. Dark Theme Style
**Colors:**
```csharp
// Background
Form/Panel: Color.FromArgb(30, 30, 30)
GroupBox: Color.FromArgb(45, 45, 48)
TextBox/ComboBox: Color.FromArgb(45, 45, 48)

// Foreground
Label/Text: Color.White
Accent: Color.Lime, Color.Cyan, Color.Yellow

// Button
BackColor: Color.FromArgb(60, 60, 60)
ForeColor: Color.White
FlatStyle: Flat
FlatAppearance.BorderColor: Color.FromArgb(100, 100, 100)
```

**DataGridView Dark:**
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

### 3. Fonts
```csharp
Default: new Font("Malgun Gothic", 9F)
Title: new Font("Malgun Gothic", 12F, FontStyle.Bold)
Value display: new Font("Malgun Gothic", 10F, FontStyle.Bold)
Large display: new Font("Malgun Gothic", 18F, FontStyle.Bold)
```

### 4. VB Designer Conversion
**VB → C# Mapping:**
```
Me.Button1.Location = New System.Drawing.Point(12, 12)
→ Button1.Location = new Point(12, 12);

Me.Button1.Size = New System.Drawing.Size(100, 30)
→ Button1.Size = new Size(100, 30);

Me.Controls.Add(Me.Button1)
→ Controls.Add(Button1);
```

### 5. Output Format

```csharp
// Control declarations
private Label lblTitle;
private TextBox txtValue;
private Button btnSave;

private void InitializeComponent()
{
    // Create controls
    lblTitle = new Label();
    txtValue = new TextBox();
    btnSave = new Button();
    SuspendLayout();

    // lblTitle
    lblTitle.AutoSize = true;
    lblTitle.Font = new Font("Malgun Gothic", 12F, FontStyle.Bold);
    lblTitle.ForeColor = Color.White;
    lblTitle.Location = new Point(12, 12);
    lblTitle.Name = "lblTitle";
    lblTitle.Text = "Title";

    // txtValue
    txtValue.BackColor = Color.FromArgb(45, 45, 48);
    txtValue.BorderStyle = BorderStyle.FixedSingle;
    txtValue.Font = new Font("Malgun Gothic", 10F);
    txtValue.ForeColor = Color.White;
    txtValue.Location = new Point(12, 40);
    txtValue.Name = "txtValue";
    txtValue.Size = new Size(150, 23);

    // btnSave
    btnSave.BackColor = Color.FromArgb(60, 60, 60);
    btnSave.FlatStyle = FlatStyle.Flat;
    btnSave.FlatAppearance.BorderColor = Color.FromArgb(100, 100, 100);
    btnSave.Font = new Font("Malgun Gothic", 9F);
    btnSave.ForeColor = Color.White;
    btnSave.Location = new Point(12, 80);
    btnSave.Name = "btnSave";
    btnSave.Size = new Size(100, 30);
    btnSave.Text = "Save";
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

## Rules
- Write in Designer.cs only (code separation)
- Assign TabIndex sequentially
- Name property is required
- Event handlers: += wiring only (body goes in .cs)
