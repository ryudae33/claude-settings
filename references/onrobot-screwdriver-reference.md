# OnRobot Screwdriver + Screw Feeder 레퍼런스

소스: QC+Screwdriver v6.5.0 EN/KO, OnRobot TM Manual v1.1.2, 데이터시트 v1.6, NSRI/OM-26R 피더 매뉴얼

## 섹션 인덱스

| 섹션 | 줄 범위 | 핵심 키워드 |
|------|---------|------------|
| 하드웨어 스펙 | 20~75 | 토크, RPM, 무게, 치수, IP54, 전원, LED, 비트홀더 |
| Compute Box | 78~140 | IP, DIP스위치, WebClient, 네트워크, 전원, I/O, 펌웨어 |
| Quick Changer | 143~175 | QC, 4.5A, 페이로드, 장착, Dual QC |
| TCP/CoG | 178~210 | TCP, CoG, 비트확장기, Angle Bracket |
| TMflow 컴포넌트 노드 | 213~370 | CONFIG, PICKUP, TIGHTEN, LOOSEN, MOVE, SELFTAPPING, PREMOUNT, GetParameters, GETIO |
| XML-RPC API | 373~420 | xmlrpc, sd_tighten, sd_loosen, sd_pickup, sd_move, sd_stop, sd_get |
| 전역변수/에러코드 | 423~530 | InitializationError, PowerError, RuntimeError, Safety, LED상태 |
| 지원 나사 규격 | 533~600 | M1.6~M6, Hex, Torx, Phillips, 셀프태핑, Screw Carrier |
| Screw Feeder NSRI | 603~700 | NSRI, M1~M3, 스쿱, 에스케이퍼, 진동, 센서, DI신호 |
| Screw Feeder OM-26R | 703~770 | OM-26R, M2~M6, 자석벨트, 호퍼, 에스케이퍼 |
| 트러블슈팅 | 773~870 | 에러복구, SD_MOVE, 유지보수, 세척, 안전 |
| SW 버전 이력 | 873~910 | v6.5.0, v5.10.0, TMcraft, 컴포넌트 |

---

## 하드웨어 스펙

### 스크루드라이버 본체

| 항목 | 최소 | 일반 | 최대 | 단위 |
|------|------|------|------|------|
| 체결 토크 범위 | 0.15 | - | 5.0 | Nm |
| 토크 정확도 (<1.33Nm) | - | ±0.04 | - | Nm |
| 토크 정확도 (≥1.33Nm) | - | ±3 | - | % |
| 셀프태핑 토크 | - | 목표의 85% | 3.0 | Nm |
| 프리마운트 정확도 오차 | - | - | 0.5 | mm |
| 출력 속도 | - | - | 340 | RPM |
| 안전 범위 나사 길이 | - | - | 35 | mm |
| 샹크 스트로크 | - | - | 55 | mm |
| 샹크 프리로드 (조절 가능) | 0 | 10 | 25 | N |
| 보호 기능 힘 | 35 | 40 | 45 | N |
| 작동 온도 | 5 | - | 50 | °C |
| 보관 온도 | 0 | - | 60 | °C |
| 상대 습도 (비응결) | 0 | - | 95 | % |
| 전원 공급 전압 | 20 | 24 | 25 | VDC |
| 전류 소비 | 75 | - | 4500 | mA |
| 치수 (WxHxD) | - | 308×86×114 | - | mm |
| 무게 | - | 2.5 | - | kg |
| IP 등급 | - | IP54 | - | - |
| ESD 안전 | Yes | | | |
| 모터 | BLDC ×2 | | | |
| 계산된 작동 수명 | 30,000 | - | - | Hours |

### LED 상태 표시 (스크루드라이버)

| LED | 상태 |
|-----|------|
| 소등 | 전원 없음 |
| 녹색 점등 | 대기 (Idle) |
| 녹색 점멸 | 초기화 중 |
| 주황색 점등 | 동작 중 (샹크 이동/회전) |
| 주황색 점멸 | 작동 오류 |
| 적색 점등 | 하드웨어 문제 |
| 적색 점멸 | 비상 정지 |

