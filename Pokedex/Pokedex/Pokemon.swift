//
//  Pokemon.swift
//  Pokedex
//
//  Created by Jacob Westerback (RIT Student) on 4/26/17.
//  Copyright © 2017 Jacob Westerback (RIT Student). All rights reserved.
//

import Foundation
import UIKit

class Pokemon : NSObject,NSCoding {
    
    // MARK: - Variables
    
    // For Evolution
    static let noParent = "No Parent"
    
    // Basic
    var name:String
    var number:Int32   // In Species
    var type:[String]
    var sprites:[String : AnyObject]
    var pkmnURL:String
    var speciesURL:String
    var isDefault:Bool
    var numAndName:String {
		return "\(numString) \(name)"
	}
	
    // Abilities
    var abilities:[String : Bool]
    
    // Evolution
    var evolutionURL:String  // In Species
    var evolutionTree:[Evolution] // In Evolution

    
    // Base Stats
    var baseHP:Int32
    var baseAtk:Int32
    var baseSpAtk:Int32
    var baseDef:Int32
    var baseSpDef:Int32
    var baseSpeed:Int32
    var totalBase:Int32 {
        return baseHP + baseAtk + baseSpAtk + baseDef + baseSpDef + baseSpeed
    }
    
    // Info
    var desc:String  // In Species (Flavor_Text_Entries)
    var species:String  // In Species (Genera)
    var height:Double
    var weight:Double
    
    // Training
    var EVYeild:[String:Int32]  // Not Yet Located
    var catchRate:Int32  // In Species
    var growthRate:String  // In Species
    var baseHappy:Int32  // In Species
    var baseXP:Int32
    
    // Breeding
    var genderRate:Int32  // In Species (Gender Rate)
    var genderRatio:Float {
        if (genderRate == -1) {
            return Float(genderRate) // Genderless
        }
        else {
            return (Float(genderRate) / 8.0)
        }
        // Returns % chance female
    }
    var femPercent:Float {
        return genderRatio * 100
    }
    var malePercent:Float {
        return (100 - femPercent)
    }
    var eggGroup:[String]  // In Species
    var eggcycles:Int32  // In Species (Hatch Counter)
    var steps:Int32 {
        return 257 * eggcycles
    }
    
    // Organization
    
    // Fav
    var downloaded:Bool
    private var fav:Bool
    
    // API
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?
    
    
    // MARK: - Initialization
    
    // EMPTY
    init (name:String, num:Int32, url:String, type:[String], sprite:String) {
        // Data
        
        // Basic
        self.pkmnURL = url
        self.speciesURL = ""
        self.name = name.capitalized
        self.number = num
        self.type = type
        self.sprites = ["front_default":sprite as AnyObject]
        self.isDefault = false
        
        // Abilities
        self.abilities = ["":false]
        
        // Evolution
        self.evolutionURL = ""
        self.evolutionTree = []
        
        // Base Stats
        self.baseHP = 0
        self.baseAtk = 0
        self.baseSpAtk = 0
        self.baseDef = 0
        self.baseSpDef = 0
        self.baseSpeed = 0

        // Info
        self.desc = ""
        self.species = ""
        self.height = 0.0
        self.weight = 0.0
        
        // Training
        self.EVYeild = ["":0]
        self.catchRate = 0
        self.growthRate = ""
        self.baseHappy = 0
        self.baseXP = 0
        
        // Breeding
        self.genderRate = 0
        self.eggGroup = [""]
        self.eggcycles = 0
        
        
        // Organization
        self.fav = false
        downloaded = false
    }
    
    // MARK: - Helpers
    
    public var numString:String {
        var num:String
        
        if number < 10 {
            num = "#00\(number)"
        } else if number < 100 {
            num = "#0\(number)"
        } else {
            num = "#\(number)"
        }
        
        return num
    }
    
    public var isFavorite:Bool {
        return fav
    }
    
