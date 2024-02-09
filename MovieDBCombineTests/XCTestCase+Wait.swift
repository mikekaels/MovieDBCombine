//
//  XCTestCase+Wait.swift
//  MovieDBCombineTests
//
//  Created by Santo Michael on 09/02/24.
//

import XCTest

extension XCTestCase {
	func wait(timeout: TimeInterval = 1.0, completion: @escaping (() -> Void)) {
		let expectation = XCTestExpectation(description: self.debugDescription)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			expectation.fulfill()
		}
		
		wait(for: [expectation], timeout: timeout)
	}
}


