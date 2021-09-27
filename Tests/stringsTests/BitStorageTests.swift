
import XCTest
@testable import strings

final class BitStorageTests: XCTestCase {

  func testDefaultValues() {
    let size = 10
    let storage = BitStorage(count: size)
    XCTAssertEqual(size, storage.count)
    
    for i in 0..<size {
      XCTAssertFalse(storage[i])
    }
  }
  
  func testModifyValues() {
    _modifyValuesTest(size: 10)
    _modifyValuesTest(size: 64)
    _modifyValuesTest(size: 1024)
    _modifyValuesTest(size: 1030)
  }
  
  func _modifyValuesTest(size: Int) {
    var storage = BitStorage(count: size)
    for i in 0..<size where  i % 2 == 0 {
      storage[i] = true
    }

    for i in 0..<size {
      if i % 2 == 0 {
        XCTAssertTrue(storage[i])
      } else {
        XCTAssertFalse(storage[i])
      }
    }
    
    for i in 0..<size where i % 2 == 0 {
      storage[i] = false
    }

    for i in 0..<size {
      XCTAssertFalse(storage[i])
    }
  }
}
