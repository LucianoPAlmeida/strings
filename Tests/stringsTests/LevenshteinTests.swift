//
//
// LevenshteinTests.swift
//  
//
//  Created by Luciano Almeida on 15/12/20.
//
import Testing
import strings

struct LevenshteinTests {
  static let values: [DistanceExpectation<Int>] = [
    DistanceExpectation(source: "friend", target: "", expectedValue: 6),
    DistanceExpectation(source: "friend", target: "fresh", expectedValue: 3),
    DistanceExpectation(source: "friend", target: "friend", expectedValue: 0),
    DistanceExpectation(source: "friend", target: "fried", expectedValue: 1),
    DistanceExpectation(source: "rick", target: "rcik", expectedValue: 2),
    DistanceExpectation(source: "rick", target: "irkc", expectedValue: 3),
    DistanceExpectation(source: "irkc", target: "rcik", expectedValue: 4),
    DistanceExpectation(source: "test", target: "team", expectedValue: 2),
    DistanceExpectation(source: "", target: "team", expectedValue: 4),
    DistanceExpectation(source: "test", target: "", expectedValue: 4),
    DistanceExpectation(source: "adlsajdlsa", target: "asv", expectedValue: 8)
  ]

  @Test(arguments: values)
  func testLevenshteinDistances(expectation: DistanceExpectation<Int>) {
    #expect(expectation.source.levenshteinDistance(to: expectation.target) == expectation.expectedValue)
  }
}
