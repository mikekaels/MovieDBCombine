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
	
	var cancellables = CancelBag()
	
	let didLoadPublisher = PassthroughSubject<Void, Never>()
	let searchDidCancelPublisher = PassthroughSubject<Void, Never>()
	let searchDidChangePublisher = PassthroughSubject<String, Never>()
	
	override func tearDown() async throws {
		cancellables.cancel()
	}
	
	func test_whenDidLoad_shouldGetLocalMovies() {
		// Given
		let movies = [
			Movie(posterPath: "", year: "1997", title: "Avengers 1", image: nil),
			Movie(posterPath: "", year: "1998", title: "Avengers 2", image: nil),
			Movie(posterPath: "", year: "1999", title: "Avengers 3", image: nil),
		]
		
		let useCase = HomeUseCaseSuccessMock(localMovies: movies)
		
		let viewModel = HomeVM(useCase: useCase)
		
		let action = HomeVM.Action(didLoad: didLoadPublisher.eraseToAnyPublisher(),
							   searchDidCancel: searchDidCancelPublisher.eraseToAnyPublisher(),
							   searchDidChange: searchDidChangePublisher)
		let state = viewModel.transform(action, cancellables)

		// When
		didLoadPublisher.send(())
		
		// Then
		wait {
			XCTAssertEqual(state.dataSources.count, 3)
		}
	}
	
	func test_whenDidLoad_shouldFetchMovieWhenLocalEmpty() {
		// Given
		let useCase = HomeUseCaseSuccessMock()
		let viewModel = HomeVM(useCase: useCase)
		
		let action = HomeVM.Action(didLoad: didLoadPublisher.eraseToAnyPublisher(),
							   searchDidCancel: searchDidCancelPublisher.eraseToAnyPublisher(),
							   searchDidChange: searchDidChangePublisher)
		let state = viewModel.transform(action, cancellables)
		
		// When
		didLoadPublisher.send(())
		
		// Then
		wait {
			XCTAssertEqual(state.dataSources.count, 1)
			XCTAssertEqual(state.page, 2)
		}
	}
	
	func test_whenFetchMovies_shouldShowNotFoundWhenGotEmptyMovies() {
		let useCase = HomeUseCaseSuccessNoMovieMock(networkReachability: true)
		
		let viewModel = HomeVM(useCase: useCase)
		
		let action = HomeVM.Action(didLoad: didLoadPublisher.eraseToAnyPublisher(),
							   searchDidCancel: searchDidCancelPublisher.eraseToAnyPublisher(),
							   searchDidChange: searchDidChangePublisher)
		let state = viewModel.transform(action, cancellables)
		
		// When
		action.searchDidChange.send("hello")
		
		// Then
		wait {
			XCTAssertEqual(state.column, 1)
			XCTAssertEqual(state.cellHeight, 600)
			XCTAssertEqual(state.searchKeyword, "hello")
			XCTAssertEqual(state.dataSources.first!, .error(.notFound("hello")))
		}
	}
	
	func test_whenSearchDidChange_shouldFetchMovie() {
		let useCase = HomeUseCaseSuccessMock(networkReachability: true)
		
		let viewModel = HomeVM(useCase: useCase)
		
		let action = HomeVM.Action(didLoad: didLoadPublisher.eraseToAnyPublisher(),
							   searchDidCancel: searchDidCancelPublisher.eraseToAnyPublisher(),
							   searchDidChange: searchDidChangePublisher)
		let state = viewModel.transform(action, cancellables)
		
		// When
		searchDidChangePublisher.send("seven")
		
		// Then
		wait(timeout: 5.0) {
			XCTAssertEqual(state.searchKeyword, "seven")
			XCTAssertEqual(state.dataSources.count, 1)
			XCTAssertEqual(state.dataSources.first!, .content(Movie(posterPath: "", year: "1997", title: "seven", image: nil)))
		}
	}
	
	func test_whenSearchDidCancel_shouldGetLocalMovies_whenGotNoInternet() {
		let movies = [
			Movie(posterPath: "", year: "1997", title: "Avengers 1", image: nil),
			Movie(posterPath: "", year: "1998", title: "Avengers 2", image: nil),
			Movie(posterPath: "", year: "1999", title: "Avengers 3", image: nil),
		]
		
		let useCase = HomeUseCaseSuccessMock(networkReachability: false, localMovies: movies)
		
		let viewModel = HomeVM(useCase: useCase)
		
		let action = HomeVM.Action(didLoad: didLoadPublisher.eraseToAnyPublisher(),
							   searchDidCancel: searchDidCancelPublisher.eraseToAnyPublisher(),
							   searchDidChange: searchDidChangePublisher)
		let state = viewModel.transform(action, cancellables)
		
		// When
		didLoadPublisher.send(())
		searchDidCancelPublisher.send(())
		
		// Then
		wait {
			XCTAssertEqual(state.searchKeyword, "Avengers")
			XCTAssertEqual(state.column, 2)
			XCTAssertEqual(state.cellHeight, 330)
			XCTAssertEqual(state.dataSources.count, 3)
			XCTAssertEqual(state.dataSources.compactMap {
				if case let .content(movie) = $0 {
					return movie
				}
				return nil
			}, movies)
		}
	}
	
	func test_whenSearchDidCancel_shouldGetLocalMovies() {
		let movies = [
			Movie(posterPath: "", year: "1997", title: "Avengers 1", image: nil),
			Movie(posterPath: "", year: "1998", title: "Avengers 2", image: nil),
			Movie(posterPath: "", year: "1999", title: "Avengers 3", image: nil),
		]
		
		let useCase = HomeUseCaseSuccessMock(networkReachability: false, localMovies: movies)
		
		let viewModel = HomeVM(useCase: useCase)
		
		let action = HomeVM.Action(didLoad: didLoadPublisher.eraseToAnyPublisher(),
							   searchDidCancel: searchDidCancelPublisher.eraseToAnyPublisher(),
							   searchDidChange: searchDidChangePublisher)
		let state = viewModel.transform(action, cancellables)
		
		// When
		didLoadPublisher.send(())
		searchDidCancelPublisher.send(())
		
		// Then
		wait {
			XCTAssertEqual(state.searchKeyword, "Avengers")
			XCTAssertEqual(state.column, 2)
			XCTAssertEqual(state.cellHeight, 330)
			XCTAssertEqual(state.dataSources.count, 3)
			XCTAssertEqual(state.dataSources.compactMap {
				if case let .content(movie) = $0 {
					return movie
				}
				return nil
			}, movies)
		}
	}
	
	func test_whenSearchDidChange_shouldPopulateLocalMovie_WhenNoConnection() {
		// Given
		let useCase = HomeUseCaseSuccessMock(networkReachability: false,
										 localMovies: [
			Movie(posterPath: "", year: "1997", title: "seven", image: nil),
			Movie(posterPath: "", year: "1998", title: "eight", image: nil)
		])
		
		let viewModel = HomeVM(useCase: useCase)
		
		let action = HomeVM.Action(didLoad: didLoadPublisher.eraseToAnyPublisher(),
							   searchDidCancel: searchDidCancelPublisher.eraseToAnyPublisher(),
							   searchDidChange: searchDidChangePublisher)
		let state = viewModel.transform(action, cancellables)
		
		// When
		searchDidChangePublisher.send("seven")
		
		// Then
		wait {
			XCTAssertEqual(state.dataSources.count, 1)
			XCTAssertEqual(state.dataSources.first!, .content(Movie(posterPath: "", year: "1997", title: "seven", image: nil)))
		}
	}
	
}

