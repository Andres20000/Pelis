//
//  PagedCategoryResponse.swift
//  Pelis
//
//  Created by Andres Garcia on 7/4/19.
//  Copyright © 2019 Andrew Inc. All rights reserved.
//

import Foundation



struct PagedCategoryResponse: Codable {
    let peliculas: [Pelicula]
    let totalPaginas: Int
    let totalPeliculas: Int
    let page: Int
    
    enum CodingKeys: String, CodingKey {
        case peliculas = "results"
        case totalPaginas = "total_pages"
        case totalPeliculas = "total_results"
        case page
    }

}

