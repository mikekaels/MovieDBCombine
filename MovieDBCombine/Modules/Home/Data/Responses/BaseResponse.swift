//
//  BaseResponse.swift
//  MovieDBCombine
//
//  Created by Santo Michael on 08/02/24.
//

internal struct BaseResponse<T: Codable>: Codable {
	let page: Int?
	let results: T?
	let totalPages, totalResults: Int?
	
	enum CodingKeys: String, CodingKey {
		case page, results
		case totalPages = "total_pages"
		case totalResults = "total_results"
	}
}
