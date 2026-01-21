/**
 * JavaScript 기초 실습 테스트
 */
const {
  sum,
  filterEven,
  squareAll,
  joinStrings,
  pluck,
  intersection,
} = require("../exercises/javascript/01_basics");

let passed = 0;
let failed = 0;

function test(name, fn) {
  try {
    fn();
    console.log(`✓ ${name} 통과`);
    passed++;
  } catch (e) {
    console.log(`✗ ${name} 실패: ${e.message}`);
    failed++;
  }
}

function assertEqual(actual, expected, msg = "") {
  const actualStr = JSON.stringify(actual);
  const expectedStr = JSON.stringify(expected);
  if (actualStr !== expectedStr) {
    throw new Error(`${msg} 예상: ${expectedStr}, 실제: ${actualStr}`);
  }
}

// 테스트 실행
test("sum", () => {
  assertEqual(sum([1, 2, 3, 4, 5]), 15);
  assertEqual(sum([]), 0);
  assertEqual(sum([-1, 1]), 0);
});

test("filterEven", () => {
  assertEqual(filterEven([1, 2, 3, 4, 5, 6]), [2, 4, 6]);
  assertEqual(filterEven([1, 3, 5]), []);
});

test("squareAll", () => {
  assertEqual(squareAll([1, 2, 3]), [1, 4, 9]);
  assertEqual(squareAll([]), []);
});

test("joinStrings", () => {
  assertEqual(joinStrings(["a", "b", "c"]), "a, b, c");
  assertEqual(joinStrings(["a", "b"], "-"), "a-b");
});

test("pluck", () => {
  assertEqual(
    pluck([{ name: "Alice" }, { name: "Bob" }], "name"),
    ["Alice", "Bob"]
  );
});

test("intersection", () => {
  assertEqual(intersection([1, 2, 3], [2, 3, 4]), [2, 3]);
  assertEqual(intersection([1, 2], [3, 4]), []);
});

console.log(`\n결과: ${passed}/${passed + failed} 통과`);
