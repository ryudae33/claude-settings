# C#/.NET 빌드 자동 버전 템플릿

## 파일명 형식
`프로젝트명(년월일)(V버전).exe`
예: `DiffTest(20260203)(V1.02).exe`

---

## 1. version.txt (프로젝트 루트)
```
1.01
```

---

## 2. increment-version.ps1 (프로젝트 루트)
```powershell
# 빌드 후 자동 버전 증가 스크립트
$versionFile = Join-Path $PSScriptRoot "version.txt"
$csprojFile = Get-ChildItem $PSScriptRoot -Filter "*.csproj" | Select-Object -First 1

if (Test-Path $versionFile) {
    $version = Get-Content $versionFile
    $parts = $version.Split('.')
    $major = [int]$parts[0]
    $minor = [int]$parts[1]
    $minor++
    $newVersion = "$major.$($minor.ToString('00'))"
} else {
    $newVersion = "1.01"
}

$newVersion | Set-Content $versionFile -NoNewline

if ($csprojFile) {
    $content = Get-Content $csprojFile.FullName -Raw
    $content = $content -replace '<BuildVersion>[^<]+</BuildVersion>', "<BuildVersion>$newVersion</BuildVersion>"
    $content | Set-Content $csprojFile.FullName -NoNewline
}

Write-Host "Build Version: $newVersion"
```

---

## 3. .csproj 추가 내용

### PropertyGroup에 추가:
```xml
<!-- 빌드 날짜 (필요 시 수동 변경) -->
<BuildDate>20260203</BuildDate>
<!-- 빌드 버전 (version.txt에서 직접 읽음) -->
<BuildVersion>$([System.IO.File]::ReadAllText('$(MSBuildProjectDirectory)\version.txt').Trim())</BuildVersion>
<AssemblyName>프로젝트명($(BuildDate))(V$(BuildVersion))</AssemblyName>
```

### Target 추가 (PropertyGroup 바깥):
```xml
<!-- 빌드 후 버전 자동 증가 -->
<Target Name="AutoIncrementVersion" AfterTargets="Build">
  <Message Text="Built $(AssemblyName)" Importance="high" />
  <Exec Command="powershell -ExecutionPolicy Bypass -File &quot;$(ProjectDir)increment-version.ps1&quot;" />
</Target>
```

---

## 동작 방식
1. 빌드 시 PropertyGroup에서 version.txt 읽음 → 현재 버전으로 빌드
2. 빌드 완료 후 스크립트 실행 → version.txt 증가 (다음 빌드용)
