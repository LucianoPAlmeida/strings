//
//
// LevenshteinTests.swift
//  
//
//  Created by Luciano Almeida on 15/12/20.
//
import XCTest

@testable import strings

final class LevenshteinTests: XCTestCase {

  func testLevenshteinDistances() {
    XCTAssertEqual("friend".levenshteinDistance(to: "fresh"), 3)
    XCTAssertEqual("friend".levenshteinDistance(to: "friend"), 0)
    XCTAssertEqual("friend".levenshteinDistance(to: "fried"), 1)
    XCTAssertEqual("rick".levenshteinDistance(to: "rcik"), 2)
    XCTAssertEqual("rick".levenshteinDistance(to: "irkc"), 3)
    XCTAssertEqual("irkc".levenshteinDistance(to: "rcik"), 4)
    XCTAssertEqual("test".levenshteinDistance(to: "team"), 2)
    XCTAssertEqual("".levenshteinDistance(to: "team"), 4)
    XCTAssertEqual("test".levenshteinDistance(to: ""), 4)
    XCTAssertEqual("adlsajdlsa".levenshteinDistance(to: "asv"), 8)
  }

  static var allTests = [
    ("testLevenshteinDistances", testLevenshteinDistances),
  ]
}
