//
//  PopularMovieRequest.swift
//  MovieDBCombine
//
//  Created by Santo Michael on 07/02/24.
//

import Networking

internal struct PopularMovieRequest: APIRequest {
	
	typealias Response = BaseModel<[Movie]>
	
	init(page: Int) {
		path = "/discover/movie?page=\(page)"
	}
	
	var baseURL: String = Constant.TheMovieDB.baseURL
	
	var method: HTTPMethod = .get
	
	var path: String = ""
	
	var headers: [String : Any] = [
		"Authorization":"Bearer \(Constant.TheMovieDB.authorization)",
		"Content-Type": "application/json; charset=UTF-8"
	]
	
	var body: [String : Any] = [:]
	
	func map(_ data: Data) throws -> BaseModel<[Movie]> {
		let decoded = try JSONDecoder().decode(BaseResponse<[MovieResponse]>.self, from: data)
		
		let movies = decoded.results?.compactMap {
			let releaseData = $0.releaseDate ?? ""
			let year = String(releaseData.prefix(4))
			return Movie(posterPath: "https://image.tmdb.org/t/p/w200/\($0.posterPath ?? "")", year: year, title: $0.title ?? "")
		}
		
		let result = BaseModel<[Movie]>(page: decoded.page ?? 0, totalPages: decoded.totalPages ?? 0, items: movies ?? [])
		return result
	}
}

