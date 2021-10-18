//
//  File.swift
//  
//
//  Created by Luciano Almeida on 16/03/21.
//

import XCTest
import strings

final class HammingTests: XCTestCase {

  func testHammingDistances() {
    XCTAssertEqual("friend".hammingDistance(to: "friend"), 0)
    XCTAssertEqual("friend".hammingDistance(to: "frinnd"), 1)
    XCTAssertEqual("test".hammingDistance(to: "team"), 2)
    XCTAssertEqual("".hammingDistance(to: ""), 0)
  }

  static var allTests = [
    ("testHammingDistances", testHammingDistances)
  ]
}
