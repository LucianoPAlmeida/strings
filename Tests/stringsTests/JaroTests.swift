//
//  JaroTests.swift
//  
//
//  Created by Luciano Almeida on 12/02/21.
//

import Testing
import strings
import Numerics

struct JaroTests {
  static let jaroValues: [DistanceExpectation<Double>] = [
    DistanceExpectation(source: "friend", target: "fresh", expectedValue: 0.70),
    DistanceExpectation(source: "friend", target: "friend", expectedValue: 1),
    DistanceExpectation(source: "friend", target: "fried", expectedValue: 0.9444),
    DistanceExpectation(source: "rick", target: "rcik", expectedValue: 0.9166),
    DistanceExpectation(source: "rick", target: "irkc", expectedValue: 0.8333),
    DistanceExpectation(source: "", target: "team", expectedValue: 0),
    DistanceExpectation(source: "team", target: "", expectedValue: 0),
    DistanceExpectation(source: "adlsajdlsa", target: "asv", expectedValue: 0.6222),
    DistanceExpectation(source: "DwAyNE", target: "DuANE", expectedValue: 0.822222)
  ]

  static let jaroWinklerValues: [DistanceExpectation<Double>] = [
    DistanceExpectation(source: "friend", target: "fresh", expectedValue: 0.760),
    DistanceExpectation(source: "friend", target: "friend", expectedValue: 1),
    DistanceExpectation(source: "friend", target: "fried", expectedValue: 0.9666),
    DistanceExpectation(source: "rick", target: "rcik", expectedValue: 0.9249),
    DistanceExpectation(source: "rick", target: "irkc", expectedValue: 0.8333),
    DistanceExpectation(source: "", target: "team", expectedValue: 0),
    DistanceExpectation(source: "team", target: "", expectedValue: 0),
    DistanceExpectation(source: "adlsajdlsa", target: "asv", expectedValue: 0.6222),
    DistanceExpectation(source: "DwAyNE", target: "DuANE", expectedValue: 0.840),
    DistanceExpectation(source: "TRATE", target: "TRACE", expectedValue: 0.906667)

  ]

  @Test(arguments: jaroValues)
  func testJaroDistances(expectation: DistanceExpectation<Double>) {
    #expect(expectation.source.jaroDistance(to: expectation.target)
      .isApproximatelyEqual(to: expectation.expectedValue, absoluteTolerance: 0.0001))
  }

  @Test(arguments: jaroWinklerValues)
  func testJaroWinklerDistances(expectation: DistanceExpectation<Double>) {
    #expect(expectation.source.jaroWinklerDistance(to: expectation.target)
      .isApproximatelyEqual(to: expectation.expectedValue, absoluteTolerance: 0.0001))
  }

  @Test
  func testJaroWinlerDistanceWithScaling() {
    #expect("TRATE".jaroWinklerDistance(to: "TRACE", scaling: 0.2)
      .isApproximatelyEqual(to: 0.9466, absoluteTolerance: 0.0001))
  }
}
