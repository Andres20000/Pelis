//
//  Pelicula.swift
//  Pelis
//
//  Created by Andres Garcia on 6/29/19.
//  Copyright © 2019 Andrew Inc. All rights reserved.
//

import Foundation



public enum TipoPelicula {
    case popular
    case topRated
    case upcoming
    
    func getStringUrl() -> String {
        switch self {
        case .popular:
            return "popular"
        case .topRated:
            return "top_rated"
        case .upcoming:
            return "upcoming"
            
        }
        
    }
}




struct Pelicula: Codable {
    var titulo:String
    var id:Int
    var poster_path:String?
    var calificacion:Double
    
    
    
    
    enum CodingKeys: String, CodingKey {
        case titulo = "title"
        case id
        case poster_path
        case calificacion = "vote_average"
        
        
    }
    
    var calificacionFormat:String {
        return String(format: "%.1f", calificacion)
    }
    
}



struct PeliculaDetalle: Codable {
    
    var titulo:String
    var poster_path:String?
    var calificacion:Double

    var resumen:String
    var id:Int
    var fecha:String
    var tagline:String
    var lenguajeOriginal:String
    var ganancias:Int
    var presupuesto:Int
    
    var duracion:Int?
    var detalle:String?
    
    var duracionFormat:String {
        get {
            if duracion == nil {
                return "-"
            }
            else {
                let horas = duracion! / 60
                let minutos = duracion! % 60
                return "\(horas)h \(minutos)m"
            }
        }
    }
    
    
    var gananciasFormat:String{
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencyCode = "USD"
        currencyFormatter.currencySymbol = "$"
        return currencyFormatter.string(for: ganancias) ?? ""
    }
    
    var presupuestoFormat:String{
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencyCode = "USD"
        currencyFormatter.currencySymbol = "$"
        return currencyFormatter.string(for: presupuesto) ?? ""
    }
    
    var idiomaFormat:String {
        let current = Locale(identifier: "en_US")
        return current.localizedString(forLanguageCode: lenguajeOriginal)!
    }
    
    var calificacionFormat:String {
        return String(format: "%.1f", calificacion)
    }
    
    enum CodingKeys: String, CodingKey {
        case titulo = "title"
        case id
        case poster_path
        case calificacion = "vote_average"
        case resumen = "overview"
        case fecha = "release_date"
        case tagline
        case lenguajeOriginal = "original_language"
        case ganancias = "revenue" 
        case presupuesto = "budget"
        case duracion = "runtime"
        case detalle
        
    }
    
}




