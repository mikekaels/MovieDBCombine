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
	}
}

extension HomeVM {
	struct Action {
		var didLoad: PassthroughSubject<Void, Never>
	}
	
	class State {
		@Published var dataSources: [DataSourceType] = []
		let genre: String = "Action"
		var page: Int = 1
		var totalPage: Int = 1
	}
	
	internal func transform(_ action: Action, _ cancellables: CancelBag) -> State {
		let state = State()
		
		action.didLoad
			.receive(on: DispatchQueue.global(qos: .userInitiated))
			.flatMap {
				self.useCase.getPopularMovies(page: state.page)
					.map { Result.success($0) }
					.catch { Just(Result.failure($0)) }
					.eraseToAnyPublisher()
			}
			.sink { result in
				if case let .failure(error) = result {
					print(error)
				}
				
				if case let .success(result) = result {
					state.page = result.page
					state.totalPage = result.totalPages
					state.dataSources = result.items.map {
						.content($0)
					}
					print(state.dataSources)
				}
			}
			.store(in: cancellables)
		
		
		return state
	}
}
