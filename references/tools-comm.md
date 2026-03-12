# Serial/Network Communication Tools

## Serial (RS232/RS485)
- **miniterm** → `python -m serial.tools.miniterm COMport baudrate` (pyserial 3.5, in PATH)
  - `python -m serial.tools.miniterm COM3 9600 --eol CR`
- **plink** → `plink` (in PATH, `C:\Program Files\PuTTY\plink.exe`)
  - `plink -serial COM3 -sercfg 9600,8,n,1`

## TCP/UDP
- **ncat** → `ncat` (in PATH, `C:\Program Files (x86)\Nmap\ncat.exe`)
  - `ncat 192.168.1.100 502` — TCP connect
  - `ncat -u 192.168.1.100 1234` — UDP
  - `ncat -l 9000` — listen mode
- **nmap** → `nmap` (in PATH, `C:\Program Files (x86)\Nmap\nmap.exe`)
  - `nmap -sn 192.168.1.0/24` — network scan
  - `nmap -p 502 192.168.1.100` — port check

## Socket Relay
- **winsocat** → `winsocat` (in PATH)
  - Serial ↔ TCP bridge etc.

## Packet Analysis
- **tshark** → `tshark` (in PATH, `C:\Program Files\Wireshark\tshark.exe`)
  - `tshark -i Ethernet -f "tcp port 502"` — Modbus TCP capture
  - `tshark -r capture.pcap` — file analysis
  - `tshark -D` — interface list

## Common
- COM port/IP/port info required
