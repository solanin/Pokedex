//
//  PokeData.swift
//  Pokedex
//
//  Created by Jacob Westerback (RIT Student) on 4/26/17.
//  Copyright © 2017 Jacob Westerback (RIT Student). All rights reserved.
//

import Foundation
import UIKit

enum DamageTaken {
    case weak
    case strong
    case immune
}

class PokeData {
    // MARK: - Initialization
    
    private init () {
        teams = []
        for _ in 0...PokeData.teamSize {
            teams.append([Int32]())
        }
    }
    
    public static let sharedData = PokeData()
    
    // MARK: - Data
    
    static let teamSize = 6
    var dex = [Pokemon]()
    var teams:[[Int32]]
    
    // MARK: - Favorites
    
    var favorites:[Pokemon] {
        var favs = [Pokemon]()
        for p in pokemon {
            if (p.isFavorite) {
                favs.append(p)
            }
        }
        favs.sort(by:{$1.number > $0.number})
        return favs
    }
    
    
    // MARK: - Helpers
    
    public var pokemon:[Pokemon] {
        dex.sort(by:{$1.number > $0.number})
        return dex
    }
	
    public func getPokemon(idNum:Int32) -> Pokemon? {
        var toReturn:Pokemon? = nil
        
        // Check the obvious
        if (idNum != 0 && pokemon[Int(idNum-1)].number == idNum) {
            toReturn = pokemon[Int(idNum-1)]
        }
        // Else look for it
        else {
            for p in dex {
                if (p.number == idNum) {
                    toReturn = p
                    break;
                }
            }
        }
        
        return toReturn
    }
    
    // MARK: - Team Helpers
	
	public func isValidTeamNo(teamNo:Int) -> Bool {
		return teamNo >= 0 && teamNo < PokeData.teamSize
	}
    
    public func getTeam(teamNo:Int) -> [Pokemon] {
        var team = [Pokemon]()
        if (isValidTeamNo(teamNo:teamNo)) {
			for p in teams[teamNo] {
                if let pokemon = getPokemon(idNum:p) {
                    team.append(pokemon)
                }
			}
		}
        return team
    }
    
    func addToTeam(teamNo:Int, pokeNo:Int32)  {
        if (isValidTeamNo(teamNo:teamNo)) {
			teams[teamNo].append(pokeNo)
			NotificationCenter.default.post(name: teamsChangedNotification, object: self, userInfo:[:])
        }
    }
    
    func removeFromTeam(teamNo:Int, index:Int)  {
        if (isValidTeamNo(teamNo:teamNo)) {
            if (index < teams[teamNo].count) {
                teams[teamNo].remove(at: index)
                NotificationCenter.default.post(name: teamsChangedNotification, object: self, userInfo:[:])
            }
        }
    }
	
	// Swaps two pokemon in a team(s)
    func swapTeamMember(fromTeam:Int, toTeam:Int, from:Int, to:Int) {
		let pokeToMove = teams[fromTeam].remove(at: from)
        teams[toTeam].insert(pokeToMove, at: to)

        NotificationCenter.default.post(name: teamsChangedNotification, object: self, userInfo:[:])
    }
    
    // MARK: - Graphic Constants
    static let defalutSprite = "front_default"
    
