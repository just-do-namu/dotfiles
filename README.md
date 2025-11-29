# dotfiles

개발 환경 및 개인 자동화를 모아둔 저장소입니다.

## Structure

- **nvim**  
  Neovim 설정 (lazy.nvim 기반)

- **vscode**  
  VSCode 설정 및 확장 자동 설치 스크립트

- **scripts**
  - **git-feature-sync**  
    main 브랜치 변경분을 feature 브랜치들에 일괄 머지하는 자동화 스크립트
  - **log-parser**  
    특정 로그 패턴을 SQLite DB로 추출하여 분석할 수 있도록 정리하는 도구

## Examples
산출물(DB, CSV, log 파일 등)은 이해를 위해 `examples/` 폴더에 정리했습니다.  
실제 프로젝트 데이터와는 무관한 예시 파일입니다.