    public func toggleFav () {
        fav = !fav
        NotificationCenter.default.post(name: favoritesChangedNotification, object: self, userInfo:[:])
    }
    
    // MARK: - NSCoding Protocal Methods
    
    required public init(coder aDecoder:NSCoder) {
        //print("init with coder called on \(name)")
        
        self.pkmnURL = aDecoder.decodeObject(forKey: "pkmnURL") as! String
        self.speciesURL = aDecoder.decodeObject(forKey: "speciesURL") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.number = aDecoder.decodeInt32(forKey: "number")
        self.type = aDecoder.decodeObject(forKey: "type") as! [String]
        self.sprites = aDecoder.decodeObject(forKey: "sprites") as! [String : AnyObject]
        self.isDefault = aDecoder.decodeBool(forKey: "isDefault")
        
        // Abilities
        self.abilities = aDecoder.decodeObject(forKey: "abilities") as! [String : Bool]
        
        // Evolution
        self.evolutionURL = aDecoder.decodeObject(forKey: "evolutionURL") as! String
        self.evolutionTree = aDecoder.decodeObject(forKey: "evolutionTree") as! [Evolution]
        
        // Base Stats
        self.baseHP  = aDecoder.decodeInt32(forKey: "baseHP")
        self.baseAtk  = aDecoder.decodeInt32(forKey: "baseAtk")
        self.baseSpAtk  = aDecoder.decodeInt32(forKey: "baseSpAtk")
        self.baseDef  = aDecoder.decodeInt32(forKey: "baseDef")
        self.baseSpDef  = aDecoder.decodeInt32(forKey: "baseSpDef")
        self.baseSpeed  = aDecoder.decodeInt32(forKey: "baseSpeed")
        
        // Info
        self.desc = aDecoder.decodeObject(forKey: "desc") as! String
        self.species = aDecoder.decodeObject(forKey: "species") as! String
        self.height = aDecoder.decodeDouble(forKey: "height")
        self.weight = aDecoder.decodeDouble(forKey: "weight")
        
        // Training
        self.EVYeild = aDecoder.decodeObject(forKey: "evYeild") as! [String:Int32]
        self.catchRate  = aDecoder.decodeInt32(forKey: "catchRate")
        self.growthRate = aDecoder.decodeObject(forKey: "growthRate") as! String
        self.baseHappy  = aDecoder.decodeInt32(forKey: "baseHappy")
        self.baseXP  = aDecoder.decodeInt32(forKey: "baseXP")
        
        // Breeding
        self.genderRate  = aDecoder.decodeInt32(forKey: "genderRate")
        self.eggGroup = aDecoder.decodeObject(forKey: "eggGroup") as! [String]
        self.eggcycles  = aDecoder.decodeInt32(forKey: "eggcycles")
        
        // Organization
        self.fav = aDecoder.decodeBool(forKey: "fav")
        self.downloaded = aDecoder.decodeBool(forKey: "dl")
    }
    
