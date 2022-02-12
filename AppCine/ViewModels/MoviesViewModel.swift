//
//  MoviesViewModel.swift
//  AppCine
//
//  Created by Jacob Aguilar on 10-02-22.
//

import Foundation
import SwiftUI

final class MoviesViewModel: ObservableObject {
    
    @Published var moviesModel: MovieModel?
    @Published var imgUrl: String = "https://image.tmdb.org/t/p/w500"
    
    func getMovieData() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=3b7f550a381e29852ffb145508b4bdb5")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                if let jsonData = data {
                    print("JSON size: \(jsonData)")
                    let json = try JSONSerialization.jsonObject(with: jsonData)
                    print(json)
                    let decodeData = try JSONDecoder().decode(MovieModel.self, from: jsonData)
                    
                    DispatchQueue.main.async {
                        self.moviesModel = decodeData
                        self.moviesModel?.results?.forEach({ result in
                            print(result.title ?? "")
                        })
                        
                       
                    }
                }
                
            } catch {
                print(error)
            }
        }.resume()
    }
}

