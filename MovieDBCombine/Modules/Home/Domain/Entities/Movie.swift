//
//  Movie.swift
//  MovieDBCombine
//
//  Created by Santo Michael on 03/02/24.
//

import Foundation

struct Discovery {
	let page: Int
	let movies: [Movie]
	let totalPages: Int
}

struct Movie: Hashable {
	let movieTitle: String
	let movieOverview: String
	let movieImageUrl: String
	let movieId: Int
}
