//
//  DetallePeliculaViewController.swift
//  Pelis
//
//  Created by Andres Garcia on 7/2/19.
//  Copyright © 2019 Andrew Inc. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class DetallePeliculaViewController: UIViewController {

    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var poster: UIImageView!
    
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var tagline: UILabel!
    @IBOutlet weak var calificacion: UILabel!
    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var job: UILabel!
    
    
    @IBOutlet weak var idioma: UILabel!
    @IBOutlet weak var duracion: UILabel!
    @IBOutlet weak var presupuesto: UILabel!
    @IBOutlet weak var ganancias: UILabel!
    
    @IBOutlet weak var play: UIButton!
    
    
    let modelo = Modelo.sharedIntance
    var pelicula:Pelicula?
    var uri = ""
    var isYoutube = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if pelicula == nil{
            return
        }
        
        overview.text = ""
        tagline.text = ""
        job.text = ""
        name.text = ""
        idioma.text = ""
        duracion.text = ""
        presupuesto.text = ""
        ganancias.text = ""
        
        play.alpha = 0;
        play.isEnabled = false
        
        
        
        titulo?.text = self.pelicula!.titulo
        calificacion.text = self.pelicula!.calificacionFormat
        
        
        if pelicula!.poster_path != nil {
            let url = modelo.configuracion!.getSmallUrl()! + pelicula!.poster_path!
            let imageURL =  URL(string: url)
            poster.sd_setImage(with: imageURL)
        }
        
        
        modelo.getDetallePelicula(with: pelicula!.id) {response in
            
            if response == nil {  // Si falla
                DispatchQueue.main.async {
                    

                }
            } else{
                DispatchQueue.main.async {
                    print(response!.resumen)
                    self.overview.text = response?.resumen
                    self.tagline.text = response?.tagline
                    self.idioma.text = response?.idiomaFormat
                    self.duracion.text = response?.duracionFormat
                    self.presupuesto.text = response?.presupuestoFormat
                    self.ganancias.text = response?.gananciasFormat
                    
                   
                }
            }
            
        }
        
        modelo.getCrowPelicula(with: pelicula!.id) {response in
            
            if response == nil {  // Si falla
                DispatchQueue.main.async {
                    
                    
                }
            } else{
                DispatchQueue.main.async {
                    
                    if response!.count == 0 {
                        return
                    }

                    self.job.text = response![0].job
                    self.name.text = response![0].name
                    
                
                }
            }
            
        }
        
        
        modelo.getVideosPelicula(with: pelicula!.id) {response in
            
            if response == nil {  // Si falla
                DispatchQueue.main.async {
                    self.play.alpha = 0;
                    self.play.isEnabled = false
                    
                    
                    
                }
            } else{
                DispatchQueue.main.async {
                    
                    if response!.count > 0 {
                        self.play.alpha = 1;
                        self.play.isEnabled = true
                        self.uri = response![0].url
                        self.isYoutube = response![0].isYouTube
                        
                    }
                    
                }
            }
            
        }
    
    }
    
    
    @IBAction func didTapPlay(_ sender: Any) {
        
        if uri == "" {
            return
        }
        
        if (isYoutube) {
            performSegue(withIdentifier: "showYouTube", sender: self)
            return
        }
        
        
        
        let videoURL = URL(string: uri)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
        
    
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showYouTube" {
            if let vc = segue.destination as? YouTubeVC {
                vc.uri = uri
            }
        }
    }
    
    
    

   

}
