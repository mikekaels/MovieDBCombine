//
//  Array+Differ.swift
//  MovieDBCombine
//
//  Created by Santo Michael on 09/02/24.
//

import Foundation

extension Array where Element: Hashable {
	func differentiate<U: Hashable>(with secondArray: [Element], property: (Element) -> U) -> (onlyInFirst: [Element], onlyInSecond: [Element]) {
		let set1 = Set(self.map(property))
		let set2 = Set(secondArray.map(property))
		
		let onlyInFirst = self.filter { !set2.contains(property($0)) }
		let onlyInSecond = secondArray.filter { !set1.contains(property($0)) }
		
		return (onlyInFirst, onlyInSecond)
	}
}