### Bit Holder A / B

| 구분 | Bit Holder A | Bit Holder B |
|------|-------------|-------------|
| 자석 강도 | 높음 | 낮음 |
| 용도 | 크고 무거운 나사 | 작고 가벼운 나사 |
| 주의 | 작은 나사에 A 사용 시 자석으로 나사 점프 가능 | - |

### Bit Extender

| 품번 | 타입 | 길이 |
|------|------|------|
| 109301 | Type A | 50mm |
| 109289 | Type B | 50mm |
| 109290 | Type A | 100mm |
| 109298 | Type B | 100mm |

---

## Compute Box

### 네트워크

| 항목 | 값 |
|------|-----|
| 기본 IP | 192.168.1.1 |
| 서브넷 | 255.255.255.0 |
| 로봇 권장 IP | 192.168.1.2 |
| DIP 스위치 기본값 | DIP3=ON, DIP4=OFF |
| LED 파란색 | 부팅 중 / IP 미획득 |
| LED 녹색 | 정상 동작 (부팅 후 ~1분) |
| 이더넷 케이블 | Cat 5e, 3m 이하 권장 |

네트워크 모드: Static IP / Dynamic IP / Default Static IP (공장복원)
DIP 스위치 변경 후 반드시 전원 재순환 필요.

### WebClient

| 항목 | 값 |
|------|-----|
| 접속 URL | http://192.168.1.1 |
| 기본 계정 | admin / OnRobot |
| 최초 로그인 | 비밀번호 변경 필수 (8자 이상) |
| 사용자 레벨 | Administrator / Operator / User |
| 주요 메뉴 | Devices, Configuration, WebLogic, Paths, Update, TCP/CoG, Licenses, Applications |

### 전원 사양

| 항목 | 5A 어댑터 (120W) | 6.25A 어댑터 (150W) |
|------|-------------------|---------------------|
| 입력 | AC 100~240V | AC 100~240V |
| 출력 | DC 24V / 5A | DC 24V / 6.25A |
| Device 출력 (CB HW v3.4) | 5A (피크 5.5A) | 4.5A (피크 4.5A) |
| Device 출력 (CB HW v3.1) | 4.5A (피크 4.5A) | 4.5A (피크 4.5A) |

Screwdriver는 Compute Box **HW v3.4 이상** 필수.

### I/O 인터페이스

| 항목 | 값 |
|------|-----|
| 레퍼런스 출력 | 24~25V, 최대 100mA |
| DO1~DO8 합계 | 최대 100mA, 활성 저항 24Ω |
| DI (PNP) TRUE | 18~30V |
| DI (PNP) FALSE | -0.5~2.5V |
| DI (NPN) TRUE | -0.5~5V |
| DI (NPN) FALSE | 18~30V |
| DI 입력 전류 | 최대 6mA, 입력 저항 5kΩ |

### 펌웨어 업데이트

1. .cbu 파일 다운로드 (OnRobot Downloads)
2. WebClient > Update > Browse > .cbu 파일 선택
3. Update 클릭, 5~10분 소요
4. **업데이트 중 절대 디바이스 분리/브라우저 닫기 금지** (디바이스 손상 위험)

### RS485 연결 (Tool Connector 경유)

TMflow > Settings > I/O Setup > COM2 탭:
- RS485 체크박스 활성화
- Pin 6: RS485(-), Pin 7: RS485(+)

---

## Quick Changer

### 요구사항

Screwdriver는 반드시 **Quick Changer Robot Side 4.5A** 버전 사용.

### 현행 제품

| 제품 | Item # | 비고 |
|------|--------|------|
| QC-R v3 | 109498 | 싱글 현행 |
| Dual QC v3 | 109878 | 듀얼 현행 |
| QC-R v2-4.5A | 104277 | 단종 |
| Dual QC v2-4.5A | 104293 | 단종 |

