//
//  MovieRepository.swift
//  MovieDBCombine
//
//  Created by Santo Michael on 07/02/24.
//

import Networking
import Combine

internal protocol MovieRepositoryProtocol {
	func getDiscoveries(apiKey: String, genre: String, page: Int) -> AnyPublisher<Discovery, ErrorResponse>
}

internal final class MovieRepository {
	let network: NetworkingProtocol
	
	init(network: NetworkingProtocol = Networking()) {
		self.network = network
	}
}

extension MovieRepository: MovieRepositoryProtocol {
	func getDiscoveries(apiKey: String, genre: String, page: Int) -> AnyPublisher<Discovery, ErrorResponse> {
		let apiRequest = DiscoveryRequest(apiKey: apiKey, genre: genre, page: page)
		let result = network.request(apiRequest)
		return result.asPublisher
	}
}
