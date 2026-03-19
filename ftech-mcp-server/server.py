"""FTech MCP Server - 공장 자동화용 HW/DB 통합 MCP 서버"""

from mcp.server.fastmcp import FastMCP
from services.connection_manager import cm
from tools import serial_tools, tcp_tools, can_tools, modbus_tools, db_tools

mcp = FastMCP(
    "ftech",
    instructions="공장 자동화 장비(Serial/TCP/CAN/Modbus) 및 DB(SQL Server/SQLite/Access) 연결 관리 서버",
)

# 도구 등록
serial_tools.register(mcp)
tcp_tools.register(mcp)
can_tools.register(mcp)
modbus_tools.register(mcp)
db_tools.register(mcp)


# 공통 도구: 연결 상태 확인
@mcp.tool()
def connection_status() -> str:
    """모든 활성 연결 상태 확인"""
    all_conns = cm.list_all()
    if not all_conns:
        return "활성 연결 없음"

    lines = [f"{'이름':<20} {'타입':<10} {'상태':<6} {'정보'}"]
    lines.append("-" * 60)
    for name, info in all_conns.items():
        status = "OK" if info["alive"] else "DEAD"
        detail = " ".join(f"{k}={v}" for k, v in info["info"].items())
        lines.append(f"{name:<20} {info['type']:<10} {status:<6} {detail}")
    return "\n".join(lines)


@mcp.tool()
def disconnect_all() -> str:
    """모든 연결 해제"""
    all_conns = cm.list_all()
    if not all_conns:
        return "해제할 연결 없음"

    names = list(all_conns.keys())
    for name in names:
        entry = cm.get(name)
        if entry:
            obj = entry["obj"]
            try:
                if entry["type"] == "can":
                    obj.shutdown()
                elif hasattr(obj, "close"):
                    obj.close()
            except Exception:
                pass
            cm.remove(name)

    return f"{len(names)}개 연결 해제 완료: {', '.join(names)}"


def main():
    mcp.run()


if __name__ == "__main__":
    main()
