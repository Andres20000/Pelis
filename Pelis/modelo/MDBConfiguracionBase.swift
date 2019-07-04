//
//  MDBConfiguracionBase.swift
//  Pelis
//
//  Created by Andres Garcia on 6/30/19.
//  Copyright © 2019 Andrew Inc. All rights reserved.
//

import Foundation


struct MDBConfiguracionBase: Decodable {
    var images:MDBConfiguracion
    
    enum CodingKeys: String, CodingKey {
        case images
    
    }
    
    
}
