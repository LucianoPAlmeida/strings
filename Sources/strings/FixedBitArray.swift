@usableFromInline
internal struct FixedBitArray {
  @usableFromInline
  typealias WordStorage = [UInt]

  // 64 on 64-bits systems, 32 on 32-bits systems
  @usableFromInline
  internal static let _bitsPerWord = UInt.bitWidth

  @usableFromInline
  internal var _words: WordStorage

  @usableFromInline
  internal let count: Int

  @inlinable
  @inline(__always)
  internal init(count: Int) {
    let (div, remainder) = count.quotientAndRemainder(dividingBy: FixedBitArray._bitsPerWord)
    self._words = WordStorage(repeating: 0, count: div &+ remainder.signum())
    self.count = count
  }

  @inlinable
  @inline(__always)
  internal subscript(_ idx: Int) -> Bool {
    get {
      assert(0..<count ~= idx, "Out of bounds index!")
      let (pos, posIdx) = idx.quotientAndRemainder(dividingBy: FixedBitArray._bitsPerWord)
      return _words[pos] & (1 << posIdx) != 0
    }
    set {
      assert(0..<count ~= idx, "Out of bounds index!")
      let (pos, posIdx) = idx.quotientAndRemainder(dividingBy: FixedBitArray._bitsPerWord)
      if newValue == true {
        _words[pos] |= (1 << posIdx)
      } else {
        _words[pos] &= ~(1 << posIdx)
      }
    }
  }
}
