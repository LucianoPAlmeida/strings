//
//  File.swift
//  
//
//  Created by Luciano Almeida on 16/03/21.
//

import Testing
import strings

struct HammingTests {
  static let values: [DistanceExpectation<Int>] = [
    DistanceExpectation(source: "friend", target: "friend", expectedValue: 0),
    DistanceExpectation(source: "friend", target: "frinnd", expectedValue: 1),
    DistanceExpectation(source: "test", target: "team", expectedValue: 2),
    DistanceExpectation(source: "", target: "", expectedValue: 0)
  ]

  @Test(arguments: values)
  func testHammingDistances(expectation: DistanceExpectation<Int>) {
    #expect(expectation.source.hammingDistance(to: expectation.target) == expectation.expectedValue)
  }
}
