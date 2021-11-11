//
//  Jaro.swift
//  
//
//  Created by Luciano Almeida on 12/02/21.
//
//===----------------------------------------------------------------------===//

@frozen
public struct Jaro<Source: StringProtocol> {
  @usableFromInline
  internal let source: Source
  
  @inlinable
  public init(_ source: Source) {
    self.source = source
  }
  
  @inlinable
  @_specialize(where S == String, Source == String)
  public func distance<S: StringProtocol>(to destination: S) -> Double {
    // Both strings are empty.
    guard !source.isEmpty || !destination.isEmpty else { return 1 }
    // One of the strings is empty.
    guard !source.isEmpty && !destination.isEmpty else { return 0 }
    
    let matchDistance = (max(source.count, destination.count) / 2) &- 1
    var sourceMatches = FixedBitArray(count: source.count)
    var destinationMatches = FixedBitArray(count: destination.count)

    var matchesCount = 0
    var iIdx = source.startIndex
    for i in 0..<source.count {
      let start = max(0, i &- matchDistance)
      let end = min(i &+ matchDistance &+ 1, destination.count)
      
      if end < start {
        break
      }
      
      var jIdx = destination.index(destination.startIndex, offsetBy: start)
      for j in start..<end {
        if destinationMatches[j] || source[iIdx] != destination[jIdx] {
          destination.formIndex(after: &jIdx)
          continue
        }
        sourceMatches[i] = true
        destinationMatches[j] = true
        matchesCount &+= 1
        break
      }
      source.formIndex(after: &iIdx)
    }
  
    guard matchesCount != 0 else { return 0 }
    
    var k = 0
    var transpositionsCount = 0
    iIdx = source.startIndex
    var kIdx = destination.startIndex
    for i in 0..<source.count {
      defer {
        source.formIndex(after: &iIdx)
      }
      
      if !sourceMatches[i] {
        continue
      }
      
      while !destinationMatches[k] {
        k &+= 1
        destination.formIndex(after: &kIdx)
      }
      
      if source[iIdx] != destination[kIdx] {
        transpositionsCount &+= 1
      }
      k &+= 1
      destination.formIndex(after: &kIdx)
    }
    
    let matches = Double(matchesCount)
    let transpositions = Double(transpositionsCount)
    
    let sourceRatio = matches / Double(source.count)
    let targetRatio = matches / Double(destination.count)
    let transpositionRatio = ((matches - (transpositions / 2)) / matches)
    
    return (sourceRatio + targetRatio + transpositionRatio) / 3.0
  }
  
  @inlinable
  @_specialize(where S == String, Source == String)
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
      prefixDistance &+= 1
    }
    return jaro + (scaling * Double(prefixDistance) * (1 - jaro))
  }
}

public extension StringProtocol {
  @inlinable
  @inline(__always)
  @_specialize(where S == String, Self == String)
  func jaroDistance<S: StringProtocol>(to destination: S) -> Double {
    return Jaro(self).distance(to: destination)
  }
  
  @inlinable
  @inline(__always)
  @_specialize(where S == String, Self == String)
  func jaroWinklerDistance<S: StringProtocol>(
    to destination: S, scaling: Double = 0.1) -> Double {
    return Jaro(self).winklerDistance(to: destination, scaling: scaling)
  }
}
