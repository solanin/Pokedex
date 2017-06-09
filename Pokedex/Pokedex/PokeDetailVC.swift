//
//  PokeDetailVC.swift
//  Pokedex
//
//  Created by Jacob Westerback (RIT Student) on 4/26/17.
//  Copyright © 2017 Jacob Westerback (RIT Student). All rights reserved.
//

import UIKit

class PokeDetailVC: UIViewController {
    
    // MARK: - Variables
    
    var pokemon:Pokemon?
    
    // Title
    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var number:UILabel!
    @IBOutlet weak var type1:UILabel!
    @IBOutlet weak var type2:UILabel!
    @IBOutlet weak var sprite:UIImageView!
    
    // Sections
    @IBOutlet weak var info:UIStackView!
    @IBOutlet weak var stat:UIStackView!
    @IBOutlet weak var breed:UIStackView!
    
    // Info
    @IBOutlet weak var resist:UILabel!
    @IBOutlet weak var weak:UILabel!
    @IBOutlet weak var imune:UILabel!
    @IBOutlet weak var ability1:UILabel!
    @IBOutlet weak var ability2:UILabel!
    @IBOutlet weak var ability3:UILabel!
    @IBOutlet weak var species:UILabel!
    @IBOutlet weak var desc:UILabel!
    @IBOutlet weak var ht:UILabel!
    @IBOutlet weak var wt:UILabel!
    
    // Stats
    @IBOutlet weak var evYeild:UILabel!
    @IBOutlet weak var catchRate:UILabel!
    @IBOutlet weak var growthRate:UILabel!
    @IBOutlet weak var baseHappy:UILabel!
    @IBOutlet weak var baseXP:UILabel!
    @IBOutlet weak var hp:UILabel!
    @IBOutlet weak var atk:UILabel!
    @IBOutlet weak var def:UILabel!
    @IBOutlet weak var spAtk:UILabel!
    @IBOutlet weak var spDef:UILabel!
    @IBOutlet weak var speed:UILabel!
    @IBOutlet weak var tot:UILabel!
    
    // Breeding
    @IBOutlet weak var evolution:UILabel!
    @IBOutlet weak var gender:UILabel!
    @IBOutlet weak var eggGroup:UILabel!
    @IBOutlet weak var eggCycles:UILabel!
    
    
    
