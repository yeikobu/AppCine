//
//  MoviesViewModel.swift
//  AppCine
//
//  Created by Jacob Aguilar on 10-02-22.
//

import Foundation

final class PopularMoviesViewModel: ObservableObject {
    
    @Published var moviesModel: MovieModel?
    @Published var imgUrl: String = "https://image.tmdb.org/t/p/w500"
    
    init() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=3b7f550a381e29852ffb145508b4bdb5")!
    
        URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                if let jsonData = data {
                    let decodeData = try JSONDecoder().decode(MovieModel.self, from: jsonData)
                    DispatchQueue.main.async {
                        self.moviesModel = decodeData

                    }
                }

            } catch {
                print(error)
            }
        }.resume()
    }
}

