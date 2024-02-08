//
//  HomeVM.swift
//  MovieDBCombine
//
//  Created by Santo Michael on 03/02/24.
//

import Combine
import UIKit

internal final class HomeVM {
	let useCase: HomeUseCaseProtocol
	
	init(useCase: HomeUseCaseProtocol = HomeUseCase()) {
		self.useCase = useCase
	}

	enum DataSourceType: Hashable {
		case content(Movie)
		case shimmer(String)
		case error(image: String, title: String, desc: String, buttonTitle: String? = nil)
	}
}

extension HomeVM {
	struct Action {
		var didLoad: PassthroughSubject<Void, Never>
		var searchDidCancel: AnyPublisher<Void, Never>
		var searchDidChange: PassthroughSubject<String, Never>
		let showLoading = PassthroughSubject<Bool, Never>()
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
		
		action.showLoading
			.sink { isLoading in
				if isLoading, state.dataSources.contains (where: {
					if case .error = $0 { return true }
					if case .shimmer = $0 { return true }
					return false
				}) {
					return state.dataSources = self.useCase.shimmers()
				} else if isLoading {
					state.dataSources = !state.dataSources.isEmpty ? state.dataSources + self.useCase.shimmers() : self.useCase.shimmers()
				} else {
					state.dataSources.removeAll(where: {
						if case .shimmer = $0 { return true }
						return false
					})
				}
			}
			.store(in: cancellables)
		
		action.didLoad
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
			.sink { result in
				action.showLoading.send(false)
				if case let .failure(error) = result {
					if error.type == .noInternet {
						state.column = 1
						state.cellHeight = 600
						state.dataSources = [.error(image: "no_internet", title: "No internet", desc: "Check your connection or try again", buttonTitle: "Try again")]
					}
				}
				
				if case let .success(result) = result {
					guard !result.items.isEmpty else {
						state.column = 1
						state.cellHeight = 600
						state.dataSources = [.error(image: "not_found", title: "Not found", desc: "Sorry, we couldn't find movie with title \"\(state.searchKeyword)\"")]
						
						return
					}
					state.totalPage = result.totalPages
					
					state.dataSources += result.items.map { .content($0) }
					
					state.page += 1
				}
			}
			.store(in: cancellables)
		
		action.searchDidChange
			.debounce(for: 0.75, scheduler: DispatchQueue.main)
			.sink { text in
				state.searchKeyword = text
				state.page = 1
				state.totalPage = 0
				state.dataSources.removeAll()
				guard !text.isEmpty else {
					state.searchKeyword = "Avengers"
					action.didLoad.send(())
					return
				}
				action.didLoad.send(())
			}
			.store(in: cancellables)
		
		action.searchDidCancel
			.sink { text in
				guard state.dataSources.contains (where: {
					if case .error = $0 { return true }
					if case .shimmer = $0 { return true }
					return false
				}) else { return }
				state.dataSources.removeAll()
				state.searchKeyword = "Avengers"
				action.didLoad.send(())
			}
			.store(in: cancellables)
		
		return state
	}
}

extension AnyPublisher {
	func toSubject() -> PassthroughSubject<Output, Failure> {
		let subject = PassthroughSubject<Output, Failure>()
		
		let _ = Deferred {
			self
		}.sink(
			receiveCompletion: { _ in },
			receiveValue: { value in
				subject.send(value)
			}
		)
		
		return subject
	}
}

