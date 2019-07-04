//
//  CeldaPelicula.swift
//  Pelis
//
//  Created by Andres Garcia on 6/29/19.
//  Copyright © 2019 Andrew Inc. All rights reserved.
//

import UIKit
import SDWebImage





class CeldaPelicula: UITableViewCell {
    @IBOutlet var displayNameLabel: UILabel!
    

    @IBOutlet var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var panelCalificacion: UIView!
    @IBOutlet weak var valor: UILabel!
    
    
    let modelo = Modelo.sharedIntance
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        configure(with: .none)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        indicatorView.hidesWhenStopped = true
        indicatorView.color = UIColor.red
    }
    
    func configure(with pelicula: Pelicula?) {
        if let pelicula = pelicula {
            displayNameLabel?.text = pelicula.titulo
            valor.text = String(format: "%.1f", pelicula.calificacion)
            displayNameLabel.alpha = 1
            poster.alpha = 1
            panelCalificacion.alpha = 1
            
            indicatorView.stopAnimating()
            
            
            if pelicula.poster_path != nil {
                let url = modelo.configuracion!.getSmallUrl()! + pelicula.poster_path!
                let imageURL =  URL(string: url)
                poster.sd_setImage(with: imageURL)
            }
           
            
            
            
            
        } else {
            poster.alpha = 0
            panelCalificacion.alpha = 0
            indicatorView.startAnimating()
        }
    }
}

