//
//  Modelo.swift
//  Pelis
//
//  Created by Andres Garcia on 6/28/19.
//  Copyright © 2019 Andrew Inc. All rights reserved.
//

import Foundation
import Alamofire
import Disk



class Modelo  {
    
    
    static let sharedIntance : Modelo = {
        let instance = Modelo ()
        return instance
    }()
    
   
    var configuracion:MDBConfiguracion?
    var resumenTitulos:[ResumenTitulos] = []
    
    
   
    
    func buscarPeliculas(with keyword: String, page: Int,
                      completion: @escaping (PagedCategoryResponse?) -> Void) {
        
        
        if !Utilitario.isConnectedToNetwork() {
            do {
                
                let resultados = resumenTitulos.filter {
                    $0.titulo.range(of: keyword, options: .caseInsensitive) != nil
                }
                
                var pelis:[Pelicula] = []
                
                for res in resultados {
                    let detalle = try Disk.retrieve("PEL" + String(res.id) + ".json", from: .documents, as: PeliculaDetalle.self )
                    let peli = Pelicula.init(titulo: detalle.titulo,
                                             id: detalle.id,
                                             poster_path: detalle.poster_path,
                                             calificacion: detalle.calificacion)
                    
                    if !pelis.contains(where: {$0.titulo == peli.titulo}) {
                        pelis.append(peli)
                    }
                    
                }
                
                let pagedCategoryResponse = PagedCategoryResponse(peliculas:pelis, totalPaginas: 1, totalPeliculas: pelis.count, page: 1)
                
                completion(pagedCategoryResponse)
                return
                
            } catch let error {
                print(error)
                completion(nil)
                return
            }
            
        }
        
        
        
        let uri = getUriSearch(page: page, keyword: keyword)
        Alamofire.request(uri).responseJSON { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let pagedCategoryResponse = try decoder.decode(PagedCategoryResponse.self, from: data)
                print(pagedCategoryResponse.totalPaginas)
                
                if (pagedCategoryResponse.peliculas.count > 0) {
                    print(pagedCategoryResponse.peliculas[0].titulo)
                }
                
                completion(pagedCategoryResponse)
                
            } catch let error {
                print(error)
                completion(nil)
            }
            
        }
        
    }
    
    
    func getVideosPelicula(with id:Int, completion: @escaping ([Video]?) -> Void){
    
        if !Utilitario.isConnectedToNetwork() {
            do {
                let saved = try Disk.retrieve("VIDEOS" + String(id) + ".json", from: .documents, as: [Video].self)
                print(saved.count)
                completion(saved)
                return
            } catch let error {
                print(error)
                completion(nil)
                return
            }
        }
        
        
        let uri = getUriVideos(with: id)
        Alamofire.request(uri).responseJSON { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let videosResponse = try decoder.decode(VideoResponse.self, from: data)
                print(videosResponse.id)
                
                try Disk.save(videosResponse.videos, to: .documents, as: "VIDEOS" + String(id) + ".json")
                
                
                completion(videosResponse.videos)
                
            } catch let error {
                print(error)
                completion(nil)
            }
            
        }
    }
    
    
    
    func getDetallePelicula(with id:Int, completion: @escaping (PeliculaDetalle?) -> Void){
        
        if !Utilitario.isConnectedToNetwork() {
            do {
                let saved = try Disk.retrieve("PEL" + String(id) + ".json", from: .documents, as: PeliculaDetalle.self )
                print(saved.fecha)
                completion(saved)
                return
                
            } catch let error {
                print(error)
                completion(nil)
                return
            }
            
        }
        
        
        let uri = getUriDetailMovie(with: id)
        Alamofire.request(uri).responseJSON { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let detalle = try decoder.decode(PeliculaDetalle.self, from: data)
                print(detalle.tagline)
                
                try Disk.save(detalle, to: .documents, as: "PEL" + String(id) + ".json")
                //Salvamos solo los titulos para busquedas locales
                let titulo = ResumenTitulos(id:detalle.id, titulo:detalle.titulo)
                
                try Disk.append(titulo, to: "resumenTitulos.json", in: .documents)
                
                completion(detalle)
                
            } catch let error {
                print(error)
                completion(nil)
            }
            
        }
        
    }
    
    
    
    func getCrowPelicula(with id:Int, completion: @escaping (_ crew:[Crew]?) -> Void){
        
        let uri = getUriCrewMovie(with: id)
        Alamofire.request(uri).responseJSON { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let detalle = try decoder.decode(CrewResponse.self, from: data)
                print(detalle.crew)
                completion(detalle.crew)
                
            } catch let error {
                print(error)
                completion(nil)
            }
            
        }
        
    }
    

    
    
    func getPeliculas(with tipo: TipoPelicula, page: Int,
                         completion: @escaping (PagedCategoryResponse?) -> Void) {
        
        if !Utilitario.isConnectedToNetwork() {
            do {
                let saved = try Disk.retrieve("PM" + tipo.getStringUrl() + String(page) + ".json", from: .documents, as: PagedCategoryResponse.self )
                print(saved.totalPaginas)
                completion(saved)
                return
                
            } catch let error {
                print(error)
                completion(nil)
                return
            }
            
        }
        
        
        
        let uri = getUriPopularMovies(tipo:tipo,page: page)
        
        Alamofire.request(uri).responseJSON { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let pagedCategoryResponse = try decoder.decode(PagedCategoryResponse.self, from: data)
                print(pagedCategoryResponse.totalPaginas)
                print(pagedCategoryResponse.peliculas[0].titulo)
                
                try Disk.save(pagedCategoryResponse, to: .documents, as: "PM" + tipo.getStringUrl() + String(page) + ".json")
               
                completion(pagedCategoryResponse)
                
                
            } catch let error {
                print(error)
                completion(nil)
            }
            
           }
        
      }
    
    
    
    func getMDBConfiguacion(completion: @escaping (MDBConfiguracion?) -> Void) {
        
        
        do {
            let resumen = try Disk.retrieve("resumenTitulos.json", from: .documents, as: [ResumenTitulos].self )
            print(resumen.count)
            self.resumenTitulos = resumen
        } catch let error {
            print(error)
        }
        
    
        
        if !Utilitario.isConnectedToNetwork() {
            do {
            let retrievedMessage = try Disk.retrieve("configuracion.json", from: .documents, as: MDBConfiguracion.self )
                self.configuracion = retrievedMessage
                completion(retrievedMessage)
            } catch let error {
                print(error)
                completion(nil)
                return
            }
            
        }
    
        
        let uri = getUriMDBConfiguracion()
        Alamofire.request(uri).responseJSON { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let configuracion = try decoder.decode(MDBConfiguracionBase.self, from: data)
                self.configuracion = configuracion.images
                try Disk.save(self.configuracion, to: .documents, as: "configuracion.json")
                completion(configuracion.images)
            } catch let error {
                print(error)
                completion(nil)
            }
            
        }
        
    }
    
    private func getKeyMovieDB() -> String {
        return "68aed791e50705c60dfb1b3be072a47a"    // v3
    }
    
    private func getUriPopularMovies(tipo:TipoPelicula, page:Int) ->  String {
        
        return "https://api.themoviedb.org/3/movie/" + tipo.getStringUrl() + "?api_key=" + getKeyMovieDB() + "&page=" + String(page)
    }
    
    private func getUriMDBConfiguracion() ->  String {
        
        return "https://api.themoviedb.org/3/configuration" + "?api_key=" + getKeyMovieDB()
    }
    
    
    private func getUriDetailMovie(with id:Int) ->  String {
        
        return "https://api.themoviedb.org/3/movie/" + String(id) + "?api_key=" + getKeyMovieDB()
        
    }
    
    private func getUriCrewMovie(with id:Int) ->  String {
        
        return "https://api.themoviedb.org/3/movie/" + String(id) + "/credits?api_key=" + getKeyMovieDB()
        
    }
    
    private func getUriVideos(with id:Int) ->  String {
        
        return "https://api.themoviedb.org/3/movie/" + String(id) + "/videos?api_key=" + getKeyMovieDB()
        
    }
    
    
    
    private func getUriSearch(page:Int, keyword:String) ->  String {
        
        if let s = keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed){
            return "https://api.themoviedb.org/3/search/movie?api_key=" + getKeyMovieDB() + "&query=" + s + "&page=" + String(page)
        } else {
            return "https://api.themoviedb.org/3/search/movie?api_key=" + getKeyMovieDB() + "&query=relax&page=" + String(page)
        }
        
    }

}
