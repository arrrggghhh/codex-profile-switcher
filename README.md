# codex-profile-switcher

여러 `~/.codex_*` 프로필 중 하나를 선택해 `CODEX_HOME`을 설정하고 `codex`를 실행하는 스크립트입니다. `auth.json`을 복사하지 않고 **선택한 프로필 디렉터리를 그대로 사용**합니다.

## 요구 사항

- `codex` CLI가 PATH에 있어야 합니다.
- `~/.codex_*` 형태의 프로필 디렉터리가 있어야 합니다.
  - 각 프로필에 필요한 설정 파일(`auth.json` 등)은 사용 환경에 맞게 준비되어 있어야 합니다.

## 사용법

```sh
./codex-profile-switcher.sh
```

실행하면 `~/.codex_*` 목록이 번호와 함께 출력됩니다. 번호를 입력하면 다음과 같이 동작합니다.

- 선택한 디렉터리를 `CODEX_HOME`으로 설정
- `codex`를 `exec`로 실행(현재 프로세스 대체)

`codex`에 인자를 넘길 때는 그대로 전달됩니다.

```sh
./codex-profile-switcher.sh --help
```

## 프로필 목록 제외 (.codex_ignore)

스크립트와 같은 디렉터리에 `.codex_ignore` 파일을 두면 특정 프로필을 목록에서 제외할 수 있습니다.

- 한 줄에 하나씩 경로나 디렉터리 이름을 작성합니다.
- 공백 줄과 `#`로 시작하는 주석 줄은 무시합니다.
- `~/`로 시작하는 경로는 홈 디렉터리로 확장됩니다.
- 절대 경로(`$HOME/.codex_work`) 또는 이름만(`.codex_work`) 모두 지원합니다.

예시:

```text
# 업무용 프로필 제외
.codex_work

# 절대 경로로 제외
~/.codex_legacy
```

## 프로필 설명 표시 (.cps_note.txt)

각 프로필 디렉터리에 `.cps_note.txt`를 두면 목록에 설명이 함께 표시됩니다. 첫 줄만 사용합니다.

```sh
echo "회사 계정" > ~/.codex_work/.cps_note.txt
```

## 동작 요약

- `~/.codex_*` 디렉터리를 검색
- `.codex_ignore`에 포함된 항목을 제외
- 목록을 보여주고 번호 입력을 받음
- `CODEX_HOME=선택한_디렉터리`로 `codex` 실행

## 오류 메시지

- `No ~/.codex_* directories found.`: 프로필 디렉터리가 없을 때
- `Invalid input: expected a number.`: 숫자가 아닌 입력
- `Invalid selection.`: 범위를 벗어난 번호
