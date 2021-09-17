//
//  Hamming.swift
//  
//
//  Created by Luciano Almeida on 16/03/21.
//
//===----------------------------------------------------------------------===//
@frozen
public struct Hamming<Source: StringProtocol> {
  @usableFromInline
  internal let source: Source
  
  @inlinable
  public init(_ source: Source) {
    self.source = source
  }

  @inlinable
  @inline(__always)
  internal func _distance<S: StringProtocol>(to destination: S) -> Int {
    var distance: Int = 0
    for (lhs, rhs) in zip(source, destination) where lhs != rhs {
      distance &+= 1
    }
    return distance
  }
  
  @inlinable
  @_specialize(where S == String, Source == String)
  public func distance<S: StringProtocol>(to destination: S) -> Int {
    precondition(source.count == destination.count,
                 "Hamming string distance requires strings of equal lengths")
    return _distance(to: destination)
  }
}

public extension StringProtocol {
  @inlinable
  @_specialize(where S == String, Self == String)
  func hammingDistance<S: StringProtocol>(to destination: S) -> Int {
    precondition(count == destination.count,
                 "Hamming string distance requires strings of equal lengths")
    return Hamming(self)._distance(to: destination)
  }
}
