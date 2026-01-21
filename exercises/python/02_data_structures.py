"""
클로드 스킬 실습 - Python 자료구조

딕셔너리, 리스트, 집합 등을 다루는 실습입니다.
"""


def count_words(text: str) -> dict[str, int]:
    """텍스트에서 단어 빈도를 계산합니다.

    Args:
        text: 분석할 텍스트

    Returns:
        단어별 출현 횟수 딕셔너리

    Example:
        >>> count_words("hello world hello")
        {"hello": 2, "world": 1}
    """
    # TODO: 구현하세요
    pass


def merge_dicts(dict1: dict, dict2: dict) -> dict:
    """두 딕셔너리를 병합합니다.

    같은 키가 있으면 값을 더합니다 (숫자인 경우).

    Args:
        dict1: 첫 번째 딕셔너리
        dict2: 두 번째 딕셔너리

    Returns:
        병합된 딕셔너리
    """
    # TODO: 구현하세요
    pass


def find_duplicates(items: list) -> list:
    """리스트에서 중복된 항목을 찾습니다.

    Args:
        items: 검사할 리스트

    Returns:
        중복된 항목들의 리스트
    """
    # TODO: 구현하세요
    pass


def flatten_list(nested: list) -> list:
    """중첩된 리스트를 평탄화합니다.

    Args:
        nested: 중첩된 리스트

    Returns:
        평탄화된 1차원 리스트

    Example:
        >>> flatten_list([[1, 2], [3, [4, 5]]])
        [1, 2, 3, 4, 5]
    """
    # TODO: 구현하세요
    pass


def group_by(items: list[dict], key: str) -> dict[str, list]:
    """딕셔너리 리스트를 특정 키로 그룹화합니다.

    Args:
        items: 딕셔너리 리스트
        key: 그룹화할 키

    Returns:
        그룹화된 딕셔너리

    Example:
        >>> items = [{"name": "Alice", "dept": "HR"}, {"name": "Bob", "dept": "HR"}]
        >>> group_by(items, "dept")
        {"HR": [{"name": "Alice", "dept": "HR"}, {"name": "Bob", "dept": "HR"}]}
    """
    # TODO: 구현하세요
    pass
