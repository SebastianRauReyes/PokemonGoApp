//
//  ViewController.swift
//  PokemonGoApp
//
//  Created by Sebastian Rau Reyes on 21/11/18.
//  Copyright © 2018 Sebastian Rau. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!

    var ubicacion = CLLocationManager()
    var pokemons:[Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemons = obtenerPokemons()
        
        ubicacion.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            setup()
        }else{
            ubicacion.requestWhenInUseAuthorization()
        }
    }
    var contActualizacion:Int = 0
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if(contActualizacion < 1 ){
            let region = MKCoordinateRegionMakeWithDistance(ubicacion.location!.coordinate, 1000, 1000)
            mapView.setRegion(region, animated: true)
            contActualizacion += 1
            print("Ubicación Actualizada...\(contActualizacion)")
        }else{
            ubicacion.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        setup()
    }
    
    func setup(){
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        ubicacion.startUpdatingLocation()
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
            if let coord = self.ubicacion.location?.coordinate{
                
                let pokemon = self.pokemons[Int(arc4random_uniform(UInt32(self.pokemons.count)))]
                
                let pin = PokePin(coord: coord, pokemon: pokemon)
                
                let randomLat = (Double(arc4random_uniform(200))-100.0)/50000.0
                let randomLon = (Double(arc4random_uniform(200))-100.0)/50000.0
                pin.coordinate.longitude += randomLon
                pin.coordinate.latitude += randomLat
                self.mapView.addAnnotation(pin)
            }
        })
    }
    
    
    
    
    @IBAction func CentrarTapped(_ sender: Any) {
        if let coord = ubicacion.location?.coordinate{
            let region = MKCoordinateRegionMakeWithDistance(ubicacion.location!.coordinate, 1000, 1000)
            mapView.setRegion(region, animated: true)
            contActualizacion += 1
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            let pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pinView.image = UIImage(named:"player")
            
            var frame = pinView.frame
            frame.size.height = 50
            frame.size.width = 50
            pinView.frame = frame
            
            return pinView
        }
        let pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        let pokemon = (annotation as! PokePin).pokemon
        
        pinView.image = UIImage(named:pokemon.imagenNombre!)
        
        var frame = pinView.frame
        frame.size.height = 40
        frame.size.width = 40
        pinView.frame = frame
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        if view.annotation is MKUserLocation{
            return
        }
        print("PIN PRESIONADO!")
        let region =  MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 600, 600)
        mapView.setRegion(region, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
            if let coord = self.ubicacion.location?.coordinate{
                let pokemon = (view.annotation as! PokePin).pokemon
               
                if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coord)){
                    print("Puede atrapar al pokemon");
                    
                    
                    var nombre = pokemon.nombre
                    var pokemones = obtenerPokemonsAtrapados();
                    var mipokemon = pokemones[1];

                    for pokemone in pokemones{
                        if(nombre == pokemone.nombre){
                            print("Ya atrapado el poquemon")
                            let alertVC = UIAlertController(title: "Alerta!", message: "El pokemon ya está atrapado.", preferredStyle: .alert)
                            
                            let pokedexAccion = UIAlertAction(title: "Capturar", style: .default, handler: {(action) in
                                mapView.removeAnnotation(view.annotation!)
                                self.performSegue(withIdentifier: "pokedexSegue", sender: nil)
                            })
                            let CancelarAction = UIAlertAction(title: "Cancelar", style: .default, handler: {(action) in
                                 return
                            })
                            
                            alertVC.addAction(pokedexAccion)
                            alertVC.addAction(CancelarAction)
                            
                            self.present(alertVC, animated: true, completion: nil)
                            return
                        }
                    }
                    pokemon.atrapado = true
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    mapView.removeAnnotation(view.annotation!)
                    
                    let alertVC = UIAlertController(title: "Felicidades!", message: "Atrapaste a un \(pokemon.nombre!)", preferredStyle: .alert)
                    let pokedexAccion = UIAlertAction(title: "Pokedex", style: .default, handler: {(action) in
                        self.performSegue(withIdentifier: "pokedexSegue", sender: nil)
                    })
                    alertVC.addAction(pokedexAccion)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertVC.addAction(okAction)
                    self.present(alertVC, animated: true, completion: nil)
                    
                }else{
                    print("No puede atrapar al pokemon");
                    let alertVC = UIAlertController(title: "Ups!", message: "Estas muy lejos de ese \(pokemon.nombre!)", preferredStyle: .alert)
                    let okAccion = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertVC.addAction(okAccion)
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
        })
        func setup2(){
            
        }
    }
}

