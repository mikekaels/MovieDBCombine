//
//  HomeTestCaseSuccessMock.swift
//  MovieDBCombineTests
//
//  Created by Santo Michael on 09/02/24.
//

@testable import MovieDBCombine
@testable import Networking
import Combine

final class HomeUseCaseSuccessMock: HomeUseCaseProtocol {
	var networkReachability: Bool
	var localMovies: [Movie]
	
	init(networkReachability: Bool = true, localMovies: [Movie] = []) {
		self.networkReachability = networkReachability
		self.localMovies = localMovies
	}
	
	func searchMovies(keyword: String, page: Int) -> AnyPublisher<BaseModel<[Movie]>, ErrorResponse> {
		return Future<BaseModel<[Movie]>, ErrorResponse> { promise in
			let movies = [
				Movie(posterPath: "", year: "1997", title: "seven", image: nil)
			]
			let baseModel = BaseModel(page: 1, totalPages: 1, items: movies)
			promise(.success(baseModel))
		}.eraseToAnyPublisher()
	}
	
	func getLocalMovies() -> AnyPublisher<[Movie], Error> {
		return Future<[Movie], Error> { promise in
			promise(.success(self.localMovies))
		}.eraseToAnyPublisher()
	}
	
	func saveMovies(movies: [MovieDBCombine.Movie]) -> AnyPublisher<Bool, Error> {
		return Future<Bool, Error> { promise in
			promise(.success(true))
		}.eraseToAnyPublisher()
	}
}


final class HomeUseCaseSuccessNoMovieMock: HomeUseCaseProtocol {
	var networkReachability: Bool
	var localMovies: [Movie]
	
	init(networkReachability: Bool = true, localMovies: [Movie] = []) {
		self.networkReachability = networkReachability
		self.localMovies = localMovies
	}
	
	func searchMovies(keyword: String, page: Int) -> AnyPublisher<BaseModel<[Movie]>, ErrorResponse> {
		return Future<BaseModel<[Movie]>, ErrorResponse> { promise in
			let movies: [Movie] = []
			let baseModel = BaseModel(page: 1, totalPages: 1, items: movies)
			promise(.success(baseModel))
		}.eraseToAnyPublisher()
	}
	
	func getLocalMovies() -> AnyPublisher<[Movie], Error> {
		return Future<[Movie], Error> { promise in
			promise(.success(self.localMovies))
		}.eraseToAnyPublisher()
	}
	
	func saveMovies(movies: [MovieDBCombine.Movie]) -> AnyPublisher<Bool, Error> {
		return Future<Bool, Error> { promise in
			promise(.success(true))
		}.eraseToAnyPublisher()
	}
}
