/**
 * 클로드 스킬 실습 - JavaScript 객체 다루기
 *
 * 객체 조작, 복사, 변환 등을 다루는 실습입니다.
 */

/**
 * 객체를 깊은 복사합니다.
 * @param {Object} obj - 복사할 객체
 * @returns {Object} 복사된 객체
 */
function deepClone(obj) {
  // TODO: 구현하세요
}

/**
 * 두 객체를 깊은 병합합니다.
 * @param {Object} target - 대상 객체
 * @param {Object} source - 소스 객체
 * @returns {Object} 병합된 객체
 */
function deepMerge(target, source) {
  // TODO: 구현하세요
}

/**
 * 중첩된 객체에서 경로로 값을 가져옵니다.
 * @param {Object} obj - 객체
 * @param {string} path - 경로 (예: "a.b.c")
 * @param {any} defaultValue - 기본값
 * @returns {any} 값
 *
 * @example
 * getNestedValue({a: {b: {c: 1}}}, 'a.b.c')
 * // => 1
 */
function getNestedValue(obj, path, defaultValue = undefined) {
  // TODO: 구현하세요
}

/**
 * 중첩된 객체에 경로로 값을 설정합니다.
 * @param {Object} obj - 객체
 * @param {string} path - 경로
 * @param {any} value - 설정할 값
 * @returns {Object} 수정된 객체
 */
function setNestedValue(obj, path, value) {
  // TODO: 구현하세요
}

/**
 * 객체에서 지정된 키들만 선택합니다.
 * @param {Object} obj - 객체
 * @param {string[]} keys - 선택할 키들
 * @returns {Object} 선택된 객체
 */
function pick(obj, keys) {
  // TODO: 구현하세요
}

/**
 * 객체에서 지정된 키들을 제외합니다.
 * @param {Object} obj - 객체
 * @param {string[]} keys - 제외할 키들
 * @returns {Object} 제외된 객체
 */
function omit(obj, keys) {
  // TODO: 구현하세요
}

/**
 * 객체의 키와 값을 뒤바꿉니다.
 * @param {Object} obj - 객체
 * @returns {Object} 반전된 객체
 */
function invert(obj) {
  // TODO: 구현하세요
}

module.exports = {
  deepClone,
  deepMerge,
  getNestedValue,
  setNestedValue,
  pick,
  omit,
  invert,
};