### 기술 데이터

| 항목 | Quick Changer | Dual QC |
|------|:---:|:---:|
| 정격 페이로드 | 25 kg | 30 kg |
| 허용 힘 | 400 N | 600 N |
| 허용 토크 | 40 Nm | 40 Nm |
| 반복 정밀도 | ±0.02 mm | ±0.02 mm |
| IP 등급 | IP67 | IP67 |
| 작동 수명 | 5,000 cycles | 5,000 cycles |
| 작동 온도 | 0~50°C | 0~50°C |

### 장착

1. 훅 메커니즘 정렬 후 툴을 QC 가까이 이동
2. 뒤집어서 완전 결합 (딸깍 소리 확인)
3. 분리: 알루미늄 버튼 누르고 역순

케이블 최소 굽힘 반경: 40mm (HEX-E/H QC는 70mm)

---

## TCP/CoG

### 기본값 (Screwdriver 단독, 마운팅/워크피스 제외)

| 항목 | X | Y | Z |
|------|---|---|---|
| TCP (mm) | 153 | 0 | 81 |
| CoG (mm) | 0 | 4 | 50 |
| 무게 | 2.5 kg | | |

### TM12 + Quick Changer + Angle Bracket 90° (Compute Box 계산값)

비트 확장기 50mm / 100mm (동일 결과):

| 항목 | X | Y | Z | Rx | Ry | Rz |
|------|---|---|---|----|----|-----|
| TCP (mm) | -136.6 | -153 | 63 | 90° | 0° | 0° |
| CoG (mm) | -100.5 | 0 | 66.6 | - | - | - |
| 무게 | 2.767 kg | | | | | |

비트 확장기 None: Compute Box WebClient > TCP/CoG에서 재계산 필요.

### Bit Extender에 따른 Shank 범위

| 상태 | Shank 범위 |
|------|-----------|
| None | 0~55 mm |
| 50mm | 50~105 mm |
| 100mm | 100~155 mm |

### TCP/CoG 계산기 (WebClient)

`http://192.168.1.1/#/tcp-calculation` 에서:
1. 로봇 브랜드/모델 선택
2. Angle Bracket 프리셋
3. 마운팅 타입
4. 툴 선택
5. Accessory (Bit Extender 50/100mm)
6. Workpiece 무게

---

## TMflow 컴포넌트 노드

### D1SD_200_CONFIG (구성 설정)

스크루드라이버에 설정 파라미터 전송.

| 파라미터 | 타입 | 범위 | 기본값 | 설명 |
|---------|------|------|--------|------|
| ExtenderLength | float | 0/50/100 | 0.0 mm | 비트 확장기 길이 |

Gateway: Success / Error

### D1SD_200_PICKUP (나사 픽업)

스크류 프리젠터에서 나사 집어올림. 샹크 하강+비트 천천히 회전→Z force 감지 시 나사 길이+10mm 후퇴.

| 파라미터 | 타입 | 범위 | 기본값 | 설명 |
|---------|------|------|--------|------|
| ZForceN | float | 18.0~30.0 | 18 N | 샹크 하방 힘 |
| ScrewLengthMM | float | 0.1~35.0 | 5 mm | 나사 길이 (후퇴량 결정) |

### D1SD_200_TIGHTEN (나사 조임)

나사 체결. 샹크 하강+시계방향 회전→Z force 감지→나사 길이 이동→토크 초과 시 완료→10mm 후퇴.

| 파라미터 | 타입 | 범위 | 기본값 | 설명 |
|---------|------|------|--------|------|
| ZForceN | float | 18.0~30.0 | 18 N | 샹크 하방 힘 |
| ScrewLengthMM | float | 0.1~35.0 | 5 mm | 나사 삽입 거리 |
| TorqueN | float | 0.15~5.0 | 0.5 Nm | 목표 토크 |

나사조임 길이 = 나사 전체 길이 - 와셔 두께 - 챔퍼 깊이
동작 상세: 90% 구간은 나사 조이기, 마지막 10%에서 목표 토크 적용.

