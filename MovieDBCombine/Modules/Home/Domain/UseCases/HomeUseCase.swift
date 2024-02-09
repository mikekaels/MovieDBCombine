//
//  HomeUseCase.swift
//  MovieDBCombine
//
//  Created by Santo Michael on 07/02/24.
//

import Combine
import Networking
import Kingfisher

internal protocol HomeUseCaseProtocol {
	func searchMovies(keyword: String, page: Int) -> AnyPublisher<BaseModel<[Movie]>, ErrorResponse>
	func getLocalMovies() -> AnyPublisher<[Movie], Error>
	func saveMovies(movies: [Movie]) -> AnyPublisher<Bool, Error>
	func shimmers() -> [HomeVM.DataSourceType]
	func differentiateArrays<T, U: Hashable>(_ array1: [T], _ array2: [T], property: (T) -> U) -> (onlyInFirst: [T], onlyInSecond: [T])
	
	var networkReachability: Bool { get }
	var localMovies: [Movie] { get set }
}

internal final class HomeUseCase {
	let movieRepository: MovieRepositoryProtocol
	var networkReachability: Bool {
		Reachability.isConnectedToNetwork()
	}
	var localMovies: [Movie] = []
	
	init(movieRepository: MovieRepositoryProtocol = MovieRepository()) {
		self.movieRepository = movieRepository
	}
}

extension HomeUseCase: HomeUseCaseProtocol {
	func saveMovies(movies: [Movie]) -> AnyPublisher<Bool, Error> {
		let cancellables = CancelBag()
		
		return Future<Bool, Error> { [weak self] promise in
			guard let self = self else { return }
			let dispatchGroup = DispatchGroup()
			var allImagesData: [Data?] = Array(repeating: nil, count: movies.count)
			
			for (index, movie) in movies.enumerated() {
				dispatchGroup.enter()
				self.getImageData(url: movie.posterPath) { imageData in
					allImagesData[index] = imageData
					dispatchGroup.leave()
				}
			}
			
			dispatchGroup.notify(queue: .main) {
				let success = self.movieRepository.saveMovies(movies: movies.enumerated().map { index, movie in
					Movie(posterPath: movie.posterPath, year: movie.year, title: movie.title, image: allImagesData[index])
				})
				
				success.sink(receiveCompletion: { completion in
					switch completion {
					case .finished:
						break
					case .failure(let error):
						promise(.failure(error))
					}
				}, receiveValue: { value in
					promise(.success(value))
				}).store(in: cancellables)
			}
		}.eraseToAnyPublisher()
	}
	
	func getImageData(url: String, completion: @escaping (Data?) -> Void) {
		KingfisherManager.shared.retrieveImage(with: URL(string: url)!) { result in
			switch result {
			case .success(let imageResult):
				if let imageData = imageResult.image.pngData() {
					completion(imageData)
				} else {
					completion(nil)
				}
			case .failure:
				completion(nil)
				print("~ FAIL TO RETRIEVE IMAGE")
			}
		}
	}
	
	func getLocalMovies() -> AnyPublisher<[Movie], Error> {
		return movieRepository.getLocalMovies()
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
	
	func searchMovies(keyword: String, page: Int) -> AnyPublisher<BaseModel<[Movie]>, ErrorResponse> {
		return movieRepository.searchMovies(keyword: keyword, page: page)
	}
	
	func differentiateArrays<T, U: Hashable>(_ array1: [T], _ array2: [T], property: (T) -> U) -> (onlyInFirst: [T], onlyInSecond: [T]) {
		let set1 = Set(array1.map(property))
		let set2 = Set(array2.map(property))
		
		let onlyInFirst = array1.filter { set2.contains(property($0)) == false }
		let onlyInSecond = array2.filter { set1.contains(property($0)) == false }
		
		return (onlyInFirst, onlyInSecond)
	}
}
