//
//  DiscoveryRequest.swift
//  MovieDBCombine
//
//  Created by Santo Michael on 07/02/24.
//

import Networking

internal struct DiscoveryRequest: APIRequest {
	
	typealias Response = Discovery
	
	init(apiKey: String, genre: String, page: Int) {
		body = [
			"api_key": apiKey,
			"with_genres": genre,
			"page": page
		]
	}
	
	var baseURL: String = Constant.URLs.baseURL
	
	var method: HTTPMethod = .get
	
	var path: String = "/genre/movie/list"
	
	var headers: [String : Any] = [:]
	
	var body: [String : Any] = [:]
	
	func map(_ data: Data) throws -> Discovery {
		let decoded = try JSONDecoder().decode(DiscoveryResponse.self, from: data)
		let movies = decoded.movies.map {
			Movie(movieTitle: $0.movieTitle ?? "", movieOverview: $0.movieOverview ?? "", movieImageUrl: $0.movieImageUrl ?? "", movieId: $0.movieId ?? 0)
		}
		return Discovery(page: decoded.page ?? 0, movies: movies, totalPages: decoded.totalPages ?? 0)
	}
}