    // UI
    @IBOutlet weak var favBtn: UIBarButtonItem!
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Notificaiton Listening
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: pokedexLoadedNotificaiton, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: favoritesChangedNotification, object: nil)
        
        // Set Page
        info.isHidden = false
        stat.isHidden = true
        breed.isHidden = true
        
        // Get data if its not there
        if (!pokemon!.downloaded) {
            pokemon!.loadPokemon()
        }

        setUp()
        
    }
    
    // Sets up Display
    func setUp() {
        // Do any additional setup after loading the view.
        if (pokemon != nil) {
            title = pokemon!.numAndName
            
            // UI
            if (pokemon!.isFavorite) {
                favBtn.image = #imageLiteral(resourceName: "Favorite")
            } else {
                favBtn.image = #imageLiteral(resourceName: "Unfavorite")
            }
            
            // Title
            name.text = pokemon!.name
            number.text = pokemon!.numString
            
            type1.text = pokemon!.type[0]
            type1.backgroundColor = PokeData.typeColors[pokemon!.type[0].lowercased()]
            if (pokemon!.type.count > 1) {
                type2.isHidden = false
                type2.text = pokemon!.type[1]
                type2.backgroundColor = PokeData.typeColors[pokemon!.type[1].lowercased()]
            } else {
                type2.isHidden = true
            }
            
            sprite.downloadedFrom(link: pokemon?.sprites["front_default"] as! String)
            
            // Info
            resist.text = ""
            for t in PokeData.getDamage(type: pokemon!.type, amt: .strong) {
                resist.text = "\(resist.text!)\(t) , "
            }
            if (resist.text!.contains(" , ")) {
                resist.text = strip(list: resist.text!, by: 3)
            } else {
                resist.text = "none"
            }
            
            imune.text = ""
            for t in PokeData.getDamage(type: pokemon!.type, amt: .immune) {
                imune.text = "\(imune.text!)\(t) , "
            }
            if (imune.text!.contains(" , ")) {
                imune.text = strip(list: imune.text!, by: 3)
            } else {
                imune.text = "none"
            }
            
            weak.text = ""
            for t in PokeData.getDamage(type: pokemon!.type, amt: .weak) {
                weak.text = "\(weak.text!)\(t) , "
            }
            if (weak.text!.contains(" , ")) {
                weak.text = strip(list: weak.text!, by: 3)
            } else {
                weak.text = "none"
            }
            
            var entered = 0
            for a in pokemon!.abilities {
                if (a.value) {
                    ability3.text = a.key + " (Hidden)"
                } else if (entered < 1) {
                    entered = 1
                    ability1.text = a.key
                } else {
                    entered = 2
                    ability2.isHidden = false
                    ability2.text = a.key
                }
            }
            if (entered != 2) {
                ability2.isHidden = true
            }
            
            species.text = pokemon!.species
            desc.text = pokemon!.desc
            ht.text = "\(pokemon!.height) m"
            wt.text = "\(pokemon!.weight) kg"
            
            // Stats
            for ev in pokemon!.EVYeild {
                evYeild.text = "\(evYeild.text)\(ev.key) : \(ev.value) , "
            }
            evYeild.text = strip(list: evYeild.text!, by: 3)
            
            // TO DO: FIND INFO
            evYeild.text = "Unknown"
            
            catchRate.text = "\(pokemon!.catchRate)"
            growthRate.text = "\(pokemon!.growthRate)"
            baseHappy.text = "\(pokemon!.baseHappy)"
            baseXP.text = "\(pokemon!.baseXP)"
            
            hp.text = "\(pokemon!.baseHP)"
            atk.text = "\(pokemon!.baseAtk)"
            spAtk.text = "\(pokemon!.baseSpAtk)"
            def.text = "\(pokemon!.baseDef)"
            spDef.text = "\(pokemon!.baseSpDef)"
            speed.text = "\(pokemon!.baseSpeed)"
            tot.text = "Total: \(pokemon!.totalBase)"
            
            // Breeding
            evolution.text = ""
            for obj in pokemon!.evolutionTree {
                if(obj.hasParent) {
                   evolution.text = "\(evolution.text!)\(obj.parent) evolves into \(obj.child) \n"
                }
            }
            if (evolution.text == "") {
                evolution.text = "This pokemon does not evolve"
            }
            
            if (pokemon!.genderRatio != -1) {
                gender.text = "\(pokemon!.femPercent)% Female, \(pokemon!.malePercent)% Male"
            } else {
                gender.text = "Genderless"
            }
            eggGroup.text = ""
            for group in pokemon!.eggGroup {
                eggGroup.text = "\(eggGroup.text!)\(group) , "
            }
            if (gender.text == "Genderless") {
                eggGroup.text = "\(eggGroup.text!)Gender Unknown , "
            }
            if (eggGroup.text!.contains(" , ")) {
                eggGroup.text = strip(list: eggGroup.text!, by: 3)
            }
            eggCycles.text = "\(pokemon!.eggcycles) (~\(pokemon!.steps) steps)"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI
    // Fav btn
    @IBAction func toggleFav(_ sender: UIBarButtonItem) {
        pokemon?.toggleFav()
        if (pokemon!.isFavorite) {
            favBtn.image = #imageLiteral(resourceName: "Favorite")
        } else {
            favBtn.image = #imageLiteral(resourceName: "Unfavorite")
        }
        
    }
    
    //On Screen Info Navigation
    @IBAction func infoBarChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            info.isHidden = false
            stat.isHidden = true
            breed.isHidden = true
            break;
        case 1:
            info.isHidden = true
            stat.isHidden = false
            breed.isHidden = true
            break;
        case 2:
            info.isHidden = true
            stat.isHidden = true
            breed.isHidden = false
            break;
        default:
            break; 
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func exitDetail(segue:UIStoryboardSegue) {
    }
    
    // MARK: - Helpers
    private func strip(list:String, by:Int) -> String {
        return list.substring(to: list.index(list.endIndex, offsetBy: (-1*by)))
    }
    
    func reload() {
        print("Reload Detail")
        setUp()
    }
}
