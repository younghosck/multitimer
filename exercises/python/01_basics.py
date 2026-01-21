"""
클로드 스킬 실습 - Python 기초

이 파일의 함수들을 완성하세요.
클로드에게 도움을 요청할 수 있습니다!

실습 방법:
1. 각 함수의 TODO를 확인하세요
2. 클로드에게 "01_basics.py의 add_numbers 함수를 구현해줘" 라고 요청하세요
3. 테스트를 실행하여 확인하세요: python -m pytest tests/test_python_basics.py
"""


def add_numbers(a: int, b: int) -> int:
    """두 숫자를 더합니다.

    Args:
        a: 첫 번째 숫자
        b: 두 번째 숫자

    Returns:
        두 숫자의 합
    """
    # TODO: 구현하세요
    pass


def reverse_string(text: str) -> str:
    """문자열을 뒤집습니다.

    Args:
        text: 뒤집을 문자열

    Returns:
        뒤집힌 문자열

    Example:
        >>> reverse_string("hello")
        "olleh"
    """
    # TODO: 구현하세요
    pass


def find_max(numbers: list[int]) -> int | None:
    """리스트에서 가장 큰 숫자를 찾습니다.

    Args:
        numbers: 정수 리스트

    Returns:
        가장 큰 숫자, 빈 리스트면 None
    """
    # TODO: 구현하세요
    pass


def is_palindrome(text: str) -> bool:
    """문자열이 회문(팰린드롬)인지 확인합니다.

    대소문자를 구분하지 않고, 공백을 무시합니다.

    Args:
        text: 확인할 문자열

    Returns:
        회문이면 True, 아니면 False

    Example:
        >>> is_palindrome("A man a plan a canal Panama")
        True
    """
    # TODO: 구현하세요
    pass


def fizzbuzz(n: int) -> list[str]:
    """1부터 n까지 FizzBuzz를 생성합니다.

    - 3의 배수: "Fizz"
    - 5의 배수: "Buzz"
    - 3과 5의 배수: "FizzBuzz"
    - 그 외: 숫자 문자열

    Args:
        n: 끝 숫자

    Returns:
        FizzBuzz 결과 리스트
    """
    # TODO: 구현하세요
    pass
