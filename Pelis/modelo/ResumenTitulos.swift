//
//  ResumenTitulos.swift
//  Pelis
//
//  Created by Andres Garcia on 7/3/19.
//  Copyright © 2019 Andrew Inc. All rights reserved.
//

import Foundation


struct ResumenTitulos: Codable {
    var id:Int
    var titulo:String
    
    enum CodingKeys: String, CodingKey {
        case titulo
        case id
        
    }
    
    
    
}
