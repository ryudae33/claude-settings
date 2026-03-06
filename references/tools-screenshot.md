# PowerShell 스크린샷 캡처

```powershell
Add-Type -AssemblyName System.Windows.Forms,System.Drawing
$b=[System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$bmp=New-Object Drawing.Bitmap($b.Width,$b.Height)
$g=[Drawing.Graphics]::FromImage($bmp)
$g.CopyFromScreen($b.Location,[Drawing.Point]::Empty,$b.Size)
$bmp.Save("C:\Users\ryuda\Pictures\Screenshots\screenshot_$(Get-Date -Format 'yyyyMMdd_HHmmss').png")
$g.Dispose();$bmp.Dispose()
```
