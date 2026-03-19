# AVS 조립성 사전 검증 시스템

## 프로젝트 위치
`C:\Users\ryuda\Desktop\Assemble Test\`

## 문서
- 기획안: `조립성검증시스템_기획안.md`
- 계획서: `PROJECT_PLAN.md` — rev.2 웹 클라이언트 구조

## 아키텍처
- **Python FastAPI 백엔드** (localhost:8321) + **브라우저 웹 클라이언트**
- 3D 뷰어: three.js CDN (v0.170.0, import map)
- STEP 처리: pythonOCC (pythonocc-core 7.8.1)
- 리포트: openpyxl(Excel) + ReportLab(PDF)

## 환경
- miniforge3 (conda 26.1.0), env `avs` (Python 3.11.15)
- **pythonOCC 7.8 API**: `OCC.Core.XXX`, 정적메서드 `topods.Solid()`, `brepgprop.VolumeProperties()`, `BRep_Tool.Triangulation()`
- XCAF (STEPCAFControl_Reader/Writer) crash → **STEPControl_Reader/Writer** 사용
- 서버 실행 PATH: `/c/Users/ryuda/miniforge3/envs/avs:/c/Users/ryuda/miniforge3/envs/avs/Scripts:/c/Users/ryuda/miniforge3/envs/avs/Library/bin`

## 완료 Phase (2026-03-07)

### Phase 1 — STEP 파서 + 3D 뷰어
- FastAPI 골격, STEP 파서, 홀 검출, GLB 변환, 웹 UI (3분할), three.js 뷰어

### Phase 2 — 검증 엔진
- 볼트 규격 불일치 검출 (bolt_validator.py)
- 3D 충돌 검출 (collision_validator.py — BRepAlgoAPI_Common)
- 공구 접근성 검출 (clearance_validator.py)
- 길이·깊이 간섭 검출 (depth_validator.py — 보스-홀 매칭)

### Phase 3 — UI 통합
- 이슈 패널, 이슈→3D 포커스, 설정 다이얼로그, 파트 표시/숨김

### Phase 4 — 리포트 + 테스트
- Excel 리포트 (openpyxl) — 요약/이슈/파트 3시트
- PDF 리포트 (ReportLab + 맑은고딕)
- 테스트 STEP (5파트, 볼트불일치/충돌/접근성 이슈 포함)
- 전체 API E2E 검증 완료

## 테스트 결과 (test_assembly.step)
- 5파트, 11홀 검출
- 볼트 불일치 3건 CRITICAL
- 충돌 1건 CRITICAL (3127mm³)
- 접근성 8건 WARNING
- Excel/PDF 리포트 생성 OK

## 알려진 한계/개선점
- XCAF Writer crash → 파트명 없이 Compound로 저장됨 (Part_1~5 자동명)
- depth_validator: 보스-홀 매칭 조건 엄격 → 테스트 데이터에서 검출 못함
- clearance 과검출: 인접 플레이트를 장애물로 인식
- 외부 STEP 샘플: GrabCAD/GitHub LFS 직접 다운로드 불가, 수동 확보 필요
- PyInstaller 배포: Phase 4.7 미완
