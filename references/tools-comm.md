# 시리얼/네트워크 통신 도구

## 시리얼 (RS232/RS485)
- **miniterm** → `python -m serial.tools.miniterm COM포트 보드레이트` (pyserial 3.5, PATH 등록)
  - `python -m serial.tools.miniterm COM3 9600 --eol CR`
- **plink** → `plink` (PATH 등록, `C:\Program Files\PuTTY\plink.exe`)
  - `plink -serial COM3 -sercfg 9600,8,n,1`

## TCP/UDP
- **ncat** → `ncat` (PATH 등록, `C:\Program Files (x86)\Nmap\ncat.exe`)
  - `ncat 192.168.1.100 502` — TCP 연결
  - `ncat -u 192.168.1.100 1234` — UDP
  - `ncat -l 9000` — 리슨 모드
- **nmap** → `nmap` (PATH 등록, `C:\Program Files (x86)\Nmap\nmap.exe`)
  - `nmap -sn 192.168.1.0/24` — 네트워크 스캔
  - `nmap -p 502 192.168.1.100` — 포트 확인

## 소켓 릴레이
- **winsocat** → `winsocat` (PATH 등록)
  - 시리얼 ↔ TCP 브릿지 등

## 패킷 분석
- **tshark** → `tshark` (PATH 등록, `C:\Program Files\Wireshark\tshark.exe`)
  - `tshark -i 이더넷 -f "tcp port 502"` — Modbus TCP 캡처
  - `tshark -r capture.pcap` — 파일 분석
  - `tshark -D` — 인터페이스 목록

## 공통
- COM포트/IP/포트 정보 필요
