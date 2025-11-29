import re, sys, sqlite3
from datetime import datetime
from pathlib import Path

# [설정] 로그 패턴 (범용 포맷)
# 예: 2024-01-01 12:00:00.000 [CODE1234] ...

# ⚠️ 프로젝트마다 다를 수 있으니 필요시 수정 필요
PATTERN = re.compile(
    r'^(?P<ts>\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3}).*?'
    r'(?P<code>[A-Z]{3,}\d{4}).*?'  # TRCODE 등 식별자
    r'(?P<data>\{.*?\})',           # JSON 데이터 등
    re.DOTALL
)

# DB 파일 생성 위치 (현재 실행 위치)
DB_PATH = Path("parsed_logs.db")

def parse_line(line: str):
    m = PATTERN.search(line)
    if not m: return None
    return m.group('ts'), m.group('code'), m.group('data')

def main(infile):
    con = sqlite3.connect(DB_PATH)
    cur = con.cursor()
    cur.execute("""
    CREATE TABLE IF NOT EXISTS logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ts TEXT,
        code TEXT,
        data TEXT
    );""")

    print(f"🔄 Parsing {infile} -> {DB_PATH} ...")
    
    with open(infile, 'r', encoding='utf-8') as f:
        for line in f:
            rec = parse_line(line)
            if rec:
                cur.execute("INSERT INTO logs (ts, code, data) VALUES (?, ?, ?)", rec)
    
    con.commit()
    print("✅ Done! Data saved to SQLite.")
    con.close()

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 log-parser.py <input.log>")
        sys.exit(1)
    main(sys.argv[1])