@usableFromInline
internal struct FixedBitArray {
  @usableFromInline
  typealias WordStorage = Array<UInt>
  
  @usableFromInline
  internal var _words: WordStorage
  
  @usableFromInline
  internal let _bitsPerWord = UInt.bitWidth // 64 on 64-bits systems, 32 on 32-bits systems
  
  @usableFromInline
  internal let count: Int
  
  @inlinable
  internal init(count: Int) {
    let (div, remainder) = count.quotientAndRemainder(dividingBy: _bitsPerWord)
    self._words = WordStorage(repeating: 0, count: div &+ remainder.signum())
    self.count = count
  }
  
  @inlinable
  @inline(__always)
  internal subscript(_ idx: Int) -> Bool {
    get {
      let (pos, posIdx) = idx.quotientAndRemainder(dividingBy: _bitsPerWord)
      return _words[pos] & (1 << posIdx) != 0
    }
    set {
      let (pos, posIdx) = idx.quotientAndRemainder(dividingBy: _bitsPerWord)
      if newValue == true {
        _words[pos] |= (1 << posIdx)
      } else {
        _words[pos] &= ~(1 << posIdx)
      }
    }
  }
}
