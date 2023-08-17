# SortedArray

A collection that maintains a sorted list of items, uses binary search to query indexes and membership, and enforces unique membership based on the sort comparator.

## Example

To create a SortedArray, you provide it with a comparator that determins how it will be sorted:

```swift
let array = SortedArray([
	Post(id: 3, title: "c"),
	Post(id: 1, title: "a"),
	Post(id: 2, title: "b"),
], using: KeyPathComparator(\.id))
```

The elements that you pass in will be sorted by that comparator. Note that any duplicates (those that are equal according to the comparator) will be removed.

Use a SortedArray like you would a regular array. Functions like `firstIndex(of:)` will be much faster because it will use a binary search to find the location.

To add new elements, you use `insert`, and the new element will be inserted at the correct position in the array.

```swift
array.insert(Post(id: 4, title: "e"))
```

If you want to update an existing value, you can use `update`.

```swift
array.update(with: Post(id: 2, title: "bb"))
```

In this example, the post with id of 2 will be replaced with the new value. If there isn't an element with a matching identity, the element will be inserted.
