//
//  PeliculasVC.swift
//  Pelis
//
//  Created by Andres Garcia on 6/28/19.
//  Copyright © 2019 Andrew Inc. All rights reserved.
//

import UIKit

class PeliculasVC: UIViewController {
    
    
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    private var viewModel: PeliculasViewModel!
    
    private var shouldShowLoadingCell = false
    private var currentType = TipoPelicula.popular
    
    
    let modelo = Modelo.sharedIntance
    
    var selectedMovie:Pelicula?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicatorView.color = UIColor.red
        indicatorView.startAnimating()
        
        tableView.isHidden = true
        tableView.separatorColor = UIColor.black
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.allowsSelection = true
        
        viewModel = PeliculasViewModel(delegate: self)
        
        
        modelo.getMDBConfiguacion() { response in
            
            if response == nil {
                DispatchQueue.main.async {
                
                }
            } else{
                DispatchQueue.main.async {
                    self.viewModel.getPeliculas(tipoPelicula: .popular, reset: true)
 
                }
            }
            
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppUtility.lockOrientation(.portrait)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
    
    
    @IBAction func cambioTipoPelicula(_ sender: Any) {
        
        switch segment.selectedSegmentIndex
        {
        case 0:
            currentType = .popular
            self.viewModel.getPeliculas(tipoPelicula: .popular, reset: true)
        case 1:
            currentType = .topRated
            self.viewModel.getPeliculas(tipoPelicula: .topRated, reset: true)
        case 2:
            currentType = .upcoming
            self.viewModel.getPeliculas(tipoPelicula: .upcoming, reset: true)
        default:
            break
        }
    }
    
    
    
    @IBAction func didTapSearch(_ sender: Any) {
        
        performSegue(withIdentifier: "showBuscar", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetalle" {
            if let vc = segue.destination as? DetallePeliculaViewController {
                vc.pelicula = selectedMovie
            }
        }
    }
    
    
    private func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    
    private func shouldAutorotate() -> Bool {
        return false
    }
    
    
}


extension PeliculasVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        return viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CeldaPeli", for: indexPath) as! CeldaPelicula
        
        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none)
        } else {
            cell.configure(with: viewModel.pelicula(at: indexPath.row))
        }
        return cell
    }
    
}

extension PeliculasVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 555;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovie = viewModel.pelicula(at: indexPath.row)
        performSegue(withIdentifier: "showDetalle", sender: self)
        
    }
}



extension PeliculasVC: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.getPeliculas(tipoPelicula: currentType, reset: false)
        }
    }
}


extension PeliculasVC: PeliculasViewModelDelegate {
    func onCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            indicatorView.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
            return
        }
        // 2
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    func onFailed(with reason: String) {
        indicatorView.stopAnimating()

    }
    
}

private extension PeliculasVC {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

