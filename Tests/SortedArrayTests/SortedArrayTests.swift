import XCTest
@testable import SortedArray

final class SortedArrayTests: XCTestCase {
	struct Example: Equatable {
		var count: Int = 0
		var name: String = ""
	}

	func test_initValue() throws {
		let array = SortedArray([
			Example(count: 3),
			Example(count: 1),
			Example(count: 2),
		], using: KeyPathComparator(\.count))

		XCTAssertEqual(array.rawValue, [
			Example(count: 1),
			Example(count: 2),
			Example(count: 3),
		])
	}

	func test_initValue_removesDuplicates() throws {
		let array = SortedArray([
			Example(count: 3),
			Example(count: 3),
			Example(count: 3),
			Example(count: 1),
			Example(count: 2),
			Example(count: 2),
		], using: KeyPathComparator(\.count))

		XCTAssertEqual(array.rawValue, [
			Example(count: 1),
			Example(count: 2),
			Example(count: 3),
		])
	}

	func test_indexOf() throws {
		let array = SortedArray([
			Example(count: 3),
			Example(count: 1),
			Example(count: 2),
			Example(count: 0),
			Example(count: 4),
			Example(count: 9),
			Example(count: 7),
			Example(count: 8),
			Example(count: 5),
			Example(count: 6),
		], using: KeyPathComparator(\.count))

		let index = array.index(of: Example(count: 6))

		XCTAssertEqual(index, 6)
	}

	func test_insert() throws {
		var array = SortedArray([
			Example(count: 3),
			Example(count: 1),
			Example(count: 2),
			Example(count: 0),
			Example(count: 4),
			Example(count: 9),
			Example(count: 7),
			Example(count: 8),
			Example(count: 5),
		], using: KeyPathComparator(\.count))

		array.insert(Example(count: 6))

		XCTAssertEqual(array.rawValue, [
			Example(count: 0),
			Example(count: 1),
			Example(count: 2),
			Example(count: 3),
			Example(count: 4),
			Example(count: 5),
			Example(count: 6),
			Example(count: 7),
			Example(count: 8),
			Example(count: 9),
		])
	}
}
