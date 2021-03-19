import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
  return [
    testCase(LevenshteinTests.allTests),
    testCase(JaroTests.allTests),
    testCase(HammingTests.allTests)
  ]
}
#endif
