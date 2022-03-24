//
//  SearchMovie.swift
//  AppCine
//
//  Created by Jacob Aguilar on 24-03-22.
//

import Foundation

final class SearchMovie: ObservableObject {
    
    @Published var movieModel: MovieModel?
    @Published var imgUrl: String = "https://image.tmdb.org/t/p/w500"
    @Published var searchedMovie: String = ""
    
    init() {
        let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=3b7f550a381e29852ffb145508b4bdb5&language=es-ES&query=\(searchedMovie)")!
    
        URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                if let jsonData = data {
                    let decodeData = try JSONDecoder().decode(MovieModel.self, from: jsonData)
                    print("Peliculas encontradas: ")
                    print(decodeData)
                    DispatchQueue.main.async {
                        self.movieModel = decodeData
                    }
                }

            } catch {
                print(error)
            }
        }.resume()
    }
    
    func searchMovie() {
        let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=3b7f550a381e29852ffb145508b4bdb5&language=en-EN&query=\(searchedMovie)")!
    
        URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                if let jsonData = data {
                    let decodeData = try JSONDecoder().decode(MovieModel.self, from: jsonData)
                    print("Peliculas encontradas: ")
                    print(decodeData)
                    DispatchQueue.main.async {
                        self.movieModel = decodeData
                    }
                }

            } catch {
                print(error)
            }
        }.resume()
    }
}
