"""DB 도구 - SQL Server / SQLite / Access 통합"""

from __future__ import annotations
import sqlite3
import pyodbc
from mcp.server.fastmcp import FastMCP
from services.connection_manager import cm


def register(mcp: FastMCP):

    @mcp.tool()
    def db_connect_sqlserver(
        name: str,
        server: str,
        database: str,
        username: str = "",
        password: str = "",
        trusted: bool = True,
    ) -> str:
        """SQL Server 연결. trusted=True면 Windows 인증"""
        existing = cm.get(name)
        if existing:
            return f"'{name}' 이름의 연결이 이미 존재합니다"

        if trusted:
            conn_str = (
                f"DRIVER={{ODBC Driver 17 for SQL Server}};"
                f"SERVER={server};DATABASE={database};Trusted_Connection=yes;"
            )
        else:
            conn_str = (
                f"DRIVER={{ODBC Driver 17 for SQL Server}};"
                f"SERVER={server};DATABASE={database};"
                f"UID={username};PWD={password};"
            )

        conn = pyodbc.connect(conn_str)
        cm.add(name, "sqlserver", conn, {
            "server": server, "database": database, "trusted": trusted,
        })
        return f"연결 완료: {name} → {server}/{database}"

    @mcp.tool()
    def db_connect_sqlite(name: str, path: str) -> str:
        """SQLite DB 연결"""
        existing = cm.get(name)
        if existing:
            return f"'{name}' 이름의 연결이 이미 존재합니다"

        conn = sqlite3.connect(path)
        conn.row_factory = sqlite3.Row
        cm.add(name, "sqlite", conn, {"path": path})
        return f"연결 완료: {name} → {path}"

    @mcp.tool()
    def db_connect_access(name: str, path: str) -> str:
        """Access DB (.mdb/.accdb) 연결"""
        existing = cm.get(name)
        if existing:
            return f"'{name}' 이름의 연결이 이미 존재합니다"

        conn_str = (
            f"DRIVER={{Microsoft Access Driver (*.mdb, *.accdb)}};"
            f"DBQ={path};"
        )
        conn = pyodbc.connect(conn_str)
        cm.add(name, "access", conn, {"path": path})
        return f"연결 완료: {name} → {path}"

    @mcp.tool()
    def db_query(name: str, sql: str, max_rows: int = 100) -> str:
        """SQL 쿼리 실행 (SELECT). 결과를 텍스트 테이블로 반환"""
        entry = cm.get(name)
        if not entry or entry["type"] not in ("sqlserver", "sqlite", "access"):
            return f"'{name}' DB 연결을 찾을 수 없음"

        conn = entry["obj"]
        db_type = entry["type"]

        # SELECT만 허용
        sql_upper = sql.strip().upper()
        if not sql_upper.startswith("SELECT") and not sql_upper.startswith("WITH"):
            return "안전을 위해 SELECT/WITH 쿼리만 허용됩니다. db_execute를 사용하세요."

        if db_type == "sqlite":
            cursor = conn.execute(sql)
            columns = [desc[0] for desc in cursor.description] if cursor.description else []
            rows = cursor.fetchmany(max_rows)
        else:
            cursor = conn.cursor()
            cursor.execute(sql)
            columns = [desc[0] for desc in cursor.description] if cursor.description else []
            rows = cursor.fetchmany(max_rows)
            cursor.close()

        if not columns:
            return "결과 없음"

        # 텍스트 테이블 포맷
        col_widths = [len(c) for c in columns]
        str_rows = []
        for row in rows:
            str_row = [str(v) if v is not None else "NULL" for v in row]
            for i, v in enumerate(str_row):
                col_widths[i] = max(col_widths[i], min(len(v), 50))
            str_rows.append(str_row)

        # 헤더
        header = " | ".join(c.ljust(col_widths[i]) for i, c in enumerate(columns))
        separator = "-+-".join("-" * w for w in col_widths)
        lines = [header, separator]
        for row in str_rows:
            line = " | ".join(
                row[i][:50].ljust(col_widths[i]) for i in range(len(columns))
            )
            lines.append(line)

        result = "\n".join(lines)
        if len(rows) >= max_rows:
            result += f"\n... (max_rows={max_rows} 제한)"
        return result

    @mcp.tool()
    def db_execute(name: str, sql: str) -> str:
        """SQL 실행 (INSERT/UPDATE/DELETE). 영향받은 행 수 반환"""
        entry = cm.get(name)
        if not entry or entry["type"] not in ("sqlserver", "sqlite", "access"):
            return f"'{name}' DB 연결을 찾을 수 없음"

        conn = entry["obj"]
        db_type = entry["type"]

        if db_type == "sqlite":
            cursor = conn.execute(sql)
            conn.commit()
            return f"실행 완료: {cursor.rowcount}행 영향"
        else:
            cursor = conn.cursor()
            cursor.execute(sql)
            rowcount = cursor.rowcount
            conn.commit()
            cursor.close()
            return f"실행 완료: {rowcount}행 영향"

    @mcp.tool()
    def db_tables(name: str) -> str:
        """DB의 테이블 목록 조회"""
        entry = cm.get(name)
        if not entry or entry["type"] not in ("sqlserver", "sqlite", "access"):
            return f"'{name}' DB 연결을 찾을 수 없음"

        conn = entry["obj"]
        db_type = entry["type"]

        if db_type == "sqlite":
            cursor = conn.execute(
                "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"
            )
            tables = [row[0] for row in cursor.fetchall()]
        elif db_type == "sqlserver":
            cursor = conn.cursor()
            cursor.execute(
                "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES "
                "WHERE TABLE_TYPE='BASE TABLE' ORDER BY TABLE_NAME"
            )
            tables = [row[0] for row in cursor.fetchall()]
            cursor.close()
        else:  # access
            cursor = conn.cursor()
            tables = [
                row.table_name
                for row in cursor.tables(tableType="TABLE")
            ]
            cursor.close()

        if not tables:
            return "테이블 없음"
        return "\n".join(tables)

    @mcp.tool()
    def db_schema(name: str, table: str) -> str:
        """테이블 스키마(컬럼 정보) 조회"""
        entry = cm.get(name)
        if not entry or entry["type"] not in ("sqlserver", "sqlite", "access"):
            return f"'{name}' DB 연결을 찾을 수 없음"

        conn = entry["obj"]
        db_type = entry["type"]

        if db_type == "sqlite":
            cursor = conn.execute(f"PRAGMA table_info('{table}')")
            lines = [f"{'컬럼':<30} {'타입':<15} {'NULL':>5} {'PK':>3}"]
            lines.append("-" * 55)
            for row in cursor.fetchall():
                lines.append(
                    f"{row[1]:<30} {row[2]:<15} {'NO' if row[3] else 'YES':>5} "
                    f"{'*' if row[5] else '':>3}"
                )
        elif db_type == "sqlserver":
            cursor = conn.cursor()
            cursor.execute(
                f"SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH "
                f"FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='{table}' "
                f"ORDER BY ORDINAL_POSITION"
            )
            lines = [f"{'컬럼':<30} {'타입':<20} {'NULL':>5}"]
            lines.append("-" * 57)
            for row in cursor.fetchall():
                type_str = row[1]
                if row[3]:
                    type_str += f"({row[3]})"
                lines.append(f"{row[0]:<30} {type_str:<20} {row[2]:>5}")
            cursor.close()
        else:  # access
            cursor = conn.cursor()
            columns = cursor.columns(table=table)
            lines = [f"{'컬럼':<30} {'타입':<20} {'크기':>8}"]
            lines.append("-" * 60)
            for col in columns:
                lines.append(f"{col.column_name:<30} {col.type_name:<20} {col.column_size or '':>8}")
            cursor.close()

        return "\n".join(lines)

    @mcp.tool()
    def db_disconnect(name: str) -> str:
        """DB 연결 해제"""
        entry = cm.get(name)
        if not entry or entry["type"] not in ("sqlserver", "sqlite", "access"):
            return f"'{name}' DB 연결을 찾을 수 없음"

        conn = entry["obj"]
        conn.close()
        cm.remove(name)
        return f"'{name}' DB 연결 해제 완료"
