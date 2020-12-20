// Levenshtein.swift
//  
//
//  Created by Luciano Almeida on 15/12/20.
//

public final class Levenshtein {
  public let source: String
  
  @inlinable
  public init(_ source: String) {
    self.source = source
  }
  
  @inlinable
  func distance(to destination: String) -> Int {
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

      if (source[sourceIdx] != destination[destinationIdx]) {
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
    var previousRow = (0...n).map{ $0 }
    var currentRow = [Int](repeating: 0, count: n &+ 1)
    currentRow[0] = 1
    
    var sourceIdx = newSource.startIndex
    for i in 1...m {
      previousRow[0] = i &- 1
      currentRow[0] = i
      
      var destinationIdx = newDestination.startIndex
      for j in 1...n {
        let sourceChar = newSource[sourceIdx]
        let destinationChar = newDestination[destinationIdx]
        // If characteres are equal for the levenshtein algorithm the minimum will
        // always be the substitution cost, so we can fast path here in order to
        // avoid min calls.
        if sourceChar == destinationChar {
          currentRow[j] = previousRow[j &- 1]
        } else {
          let deletion: Int = previousRow[j]
          let insertion: Int = currentRow[j &- 1]
          let substitution: Int = previousRow[j &- 1]
          let minimum = SIMD3(deletion, insertion, substitution).min()
          currentRow[j] = minimum &+ 1
        }
        // j += 1
        newDestination.formIndex(after: &destinationIdx)
      }
      // i += 1
      newSource.formIndex(after: &sourceIdx)
      
      if i != m {
        swap(&previousRow, &currentRow)
      }
    }

    return currentRow[n]
  }
}