    public func encode(with aCoder: NSCoder) {
        //print("Encode with coder called on \(name)")
        
        aCoder.encode(pkmnURL, forKey: "pkmnURL")
        aCoder.encode(speciesURL, forKey: "speciesURL")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(number, forKey: "number")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(sprites, forKey: "sprites")
        aCoder.encode(isDefault, forKey: "isDefault")
        
        // Abilities
        aCoder.encode(abilities, forKey: "abilities")
        
        // Evolution
        aCoder.encode(evolutionURL, forKey: "evolutionURL")
        aCoder.encode(evolutionTree, forKey: "evolutionTree")
        
        // Base Stats
        aCoder.encode(baseHP, forKey: "baseHP")
        aCoder.encode(baseAtk, forKey: "baseAtk")
        aCoder.encode(baseSpAtk, forKey: "baseSpAtk")
        aCoder.encode(baseDef, forKey: "baseDef")
        aCoder.encode(baseSpDef, forKey: "baseSpDef")
        aCoder.encode(baseSpeed, forKey: "baseSpeed")
        
        // Info
        aCoder.encode(desc, forKey: "desc")
        aCoder.encode(species, forKey: "species")
        aCoder.encode(height, forKey: "height")
        aCoder.encode(weight, forKey: "weight")
        
        // Training
        aCoder.encode(EVYeild, forKey: "evYeild")
        aCoder.encode(catchRate, forKey: "catchRate")
        aCoder.encode(growthRate, forKey: "growthRate")
        aCoder.encode(baseHappy, forKey: "baseHappy")
        aCoder.encode(baseXP, forKey: "baseXP")
        
        // Breeding
        aCoder.encode(genderRate, forKey: "genderRate")
        aCoder.encode(eggGroup, forKey: "eggGroup")
        aCoder.encode(eggcycles, forKey: "eggcycles")
        
        // Organization
        aCoder.encode(fav, forKey: "fav")
        aCoder.encode(downloaded, forKey: "dl")
    }
    
