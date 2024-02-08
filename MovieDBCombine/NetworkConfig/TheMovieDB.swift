//
//  TheMovieDB.swift
//  MovieDBCombine
//
//  Created by Santo Michael on 03/02/24.
//

import Foundation

extension Constant {
	internal enum TheMovieDB {
		static var apiKey: String {
			return "dabd891097ebc46c5b0cab7182d05e30"
		}
		
		static var authorization: String {
			return "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkYWJkODkxMDk3ZWJjNDZjNWIwY2FiNzE4MmQwNWUzMCIsInN1YiI6IjVlNTg5YTg0ZjQ4YjM0MDAxMzdiMWViYiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.jnEA6v27xVXElLsejJxPBwHfExzp3IogPuZPramfwAs"
		}
		
		static var baseURL: String {
			return "https://api.themoviedb.org/3"
		}
	}
}
