import Foundation

public struct SortedArray<Element, Comparator: SortComparator>
where Comparator.Compared == Element {
	public private(set) var rawValue: [Element]
	public let sortComparator: Comparator

	public init(sorted: [Element], using comparator: Comparator) {
		self.rawValue = sorted
		self.sortComparator = comparator
	}

	public init(using comparator: Comparator) {
		self.init(sorted: [], using: comparator)
	}

	public init(_ values: some Collection<Element>, using comparator: Comparator) {
		var sorted = values.sorted(using: comparator)
		for index in sorted.indices.dropFirst().reversed() {
			if comparator.compare(sorted[index], sorted[sorted.index(before: index)]) == .orderedSame {
				sorted.remove(at: index)
			}
		}

		self.init(sorted: sorted, using: comparator)
	}

	public mutating func replaceContent(_ values: some Collection<Element>) {
		var sorted = values.sorted(using: sortComparator)
		for index in sorted.indices.dropFirst().reversed() {
			if sortComparator.compare(sorted[index], sorted[sorted.index(before: index)]) == .orderedSame {
				sorted.remove(at: index)
			}
		}

		rawValue = sorted
	}

	enum LookupResult {
		case matched(Int)
		case unmatched(Int)
	}

	func lookup(_ element: Element) -> LookupResult {
		var lowerBound = startIndex
		var upperBound = endIndex
		while lowerBound < upperBound {
			let midIndex = lowerBound + (upperBound - lowerBound) / 2
			let result = sortComparator.compare(self[midIndex], element)
			switch result {
			case .orderedSame:
				return .matched(midIndex)
			case .orderedAscending:
				lowerBound = midIndex + 1
			case .orderedDescending:
				upperBound = midIndex
			}
		}
		return .unmatched(lowerBound)
	}

	public func index(of element: Element) -> Int? {
		switch self.lookup(element) {
		case .matched(let index):
			return index
		case .unmatched:
			return nil
		}
	}

	public func firstIndex(of element: Element) -> Int? {
		index(of: element)
	}
}

extension SortedArray: Collection {
	public typealias Index = Int

	public var startIndex: Index { rawValue.startIndex }
	public var endIndex: Index { rawValue.endIndex }

	public subscript(index: Int) -> Element {
		rawValue[index]
	}

	public func index(after i: Index) -> Index {
		rawValue.index(after: i)
	}
}

public extension SortedArray {
	func contains(_ member: Element) -> Bool {
		switch self.lookup(member) {
		case .matched:
			return true
		case .unmatched:
			return false
		}
	}

	@discardableResult
	mutating func insert(_ newMember: __owned Element) -> (inserted: Bool, memberAfterInsert: Element) {
		switch self.lookup(newMember) {
		case let .matched(index):
			return (false, self[index])
		case let .unmatched(index):
			rawValue.insert(newMember, at: index)
			return (true, newMember)
		}
	}

	@discardableResult
	mutating func remove(_ member: Element) -> Element? {
		switch self.lookup(member) {
		case let .matched(index):
			let element = self[index]
			rawValue.remove(at: index)
			return element
		case .unmatched:
			return nil
		}
	}

	mutating func update(with newMember: __owned Element) -> Element? {
		switch self.lookup(newMember) {
		case let .matched(index):
			let element = self[index]
			rawValue[index] = newMember
			return element
		case let .unmatched(index):
			rawValue.insert(newMember, at: index)
			return nil
		}
	}

	func union(_ other: __owned SortedArray<Element, Comparator>) -> SortedArray<Element, Comparator> {
		var result: SortedArray<Element, Comparator>
		let inserted: SortedArray<Element, Comparator>
		if count > other.count {
			result = self
			inserted = other
		} else {
			result = other
			inserted = self
		}

		result.formUnion(inserted)

		return result
	}

	mutating func formUnion(_ other: __owned SortedArray<Element, Comparator>) {
		self.rawValue.reserveCapacity(self.count + other.count)
		for element in other {
			self.insert(element)
		}
	}
}

extension SortedArray: Equatable where Element: Equatable {}

extension SortedArray: Hashable where Element: Hashable {}

extension SortedArray: Sendable where Element: Sendable, Comparator: Sendable {}

extension SortedArray: Encodable where Element: Encodable {
	public func encode(to encoder: Encoder) throws {
		try rawValue.encode(to: encoder)
	}
}
