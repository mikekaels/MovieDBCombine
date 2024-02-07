//
//  DiscoveryResponses.swift
//  MovieDBCombine
//
//  Created by Santo Michael on 07/02/24.
//

import Foundation

struct DiscoveryResponse: Codable {
	var page: Int?
	var movies: [MovieResponse]
	var totalPages: Int?
	
	enum CodingKeys: String, CodingKey {
		case page = "page"
		case movies = "results"
		case totalPages = "total_pages"
	}
}

struct MovieResponse: Codable {
	
	var movieTitle, movieOverview, movieImageUrl: String?
	var movieId: Int?
	
	enum CodingKeys: String, CodingKey {
		case movieTitle    = "title"
		case movieOverview = "overview"
		case movieImageUrl = "poster_path"
		case movieId = "id"
	}
}