### D1SD_200_LOOSEN (나사 풀기)

나사 해체. 샹크 하강+반시계방향 회전→Z force 감지→나사 길이 이동 후 정지→10mm 후퇴.

| 파라미터 | 타입 | 범위 | 기본값 | 설명 |
|---------|------|------|--------|------|
| ZForceN | float | 18.0~30.0 | 18 N | 샹크 하방 힘 |
| ScrewLengthMM | float | 0.1~35.0 | 5 mm | 나사 추출 거리 |

5Nm 이상으로 체결된 나사는 풀기 불가.

### D1SD_200_MOVE (샹크 이동)

샹크를 특정 위치로 이동. 에러/Safety 복구에도 사용.

| 파라미터 | 타입 | 범위 | 기본값 | 설명 |
|---------|------|------|--------|------|
| ZPositionMM | float | 비트확장기별 상이 | - | 0=후퇴, 55=전개 |

범위: None 0~55, 50mm 50~105, 100mm 100~155

### D1SD_200_SELFTAPPING (셀프태핑)

셀프태핑 나사 체결. 85% 토크로 태핑 후 목표 토크로 최종 체결. 최대 셀프태핑 토크 3Nm.

| 파라미터 | 타입 | 범위 | 기본값 | 설명 |
|---------|------|------|--------|------|
| ZForceN | float | 18.0~30.0 | 18 N | 샹크 하방 힘 |
| ScrewLengthMM | float | 0.1~35.0 | 5 mm | 나사 길이 (뾰족 부분 제외) |
| TargetTorqueN | float | 0.15~5.0 | 0.5 Nm | 최종 목표 토크 |

### D1SD_200_PREMOUNT (사전 장착)

나사를 길이까지 삽입하되 최종 토크 미적용. 머신 스크류 전용 (셀프태핑 불가).

| 파라미터 | 타입 | 범위 | 기본값 | 설명 |
|---------|------|------|--------|------|
| ZForceN | float | 18.0~30.0 | 18 N | 샹크 하방 힘 |
| ScrewLengthMM | float | 0.1~35.0 | 5 mm | 나사 길이 |
| TorqueLimitN | float | 0.15~5.0 | 0.5 Nm | 프리마운트 중 최대 허용 토크 |

### D1SD_200_GetParameters (파라미터 읽기)

| 출력 변수 | 타입 | 설명 |
|-----------|------|------|
| statusZAxisBusy | int | 1=Z축 동작중 |
| statusScrewdriverBusy | int | 1=스크루드라이버 동작중 |
| additionalResults | int | 런타임 에러코드 (0~10) |
| torqueNm | float | 현재 토크 [Nm] |
| torqueAchievedNm | float | 마지막 달성 토크 [Nm] |
| torqueAngleGr | float | 토크 각도 기울기 [Nm/rad] |
| ZForceN | float | Z축 현재 힘 [N] |
| zPositionMm | float | Z축 샹크 위치 [mm] |
| minShank | float | 최소 샹크 위치 [mm] |
| maxShank | float | 최대 샹크 위치 [mm] |
| extenderLength | float | 확장기 길이 [mm] |
| initializeZStallCurrentNotReached | int | 1=에러 |
| initializeNoZIndexMarkFound | int | 1=에러 |
| initializeUnableToHomeZAxis | int | 1=에러 |
| initializeZIndexPlacementNotOk | int | 1=에러 |
| initializeNoIndexMarkFoundOnTorqueEncoders | int | 1=에러 |
| initializeTooBigTorqueDifferenceDuringInitialization | int | 1=에러 |
| errorQCType | int | 1=잘못된 QC 타입 |
| errorPowerSupply | int | 1=잘못된 전원 |
| errorZAxisSafetyActivated | int | 1=Z축 안전 발동 |

### CB_200_GETIO (Compute Box I/O 읽기)

Compute Box 디지털 입력 8핀 상태 읽기.
출력: `g_CB_OR_CB_IO_VALUES` (Bool[8])

