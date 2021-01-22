// Levenshtein.swift
//  
//
//  Created by Luciano Almeida on 15/12/20.
//

@frozen
public struct Levenshtein {
  public let source: String
  
  @inlinable
  public init(_ source: String) {
    self.source = source
  }
  
  @inlinable
  @_specialize(where S == String)
  func distance<S: StringProtocol>(to destination: S) -> Int {
    var sourceStartTrim = source.startIndex
    var destinatioStartTrim = destination.startIndex
    while sourceStartTrim < source.endIndex &&
          destinatioStartTrim < destination.endIndex &&
          source[sourceStartTrim] == destination[destinatioStartTrim] {
      source.formIndex(after: &sourceStartTrim)
      destination.formIndex(after: &destinatioStartTrim)
    }
    
    var sourceEndTrim = source.endIndex
    var destinatioEndTrim = destination.endIndex
    
    while sourceEndTrim > sourceStartTrim &&
          destinatioEndTrim > destinatioStartTrim {
      let sourceIdx = source.index(before: sourceEndTrim)
      let destinationIdx = source.index(before: destinatioEndTrim)

      guard source[sourceIdx] == destination[destinationIdx] else {
        break
      }

      source.formIndex(before: &sourceEndTrim)
      destination.formIndex(before: &destinatioEndTrim)
    }
    
    // Equal strings
    guard sourceStartTrim != source.endIndex ||
          destinatioStartTrim != destination.endIndex else {
      return 0
    }
    
    guard sourceStartTrim < sourceEndTrim else {
      return destination.distance(from: destinatioStartTrim,
                                  to: destinatioEndTrim)
    }
    
    guard destinatioStartTrim < destinatioEndTrim else {
      return source.distance(from: sourceStartTrim,
                             to: sourceEndTrim)
    }
    
    let newSource = source[sourceStartTrim..<sourceEndTrim]
    let newDestination = destination[destinatioStartTrim..<destinatioEndTrim]

    let m: Int = newSource.count
    let n: Int = newDestination.count
    
    // Initialize the levenshtein matrix with only two rows
    // current and previous.
    var previousRow = ContiguousArray<Int>(0...n)
    var currentRow = ContiguousArray<Int>(repeating: 0, count: n &+ 1)
  
    return previousRow.withUnsafeMutableBufferPointer { (previousBuffer) in
      currentRow.withUnsafeMutableBufferPointer { (currentBuffer) in
        // Initialize
        currentBuffer[0] = 1
        
        var sourceIdx = newSource.startIndex
        // Make mutable vars it able to swap and reuse rows.
        var current = currentBuffer
        var previous = previousBuffer
        
        for i in 1...m {
          previous[0] = i &- 1
          current[0] = i
          
          var destinationIdx = newDestination.startIndex
          for j in 1...n {
            // If characteres are equal for the levenshtein algorithm the minimum will
            // always be the substitution cost, so we can fast path here in order to
            // avoid min calls.
            if newSource[sourceIdx] == newDestination[destinationIdx] {
              current[j] = previous[j &- 1]
            } else {
              let deletion: Int = previous[j]
              let insertion: Int = current[j &- 1]
              let substitution: Int = previous[j &- 1]
              let minimum = SIMD3(deletion, insertion, substitution).min()
              current[j] = minimum &+ 1
            }
            // j += 1
            newDestination.formIndex(after: &destinationIdx)
          }
          // i += 1
          newSource.formIndex(after: &sourceIdx)
          
          if _fastPath(i != m) {
            swap(&previous, &current)
          }
        }
        return current[n]
      }
    }
  }
}

public extension String {
  @inlinable
  @_specialize(where S == String)
  func levenshteinDistance<S: StringProtocol>(to destination: S) -> Int {
    return Levenshtein(self).distance(to: destination)
  }
}
