"""CAN 통신 도구 (PEAK-System PCAN)"""

from __future__ import annotations
import can
from mcp.server.fastmcp import FastMCP
from services.connection_manager import cm


def register(mcp: FastMCP):

    @mcp.tool()
    def can_connect(
        name: str,
        channel: str = "PCAN_USBBUS1",
        bitrate: int = 500000,
        fd: bool = False,
    ) -> str:
        """PCAN CAN 버스 연결. channel: PCAN_USBBUS1~16, bitrate: 125000/250000/500000/1000000"""
        existing = cm.get(name)
        if existing:
            return f"'{name}' 이름의 연결이 이미 존재합니다"

        bus = can.interface.Bus(
            interface="pcan",
            channel=channel,
            bitrate=bitrate,
            fd=fd,
        )
        cm.add(name, "can", bus, {
            "channel": channel, "bitrate": bitrate, "fd": fd,
        })
        return f"연결 완료: {name} → {channel} @ {bitrate}bps (FD={fd})"

    @mcp.tool()
    def can_send(
        name: str,
        arbitration_id: int,
        data: str,
        is_extended: bool = False,
    ) -> str:
        """CAN 메시지 전송. data: HEX 문자열 (예: '01 02 03 04')"""
        entry = cm.get(name)
        if not entry or entry["type"] != "can":
            return f"'{name}' CAN 연결을 찾을 수 없음"

        bus: can.Bus = entry["obj"]
        raw = bytes.fromhex(data.replace(" ", ""))
        msg = can.Message(
            arbitration_id=arbitration_id,
            data=raw,
            is_extended_id=is_extended,
        )
        bus.send(msg)
        return f"전송: ID=0x{arbitration_id:03X} Data={raw.hex(' ').upper()} ({len(raw)}B)"

    @mcp.tool()
    def can_receive(
        name: str,
        timeout: float = 1.0,
        count: int = 1,
        filter_id: int | None = None,
    ) -> str:
        """CAN 메시지 수신. count: 수신할 메시지 수, filter_id: 특정 ID만 수신"""
        entry = cm.get(name)
        if not entry or entry["type"] != "can":
            return f"'{name}' CAN 연결을 찾을 수 없음"

        bus: can.Bus = entry["obj"]

        if filter_id is not None:
            bus.set_filters([{"can_id": filter_id, "can_mask": 0x7FF}])

        messages = []
        for _ in range(count):
            msg = bus.recv(timeout=timeout)
            if msg is None:
                break
            messages.append(
                f"ID=0x{msg.arbitration_id:03X} "
                f"Data={msg.data.hex(' ').upper()} "
                f"DLC={msg.dlc} "
                f"T={msg.timestamp:.3f}"
            )

        if filter_id is not None:
            bus.set_filters(None)

        if not messages:
            return "수신 메시지 없음 (타임아웃)"
        return "\n".join(messages)

    @mcp.tool()
    def can_status(name: str) -> str:
        """CAN 버스 상태 확인"""
        entry = cm.get(name)
        if not entry or entry["type"] != "can":
            return f"'{name}' CAN 연결을 찾을 수 없음"

        bus: can.Bus = entry["obj"]
        state = bus.state
        info = entry["info"]
        return (
            f"채널: {info['channel']}\n"
            f"Bitrate: {info['bitrate']}\n"
            f"FD: {info['fd']}\n"
            f"상태: {state}"
        )

    @mcp.tool()
    def can_disconnect(name: str) -> str:
        """CAN 버스 연결 해제"""
        entry = cm.get(name)
        if not entry or entry["type"] != "can":
            return f"'{name}' CAN 연결을 찾을 수 없음"

        bus: can.Bus = entry["obj"]
        bus.shutdown()
        cm.remove(name)
        return f"'{name}' CAN 연결 해제 완료"
