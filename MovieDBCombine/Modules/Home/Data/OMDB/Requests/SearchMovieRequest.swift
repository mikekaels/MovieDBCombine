//
//  SearchMovieRequest.swift
//  MovieDBCombine
//
//  Created by Santo Michael on 08/02/24.
//

import Networking

internal struct SearchMovieRequest: APIRequest {
	
	typealias Response = BaseModel<[Movie]>
	let page: Int
	
	init(page: Int, keyword: String) {
		self.page = page
		path = "/?apikey=\(Constant.OMDB.apiKey)&s=\(keyword)&page=\(page)"
	}
	
	var baseURL: String = Constant.OMDB.baseURL
	
	var method: HTTPMethod = .get
	
	var path: String = ""
	
	var headers: [String : Any] = [:]
	
	var body: [String : Any] = [:]
	
	func map(_ data: Data) throws -> BaseModel<[Movie]> {
		let decoded = try JSONDecoder().decode(SearchMovieResponse.self, from: data)
		let totalResult = Int(decoded.totalResults ?? "0") ?? 0
		let movies = decoded.search?.compactMap {
			Movie(posterPath: $0.poster ?? "", year: $0.year ?? "", title: $0.title ?? "")
		}
		
		return BaseModel(page: page, totalPages: totalResult / 10 == 0 ? 1 : totalResult / 10, items: movies ?? [])
	}
}