### 공통 Gateway (모든 동작 노드)

| Gateway | 설명 |
|---------|------|
| Success | 작업 성공 |
| InitializationError | 초기화 실패 |
| PowerError | 전원 요건 미충족 |
| RuntimeError | 작업 실패 |
| Safety | 샹크 최대 안전 힘 초과 |
| Timeout | 시간 내 미완료 |

**Safety/RuntimeError 복구**: 반드시 SD_MOVE 노드로 샹크를 새 위치로 이동.

---

## XML-RPC API

Compute Box (192.168.1.1:41414) XML-RPC로 PC에서 직접 제어 가능.

```python
import xmlrpc.client
cb = xmlrpc.client.ServerProxy("http://192.168.1.1:41414")
```

### 동작 함수

| 함수 | 파라미터 | 설명 |
|------|----------|------|
| `cb.sd_tighten(t_idx, force_N, len_mm, torque_Nm)` | int, float, float, float | 나사 체결 |
| `cb.sd_loosen(t_idx, force_N, len_mm)` | int, float, float | 나사 풀기 |
| `cb.sd_pickup_screw(t_idx, force_N, len_mm)` | int, float, float | 나사 픽업 |
| `cb.sd_move_shank(t_idx, position_mm)` | int, float | 샹크 이동 (0=후퇴, 55=전개) |
| `cb.sd_stop(t_idx)` | int | 정지 |

### 상태 읽기 함수

| 함수 | 반환 | 설명 |
|------|------|------|
| `cb.sd_get_screwdriver_busy(t_idx)` | bool | 동작 중 여부 |
| `cb.sd_get_achieved_torque(t_idx)` | float | 달성 토크 [Nm] |
| `cb.sd_get_error_code(t_idx)` | int | 에러 코드 |

- `t_idx`: 툴 인덱스 (싱글 스크루드라이버 = 0)
- 영구자석 비트 — 외부 전자석 제어 불가, Shank 이동으로 간접 제어만 가능

### XML-RPC 사용 예시

```python
import xmlrpc.client, time
cb = xmlrpc.client.ServerProxy("http://192.168.1.1:41414")

# 나사 픽업 (M4 8mm, Z force 18N)
cb.sd_pickup_screw(0, 18, 8.0)
while cb.sd_get_screwdriver_busy(0):
    time.sleep(0.1)

# 나사 체결 (토크 2.5Nm)
cb.sd_tighten(0, 18, 8.0, 2.5)
while cb.sd_get_screwdriver_busy(0):
    time.sleep(0.1)

torque = cb.sd_get_achieved_torque(0)
error = cb.sd_get_error_code(0)
```

---

## 전역변수 / 에러코드

### 전역변수

| 변수명 | 타입 | 설명 |
|--------|------|------|
| g_ScrewDriver_OR_SD_InitializationError | int | 초기화 에러코드 |
| g_ScrewDriver_OR_SD_PowerError | int | 전원 에러코드 |
| g_ScrewDriver_OR_SD_RuntimeError | int | 런타임 에러코드 |
| g_CB_OR_CB_IO_VALUES | bool[] | CB 디지털 입력 8개 상태 |

### 초기화 에러 (InitializationError)

| 코드 | 설명 |
|------|------|
| 0 | 에러 없음 |
| 1 | Z축 스톨 전류에 도달하지 못함 |
| 2 | Z 인덱스 마크를 찾을 수 없음 |
| 3 | Z축 원위치로 돌아갈 수 없음 |
| 4 | Z 인덱스 설치가 적합하지 않음 |
| 5 | 토크 인코더에서 인덱스 마크를 찾을 수 없음 |
| 6 | 시작하는 동안의 토크 차이가 너무 큼 |
| 7 | 토크 인덱스 마커가 변경됨 |

### 전원 에러 (PowerError, 마스크)

