#!/bin/bash
# 클로드 스킬 실습 - Bash 스크립팅
#
# 각 함수를 완성하세요.
# 클로드에게 "count_files 함수를 구현해줘" 라고 요청할 수 있습니다.

# 1. 디렉토리의 파일 개수를 세는 함수
count_files() {
    local dir="$1"
    # TODO: 구현하세요
}

# 2. 특정 확장자를 가진 파일 찾기
find_by_extension() {
    local dir="$1"
    local ext="$2"
    # TODO: 구현하세요
}

# 3. 파일 백업 (날짜 접미사 추가)
backup_file() {
    local file="$1"
    # TODO: 파일명_YYYYMMDD.확장자 형식으로 복사
}

# 4. 디렉토리 크기 확인 (MB 단위)
dir_size_mb() {
    local dir="$1"
    # TODO: 구현하세요
}

# 5. 로그 파일에서 에러 라인 추출
extract_errors() {
    local logfile="$1"
    # TODO: ERROR 또는 error가 포함된 라인 출력
}

# 6. CSV 파일의 특정 열 추출
extract_column() {
    local csvfile="$1"
    local column="$2"
    # TODO: 구현하세요
}

# 7. 프로세스가 실행 중인지 확인
is_process_running() {
    local process_name="$1"
    # TODO: 실행 중이면 0, 아니면 1 반환
}

# 8. 오래된 파일 정리 (N일 이상)
cleanup_old_files() {
    local dir="$1"
    local days="$2"
    # TODO: 구현하세요 (삭제 전 확인 메시지 출력)
}

# 테스트 실행
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "=== Bash 스크립트 테스트 ==="
    echo "count_files: $(count_files .)"
    echo "dir_size_mb: $(dir_size_mb .)"
fi
