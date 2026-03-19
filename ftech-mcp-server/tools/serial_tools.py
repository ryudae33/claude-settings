"""시리얼(RS232/RS485) 통신 도구"""

from __future__ import annotations
import serial
import serial.tools.list_ports
from mcp.server.fastmcp import FastMCP
from services.connection_manager import cm


def register(mcp: FastMCP):

    @mcp.tool()
    def serial_list_ports() -> str:
        """사용 가능한 COM 포트 목록 조회"""
        ports = serial.tools.list_ports.comports()
        if not ports:
            return "사용 가능한 COM 포트 없음"
        lines = []
        for p in ports:
            lines.append(f"{p.device} - {p.description} [{p.hwid}]")
        return "\n".join(lines)

    @mcp.tool()
    def serial_connect(
        name: str,
        port: str,
        baudrate: int = 9600,
        bytesize: int = 8,
        parity: str = "N",
        stopbits: float = 1,
        timeout: float = 1.0,
    ) -> str:
        """시리얼 포트 연결. parity: N/E/O/M/S, stopbits: 1/1.5/2"""
        existing = cm.get(name)
        if existing:
            return f"'{name}' 이름의 연결이 이미 존재합니다 (type={existing['type']})"

        ser = serial.Serial(
            port=port,
            baudrate=baudrate,
            bytesize=bytesize,
            parity=parity,
            stopbits=stopbits,
            timeout=timeout,
        )
        cm.add(name, "serial", ser, {
            "port": port, "baudrate": baudrate,
            "parity": parity, "stopbits": stopbits,
        })
        return f"연결 완료: {name} → {port} @ {baudrate}bps"

    @mcp.tool()
    def serial_send(name: str, data: str, hex_mode: bool = False) -> str:
        """시리얼 데이터 전송. hex_mode=True면 '01 03 00 00' 형태의 HEX 문자열"""
        entry = cm.get(name)
        if not entry or entry["type"] != "serial":
            return f"'{name}' 시리얼 연결을 찾을 수 없음"

        ser: serial.Serial = entry["obj"]
        if hex_mode:
            raw = bytes.fromhex(data.replace(" ", ""))
        else:
            raw = data.encode("utf-8")

        written = ser.write(raw)
        return f"{written}바이트 전송 완료 (hex={hex_mode})"

    @mcp.tool()
    def serial_receive(
        name: str,
        size: int = 0,
        timeout: float = 1.0,
        hex_mode: bool = False,
    ) -> str:
        """시리얼 데이터 수신. size=0이면 버퍼에 있는 만큼 읽기"""
        entry = cm.get(name)
        if not entry or entry["type"] != "serial":
            return f"'{name}' 시리얼 연결을 찾을 수 없음"

        ser: serial.Serial = entry["obj"]
        old_timeout = ser.timeout
        ser.timeout = timeout

        if size > 0:
            raw = ser.read(size)
        else:
            # 버퍼에 있는 만큼 읽기
            raw = ser.read(ser.in_waiting or 1)

        ser.timeout = old_timeout

        if not raw:
            return "수신 데이터 없음 (타임아웃)"

        if hex_mode:
            return raw.hex(" ").upper()
        else:
            try:
                return raw.decode("utf-8", errors="replace")
            except Exception:
                return raw.hex(" ").upper()

    @mcp.tool()
    def serial_disconnect(name: str) -> str:
        """시리얼 연결 해제"""
        entry = cm.get(name)
        if not entry or entry["type"] != "serial":
            return f"'{name}' 시리얼 연결을 찾을 수 없음"

        ser: serial.Serial = entry["obj"]
        ser.close()
        cm.remove(name)
        return f"'{name}' 시리얼 연결 해제 완료"
