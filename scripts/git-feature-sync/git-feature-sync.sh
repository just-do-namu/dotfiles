#!/bin/bash

# [설정] 작업할 디렉토리 (현재 위치 기준)
REPO_DIR=$(pwd)
SOURCE_BRANCH="main"
AUTO_Y=false

echo "📂 Working Directory: $REPO_DIR"

# 옵션 파싱 (-y: 자동 모드)
while getopts "y" opt; do
  case $opt in
    y)
      AUTO_Y=true
      ;;
    *)
      echo "❗ Usage: $0 [-y]"
      exit 1
      ;;
  esac
done

# 깃 정보 갱신
git fetch origin

# 최신 소스 브랜치(main) pull
git checkout "$SOURCE_BRANCH"
git pull origin "$SOURCE_BRANCH"

# 로컬의 Feature 브랜치 목록 추출
LOCAL_FEATURE_BRANCHES=$(git branch --format="%(refname:short)")
ALL_FEATURE_BRANCHES=$(echo "${LOCAL_FEATURE_BRANCHES}" | sort -u)

echo "🔍 Detected Feature Branches:"
echo "$ALL_FEATURE_BRANCHES"
echo ""

MERGED_BRANCHES=()
FAILED_BRANCHES=()

# 병합 루프 시작
for branch in $ALL_FEATURE_BRANCHES; do
  # main 브랜치는 건너뜀
  if [ "$branch" == "$SOURCE_BRANCH" ]; then continue; fi

  echo "🔀 Merging $SOURCE_BRANCH into -> $branch"

  if [ "$AUTO_Y" = false ]; then
    read -p "❓ Proceed? (y/n/all): " answer
    if [[ "$answer" == "all" ]]; then
      AUTO_Y=true
    elif [[ "$answer" != "y" && "$answer" != "Y" ]]; then
      echo "⏩ Skipped: $branch"
      continue
    fi
  fi

  git checkout "$branch"
  git pull origin "$branch"

  if git merge "$SOURCE_BRANCH" -m "chore: Auto-sync from $SOURCE_BRANCH"; then
    MERGED_BRANCHES+=("$branch")
    echo "✅ Success: $branch"
  else
    FAILED_BRANCHES+=("$branch")
    echo "⚠️ Conflict: $branch (Skipping...)"
    git merge --abort # 충돌 시 롤백
  fi
  echo ""
done

# 결과 리포트
echo "=============================="
echo "📝 Summary"
if [[ ${#MERGED_BRANCHES[@]} -gt 0 ]]; then
  echo "✅ Merged: ${MERGED_BRANCHES[@]}"
fi
if [[ ${#FAILED_BRANCHES[@]} -gt 0 ]]; then
  echo "🚨 Failed: ${FAILED_BRANCHES[@]}"
fi
echo "=============================="