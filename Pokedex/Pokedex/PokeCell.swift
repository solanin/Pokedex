//
//  PokeCell.swift
//  Pokedex
//
//  Created by Jacob Westerback (RIT Student) on 4/26/17.
//  Copyright © 2017 Jacob Westerback (RIT Student). All rights reserved.
//

import Foundation
import UIKit

// Used for Cell in list of Pokemon

class PokeCell: UITableViewCell {
    
    // MARK: - Vars
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var numberLabel:UILabel!
    @IBOutlet weak var sprite:UIImageView!
    @IBOutlet weak var type1:UILabel!
    @IBOutlet weak var type2:UILabel!    

    // MARK: - Setup
    func configure(pokemon:Pokemon) {
        // loads info from pokemon into cell
        
        nameLabel.text = pokemon.name
        numberLabel.text = pokemon.numString
        
        type1.text = pokemon.type[0]
        type1.backgroundColor = PokeData.typeColors[pokemon.type[0].lowercased()]
        if (pokemon.type.count > 1) {
            type2.isHidden = false
            type2.text = pokemon.type[1]
            type2.backgroundColor = PokeData.typeColors[pokemon.type[1].lowercased()]
        } else {
            type2.isHidden = true
        }
        
        sprite.downloadedFrom(link: pokemon.sprites[PokeData.defalutSprite] as! String)
    }
}
