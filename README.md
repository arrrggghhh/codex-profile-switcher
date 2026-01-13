# codex-profile-switcher

`~/.codex_*` 프로필 디렉터리에서 원하는 `auth.json`을 선택해 `~/.codex/auth.json`으로 복사한 뒤, `codex`를 실행하는 스크립트입니다.

## 요구 사항

- `codex` CLI가 PATH에 있어야 합니다.
- 각 프로필 디렉터리는 `~/.codex_*` 형태이며 `auth.json`을 포함해야 합니다.

## 사용법

```sh
./codex-profile-switcher.sh
```

실행하면 `~/.codex_*` 목록이 출력되고 번호를 입력해 선택합니다. 선택된 프로필의 `auth.json`이 `~/.codex/auth.json`으로 복사된 뒤 `codex`가 실행됩니다.

`codex`에 전달할 인자가 있으면 그대로 넘길 수 있습니다.

```sh
./codex-profile-switcher.sh --help
```

## ignore 파일 사용법

스크립트와 같은 디렉터리에 `.codex_ignore` 파일을 두면 특정 프로필을 목록에서 제외할 수 있습니다.

- 한 줄에 하나씩 경로 또는 디렉터리 이름을 작성합니다.
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