| 코드 | 설명 |
|------|------|
| 0 | 에러 없음 |
| 1 | Quick Changer가 전력 요구 사항 미충족 (4.5A 아님) |
| 2 | 전원 공급 장치가 전력 요구 사항 미충족 |

### 런타임 에러 (RuntimeError)

| 코드 | 설명 | 대처 |
|------|------|------|
| 0 | 에러 없음 | - |
| 1 | 명령 알 수 없음 | 전원 재순환, SW/FW 업데이트 |
| 2 | 나사 체결 안 됨 | 나사 유무 확인, 나사산/구멍 위치 확인 |
| 3 | 토크 대기 타임아웃 (4초) | 나사산/구멍 확인, ScrewLength 값 줄이기 |
| 4 | 토크 조기 초과 | ScrewLength 값 늘리기 |
| 5 | 나사 풀기 불가 (최대 토크 초과) | 재시도. 5Nm 이상 체결 나사는 풀기 불가 |
| 6 | Z축 끝 도달 | 팁을 나사/구멍에 더 가까이 배치 |
| 7 | Z축 이동 중 막힘 | 샹크 끝 충돌/내부 이물질 확인 |
| 8 | 토크 또는 전류 제한 초과 | - |
| 9 | Z축 과부하 | 전원 재순환, SW/FW 업데이트 |
| 10 | 토크 예상치 않게 감소 | 나사 파손 가능 (셀프태핑 시 재료 너무 단단) |

### WebClient 하드웨어 상태 에러

| 코드 | 설명 |
|------|------|
| 2 | Z축/Init Busy |
| 4 | Z축 Safety 발동 |
| 8 | 미교정 |
| 16 | Init: 샹크 스톨 전류 미도달 |
| 32 | Init: 샹크 인덱스 마크 미발견 |
| 48 | Init: Z축 홈 불가/과전류 |
| 64 | Init: Z 인덱스 배치 이상 |
| 80 | Init: 토크 인덱스 마크 미발견 |
| 96 | Init: 토크 차이 과대 (벨로우 접촉 확인, 윤활유 도포) |
| 112 | Init: 인덱스 마크 값 변경 |
| 256 | QC 타입 오류 (4.5A QC 필수) |
| 512 | 전원 공급 오류 (5A 이상 필수) |
| 768 | 256+512 동시 발생 |

---

## 지원 나사 규격

### Metric 나사 (자성체)

나사 길이 최대 50mm, 나사산 길이 35mm.

| 사이즈 | DIN 912/ISO 4762 (Hex) | ISO 14579 (Torx) | ISO 14580 (Torx) | ISO 14581 (CS Torx) | DIN 7985A (Phillips) |
|--------|:---:|:---:|:---:|:---:|:---:|
| M1.6 | O | - | - | - | - |
| M2 | O | O | - | O | O |
| M2.5 | O | O | - | O | O |
| M3 | O | O | O | O | O |
| M4 | O | O | O | O | O |
| M5 | O | O | O | O | O |
| M6 | O | O | O | O | O |

### 비트 규격

1/4" HEX 샹크, 길이 25mm. 타입: HEX, Torx, Phillips

### Screw Carrier

| 표기 | 나사 사이즈 |
|------|-----------|
| K20 | M2 |
| KB25/K25 | M2.5 |
| KB30/K30 | M3 |
| KB35/K35 | ST3.5 |
| KB40/K40 | M4 |
| KB50/K50 | M5 |
| (M6 전용) | M6 |

### Screw Fix

DIN 912, ISO 4762, ISO 14579/14580, DIN 7981C 등에 필요.
Metric: M1.6, M2, M2.5, M3, M4, M5, M6 / US: 1#~10#, 1/4"

---

## Screw Feeder NSRI

### 개요

OHTAKE ROOT KOGYO 제조, OnRobot 유통. 스쿱 블록(상하 운동)으로 나사 퍼올림, 진동 레일 이송, 에스케이퍼 회전(90°) 공급. **자율 동작** — 전원 ON만 하면 나사 공급→센서 감지→정지→픽업→재가동.

### 사양

