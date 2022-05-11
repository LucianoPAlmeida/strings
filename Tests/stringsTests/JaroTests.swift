//
//  JaroTests.swift
//  
//
//  Created by Luciano Almeida on 12/02/21.
//

import XCTest
import strings

final class JaroTests: XCTestCase {

  func testJaroDistances() {
    XCTAssertEqual(0.70, "friend".jaroDistance(to: "fresh"), accuracy: 0.0001)
    XCTAssertEqual(1, "friend".jaroDistance(to: "friend"), accuracy: 0.0001)
    XCTAssertEqual(0.9444, "friend".jaroDistance(to: "fried"), accuracy: 0.0001)
    XCTAssertEqual(0.9166, "rick".jaroDistance(to: "rcik"), accuracy: 0.0001)
    XCTAssertEqual(0.8333, "rick".jaroDistance(to: "irkc"), accuracy: 0.0001)
    XCTAssertEqual(0, "".jaroDistance(to: "team"), accuracy: 0.0001)
    XCTAssertEqual(0, "team".jaroDistance(to: ""), accuracy: 0.0001)
    XCTAssertEqual(0.6222, "adlsajdlsa".jaroDistance(to: "asv"), accuracy: 0.0001)
    XCTAssertEqual(0.822222, "DwAyNE".jaroDistance(to: "DuANE"), accuracy: 0.0001)
  }

  func testJaroWinklerDistances() {
    XCTAssertEqual(0.760, "friend".jaroWinklerDistance(to: "fresh"), accuracy: 0.0001)
    XCTAssertEqual(1, "friend".jaroWinklerDistance(to: "friend"), accuracy: 0.0001)
    XCTAssertEqual(0.9666, "friend".jaroWinklerDistance(to: "fried"), accuracy: 0.0001)
    XCTAssertEqual(0.9249, "rick".jaroWinklerDistance(to: "rcik"), accuracy: 0.0001)
    XCTAssertEqual(0.8333, "rick".jaroWinklerDistance(to: "irkc"), accuracy: 0.0001)
    XCTAssertEqual(0, "".jaroWinklerDistance(to: "team"), accuracy: 0.0001)
    XCTAssertEqual(0, "team".jaroWinklerDistance(to: ""), accuracy: 0.0001)
    XCTAssertEqual(0.6222, "adlsajdlsa".jaroWinklerDistance(to: "asv"), accuracy: 0.0001)
    XCTAssertEqual(0.840, "DwAyNE".jaroWinklerDistance(to: "DuANE"), accuracy: 0.0001)
    XCTAssertEqual(0.906667, "TRATE".jaroWinklerDistance(to: "TRACE"), accuracy: 0.0001)

    // Scaling
    XCTAssertEqual(0.9466, "TRATE".jaroWinklerDistance(to: "TRACE", scaling: 0.2), accuracy: 0.0001)
  }

  static var allTests = [
    ("testJaroDistances", testJaroDistances),
    ("testJaroWinklerDistances", testJaroWinklerDistances)
  ]
}
