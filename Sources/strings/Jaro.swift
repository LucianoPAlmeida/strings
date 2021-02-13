//
//  Jaro.swift
//  
//
//  Created by Luciano Almeida on 12/02/21.
//

@frozen
public struct Jaro {
  public let source: String
  
  @inlinable
  public init(_ source: String) {
    self.source = source
  }
  
  @inlinable
  @_specialize(where S == String)
  public func distance<S: StringProtocol>(to destination: S) -> Double {
    // Both strings are empty.
    guard !source.isEmpty || !destination.isEmpty else { return 1 }
    // One of the strings is empty.
    guard !source.isEmpty && !destination.isEmpty else { return 0 }
    
    let matchDistance = (max(source.count, destination.count) / 2) - 1
    var sourceMatches = ContiguousArray(repeating: false, count: source.count)
    var targetMatches = ContiguousArray(repeating: false, count: destination.count)
    var matches = 0.0
    var transpositions = 0.0
    
    for i in 0..<source.count {
      let start = max(0, i - matchDistance)
      let end = min(i + matchDistance + 1, destination.count)
      
      if end < start {
        break
      }
      
      for j in start..<end where !targetMatches[j] {
        let iIdx = source.index(source.startIndex, offsetBy: i)
        let jIdx = destination.index(destination.startIndex, offsetBy: j)
        if source[iIdx] != destination[jIdx] {
          continue
        }
        sourceMatches[i] = true
        targetMatches[j] = true
        matches += 1
        break
      }
    }

    guard matches != 0 else { return 0 }
    
    var k = 0
    for i in 0..<source.count where sourceMatches[i] {
      while !targetMatches[k] {
        k += 1
      }
      
      let iIdx = source.index(source.startIndex, offsetBy: i)
      let kIdx = destination.index(destination.startIndex, offsetBy: k)
      if source[iIdx] != destination[kIdx] {
        transpositions += 1
      }
      k += 1
    }
    
    let sourceRatio = matches / Double(source.count)
    let targetRatio = matches / Double(destination.count)
    let transpositionRatio = ((matches - (transpositions / 2)) / matches)
    
    return (sourceRatio + targetRatio + transpositionRatio) / 3.0

  }
}

public extension String {
  @inlinable
  @_specialize(where S == String)
  func jaroDistance<S: StringProtocol>(to destination: S) -> Double {
    return Jaro(self).distance(to: destination)
  }
}
