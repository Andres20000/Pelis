//
//  YouTubeVC.swift
//  Pelis
//
//  Created by Andres Garcia on 7/3/19.
//  Copyright © 2019 Andrew Inc. All rights reserved.
//

import UIKit
import WebKit

class YouTubeVC: UIViewController {

    @IBOutlet weak var web: WKWebView!
    
    var uri = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let req = URLRequest(url: URL(string: uri)!)
        web.load(req)
        
        
    }
    

   

}
