//
//  MDBConfiguracion.swift
//  Pelis
//
//  Created by Andres Garcia on 6/30/19.
//  Copyright © 2019 Andrew Inc. All rights reserved.
//

import Foundation


struct MDBConfiguracion: Codable {
    var imagenesUrl:String
    var sizes:[String]
    
    
    
    enum CodingKeys: String, CodingKey {
        case imagenesUrl = "secure_base_url"
        case sizes = "poster_sizes"
    
    }
    
    
    func getSmallUrl() -> String? {
        
        if (sizes.count > 3) {
            return imagenesUrl + sizes[3]
        }
        
        if (sizes.count > 2) {
            return imagenesUrl + sizes[2]
        }
        
        if (sizes.count > 1) {
            return imagenesUrl + sizes[1]
        }
        
        if (sizes.count > 0) {
            return imagenesUrl + sizes[0]
        }
        
        return nil
        
    }
    
    func getLargeUrl() -> String? {
        if (sizes.count > 4) {
            return imagenesUrl + sizes[4]
        }
        
        if (sizes.count > 3) {
            return imagenesUrl + sizes[3]
        }
        
        if (sizes.count > 2) {
            return imagenesUrl + sizes[2]
        }
        
        if (sizes.count > 1) {
            return imagenesUrl + sizes[1]
        }
        
        if (sizes.count > 0) {
            return imagenesUrl + sizes[0]
        }
        
        return nil
        
    }
    
    
}
