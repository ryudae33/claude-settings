# Git 프로젝트 초기화 에이전트

## 역할
새 프로젝트의 Git 리포지토리를 초기화하고, ftech-projects 조직에 리포를 생성하며, 필수 템플릿 파일을 세팅한다.

## 입력
$ARGUMENTS (프로젝트명 또는 프로젝트 경로)

## 동작

### 1. 사전 확인
- 인자가 없으면 현재 디렉토리를 프로젝트 경로로 사용
- 인자가 경로면 해당 경로 사용, 이름만 있으면 현재 디렉토리 아래에 폴더 생성
- 이미 .git이 있으면 "이미 Git 초기화됨" 안내 후 중단

### 2. GitHub 계정 전환
```bash
gh auth switch --user ryudae33
```

### 3. Git 초기화
```bash
git init
git config user.email "ryudae33@ftechq.com"
```

### 4. .gitignore 생성
프로젝트 내 파일을 스캔하여 언어를 판별한 후 적절한 .gitignore 생성:
- .sln/.csproj 발견 → C#/.NET용
- .vbproj 발견 → VB.NET용
- package.json 발견 → Node.js용
- 기본: Visual Studio + OS 공통 패턴

#### .NET 기본 패턴
```
bin/
obj/
*.user
*.suo
*.cache
.vs/
packages/
*.nupkg
crash.log
```

### 5. CLAUDE.md 템플릿 생성
프로젝트 폴더에 CLAUDE.md 생성:
```markdown
# {프로젝트명}

## 개요
-

## 기술 스택
-

## 빌드/실행
```
dotnet build
```

## 작업 이력
| 날짜 | 내역 |
|------|------|
```

### 6. 전역 예외 핸들러 추가 (C#/VB.NET 프로젝트만)
Program.cs 또는 Program.vb가 있으면, 전역 예외 핸들러 코드가 이미 있는지 확인 후 없으면 추가 제안:

#### C# 템플릿
```csharp
// 전역 예외 핸들러
Application.ThreadException += (s, e) => LogCrash(e.Exception);
AppDomain.CurrentDomain.UnhandledException += (s, e) => LogCrash((Exception)e.ExceptionObject);

static void LogCrash(Exception ex)
{
    var msg = $"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] {ex.Source}: {ex.Message}\n{ex.StackTrace}\n\n";
    File.AppendAllText("crash.log", msg);
}
```

#### VB.NET 템플릿
```vb
' 전역 예외 핸들러
AddHandler Application.ThreadException, Sub(s, e) LogCrash(e.Exception)
AddHandler AppDomain.CurrentDomain.UnhandledException, Sub(s, e) LogCrash(DirectCast(e.ExceptionObject, Exception))

Private Sub LogCrash(ex As Exception)
    Dim msg = $"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] {ex.Source}: {ex.Message}{vbCrLf}{ex.StackTrace}{vbCrLf}{vbCrLf}"
    IO.File.AppendAllText("crash.log", msg)
End Sub
```

### 7. GitHub 리포 생성
```bash
gh repo create ftech-projects/{프로젝트명} --private --source=. --push
```

### 8. 초기 커밋
```bash
git add .
git commit -m "초기 프로젝트 세팅"
git push -u origin main
```

## 규칙
- 리포 생성 전 사용자에게 리포명/공개여부 확인
- 이미 존재하는 파일은 덮어쓰지 않음
- crash.log 핸들러는 추가 여부를 사용자에게 확인
- 한글로 응답
