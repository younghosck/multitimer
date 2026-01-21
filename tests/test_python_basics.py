"""Python 기초 실습 테스트"""
import sys
sys.path.insert(0, '..')

from exercises.python.basics_01 import (
    add_numbers,
    reverse_string,
    find_max,
    is_palindrome,
    fizzbuzz,
)


def test_add_numbers():
    assert add_numbers(1, 2) == 3
    assert add_numbers(-1, 1) == 0
    assert add_numbers(0, 0) == 0
    print("✓ add_numbers 통과")


def test_reverse_string():
    assert reverse_string("hello") == "olleh"
    assert reverse_string("") == ""
    assert reverse_string("a") == "a"
    print("✓ reverse_string 통과")


def test_find_max():
    assert find_max([1, 5, 3, 9, 2]) == 9
    assert find_max([-1, -5, -3]) == -1
    assert find_max([]) is None
    print("✓ find_max 통과")


def test_is_palindrome():
    assert is_palindrome("racecar") is True
    assert is_palindrome("A man a plan a canal Panama") is True
    assert is_palindrome("hello") is False
    print("✓ is_palindrome 통과")


def test_fizzbuzz():
    result = fizzbuzz(15)
    assert result[2] == "Fizz"  # 3
    assert result[4] == "Buzz"  # 5
    assert result[14] == "FizzBuzz"  # 15
    assert result[0] == "1"
    print("✓ fizzbuzz 통과")


if __name__ == "__main__":
    tests = [
        test_add_numbers,
        test_reverse_string,
        test_find_max,
        test_is_palindrome,
        test_fizzbuzz,
    ]

    passed = 0
    failed = 0

    for test in tests:
        try:
            test()
            passed += 1
        except (AssertionError, TypeError) as e:
            print(f"✗ {test.__name__} 실패: {e}")
            failed += 1

    print(f"\n결과: {passed}/{len(tests)} 통과")
