"""TCP 소켓 통신 도구"""

from __future__ import annotations
import socket
from mcp.server.fastmcp import FastMCP
from services.connection_manager import cm


def register(mcp: FastMCP):

    @mcp.tool()
    def tcp_connect(name: str, host: str, port: int, timeout: float = 3.0) -> str:
        """TCP 소켓 연결"""
        existing = cm.get(name)
        if existing:
            return f"'{name}' 이름의 연결이 이미 존재합니다"

        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(timeout)
        sock.connect((host, port))
        cm.add(name, "tcp", sock, {"host": host, "port": port})
        return f"연결 완료: {name} → {host}:{port}"

    @mcp.tool()
    def tcp_send(name: str, data: str, hex_mode: bool = False) -> str:
        """TCP 데이터 전송"""
        entry = cm.get(name)
        if not entry or entry["type"] != "tcp":
            return f"'{name}' TCP 연결을 찾을 수 없음"

        sock: socket.socket = entry["obj"]
        if hex_mode:
            raw = bytes.fromhex(data.replace(" ", ""))
        else:
            raw = data.encode("utf-8")

        sock.sendall(raw)
        return f"{len(raw)}바이트 전송 완료"

    @mcp.tool()
    def tcp_receive(
        name: str,
        size: int = 4096,
        timeout: float = 1.0,
        hex_mode: bool = False,
    ) -> str:
        """TCP 데이터 수신"""
        entry = cm.get(name)
        if not entry or entry["type"] != "tcp":
            return f"'{name}' TCP 연결을 찾을 수 없음"

        sock: socket.socket = entry["obj"]
        sock.settimeout(timeout)
        try:
            raw = sock.recv(size)
        except socket.timeout:
            return "수신 데이터 없음 (타임아웃)"

        if not raw:
            return "연결이 닫혔습니다"

        if hex_mode:
            return raw.hex(" ").upper()
        else:
            try:
                return raw.decode("utf-8", errors="replace")
            except Exception:
                return raw.hex(" ").upper()

    @mcp.tool()
    def tcp_disconnect(name: str) -> str:
        """TCP 연결 해제"""
        entry = cm.get(name)
        if not entry or entry["type"] != "tcp":
            return f"'{name}' TCP 연결을 찾을 수 없음"

        sock: socket.socket = entry["obj"]
        sock.close()
        cm.remove(name)
        return f"'{name}' TCP 연결 해제 완료"
