/**
 * 클로드 스킬 실습 - JavaScript 기초
 *
 * 이 파일의 함수들을 완성하세요.
 * 클로드에게 도움을 요청할 수 있습니다!
 *
 * 실습 방법:
 * 1. 각 함수의 TODO를 확인하세요
 * 2. 클로드에게 "01_basics.js의 sum 함수를 구현해줘" 라고 요청하세요
 * 3. 테스트 실행: node tests/test_js_basics.js
 */

/**
 * 배열의 합계를 계산합니다.
 * @param {number[]} numbers - 숫자 배열
 * @returns {number} 합계
 */
function sum(numbers) {
  // TODO: 구현하세요
}

/**
 * 배열에서 짝수만 필터링합니다.
 * @param {number[]} numbers - 숫자 배열
 * @returns {number[]} 짝수 배열
 */
function filterEven(numbers) {
  // TODO: 구현하세요
}

/**
 * 배열의 각 요소를 제곱합니다.
 * @param {number[]} numbers - 숫자 배열
 * @returns {number[]} 제곱된 배열
 */
function squareAll(numbers) {
  // TODO: 구현하세요
}

/**
 * 문자열 배열을 하나로 합칩니다.
 * @param {string[]} strings - 문자열 배열
 * @param {string} separator - 구분자
 * @returns {string} 합쳐진 문자열
 */
function joinStrings(strings, separator = ", ") {
  // TODO: 구현하세요
}

/**
 * 객체 배열에서 특정 속성값만 추출합니다.
 * @param {Object[]} objects - 객체 배열
 * @param {string} key - 추출할 키
 * @returns {any[]} 속성값 배열
 *
 * @example
 * pluck([{name: 'Alice'}, {name: 'Bob'}], 'name')
 * // => ['Alice', 'Bob']
 */
function pluck(objects, key) {
  // TODO: 구현하세요
}

/**
 * 두 배열의 교집합을 구합니다.
 * @param {any[]} arr1 - 첫 번째 배열
 * @param {any[]} arr2 - 두 번째 배열
 * @returns {any[]} 교집합
 */
function intersection(arr1, arr2) {
  // TODO: 구현하세요
}

module.exports = {
  sum,
  filterEven,
  squareAll,
  joinStrings,
  pluck,
  intersection,
};
