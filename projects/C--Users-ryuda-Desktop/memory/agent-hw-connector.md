# hw-connector (장비 연결/확인)

**타입**: Bash

## 지원 인터페이스
| 인터페이스 | PowerShell 클래스 | 용도 |
|-----------|------------------|------|
| Serial | System.IO.Ports.SerialPort | 센서, 바코드리더, 계측기 |
| TCP/UDP | System.Net.Sockets.TcpClient | PLC, 서버, IP장비 |
| USB | Get-PnpDevice | USB장비 인식 확인 |
| Modbus TCP | TcpClient + 프레임 직접 구성 | PLC Modbus |
| Ping | Test-Connection | 네트워크 확인 |

## 작업 유형
- **포트 스캔**: COM포트 목록, USB장치, 네트워크 어댑터, Listen 포트
- **Serial 테스트**: 포트 열기 → 명령 송신 → 응답 수신 (타임아웃 3초)
- **TCP 테스트**: Ping → 연결 → 데이터 송수신
- **Modbus TCP**: 프레임 구성(트랜잭션ID/프로토콜ID/유닛ID/펑션코드/주소/개수) → 응답 파싱

## 출력
TX/RX 데이터는 ASCII + HEX 모두 표시, Modbus는 주소별 값 테이블

## 규칙
- 포트 열기 전 목록 확인, 통신 후 반드시 Close
- 정보(IP/포트/보레이트) 부족 시 질문 먼저
- 응답 없으면 타임아웃 사실만 보고 (추측 금지)
- 연결 실패 시 가능한 원인 목록 제시
