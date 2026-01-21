# 클로드 스킬 실습 환경

클로드 AI와 함께 프로그래밍 실습을 할 수 있는 환경입니다.

## 프로젝트 구조

```
├── exercises/
│   ├── python/          # Python 실습
│   │   ├── 01_basics.py         # 기초 함수
│   │   ├── 02_data_structures.py # 자료구조
│   │   └── 03_algorithms.py      # 알고리즘
│   ├── javascript/      # JavaScript 실습
│   │   ├── 01_basics.js         # 기초 함수
│   │   ├── 02_async.js          # 비동기 처리
│   │   └── 03_objects.js        # 객체 다루기
│   ├── sql/             # SQL 실습
│   │   └── 01_queries.sql       # 쿼리 작성
│   └── bash/            # Bash 실습
│       └── 01_scripts.sh        # 스크립트 작성
├── tests/               # 테스트 파일
├── solutions/           # 정답 (직접 풀어보세요!)
└── README.md
```

## 실습 방법

### 1. 함수 구현 요청하기

```
클로드: exercises/python/01_basics.py의 add_numbers 함수를 구현해줘
```

### 2. 코드 설명 요청하기

```
클로드: 이 코드가 어떻게 동작하는지 설명해줘
```

### 3. 테스트 실행 요청하기

```
클로드: Python 기초 테스트를 실행해줘
```

### 4. 버그 수정 요청하기

```
클로드: 이 함수에 버그가 있어. 찾아서 수정해줘
```

### 5. 코드 개선 요청하기

```
클로드: 이 코드를 더 효율적으로 개선해줘
```

## 클로드 스킬 목록

### 코드 작성
- 함수/클래스 구현
- 알고리즘 구현
- API 연동

### 코드 분석
- 버그 찾기
- 코드 리뷰
- 복잡도 분석

### 리팩토링
- 코드 정리
- 성능 개선
- 패턴 적용

### 테스트
- 단위 테스트 작성
- 테스트 실행
- 커버리지 분석

### 문서화
- 주석 추가
- README 작성
- API 문서화

### Git 작업
- 커밋 메시지 작성
- 브랜치 관리
- PR 생성

## 테스트 실행

### Python
```bash
python tests/test_python_basics.py
```

### JavaScript
```bash
node tests/test_js_basics.js
```

## 실습 예시

### 예시 1: 함수 구현
```
사용자: exercises/python/01_basics.py의 is_palindrome 함수를 구현해줘

클로드: [함수 구현 후]
def is_palindrome(text: str) -> bool:
    cleaned = ''.join(c.lower() for c in text if c.isalnum())
    return cleaned == cleaned[::-1]
```

### 예시 2: 버그 수정
```
사용자: 이 함수가 제대로 동작하지 않아:
def find_max(numbers):
    max_val = 0
    for n in numbers:
        if n > max_val:
            max_val = n
    return max_val

클로드: 버그를 찾았습니다! 초기값이 0이라 음수만 있는 경우 잘못된 결과가 나옵니다.
수정된 코드:
def find_max(numbers):
    if not numbers:
        return None
    max_val = numbers[0]
    for n in numbers[1:]:
        if n > max_val:
            max_val = n
    return max_val
```

## 난이도별 추천

### 초급
- `exercises/python/01_basics.py`
- `exercises/javascript/01_basics.js`

### 중급
- `exercises/python/02_data_structures.py`
- `exercises/javascript/02_async.js`

### 고급
- `exercises/python/03_algorithms.py`
- `exercises/javascript/03_objects.js`

---

즐거운 코딩 되세요!
