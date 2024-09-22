//
//  DistanceExpectation.swift
//  strings
//
//  Created by Luciano Almeida on 22/09/24.
//

struct DistanceExpectation<DistanceValue: Numeric> {
  let source: String
  let target: String
  let expectedValue: DistanceValue
}
