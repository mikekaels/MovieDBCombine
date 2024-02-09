//
//  HomeVMTests.swift
//  MovieDBCombineTests
//
//  Created by Santo Michael on 09/02/24.
//

import XCTest
import Combine
@testable import MovieDBCombine

final class HomeVMTests: XCTestCase {
	
	private var viewModel: HomeVM!
	private var useCase: HomeUseCaseProtocol!
	
	private var action: HomeVM.Action!
	private var state: HomeVM.State!
	
	var cancellables: CancelBag!
	
	let didLoadPublisher = PassthroughSubject<Void, Never>()
	let searchDidCancelPublisher = PassthroughSubject<Void, Never>()
	let searchDidChangePublisher = PassthroughSubject<String, Never>()
	
	
	func test_whenDidLoad_shouldGetLocalMovies() {
		// Given
		useCase = HomeUseCaseSuccessMock()
		useCase.localMovies = [
			Movie(posterPath: "", year: "1997", title: "seven", image: nil),
			Movie(posterPath: "", year: "1998", title: "eight", image: nil),
			Movie(posterPath: "", year: "1999", title: "nine", image: nil),
		]
		
		cancellables = CancelBag()
		viewModel = HomeVM(useCase: useCase)
		
		action = HomeVM.Action(didLoad: didLoadPublisher.eraseToAnyPublisher(),
							   searchDidCancel: searchDidCancelPublisher.eraseToAnyPublisher(),
							   searchDidChange: searchDidChangePublisher)
		
		state = viewModel.transform(action, cancellables)

		// When
		didLoadPublisher.send(())
		
		// Then
		wait {
			XCTAssertEqual(self.state.dataSources.count, 3)
		}
	}
	
	func test_whenDidLoad_shouldFetchMovieWhenLocalEmpty() {
		useCase = HomeUseCaseSuccessMock()
		
		cancellables = CancelBag()
		viewModel = HomeVM(useCase: useCase)
		
		action = HomeVM.Action(didLoad: didLoadPublisher.eraseToAnyPublisher(),
							   searchDidCancel: searchDidCancelPublisher.eraseToAnyPublisher(),
							   searchDidChange: searchDidChangePublisher)
		
		state = viewModel.transform(action, cancellables)
		
		// When
		didLoadPublisher.send(())
		
		// Then
		wait {
			XCTAssertEqual(self.state.dataSources.count, 1)
		}
	}
}