| 항목 | 값 |
|------|-----|
| 치수 (WxDxH) | 123 × 181 × 145 mm |
| 무게 (레일 포함) | ~3 kg |
| 전원 | AC 100~240V → DC 15V 1A |
| 작동 온도 | 0~40°C |
| 소음 | <70 dB (1m) |

### 지원 나사

| 사이즈 | 축 직경 | 축 길이 | 머리 형상 |
|--------|---------|---------|---------|
| M1.0 | 0.9~0.95 | 1.6~10 | Hex flange만 |
| M1.2 | 1.1~1.15 | 1.8~10 | Hex flange만 |
| M1.4 | 1.3~1.4 | 2.0~10 | Hex flange만 |
| M1.7 | 1.6~1.7 | 2.3~10 | Hex flange만 |
| M2.0 | 1.9~2.1 | 2.6~20 | Pan/Sems/Bind/Flat/CS/Hex 전부 |
| M2.3 | 2.2~2.4 | 2.9~20 | 전부 |
| M2.6 | 2.5~2.7 | 3.2~20 | 전부 |
| M3.0 | 2.9~3.2 | 3.6~20 | 전부 |

### 로봇 연동

**디지털 신호만 제공** (XML-RPC/Modbus 없음):
- 보라색선 = 신호 출력 (콜렉터, NPN 오픈콜렉터)
- 회색선 = GND (에미터)
- 나사 있음 = HIGH, 없음/OFF = LOW
- 최대 100mA, 5~24VDC, 신호선 3m 이하

TM 로봇 연결: 보라색→CB DI, 회색→GND, 2.2kΩ 풀업 저항(+24V↔DI)

### 픽업 위치 "A" 치수 (에스케이퍼 상단→나사 중심)

| 사이즈 | A (mm) |
|--------|--------|
| M1.0 | 7.2 |
| M1.2 | 7.2 |
| M1.4 | 7.3 |
| M1.7 | 7.4 |
| M2.0 | 7.6 |
| M2.3 | 7.9 |
| M2.6 | 8.0 |
| M3.0 | 8.2 |

로봇 누름 힘 제한: **최대 20N**
에스케이퍼 회전 정지 시간: ~0.6초

### 교환 키트 (나사 직경 변경 시 4부품 교체)

| 모델 | 사이즈 | 키트 | 패싱 플레이트 | 로봇 가이드 |
|------|--------|------|-------------|-----------|
| NSRI10~17 | M1.0~1.7 | RI10~17SET | SW1017 (공용) | SIER10-17 (공용) |
| NSRI20~30 | M2.0~3.0 | RI20~30SET | SW2030 (공용) | SIER20-30 (공용) |

### 조정 항목

- **진동**: 하부 볼트(T) — 시계방향=증가, 반시계=감소
- **브러시**: 나사 머리에 살짝 접촉, 패싱 플레이트에 닿지 않게
- **패싱 플레이트**: 나사가 겨우 통과할 높이
- **홀딩 플레이트**: 나사와 0~1mm 간격
- **타이머**: 후면 노브(W) — 시계방향=짧게, 반시계=길게

---

## Screw Feeder OM-26R

### 개요

OHTAKE 제조, OnRobot 유통. **자석 벨트 스쿠핑** 방식 (강철 나사 전용, 스테인리스/플라스틱 불가). 바이브레이션 레일 + 에스케이퍼 회전 공급.

### 사양

| 항목 | 값 |
|------|-----|
| 치수 (WxDxH) | 119 × 226 × 152 mm |
| 무게 (레일 포함) | ~3.1 kg |
| 전원 | AC 100~240V → DC 15V 1A |
| 작동 온도 | 0~40°C |
| 소음 | <70 dB (1m) |

### 지원 나사

M2, M2.3, M2.5/M2.6, M3, M3.5, M4, M5, M6
축 길이: 사이즈별 ~25mm까지
머리 형상: Pan, Bind, Flat, Hex flange, Sems, Double sems, Washer head

