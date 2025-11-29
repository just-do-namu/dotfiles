# 🔄 Git Feature Synchronizer

> **"다수의 피처 브랜치를 운영하는 환경에서, 최신 변경 사항을 안전하고 빠르게 동기화(Reverse Merge)하는 자동화 도구입니다."**

## 1. Motivation (개발 배경)
개발 환경에서는 동시에 여러 건의 기능 개발(Feature)이 병렬로 진행됩니다. 이때 `main`(또는 `develop`) 브랜치의 최신 코드를 각 피처 브랜치에 주기적으로 반영해주지 않으면, **배포 시점에 거대한 충돌(Merge Conflict Hell)**이 발생합니다.

하지만 수십 개의 브랜치를 일일이 체크아웃하고 머지하는 과정은:
1.  **시간 소모적**이며 (매일 아침 15~30분 소요),
2.  **휴먼 에러**가 발생하기 쉽습니다. (브랜치 누락, 머지 순서 실수 등)

이러한 **비효율적인 반복 작업(Toil)을 제거**하기 위해 이 스크립트를 제작했습니다.

---

## 2. Key Features (핵심 기능)

### ✅ Auto Discovery (자동 감지)
- 하드코딩된 브랜치 리스트를 사용하지 않습니다.
- 현재 로컬 저장소에 존재하는 모든 브랜치를 동적으로 감지하여 순회합니다.

### 🛡️ Conflict Safety (충돌 방지 시스템)
- 병합 중 충돌(Conflict)이 발생하면 스크립트가 멈추거나 터지지 않습니다.
- 해당 브랜치의 병합을 즉시 중단(`git merge --abort`)하고 **Skipping** 처리한 뒤, 다음 브랜치로 넘어갑니다.
- 개발자는 작업 완료 후 **실패한 브랜치만 확인**하면 됩니다.

### 🚀 Batch Mode (일괄 처리)
- 기본적으로는 각 브랜치마다 병합 여부를 묻지만(Interactive), `-y` 옵션을 통해 모든 브랜치를 한 번에 처리할 수 있습니다.

---

## 3. Usage (사용법)

# 1. 인터랙티브 모드 (브랜치마다 y/n 확인)
~/dotfiles/scripts/git-feature-sync/git-feature-sync.sh

# 2. 자동 모드 (모든 브랜치 일괄 병합)
~/dotfiles/scripts/git-feature-sync/git-feature-sync.sh -y

### 사전 준비 (Permission)
스크립트에 실행 권한을 부여합니다.
```bash
chmod +x git-feature-sync.sh