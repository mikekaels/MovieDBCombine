//
//  HomeVM.swift
//  MovieDBCombine
//
//  Created by Santo Michael on 03/02/24.
//

import Combine
import UIKit
import Networking

internal final class HomeVM {
	var useCase: HomeUseCaseProtocol
	
	init(useCase: HomeUseCaseProtocol = HomeUseCase()) {
		self.useCase = useCase
	}

	enum DataSourceType: Hashable {
		case content(Movie)
		case shimmer(String = UUID().uuidString)
		case error(HomeErrorType)
	}
}

extension HomeVM {
	struct Action {
		var didLoad: AnyPublisher<Void, Never>
		var fetchMovies = PassthroughSubject<Void, Never>()
		var searchDidCancel: AnyPublisher<Void, Never>
		var searchDidChange: PassthroughSubject<String, Never>
		let showLoading = PassthroughSubject<Bool, Never>()
		let getLocalMovies = PassthroughSubject<Void, Never>()
		let saveMovies = PassthroughSubject<[Movie], Never>()
	}
	
	class State {
		@Published var dataSources: [DataSourceType] = []
		@Published var column: Int = 2
		@Published var cellHeight: CGFloat = 330
		
		var page: Int = 1
		var totalPage: Int = 0
		var searchKeyword: String = "Avengers"
	}
	
	internal func transform(_ action: Action, _ cancellables: CancelBag) -> State {
		let state = State()
		
		func shimmers() -> [DataSourceType] {
			return [
				.shimmer(),
				.shimmer(),
				.shimmer(),
				.shimmer(),
				.shimmer(),
				.shimmer(),
				.shimmer(),
				.shimmer(),
			]
		}
		
		action.didLoad
			.sink { _ in
				action.getLocalMovies.send(())
			}
			.store(in: cancellables)
		
		action.getLocalMovies
			.map {
				action.showLoading.send(true)
			}
			.receive(on: DispatchQueue.global(qos: .userInitiated))
			.flatMap {
				self.useCase.getLocalMovies()
					.map { Result.success($0) }
					.catch { Just(Result.failure($0)) }
					.eraseToAnyPublisher()
			}
			.sink { [weak self] result in
				action.showLoading.send(false)
				if case let .success(movies) = result {
					self?.useCase.localMovies = movies
					if movies.isEmpty {
						action.fetchMovies.send(())
						return
					}
					
					let filteredMovies: [Movie] = !state.searchKeyword.isEmpty ? movies.filter { $0.title.lowercased().contains(state.searchKeyword.lowercased()) } : movies
					
					if filteredMovies.isEmpty {
						state.column = 1
						state.cellHeight = 600
						state.dataSources = [.error(.notFound(state.searchKeyword))]
						return
					}
					
					if state.column == 1 {
						state.column = 2
						state.cellHeight = 330
					}
					state.dataSources = filteredMovies.map { .content($0) }
					
				}
			}
			.store(in: cancellables)
		
		action.showLoading
			.sink { isLoading in
				if isLoading, state.dataSources.contains (where: {
					if case .error = $0 { return true }
					if case .shimmer = $0 { return true }
					return false
				}) {
					return state.dataSources = shimmers()
				} else if isLoading {
					state.dataSources = !state.dataSources.isEmpty ? state.dataSources + shimmers() : shimmers()
				} else {
					state.dataSources.removeAll(where: {
						if case .shimmer = $0 { return true }
						return false
					})
				}
			}
			.store(in: cancellables)
		
		action.fetchMovies
			.receive(on: DispatchQueue.global(qos: .userInitiated))
			.filter {
				if state.totalPage == 0 { return true }
				if state.page > state.totalPage { return false }
				return true
			}
			.map {
				action.showLoading.send(true)
				if state.column == 1 {
					state.column = 2
					state.cellHeight = 330
				}
			}
			.flatMap {
				self.useCase.searchMovies(keyword: state.searchKeyword, page: state.page)
					.map { Result.success($0) }
					.catch { Just(Result.failure($0)) }
					.eraseToAnyPublisher()
			}
			.sink { [weak self] result in
				guard let self = self else { return }
				action.showLoading.send(false)
				if case let .failure(error) = result {
					if error.type == .noInternet, self.useCase.localMovies.isEmpty {
						state.column = 1
						state.cellHeight = 600
						state.dataSources = [.error(.noInternet)]
					}
				}
				
				if case let .success(result) = result {
					guard !result.items.isEmpty else {
						state.column = 1
						state.cellHeight = 600
						state.dataSources = [.error(.notFound(state.searchKeyword))]
						return
					}
					state.totalPage = result.totalPages
					let dataSource = state.dataSources.compactMap {
						if case let .content(movie) = $0 { return movie }
						return nil
					}
					
					let differ = dataSource.differentiate(with: result.items) { $0.title }
					
					state.dataSources += differ.onlyInSecond.map { .content($0) }
					
					state.page += 1
					
					action.saveMovies.send(differ.onlyInSecond)
					self.useCase.localMovies += differ.onlyInSecond
				}
			}
			.store(in: cancellables)
		
		action.searchDidChange
			.sink { [weak self] text in
				guard let self = self else { return }
				state.searchKeyword = text
				state.page = 1
				state.totalPage = 0
				state.dataSources.removeAll()
				
				if !Reachability.isConnectedToNetwork() {
					return action.getLocalMovies.send(())
				}
				
				if text.isEmpty {
					state.searchKeyword = "Avengers"
					return action.fetchMovies.send(())
				}
				
				action.fetchMovies.send(())
			}
			.store(in: cancellables)
		
		action.searchDidCancel
			.sink { text in
				guard state.dataSources.contains (where: {
					if case .error = $0 { return true }
					if case .shimmer = $0 { return true }
					return false
				}) else { return }
				state.column = 2
				state.cellHeight = 330
				state.dataSources.removeAll()
				state.searchKeyword = "Avengers"
				action.getLocalMovies.send(())
			}
			.store(in: cancellables)
		
		action.saveMovies
			.receive(on: DispatchQueue.global(qos: .userInitiated))
			.flatMap {
				self.useCase.saveMovies(movies: $0)
					.map { Result.success($0) }
					.catch { Just(.failure($0)) }
					.eraseToAnyPublisher()
			}
			.sink { result in
				if case let .failure(error) = result {
					print("~ MOVIE SUCCESSFULLY SAVED: \(error.localizedDescription)")
				}
				if case let .success(isSaved) = result {
					print("~ MOVIE SUCCESSFULLY SAVED: \(isSaved)")
				}
			}
			.store(in: cancellables)
		
		return state
	}
}
