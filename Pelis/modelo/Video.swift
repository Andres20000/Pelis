//
//  Video.swift
//  Pelis
//
//  Created by Andres Garcia on 7/3/19.
//  Copyright © 2019 Andrew Inc. All rights reserved.
//

import Foundation


struct Video:Codable {
    var id:String
    var key:String
    var site:String
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case key
        case site
        
    }
    
    var url:String {
        if site == "YouTube" {
            return "https://www.youtube.com/watch?v=" + key
        }
        if site == "Vimeo" {
            return "https://vimeo.com/" + key
        }
        
        return "https://www.youtube.com/watch?v=" + key
    }
    
    var isYouTube:Bool {
        if site == "YouTube" {
            return true
        }
        if site == "Vimeo" {
            return false
        }
        
        return false
        
        
    }
    
}

struct VideoResponse: Codable {
    let videos: [Video]
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case videos = "results"
        
    }
}

