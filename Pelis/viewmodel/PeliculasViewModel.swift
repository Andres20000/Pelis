//
//  PeliculasViewModel.swift
//  Pelis
//
//  Created by Andres Garcia on 6/29/19.
//  Copyright © 2019 Andrew Inc. All rights reserved.
//

import Foundation


protocol PeliculasViewModelDelegate: class {
    func onCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFailed(with reason: String)
}


final class PeliculasViewModel {
    
    private weak var delegate: PeliculasViewModelDelegate?
    private var peliculas: [Pelicula] = []
    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false
    
    let model = Modelo.sharedIntance
    
    
    init(delegate: PeliculasViewModelDelegate) {
        self.delegate = delegate
    }
    
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return peliculas.count
    }
    
    func pelicula(at index: Int) -> Pelicula {
        return peliculas[index]
    }
    
    func getPeliculas(tipoPelicula: TipoPelicula, reset:Bool) {
        guard !isFetchInProgress else {
            return
        }
        
        if (reset) {
            peliculas.removeAll()
            currentPage = 1
        }
        
        isFetchInProgress = true
        
        model.getPeliculas(with: tipoPelicula, page: currentPage) { response in
            
            if response == nil {
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onFailed(with: "Offline")
                }
            } else{
                DispatchQueue.main.async {
                    print(self.currentPage)
                    self.currentPage += 1
                    self.isFetchInProgress = false
                    self.total = response!.totalPeliculas
                    self.peliculas.append(contentsOf: response!.peliculas)
                    
                    if response!.page > 1 {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: response!.peliculas)
                        self.delegate?.onCompleted(with: indexPathsToReload)
                    } else {
                        self.delegate?.onCompleted(with: .none)
                    }
                }
                
            }
            
            
        }
    }
    
    private func calculateIndexPathsToReload(from newMovies: [Pelicula]) -> [IndexPath] {
        let startIndex = peliculas.count - newMovies.count
        let endIndex = startIndex + newMovies.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
}



