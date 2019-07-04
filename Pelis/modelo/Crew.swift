//
//  Crew.swift
//  Pelis
//
//  Created by Andres Garcia on 7/4/19.
//  Copyright © 2019 Andrew Inc. All rights reserved.
//

import Foundation


struct Crew: Codable {
    var job:String
    var name: String
}

struct CrewResponse: Codable {
    let crew: [Crew]
    let id: Int
}
