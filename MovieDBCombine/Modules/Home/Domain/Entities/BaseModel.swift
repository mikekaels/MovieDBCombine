//
//  BaseModel.swift
//  MovieDBCombine
//
//  Created by Santo Michael on 08/02/24.
//

internal struct BaseModel<T> {
	let page: Int
	let totalPages: Int
	let items: T
}
