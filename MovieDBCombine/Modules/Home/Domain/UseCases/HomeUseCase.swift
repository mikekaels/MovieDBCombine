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
}

internal final class HomeUseCase {
	let movieRepository: MovieRepositoryProtocol
	
	init(movieRepository: MovieRepositoryProtocol = MovieRepository()) {
		self.movieRepository = movieRepository
	}
}

extension HomeUseCase: HomeUseCaseProtocol {
	func getPopularMovies(page: Int) -> AnyPublisher<BaseModel<[Movie]>, ErrorResponse> {
		return movieRepository.getPopularMovies(page: page)
	}
}
