//
//  PopularMovieResponses.swift
//  MovieDBCombine
//
//  Created by Santo Michael on 07/02/24.
//

internal struct MovieResponse: Codable {
	let posterPath, releaseDate, title: String?
	
	enum CodingKeys: String, CodingKey {
		case title
		case posterPath = "poster_path"
		case releaseDate = "release_date"
	}
}