    static let typeColors:[String:UIColor] = [
        "normal":UIColor(red: 168/255, green: 168/255, blue: 120/255, alpha: 1),
        "fire":UIColor(red: 240/255, green: 128/255, blue: 48/255, alpha: 1),
        "fighting":UIColor(red: 192/255, green: 48/255, blue: 40/255, alpha: 1),
        "water":UIColor(red: 104/255, green: 144/255, blue: 240/255, alpha: 1),
        "flying":UIColor(red: 168/255, green: 144/255, blue: 240/255, alpha: 1),
        "grass":UIColor(red: 120/255, green: 200/255, blue: 80/255, alpha: 1),
        "poison":UIColor(red: 160/255, green: 64/255, blue: 160/255, alpha: 1),
        "electric":UIColor(red: 248/255, green: 208/255, blue: 48/255, alpha: 1),
        "ground":UIColor(red: 224/255, green: 192/255, blue: 104/255, alpha: 1),
        "psychic":UIColor(red: 248/255, green: 88/255, blue: 136/255, alpha: 1),
        "rock":UIColor(red: 184/255, green: 160/255, blue: 56/255, alpha: 1),
        "ice":UIColor(red: 152/255, green: 216/255, blue: 216/255, alpha: 1),
        "bug":UIColor(red: 168/255, green: 184/255, blue: 32/255, alpha: 1),
        "dragon":UIColor(red: 112/255, green: 56/255, blue: 248/255, alpha: 1),
        "ghost":UIColor(red: 112/255, green: 88/255, blue: 152/255, alpha: 1),
        "dark":UIColor(red: 112/255, green: 88/255, blue: 72/255, alpha: 1),
        "steel":UIColor(red: 184/255, green: 184/255, blue: 208/255, alpha: 1),
        "fairy":UIColor(red: 238/255, green: 153/255, blue: 172/255, alpha: 1),
        "???":UIColor(red: 104/255, green: 160/255, blue: 144/255, alpha: 1)
    ]
    static let breedColors:[String:UIColor] = [
        "monster":UIColor(red: 210/255, green: 80/255, blue: 100/255, alpha: 1),
        "human-like":UIColor(red: 210/255, green: 150/255, blue: 130/255, alpha: 1),
        "water 1":UIColor(red: 151/255, green: 181/255, blue: 253/255, alpha: 1),
        "water 3":UIColor(red: 88/255, green: 118/255, blue: 190/255, alpha: 1),
        "bug":UIColor(red: 170/255, green: 194/255, blue: 42/255, alpha: 1),
        "mineral":UIColor(red: 122/255, green: 98/255, blue: 82/255, alpha: 1),
        "flying":UIColor(red: 178/255, green: 154/255, blue: 250/255, alpha: 1),
        "amorphous":UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1),
        "field":UIColor(red: 224/255, green: 192/255, blue: 104/255, alpha: 1),
        "water 2":UIColor(red: 114/255, green: 154/255, blue: 250/255, alpha: 1),
        "fairy":UIColor(red: 255/255, green: 200/255, blue: 240/255, alpha: 1),
        "ditto":UIColor(red: 166/255, green: 100/255, blue: 191/255, alpha: 1),
        "grass":UIColor(red: 130/255, green: 210/255, blue: 90/255, alpha: 1),
        "dragon":UIColor(red: 122/255, green: 66/255, blue: 255/255, alpha: 1),
        "undiscovered":UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1),
        "gender unknown":UIColor(red: 0/255, green: 128/255, blue: 192/255, alpha: 1)
    ]
    
    // MARK: - Damage Caluation Helpers
    
    static func typeAsNumber (type:String) -> Int {
        switch type.capitalized {
        case "Normal":
            return 0
        case "Fighting":
            return 1
        case "Flying":
            return 2
        case "Poison":
            return 3
        case "Ground":
            return 4
        case "Rock":
            return 5
        case "Bug":
            return 6
        case "Ghost":
            return 7
        case "Steel":
            return 8
        case "Fire":
            return 9
        case "Water":
            return 10
        case "Grass":
            return 11
        case "Electric":
            return 12
        case "Psychic":
            return 13
        case "Ice":
            return 14
        case "Dragon":
            return 15
        case "Dark":
            return 16
        case "Fairy":
            return 17
        case "???":
            return 0
        default:
            return 0
        }
    }
    
    static func numAsType (type:Int) -> String {
        switch type {
        case 0:
            return "Normal"
        case 1:
            return "Fighting"
        case 2:
            return "Flying"
        case 3:
            return "Poison"
        case 4:
            return "Ground"
        case 5:
            return "Rock"
        case 6:
            return "Bug"
        case 7:
            return "Ghost"
        case 8:
            return "Steel"
        case 9:
            return "Fire"
        case 10:
            return "Water"
        case 11:
            return "Grass"
        case 12:
            return "Electric"
        case 13:
            return "Psychic"
        case 14:
            return "Ice"
        case 15:
            return "Dragon"
        case 16:
            return "Dark"
        case 17:
            return "Fairy"
        default:
            return "???"
        }
    }
    
    static func dmgAsMod(amt: Double) -> String {
        switch amt {
        case 0.25:
            return "x1/4"
        case 0.5:
            return "x1/2"
        case 2:
            return "x2"
        case 4:
            return "x4"
        case 0:
            return "x0"
        default:
            return "x1"
        }
    }
    
    // MARK: - Damage Calculation
    
    static let damage: [[Double]] = [
        // ATK
        //Nor Fig  Fly  Poi  Grn  Rok  Bug  Ght  Stl  Fir  Wat  Grs  Elc  Psy  Ice  Drg  Drk  Fai   // DEF
        [1.0, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0], // Nor
        [1.0, 1.0, 2.0, 1.0, 1.0, 0.5, 0.5, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 1.0, 1.0, 0.5, 2.0], // Fig
        [1.0, 0.5, 1.0, 1.0, 0.0, 2.0, 0.5, 1.0, 1.0, 1.0, 1.0, 0.5, 2.0, 1.0, 2.0, 1.0, 1.0, 1.0], // Fly
        [1.0, 0.5, 1.0, 0.5, 2.0, 1.0, 0.5, 1.0, 1.0, 1.0, 1.0, 0.5, 1.0, 2.0, 1.0, 1.0, 1.0, 0.5], // Poi
        [1.0, 1.0, 1.0, 0.5, 1.0, 0.5, 1.0, 1.0, 1.0, 1.0, 2.0, 2.0, 0.0, 1.0, 2.0, 1.0, 1.0, 1.0], // Grn
        [0.5, 2.0, 0.5, 0.5, 2.0, 1.0, 1.0, 1.0, 2.0, 0.5, 2.0, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0], // Rok
        [1.0, 0.5, 2.0, 1.0, 0.5, 2.0, 1.0, 1.0, 1.0, 2.0, 1.0, 0.5, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0], // Bug
        [0.0, 0.0, 1.0, 0.5, 1.0, 1.0, 0.5, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 1.0], // Ght
        [0.5, 2.0, 0.5, 0.0, 2.0, 0.5, 0.5, 1.0, 0.5, 2.0, 1.0, 0.5, 1.0, 0.5, 0.5, 0.5, 1.0, 0.5], // Stl
        [1.0, 1.0, 1.0, 1.0, 2.0, 2.0, 0.5, 1.0, 0.5, 0.5, 2.0, 0.5, 1.0, 1.0, 0.5, 1.0, 1.0, 0.5], // Fir
        [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.5, 0.5, 0.5, 2.0, 2.0, 1.0, 0.5, 1.0, 1.0, 1.0], // Wat
        [1.0, 1.0, 2.0, 2.0, 0.5, 1.0, 2.0, 1.0, 1.0, 2.0, 0.5, 0.5, 0.5, 1.0, 2.0, 1.0, 1.0, 1.0], // Grs
        [1.0, 1.0, 0.5, 1.0, 2.0, 1.0, 1.0, 1.0, 0.5, 1.0, 1.0, 1.0, 0.5, 1.0, 1.0, 1.0, 1.0, 1.0], // Elc
        [1.0, 0.5, 1.0, 1.0, 1.0, 1.0, 2.0, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.5, 1.0, 1.0, 2.0, 1.0], // Psy
        [1.0, 2.0, 1.0, 1.0, 1.0, 2.0, 1.0, 1.0, 2.0, 2.0, 1.0, 1.0, 1.0, 1.0, 0.5, 1.0, 1.0, 1.0], // Ice
        [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.5, 0.5, 0.5, 0.5, 1.0, 2.0, 2.0, 1.0, 2.0], // Drg
        [1.0, 2.0, 1.0, 1.0, 1.0, 1.0, 2.0, 0.5, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 1.0, 1.0, 0.5, 2.0], // Drk
        [1.0, 0.5, 1.0, 2.0, 1.0, 1.0, 0.5, 1.0, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.5, 1.0]  // Fai
    ]
    
    static func getDamage(type:[String], amt:DamageTaken) -> [String] {
        var dmgTyp:[String] = []
        var dmgAmt:[Double] = []
        
        var types:[Int] = []
        
        // What are the types
        for t in type {
            if (t != numAsType(type: typeAsNumber(type: t))) {
                print ("ERROR CONVERTING TYPE TO NUMBER")
            }
            types.append(typeAsNumber(type: t))
        }
        
        // Get row(s) and set to single row
        if (types.count == 2) {
            for a in 0..<damage[types[0]].count { // Same
                dmgTyp.append(numAsType(type: a))
                let modifier = (damage[types[0]][a] * damage[types[1]][a])
                dmgAmt.append(modifier)
            }
        } else {
            for a in 0..<damage[types[0]].count { // Same
                dmgTyp.append(numAsType(type: a))
                dmgAmt.append(damage[types[0]][a])
            }
        }
        
        // Parse row
        var damageTypes:[String] = []
        
        for b in 0..<dmgAmt.count {
            if (amt == .strong && dmgAmt[b] <= 0.5 && dmgAmt[b] > 0) {
                damageTypes.append("\(numAsType(type: b)) \(dmgAsMod(amt: dmgAmt[b]))")
            } else if (amt == .weak && dmgAmt[b] >= 2.0) {
                damageTypes.append("\(numAsType(type: b)) \(dmgAsMod(amt: dmgAmt[b]))")
            } else if (amt == .immune && dmgAmt[b] == 0.0) {
                damageTypes.append("\(numAsType(type: b)) \(dmgAsMod(amt: dmgAmt[b]))")
            }
        }
        
        return damageTypes
    }
}
