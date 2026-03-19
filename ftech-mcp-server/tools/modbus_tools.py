"""Modbus RTU/TCP 통신 도구"""

from __future__ import annotations
import socket
import serial
from pymodbus.client import ModbusTcpClient, ModbusSerialClient
from mcp.server.fastmcp import FastMCP
from services.connection_manager import cm


def register(mcp: FastMCP):

    @mcp.tool()
    def modbus_connect_tcp(
        name: str,
        host: str,
        port: int = 502,
        timeout: float = 3.0,
    ) -> str:
        """Modbus TCP 연결"""
        existing = cm.get(name)
        if existing:
            return f"'{name}' 이름의 연결이 이미 존재합니다"

        client = ModbusTcpClient(host, port=port, timeout=timeout)
        if not client.connect():
            return f"연결 실패: {host}:{port}"

        cm.add(name, "modbus", client, {
            "protocol": "tcp", "host": host, "port": port,
        })
        return f"연결 완료: {name} → {host}:{port} (Modbus TCP)"

    @mcp.tool()
    def modbus_connect_rtu(
        name: str,
        port: str,
        baudrate: int = 9600,
        parity: str = "N",
        stopbits: int = 1,
        timeout: float = 1.0,
    ) -> str:
        """Modbus RTU (시리얼) 연결"""
        existing = cm.get(name)
        if existing:
            return f"'{name}' 이름의 연결이 이미 존재합니다"

        client = ModbusSerialClient(
            port=port,
            baudrate=baudrate,
            parity=parity,
            stopbits=stopbits,
            timeout=timeout,
        )
        if not client.connect():
            return f"연결 실패: {port}"

        cm.add(name, "modbus", client, {
            "protocol": "rtu", "port": port, "baudrate": baudrate,
        })
        return f"연결 완료: {name} → {port} @ {baudrate}bps (Modbus RTU)"

    @mcp.tool()
    def modbus_read_holding_registers(
        name: str,
        address: int,
        count: int = 1,
        slave: int = 1,
    ) -> str:
        """Holding Register 읽기 (FC03)"""
        entry = cm.get(name)
        if not entry or entry["type"] != "modbus":
            return f"'{name}' Modbus 연결을 찾을 수 없음"

        client = entry["obj"]
        result = client.read_holding_registers(address, count, slave=slave)
        if result.isError():
            return f"에러: {result}"

        regs = result.registers
        lines = [f"Holding Registers (slave={slave}, addr={address}, count={count}):"]
        for i, val in enumerate(regs):
            lines.append(f"  [{address + i}] = {val} (0x{val:04X})")
        return "\n".join(lines)

    @mcp.tool()
    def modbus_read_input_registers(
        name: str,
        address: int,
        count: int = 1,
        slave: int = 1,
    ) -> str:
        """Input Register 읽기 (FC04)"""
        entry = cm.get(name)
        if not entry or entry["type"] != "modbus":
            return f"'{name}' Modbus 연결을 찾을 수 없음"

        client = entry["obj"]
        result = client.read_input_registers(address, count, slave=slave)
        if result.isError():
            return f"에러: {result}"

        regs = result.registers
        lines = [f"Input Registers (slave={slave}, addr={address}, count={count}):"]
        for i, val in enumerate(regs):
            lines.append(f"  [{address + i}] = {val} (0x{val:04X})")
        return "\n".join(lines)

    @mcp.tool()
    def modbus_read_coils(
        name: str,
        address: int,
        count: int = 1,
        slave: int = 1,
    ) -> str:
        """Coil 읽기 (FC01)"""
        entry = cm.get(name)
        if not entry or entry["type"] != "modbus":
            return f"'{name}' Modbus 연결을 찾을 수 없음"

        client = entry["obj"]
        result = client.read_coils(address, count, slave=slave)
        if result.isError():
            return f"에러: {result}"

        bits = result.bits[:count]
        lines = [f"Coils (slave={slave}, addr={address}, count={count}):"]
        for i, val in enumerate(bits):
            lines.append(f"  [{address + i}] = {'ON' if val else 'OFF'}")
        return "\n".join(lines)

    @mcp.tool()
    def modbus_write_register(
        name: str,
        address: int,
        value: int,
        slave: int = 1,
    ) -> str:
        """단일 Holding Register 쓰기 (FC06)"""
        entry = cm.get(name)
        if not entry or entry["type"] != "modbus":
            return f"'{name}' Modbus 연결을 찾을 수 없음"

        client = entry["obj"]
        result = client.write_register(address, value, slave=slave)
        if result.isError():
            return f"에러: {result}"
        return f"쓰기 완료: [{address}] = {value} (0x{value:04X}), slave={slave}"

    @mcp.tool()
    def modbus_write_coil(
        name: str,
        address: int,
        value: bool,
        slave: int = 1,
    ) -> str:
        """단일 Coil 쓰기 (FC05)"""
        entry = cm.get(name)
        if not entry or entry["type"] != "modbus":
            return f"'{name}' Modbus 연결을 찾을 수 없음"

        client = entry["obj"]
        result = client.write_coil(address, value, slave=slave)
        if result.isError():
            return f"에러: {result}"
        return f"쓰기 완료: [{address}] = {'ON' if value else 'OFF'}, slave={slave}"

    @mcp.tool()
    def modbus_disconnect(name: str) -> str:
        """Modbus 연결 해제"""
        entry = cm.get(name)
        if not entry or entry["type"] != "modbus":
            return f"'{name}' Modbus 연결을 찾을 수 없음"

        client = entry["obj"]
        client.close()
        cm.remove(name)
        return f"'{name}' Modbus 연결 해제 완료"
