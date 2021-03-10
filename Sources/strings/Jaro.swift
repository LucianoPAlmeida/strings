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
    
    let matches = sourceMatches.withUnsafeMutableBufferPointer { (sourceMatchesBuffer) in
      targetMatches.withUnsafeMutableBufferPointer { (targetMatchesBuffer) -> Double in
        var matchCount = 0
        var iIdx = source.startIndex
        for i in 0..<source.count {
          let start = max(0, i - matchDistance)
          let end = min(i &+ matchDistance &+ 1, destination.count)
          
          if end < start {
            break
          }
          
          var jIdx = destination.index(destination.startIndex, offsetBy: start)
          for j in start..<end {
            if targetMatchesBuffer[j] || source[iIdx] != destination[jIdx] {
              destination.formIndex(after: &jIdx)
              continue
            }
            sourceMatchesBuffer[i] = true
            targetMatchesBuffer[j] = true
            matchCount &+= 1
            break
          }
          source.formIndex(after: &iIdx)
        }
        return Double(matchCount)
      }
    }
  
    guard matches != 0 else { return 0 }
    
    var transpositions = 0.0
    var k = 0
    var iIdx = source.startIndex
    var kIdx = destination.startIndex
    for i in 0..<source.count {
      defer {
        source.formIndex(after: &iIdx)
      }

      if !sourceMatches[i] {
        continue
      }

      while !targetMatches[k] {
        k &+= 1
        destination.formIndex(after: &kIdx)
      }
      
      if source[iIdx] != destination[kIdx] {
        transpositions += 1
      }
      k &+= 1
      destination.formIndex(after: &kIdx)
    }
    
    let sourceRatio = matches / Double(source.count)
    let targetRatio = matches / Double(destination.count)
    let transpositionRatio = ((matches - (transpositions / 2)) / matches)
    
    return (sourceRatio + targetRatio + transpositionRatio) / 3.0

  }
  
  public func winklerDistance<S: StringProtocol>(
    to destination: S, scaling: Double) -> Double {
    let jaro = distance(to: destination)
    guard jaro > 0.7 else {
      return jaro
    }
      
    // Maximum of 4 characters are allowed in prefix.
    let maxPrefix = 4
    var prefixDistance = 0
    var sourceStart = source.startIndex
    var destinationStart = destination.startIndex
    while sourceStart != source.endIndex &&
          destinationStart != destination.endIndex &&
          source[sourceStart] == destination[destinationStart] &&
          prefixDistance < maxPrefix {
      source.formIndex(after: &sourceStart)
      destination.formIndex(after: &destinationStart)
      prefixDistance += 1
    }
    return jaro + (scaling * Double(prefixDistance) * (1 - jaro))
  }
}

public extension String {
  @inlinable
  @_specialize(where S == String)
  func jaroDistance<S: StringProtocol>(to destination: S) -> Double {
    return Jaro(self).distance(to: destination)
  }
  
  @inlinable
  @_specialize(where S == String)
  func jaroWinklerDistance<S: StringProtocol>(
    to destination: S, scaling: Double = 0.1) -> Double {
    return Jaro(self).winklerDistance(to: destination, scaling: scaling)
  }
}
