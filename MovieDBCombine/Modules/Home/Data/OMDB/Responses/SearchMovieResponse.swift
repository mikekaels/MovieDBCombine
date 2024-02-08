//
//  SearchMovieResponse.swift
//  MovieDBCombine
//
//  Created by Santo Michael on 08/02/24.
//

import Foundation

struct SearchMovieResponse: Codable {
	let search: [Search]?
	let totalResults, response: String?
	
	enum CodingKeys: String, CodingKey {
		case search = "Search"
		case totalResults
		case response = "Response"
	}
}

struct Search: Codable {
	let title, year, imdbId, type: String?
	let poster: String?
	
	enum CodingKeys: String, CodingKey {
		case title = "Title"
		case year = "Year"
		case imdbId = "imdbID"
		case type = "Type"
		case poster = "Poster"
	}
}

