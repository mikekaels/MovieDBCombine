//
//  HomeUseCase.swift
//  MovieDBCombine
//
//  Created by Santo Michael on 07/02/24.
//

import Combine
import Networking

internal protocol HomeUseCaseProtocol {
	func getPopularMovies(page: Int) -> AnyPublisher<BaseModel<[Movie]>, ErrorResponse>
	func searchMovies(keyword: String, page: Int) -> AnyPublisher<BaseModel<[Movie]>, ErrorResponse>
	func shimmers() -> [HomeVM.DataSourceType]
}

internal final class HomeUseCase {
	let movieRepository: MovieRepositoryProtocol
	
	init(movieRepository: MovieRepositoryProtocol = MovieRepository()) {
		self.movieRepository = movieRepository
	}
}

extension HomeUseCase: HomeUseCaseProtocol {
	func shimmers() -> [HomeVM.DataSourceType] {
		return [
			.shimmer(UUID().uuidString),
			.shimmer(UUID().uuidString),
			.shimmer(UUID().uuidString),
			.shimmer(UUID().uuidString),
			.shimmer(UUID().uuidString),
			.shimmer(UUID().uuidString),
			.shimmer(UUID().uuidString),
			.shimmer(UUID().uuidString),
		]
	}
	
	func searchMovies(keyword: String, page: Int) -> AnyPublisher<BaseModel<[Movie]>, ErrorResponse> {
		return movieRepository.searchMovies(keyword: keyword, page: page)
	}
	
	func getPopularMovies(page: Int) -> AnyPublisher<BaseModel<[Movie]>, ErrorResponse> {
		return movieRepository.getPopularMovies(page: page)
	}
}
