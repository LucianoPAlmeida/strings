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
      XCTAssertEqual(Levenshtein("friend").distance(to: "fresh"), 3)
      XCTAssertEqual(Levenshtein("friend").distance(to: "friend"), 0)
      XCTAssertEqual(Levenshtein("friend").distance(to: "fried"), 1)
      XCTAssertEqual(Levenshtein("rick").distance(to: "rcik"), 2)
      XCTAssertEqual(Levenshtein("rick").distance(to: "irkc"), 3)
      XCTAssertEqual(Levenshtein("irkc").distance(to: "rcik"), 4)
      XCTAssertEqual(Levenshtein("test").distance(to: "team"), 2)
      XCTAssertEqual(Levenshtein("").distance(to: "team"), 4)
      XCTAssertEqual(Levenshtein("test").distance(to: ""), 4)
      XCTAssertEqual(Levenshtein("adlsajdlsa").distance(to: "asv"), 8)
    }

    static var allTests = [
        ("testLevenshteinDistances", testLevenshteinDistances),
    ]
}
