//
//  PokePin.swift
//  PokemonGoApp
//
//  Created by Sebastian Rau Reyes on 21/11/18.
//  Copyright © 2018 Sebastian Rau. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PokePin : NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var pokemon : Pokemon
    init(coord: CLLocationCoordinate2D, pokemon: Pokemon){
        self.coordinate = coord
        self.pokemon = pokemon
    }
}
