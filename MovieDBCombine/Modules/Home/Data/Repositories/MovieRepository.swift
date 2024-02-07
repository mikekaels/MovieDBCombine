//
//  MovieRepository.swift
//  MovieDBCombine
//
//  Created by Santo Michael on 07/02/24.
//

import Networking
import Combine

internal protocol MovieRepositoryProtocol {
	func getPopularMovies(page: Int) -> AnyPublisher<BaseModel<[Movie]>, ErrorResponse>
}

internal final class MovieRepository {
	let network: NetworkingProtocol
	
	init(network: NetworkingProtocol = Networking()) {
		self.network = network
	}
}

extension MovieRepository: MovieRepositoryProtocol {
	func getPopularMovies(page: Int) -> AnyPublisher<BaseModel<[Movie]>, ErrorResponse> {
		let apiRequest = PopularMovieRequest(page: page)
		let result = network.request(apiRequest)
		return result.asPublisher
	}
}