    // MARK: - API
    func loadPokemon() {
        // 2
        if let dataTask = dataTask {
            dataTask.cancel()
        }
        
        // 5
        guard let url = URL(string: pkmnURL) else {
            print ("Something is wrong with the pokemon URL")
            return
        }
        
        // 3
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // 6
        dataTask = defaultSession.dataTask(with: url as URL) {
            data, response, error in
            
            // 7
            DispatchQueue.main.async {
                
                // 8
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                // 9
                if let error = error {
                    print(error.localizedDescription)
                } else if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        self.updatePokemon(data)
                    }
                }
            }
        }
        
        // 10
        self.dataTask?.resume()
    }
    
    func loadSpecies(url:String) {
        // 2
        if let dataTask = dataTask {
            dataTask.cancel()
        }
        
        // 5
        guard let url = URL(string: url) else {
            print ("Something is wrong with the Species URL")
            return
        }
        
        // 3
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // 6
        dataTask = defaultSession.dataTask(with: url as URL) {
            data, response, error in
            
            // 7
            DispatchQueue.main.async {
                
                // 8
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                // 9
                if let error = error {
                    print(error.localizedDescription)
                } else if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        self.updateSpecies(data)
                    }
                }
            }
        }
        
        // 10
        self.dataTask?.resume()
    }
    
    func loadEvolution(url:String) {
        // 2
        if let dataTask = dataTask {
            dataTask.cancel()
        }
        
        // 5
        guard let url = URL(string: url) else {
            print ("Something is wrong with the Species URL")
            return
        }
        
        // 3
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // 6
        dataTask = defaultSession.dataTask(with: url as URL) {
            data, response, error in
            
            // 7
            DispatchQueue.main.async {
                
                // 8
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                // 9
                if let error = error {
                    print(error.localizedDescription)
                } else if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        self.updateEvolution(data)
                    }
                }
            }
        }
        
        // 10
        self.dataTask?.resume()
    }
    
    func updatePokemon (_ data: Data?) {
        do {
            if let data = data, let responseDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String:AnyObject] {
                //print(responseDictionary)
                
                // Basic
                
                guard let species_URL:AnyObject = responseDictionary["species"] else {
                    print("species key not found in dictionary - likely an error page")
                    return
                }
                speciesURL = species_URL["url"] as! String
                
                guard let typeDict:AnyObject = responseDictionary["types"] else {
                    print("types key not found in dictionary - likely an error page")
                    return
                }
                type.removeAll()
                let typeDictCast = typeDict as! [[String:AnyObject]]
                for t in typeDictCast {
                    let types = t["type"] as! [String:String]
                    type.append(types["name"]!.capitalized)
                }
                
                sprites.removeAll()
                guard let spritesDict:AnyObject = responseDictionary["sprites"] else {
                    print("sprites key not found in dictionary - likely an error page")
                    return
                }
                sprites = spritesDict as! [String:AnyObject]
                
                guard let is_default:AnyObject = responseDictionary["is_default"] else {
                    print("default key not found in dictionary - likely an error page")
                    return
                }
                isDefault = is_default as! Bool
                
                // Abilities
                guard let abilitiesDict:AnyObject = responseDictionary["abilities"] else {
                    print("abilities key not found in dictionary - likely an error page")
                    return
                }
                abilities.removeAll()
                let abilitiesDictCast = abilitiesDict as! [[String:AnyObject]]
                for a in abilitiesDictCast {
                    let abilitiy = a["ability"] as! [String:String]
                    abilities[abilitiy["name"]!.capitalized] = a["is_hidden"] as? Bool
                }
                
                // Stats
                guard let statDict:AnyObject = responseDictionary["stats"] else {
                    print("stats key not found in dictionary - likely an error page")
                    return
                }
                
                let statDictCast = statDict as! [[String:AnyObject]]
                for s in statDictCast {
                    let stat = s["stat"] as! [String:String]
                    switch stat["name"]! {
                    case "hp":
                        baseHP = s["base_stat"] as! Int32
                        break
                    case "attack":
                        baseAtk = s["base_stat"] as! Int32
                        break
                    case "special-attack":
                        baseSpAtk = s["base_stat"] as! Int32
                        break
                    case "defense":
                        baseDef = s["base_stat"] as! Int32
                        break
                    case "special-defense":
                        baseSpDef = s["base_stat"] as! Int32
                        break
                    case "speed":
                        baseSpeed = s["base_stat"] as! Int32
                        break
                    default:
                        break
                    }
                }
                
                // Info
                guard let h:AnyObject = responseDictionary["height"] else {
                    print("height key not found in dictionary - likely an error page")
                    return
                }
                height = (h as! Double / 10.0)
                guard let w:AnyObject = responseDictionary["weight"] else {
                    print("weight key not found in dictionary - likely an error page")
                    return
                }
                weight = ((w as! Double) / 10.0)
                
                // Training
                guard let base_experience:AnyObject = responseDictionary["base_experience"] else {
                    print("base_experience key not found in dictionary - likely an error page")
                    return
                }
                baseXP = base_experience as! Int32
                
                loadSpecies(url: speciesURL)
                
            } else {
                print("JSON error in Pokemon")
            }
        } catch {
            print("Error parsing results \(error.localizedDescription)")
        }
    }
    
    func updateSpecies (_ data: Data?) {
        do {
            if let data = data, let responseDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String:AnyObject] {
                //print(responseDictionary)
                
                // Basic
                guard let pokedex_numbers:AnyObject = responseDictionary["pokedex_numbers"] else {
                    print("pokedex_numbers key not found in dictionary - likely an error page")
                    return
                }
                
                let pokedex_cast = pokedex_numbers as! [[String:AnyObject]]
                for p in pokedex_cast {
                    let dex = p["pokedex"] as! [String:String]
                    switch dex["name"]! {
                    case "national":
                        number = p["entry_number"] as! Int32
                        break
                    default:
                        break
                    }
                }
                
                // Evolution
                guard let evolution_chain:AnyObject = responseDictionary["evolution_chain"] else {
                    print("evolution_chain key not found in dictionary - likely an error page")
                    return
                }
                let evolution_chain_cast = evolution_chain as! [String:String]
                evolutionURL = evolution_chain_cast["url"]!
                
                // Info
                guard let flavor:AnyObject = responseDictionary["flavor_text_entries"] else {
                    print("flavor key not found in dictionary - likely an error page")
                    return
                }
                
                let flavorCast = flavor as! [[String:AnyObject]]
                for f in flavorCast {
                    let lang = f["language"] as! [String:String]
                    let ver = f["version"] as! [String:String]
                    if (lang["name"] == "en"){
                        desc = f["flavor_text"] as! String
                        if (ver["name"] == "alpha-sapphire") {
                            desc = f["flavor_text"] as! String
                        }
                    }
                }
                desc = desc.replacingOccurrences(of: "\n", with: " ", options: .regularExpression)

                
                guard let genera:AnyObject = responseDictionary["genera"] else {
                    print("genera key not found in dictionary - likely an error page")
                    return
                }
                
                let generaCast = genera as! [[String:AnyObject]]
                for g in generaCast {
                    let lang = g["language"] as! [String:String]
                    switch lang["name"]! {
                    case "en":
                        species = g["genus"] as! String
                        break
                    default:
                        break
                    }
                }
                species += " Pokemon"
                
                // Training
                guard let capture_rate:AnyObject = responseDictionary["capture_rate"] else {
                    print("capture_rate key not found in dictionary - likely an error page")
                    return
                }
                catchRate = capture_rate as! Int32
                
                guard let growth_rate:AnyObject = responseDictionary["growth_rate"] else {
                    print("growth_rate key not found in dictionary - likely an error page")
                    return
                }
                let growth_rate_cast = growth_rate as! [String:String]
                growthRate = growth_rate_cast["name"]!
                
                guard let base_happiness:AnyObject = responseDictionary["base_happiness"] else {
                    print("base_happiness key not found in dictionary - likely an error page")
                    return
                }
                baseHappy = base_happiness as! Int32
                
                // Breeding
                guard let gr:AnyObject = responseDictionary["gender_rate"] else {
                    print("gender_rate key not found in dictionary - likely an error page")
                    return
                }
                genderRate = gr as! Int32
                
                guard let eggGroupDict:AnyObject = responseDictionary["egg_groups"] else {
                    print("egg_groups key not found in dictionary - likely an error page")
                    return
                }
                eggGroup.removeAll()
                let eggGroupDictCast = eggGroupDict as! [[String:String]]
                for e in eggGroupDictCast {
                    eggGroup.append(e["name"]!.capitalized)
                }
                
                guard let hc:AnyObject = responseDictionary["hatch_counter"] else {
                    print("hatch_counter key not found in dictionary - likely an error page")
                    return
                }
                eggcycles = hc as! Int32
                
                loadEvolution(url: evolutionURL)
                
            } else {
                print("JSON error in Species")
            }
        } catch {
            print("Error parsing results \(error.localizedDescription)")
        }
    }
    
    func updateEvolution (_ data: Data?) {
        do {
            if let data = data, let responseDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String:AnyObject] {
                //print(responseDictionary)
                
                // Evolution
                
                guard let chain:AnyObject = responseDictionary["chain"] else {
                    print("chain key not found in dictionary - likely an error page")
                    return
                }
                
                let chain_cast = chain as! [String:AnyObject]
                evolutionTree = []
                var currParent:String = Pokemon.noParent
                
                evolutionTree.append(Evolution(parent: currParent, child:  chain_cast["species"]?["name"] as! String))
                currParent = chain_cast["species"]?["name"] as! String
                
                if let rung1 = chain_cast["evolves_to"] as? [[String:AnyObject]] {
                    for nextStep in rung1 {
                        currParent = chain_cast["species"]?["name"] as! String
                        evolutionTree.append(Evolution(parent: currParent, child:  nextStep["species"]?["name"] as! String))
                        if let rung2 = nextStep["evolves_to"] as? [[String:AnyObject]] {
                            for nextStep2 in rung2 {
                                currParent = nextStep["species"]?["name"] as! String
                                evolutionTree.append(Evolution(parent: currParent, child: nextStep2["species"]?["name"] as! String))
                            }
                        }
                        
                    }
                }
                
                // All done
                downloaded = true
                NotificationCenter.default.post(name: pokedexLoadedNotificaiton, object: self, userInfo:[:])
                
            } else {
                print("JSON error in Evolution")
            }
        } catch {
            print("Error parsing results \(error.localizedDescription)")
        }
    }
}
