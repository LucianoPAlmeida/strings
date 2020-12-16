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
    guard sourceStartTrim <= sourceEndTrim &&
          destinatioStartTrim <= destinatioEndTrim else {
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
    var matrix: [[Int]] = []
    matrix.append((0...n).map{ $0 })
    matrix.append([Int](repeating: 0, count: n + 1))
    matrix[1][0] = 1
    
    for i in 1...m {
      // Previous.
      matrix[0][0] = i - 1
      // Current.
      matrix[1][0] = i
      for j in 1...n {
        let sourceChar = newSource[
          newSource.index(newSource.startIndex, offsetBy: i - 1)]
        let destinationChar = newDestination[
          newDestination.index(newDestination.startIndex, offsetBy: j - 1)]
        let subCost: Int = sourceChar == destinationChar ? 0 : 1
        let deletion: Int = matrix[0][j] + 1
        let insertion: Int = matrix[1][j - 1] + 1
        let substitution: Int = matrix[0][j - 1] + subCost
        matrix[1][j] = min(min(deletion, insertion), substitution)
      }
      if i != m {
        matrix.swapAt(0, 1)
      }
    }

    return matrix[1][n]
  }
}
