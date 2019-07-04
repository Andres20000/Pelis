//
//  BuscarPeliculasTableViewController.swift
//  Pelis
//
//  Created by Andres Garcia on 7/1/19.
//  Copyright © 2019 Andrew Inc. All rights reserved.
//

import UIKit

class BuscarPeliculasTableViewController: UITableViewController, UISearchResultsUpdating {

    
    let tableData:[Pelicula] = []
    var filteredTableData:[Pelicula] = []
    var resultSearchController = UISearchController()
    let modelo = Modelo.sharedIntance
    
    var selectedMovie:Pelicula?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewDidLoad()
        
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.definesPresentationContext = true
        tableView.reloadData()

        
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if  (resultSearchController.isActive) {
            return filteredTableData.count
        } else {
            return tableData.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if (resultSearchController.isActive) {
            cell.textLabel?.text = filteredTableData[indexPath.row].titulo
            
            return cell
        }
        else {
            cell.textLabel?.text = tableData[indexPath.row].titulo
            return cell
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        modelo.buscarPeliculas(with: searchController.searchBar.text!, page: 1) {response in
         
           if response == nil {
               DispatchQueue.main.async {
                    self.filteredTableData.removeAll(keepingCapacity: false)
                    self.filteredTableData.removeAll(keepingCapacity: false)
                    self.tableView.reloadData()
               }
           } else{
               DispatchQueue.main.async {
                self.filteredTableData.removeAll(keepingCapacity: false)
                self.filteredTableData = response!.peliculas
                self.tableView.reloadData()
               }
           }
         
        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovie = filteredTableData[indexPath.row]
        performSegue(withIdentifier: "showDetalle", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetalle" {
            if let vc = segue.destination as? DetallePeliculaViewController {
                vc.pelicula = selectedMovie
            }
        }
    }


}
