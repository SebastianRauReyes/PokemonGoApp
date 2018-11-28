//
//  PokedexViewController.swift
//  PokemonGoApp
//
//  Created by Sebastian Rau Reyes on 21/11/18.
//  Copyright © 2018 Sebastian Rau. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var pokemonsNoAtrapados:[Pokemon] = []
    var pokemonsAtrapados:[Pokemon] = []
    
    var pokemons : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        pokemonsAtrapados = obtenerPokemonsAtrapados()
        pokemonsNoAtrapados = obtenerPokemonsNoAtrapados()
    }
    
    @IBAction func mapTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return pokemonsAtrapados.count
        }else{
            return pokemonsNoAtrapados.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokemon : Pokemon
        if indexPath.section == 0{
            pokemon = pokemonsAtrapados[indexPath.row]
        }else{
            pokemon = pokemonsNoAtrapados[indexPath.row]
        }
        let cell = UITableViewCell()
        cell.textLabel?.text = pokemon.nombre
        cell.imageView?.image = UIImage(named:pokemon.imagenNombre!)
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if( section == 0){
            return "Atrapados"
        }else{
            return "No Atrapados"
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if( indexPath.section == 0){
            return true
        }else{
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            if editingStyle == .delete {
                let pokemon = pokemonsAtrapados[indexPath.row]
                print(pokemon)
                pokemon.atrapado = false
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                pokemonsAtrapados = obtenerPokemonsAtrapados()
                pokemonsNoAtrapados = obtenerPokemonsNoAtrapados()
                tableView.reloadData()
            }
        }
    }
}
