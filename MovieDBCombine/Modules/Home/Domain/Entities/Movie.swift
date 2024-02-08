//
//  Movie.swift
//  MovieDBCombine
//
//  Created by Santo Michael on 03/02/24.
//

import Foundation


internal struct Movie: Hashable, Identifiable {
	let id = UUID()
	let posterPath, year, title: String
}