### 로봇 연동

NSRI와 동일한 디지털 신호 방식:
- 보라색 = 콜렉터, 회색 = 에미터/GND
- 나사 있음 = HIGH, 없음 = LOW
- 최대 100mA, 5~24VDC

### NSRI vs OM-26R 비교

| 항목 | NSRI | OM-26R |
|------|------|--------|
| 스쿠핑 방식 | 블록 상하 운동 | 자석 벨트 |
| 나사 사이즈 | M1.0~M3.0 | M2~M6 |
| 나사 재질 | 제한 없음 | **강철만** (자석 방식) |
| 치수 | 123×181×145 | 119×226×152 |
| 무게 | ~3.0 kg | ~3.1 kg |
| 추가 조절 | 진동, 타이머 | 진동 주파수, 진폭, 타이머 |
| 나사 잔량 센서 | 옵션 (TKA09452) | 옵션 |

---

## 트러블슈팅

### 에러 복구 필수 절차

모든 Safety/RuntimeError 후 **반드시 SD_MOVE 노드로 샹크를 0 위치로 이동**해야 다음 동작 가능.

### 작동 거리 제한

스크루드라이버 바닥면과 작업면 사이: **0~8mm**에서만 동작. 초과 시 에러.
하방향 또는 최대 측면(90°)까지만 작동. **상향 작동 시 보호 기능 발동**.

### 안전 보호 기능

- 작동 중 40N 이상 힘 → 기계적 샹크 즉시 후퇴
- 비작동 중 20N 이상 힘 → 일시적 후퇴 (프로그램 중단 없음)
- **전원 차단 시 보호 기능 미동작** — 별도 안전 조치 필요
- 나사 35mm 이하 + 비트확장기 미사용 시에만 완전 보호

### 유지보수 주기

| 부품 | 주기 |
|------|------|
| 나사 고정 장치 및 비트 | 주 1회 또는 60,000 사이클 |
| 오링 | 월 1회 |
| 나사 비트 시스템 전체 | 주 1회 육안 검사 |
| 비트 홀더 내부 이물질 | 정기적 (자석 금속 파편 확인) |
| 말단 적용체 종합 점검 | 6개월 1회 |

### 세척

- 알코올 (이소프로필 70%) 또는 과산화수소수
- 비트 홀더/확장기 내 금속 입자: 평 자석 핸드 나사로 정기 청소
- 레일: 알코올 + 부드러운 천 (오일 도포 금지)

### 코드 96 특수 해결

벨로우가 스크류 비트 시스템에 접촉 시 발생. 덮개 제거 후 접촉 고무에 오일 한 방울 도포.

### QC 오류 (256) 해결

Quick Changer Robot Side에 **4.5A 버전** 사용 필수.

### 전원 오류 (512) 해결

Compute Box에 **5A 이상** 전원 공급기 사용 필수.

---

## SW 버전 이력

### 현재 보유 버전

| 항목 | 버전 |
|------|------|
| TMflow | 2.18.33 |
| Compute Box WebClient | v6.5.1 |
| TMflow 컴포넌트 (설치됨) | v6.5.0 |
| CB 펌웨어 업데이트 파일 | v6.5.3 (미적용) |

### Screwdriver 관련 주요 변경

| 버전 | 변경 내용 |
|------|----------|
| v6.5.0 | TMcraft v1.0.0 최초 릴리스, Minor fixes |
| v5.10.0 | Screwdriver FW 마이너 개선 |
| v5.4.4 | **Screwdriver GetParameters 기능 추가** (컴포넌트 v1.4.0) |

### 알려진 문제

- CB v6.5.1 / 컴포넌트 v6.5.0 버전 불일치 → 노드 실행 매우 느림 (CONFIG ~20초, 포지션 ~2분)
- v6.5.1, v6.5.3은 공식 Changelog 문서에 미기재 (v6.5.0이 마지막)
- v6.5.3 컴포넌트는 df.onrobot.com에 없음 (v6.5.0만 있음)
