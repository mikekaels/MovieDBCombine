//
//  MovieRepository.swift
//  MovieDBCombine
//
//  Created by Santo Michael on 07/02/24.
//

import Networking
import Combine
import CoreData
import Kingfisher

typealias MovieRepositoryProtocol = MovieNetworkRepositoryProtocol & MoviePersistenceRepositoryProtocol

internal protocol MovieNetworkRepositoryProtocol {
	func searchMovies(keyword: String, page: Int) -> AnyPublisher<BaseModel<[Movie]>, ErrorResponse>
}

internal protocol MoviePersistenceRepositoryProtocol {
	func getLocalMovies() -> AnyPublisher<[Movie], Error>
	func saveMovies(movies: [Movie]) -> AnyPublisher<Bool, Error>
}

internal final class MovieRepository {
	let network: NetworkingProtocol
	let persistence: NSPersistentContainer
	
	init(network: NetworkingProtocol = Networking()) {
		self.network = network
		persistence = NSPersistentContainer(name: "MoviePersistence")
		persistence.loadPersistentStores { description, error in
			if error != nil {
				fatalError("Cannot Load Core Data Model")
			}
		}
	}
}

extension MovieRepository: MovieNetworkRepositoryProtocol {
	func searchMovies(keyword: String, page: Int) -> AnyPublisher<BaseModel<[Movie]>, ErrorResponse> {
		let apiRequest = SearchMovieRequest(page: page, keyword: keyword)
		let result = network.request(apiRequest)
		return result.asPublisher
	}
}

extension MovieRepository: MoviePersistenceRepositoryProtocol {
	func saveMovies(movies: [Movie]) -> AnyPublisher<Bool, Error> {
		let context = persistence.viewContext // Assuming 'persistence' is your Core Data persistent container
		
		return Future<Bool, Error> { promise in
			context.perform {
				do {
					for movie in movies {
						// Check if an entity with the same title and year already exists
						let fetchRequest: NSFetchRequest<MoviePersistence> = MoviePersistence.fetchRequest()
						fetchRequest.predicate = NSPredicate(format: "title == %@ AND year == %@", movie.title, movie.year)
						let existingMovies = try context.fetch(fetchRequest)
						
						if let existingMovie = existingMovies.first {
							// Update existing movie entity if needed
							existingMovie.posterPath = movie.posterPath
						} else {
							// Create new movie entity if it doesn't exist
							let entity = MoviePersistence(context: context)
							entity.title = movie.title
							entity.year = movie.year
							entity.posterPath = movie.posterPath
							entity.image = movie.image
						}
					}
					
					if context.hasChanges {
						try context.save()
						promise(.success(true))
					} else {
						promise(.failure(NSError(domain: "No changes to save", code: -1)))
					}
				} catch {
					promise(.failure(error))
				}
			}
		}.eraseToAnyPublisher()
	}
	
	func getLocalMovies() -> AnyPublisher<[Movie], Error> {
		let request = MoviePersistence.fetchRequest()
		do {
			let result: [Movie] = try persistence.viewContext.fetch(request).map { item in
				return Movie(posterPath: item.posterPath ?? "", year: item.year ?? "", title: item.title ?? "", image: item.image)
			}
			
			return Future<[Movie], Error> { promise in
				promise(.success(result))
			}.eraseToAnyPublisher()
		} catch {
			return Future<[Movie], Error> { promise in
				promise(.failure(NSError(domain: "", code: 0)))
			}.eraseToAnyPublisher()
		}
	}
	
}
