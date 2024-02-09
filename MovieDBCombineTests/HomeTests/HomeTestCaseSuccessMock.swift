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
	var networkReachability: Bool = true
	
	var localMovies: [Movie] = []
	
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
	
	func differentiateArrays<T, U>(_ array1: [T], _ array2: [T], property: (T) -> U) -> (onlyInFirst: [T], onlyInSecond: [T]) where U : Hashable {
		let set1 = Set(array1.map(property))
		let set2 = Set(array2.map(property))
		
		let onlyInFirst = array1.filter { set2.contains(property($0)) == false }
		let onlyInSecond = array2.filter { set1.contains(property($0)) == false }
		
		return (onlyInFirst, onlyInSecond)
	}
}


