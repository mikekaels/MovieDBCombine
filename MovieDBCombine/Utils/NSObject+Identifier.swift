//
//  NSObject+Identifier.swift
//  MovieDBCombine
//
//  Created by Santo Michael on 03/02/24.
//

import Foundation

extension NSObject {
	public var identifier: String {
		String(describing: type(of: self))
	}
	
	public static var identifier: String {
		String(describing: self)
	}
}


