//
//  MovieRepository.swift
//  MovieDBCombine
//
//  Created by Santo Michael on 07/02/24.
//

import Networking
import Combine

internal protocol MovieRepositoryProtocol {
	
	/// THE MOVIE DB
	func getPopularMovies(page: Int) -> AnyPublisher<BaseModel<[Movie]>, ErrorResponse>
	
	// OMDB
	func searchMovies(keyword: String, page: Int) -> AnyPublisher<BaseModel<[Movie]>, ErrorResponse>
}

internal final class MovieRepository {
	let network: NetworkingProtocol
	
	init(network: NetworkingProtocol = Networking()) {
		self.network = network
	}
}

extension MovieRepository: MovieRepositoryProtocol {
	func searchMovies(keyword: String, page: Int) -> AnyPublisher<BaseModel<[Movie]>, ErrorResponse> {
		let apiRequest = SearchMovieRequest(page: page, keyword: keyword)
		let result = network.request(apiRequest)
		return result.asPublisher
	}
	
	func getPopularMovies(page: Int) -> AnyPublisher<BaseModel<[Movie]>, ErrorResponse> {
		let apiRequest = PopularMovieRequest(page: page)
		let result = network.request(apiRequest)
		return result.asPublisher
	}
}
