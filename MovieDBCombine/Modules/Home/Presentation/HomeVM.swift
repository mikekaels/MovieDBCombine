//
//  HomeVM.swift
//  MovieDBCombine
//
//  Created by Santo Michael on 03/02/24.
//

import Foundation
import Networking
import UIKit

internal final class HomeVM {

	enum DataSourceType: Hashable {
		case content(Movie)
	}
}

extension HomeVM {
	struct Action {
		
	}
	
	class State {
		@Published var dataSources: [DataSourceType] = [
			.content(.init(title: "Hello1", color: UIColor.getRandomPrefixColor())),
			.content(.init(title: "World2", color: UIColor.getRandomPrefixColor())),
			.content(.init(title: "Hello3", color: UIColor.getRandomPrefixColor())),
			.content(.init(title: "World4", color: UIColor.getRandomPrefixColor())),
			.content(.init(title: "Hello5", color: UIColor.getRandomPrefixColor())),
			.content(.init(title: "World6", color: UIColor.getRandomPrefixColor())),
			.content(.init(title: "Hello7", color: UIColor.getRandomPrefixColor())),
			.content(.init(title: "World8", color: UIColor.getRandomPrefixColor())),
		]
	}
	
	internal func transform(_ action: Action, _ cancellables: CancelBag) -> State {
		let state = State()
		return state
	}
}
