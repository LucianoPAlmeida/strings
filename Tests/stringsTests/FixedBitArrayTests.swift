import Testing
@testable import strings

struct FixedBitArrayTests {

  @Test func testDefaultValues() {
    let size = 10
    let storage = FixedBitArray(count: size)
    #expect(size == storage.count)

    for i in 0..<size {
      #expect(!storage[i])
    }
  }

  @Test(arguments: [10, 64, 1024, 1030])
  func testModifyValues(size: Int) {
    var storage = FixedBitArray(count: size)
    for i in 0..<size where  i % 2 == 0 {
      storage[i] = true
    }

    for i in 0..<size {
      if i % 2 == 0 {
        #expect(storage[i])
      } else {
        #expect(!storage[i])
      }
    }

    for i in 0..<size where i % 2 == 0 {
      storage[i] = false
    }

    for i in 0..<size {
      #expect(!storage[i])
    }
  }
}
