// Levenshtein.swift
//  
//
//  Created by Luciano Almeida on 15/12/20.
//
//===----------------------------------------------------------------------===//

public struct LevenshteinCost: Equatable {
  public var insertion: Int
  public var deletion: Int
  public var substitution: Int

  public init(insertion: Int = 1, deletion: Int = 1, substitution: Int = 1) {
    self.insertion = insertion
    self.deletion = deletion
    self.substitution = substitution
  }
  
  public static var `default`: LevenshteinCost { LevenshteinCost() }
  
  @inlinable
  internal func _with(
    _ property: WritableKeyPath<LevenshteinCost, Int>, value: Int
  ) -> LevenshteinCost {
    var copy = self
    copy[keyPath: property] = value
    return copy
  }
  
  @inlinable
  public func with(insertion: Int) -> LevenshteinCost {
    return _with(\.insertion, value: insertion)
  }
  
  @inlinable
  public func with(deletion: Int) -> LevenshteinCost {
    return _with(\.deletion, value: deletion)
  }
  
  @inlinable
  public func with(substitution: Int) -> LevenshteinCost {
    return _with(\.substitution, value: substitution)
  }
}

public struct Levenshtein<Source: StringProtocol> {
  @usableFromInline
  internal let source: Source
  
  @inlinable
  public init(_ source: Source) {
    self.source = source
  }
  
  @inlinable
  @_specialize(where S == String, Source == String)
  func distance<S>(to destination: S,
                   cost: LevenshteinCost = .default) -> Int
    where S: StringProtocol {
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

    let m = newSource.count
    let n = newDestination.count
    
    // Initialize the levenshtein matrix with only two rows
    // current and previous.
    var previousRow = ContiguousArray<Int>(repeating: 0, count: n + 1)
    var currentRow = ContiguousArray<Int>(0...n)

    var sourceIdx = newSource.startIndex
    for i in 1...m {
      swap(&previousRow, &currentRow)
      currentRow[0] = i
      
      var destinationIdx = newDestination.startIndex
      for j in 1...n {
        // If characteres are equal for the levenshtein algorithm the
        // minimum will always be the substitution cost, so we can fast
        // path here in order to avoid min calls.
        if newSource[sourceIdx] == newDestination[destinationIdx] {
          currentRow[j] = previousRow[j &- 1]
        } else {
          let deletion = previousRow[j] &+ cost.deletion
          let insertion = currentRow[j &- 1] &+ cost.insertion
          let substitution = previousRow[j &- 1] &+ cost.substitution
          currentRow[j] = min(deletion, min(insertion, substitution))
        }
        // j += 1
        newDestination.formIndex(after: &destinationIdx)
      }
      // i += 1
      newSource.formIndex(after: &sourceIdx)
    }
    return currentRow[n]
  }
}

public extension StringProtocol {
  @inlinable
  @_specialize(where S == String, Self == String)
  func levenshteinDistance<S>(to destination: S,
                              cost: LevenshteinCost = .default) -> Int
    where S: StringProtocol {
    return Levenshtein(self).distance(to: destination, cost: cost)
  }
}
