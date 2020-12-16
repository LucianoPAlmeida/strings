import XCTest

import stringsTests

var tests = [XCTestCaseEntry]()
tests += stringsTests.allTests()
XCTMain(tests)
