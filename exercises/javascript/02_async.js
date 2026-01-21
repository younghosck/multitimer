/**
 * 클로드 스킬 실습 - JavaScript 비동기 처리
 *
 * Promise와 async/await를 다루는 실습입니다.
 */

/**
 * 지정된 시간 후에 resolve되는 Promise를 반환합니다.
 * @param {number} ms - 대기 시간 (밀리초)
 * @returns {Promise<void>}
 */
function delay(ms) {
  // TODO: 구현하세요
}

/**
 * 주어진 값을 비동기로 반환합니다.
 * @param {any} value - 반환할 값
 * @returns {Promise<any>}
 */
async function asyncReturn(value) {
  // TODO: 구현하세요
}

/**
 * 여러 Promise를 병렬로 실행하고 모든 결과를 반환합니다.
 * @param {Promise[]} promises - Promise 배열
 * @returns {Promise<any[]>} 모든 결과
 */
async function runAll(promises) {
  // TODO: 구현하세요
}

/**
 * 여러 Promise 중 가장 먼저 완료되는 결과를 반환합니다.
 * @param {Promise[]} promises - Promise 배열
 * @returns {Promise<any>} 첫 번째 결과
 */
async function runFirst(promises) {
  // TODO: 구현하세요
}

/**
 * 실패할 수 있는 작업을 재시도합니다.
 * @param {Function} fn - 실행할 함수 (Promise 반환)
 * @param {number} maxRetries - 최대 재시도 횟수
 * @returns {Promise<any>} 성공 결과
 */
async function retry(fn, maxRetries = 3) {
  // TODO: 구현하세요
}

/**
 * 배열의 각 요소에 대해 비동기 함수를 순차적으로 실행합니다.
 * @param {any[]} items - 처리할 배열
 * @param {Function} asyncFn - 비동기 함수
 * @returns {Promise<any[]>} 결과 배열
 */
async function mapSequential(items, asyncFn) {
  // TODO: 구현하세요
}

module.exports = {
  delay,
  asyncReturn,
  runAll,
  runFirst,
  retry,
  mapSequential,
};
