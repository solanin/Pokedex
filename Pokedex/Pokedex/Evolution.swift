//
//  Evolution.swift
//  Pokedex
//
//  Created by Jacob Westerback (RIT Student) on 5/15/17.
//  Copyright © 2017 Jacob Westerback (RIT Student). All rights reserved.
//

import Foundation
import UIKit

// Used to store Evolution info in a Pokemon
class Evolution : NSObject,NSCoding {
    
    // MARK: - Vars
    
    var parent:String
    var child:String
    var isBase:Bool
    
    var hasParent:Bool {
        return !isBase
    }
    
    // MARK: - Init
    
    init(parent:String, child:String){
        if(parent == Pokemon.noParent) {
            self.isBase = true
        } else {
            self.isBase = false
        }
        
        self.parent = parent.capitalized
        self.child = child.capitalized
    }
    
    
    // MARK: - NSCoding
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(parent, forKey: "parent")
        aCoder.encode(child, forKey: "child")
        aCoder.encode(isBase, forKey: "base")
    }
    
    required public init(coder aDecoder:NSCoder) {
        self.parent = aDecoder.decodeObject(forKey: "parent") as! String
        self.child = aDecoder.decodeObject(forKey: "child") as! String
        self.isBase = aDecoder.decodeBool(forKey: "base")
    }
    
    // MARK: - Helper
    
    override var description: String {
        return "parent: \(parent), child: \(child)"
    }
}
