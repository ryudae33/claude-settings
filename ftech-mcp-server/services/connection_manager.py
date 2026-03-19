"""연결 상태 관리 - Serial/TCP/CAN/Modbus/DB 연결을 이름으로 관리"""

from __future__ import annotations
import threading
from typing import Any


class ConnectionManager:
    """모든 활성 연결을 이름 기반으로 관리"""

    def __init__(self):
        self._connections: dict[str, dict[str, Any]] = {}
        self._lock = threading.Lock()

    def add(self, name: str, conn_type: str, obj: Any, info: dict | None = None):
        with self._lock:
            self._connections[name] = {
                "type": conn_type,
                "obj": obj,
                "info": info or {},
            }

    def get(self, name: str) -> dict[str, Any] | None:
        with self._lock:
            return self._connections.get(name)

    def remove(self, name: str) -> bool:
        with self._lock:
            return self._connections.pop(name, None) is not None

    def list_all(self) -> dict[str, dict]:
        with self._lock:
            result = {}
            for name, entry in self._connections.items():
                result[name] = {
                    "type": entry["type"],
                    "info": entry["info"],
                    "alive": self._check_alive(entry),
                }
            return result

    def _check_alive(self, entry: dict) -> bool:
        obj = entry["obj"]
        conn_type = entry["type"]
        try:
            if conn_type == "serial":
                return obj.is_open
            elif conn_type == "tcp":
                # 소켓이 닫혔는지 확인
                return obj.fileno() != -1
            elif conn_type == "can":
                return obj is not None
            elif conn_type == "modbus":
                return obj.connected
            elif conn_type in ("sqlserver", "sqlite", "access"):
                return True  # DB 연결은 쿼리 시 확인
            return False
        except Exception:
            return False


# 싱글턴
cm = ConnectionManager()
