# 📊 Log to SQLite Parser

## Overview
대용량 텍스트 로그 파일을 파싱하여 **SQLite 데이터베이스**로 변환하는 도구입니다.

## Motivation
- 단순 텍스트 검색(grep)으로는 복잡한 트랜잭션 흐름이나 특정 에러 패턴을 분석하기 어렵습니다.
- 로그를 DB화하여 **SQL 쿼리**로 특정 조건의 데이터를 빠르게 추출하기 위해 제작하였습니다.

## Usage
```bash
python3 log-parser.py test.log
# 생성된 parsed_logs.db 파일을 DB 브라우저로 열어서 분석
