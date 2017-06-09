//
//  PokeDexTVC.swift
//  Pokedex
//
//  Created by Jacob Westerback (RIT Student) on 4/26/17.
//  Copyright © 2017 Jacob Westerback (RIT Student). All rights reserved.
//

import UIKit

// MARK: - Global Notification Variables -
let pokedexLoadedNotificaiton = NSNotification.Name("pokedexLoaded")
let favoritesChangedNotification = NSNotification.Name("favoritesChangedNotification")
let teamsChangedNotification = NSNotification.Name("teamsChangedNotification")

class PokeDexTVC: UITableViewController, UISearchResultsUpdating {
    
    // MARK: - Variables
    
    let fileName = "pokemon.archive"
    let fileNameTeam = "teams.archive"
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?
    var filteredPokemon:[Pokemon] = [Pokemon]()
    let searchController = UISearchController(searchResultsController: nil)
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredPokemon = PokeData.sharedData.pokemon.filter { pokemon in
            return pokemon.name.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("START")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //Notificaiton Listening
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: pokedexLoadedNotificaiton, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveData), name: favoritesChangedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveData), name: teamsChangedNotification, object: nil)
        let FavTableVC:FavoritesTVC = tabBarController!.viewControllers![1].childViewControllers[0] as! FavoritesTVC
        NotificationCenter.default.addObserver(FavTableVC, selector: #selector(FavoritesTVC.reload), name: favoritesChangedNotification, object: nil)
        
        // Load Data
        
        var pathToFile = FileManager.filePathInDocumentsDirectory(fileName:fileName)
        if FileManager.default.fileExists(atPath: pathToFile.path){
            print("Opened \(pathToFile)")
            let tempDex = NSKeyedUnarchiver.unarchiveObject(withFile: pathToFile.path) as! [Pokemon]
            //print("Dex = \(tempDex)")
            PokeData.sharedData.dex = tempDex
        } else {
            print("Could not find \(pathToFile), Downlaoding from JSON")
            loadData()
        }
        
        if (PokeData.sharedData.dex.count == 0) {
            print("Data \(pathToFile) is empty, Downlaoding from JSON")
            loadData()
        }
		
		// Load Teams
        pathToFile = FileManager.filePathInDocumentsDirectory(fileName:fileNameTeam)
        if FileManager.default.fileExists(atPath: pathToFile.path){
            print("Opened \(pathToFile)")
            let tempTeam = NSKeyedUnarchiver.unarchiveObject(withFile: pathToFile.path) as! [[Int32]]
            //print("Team = \(tempTeam)")
            PokeData.sharedData.teams = tempTeam
        } else {
            print("Could not find \(pathToFile), No Teams loaded")
        }
        
        saveData()
        
        // Pokedex Setup
        
        title = "Pokemon"
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Helper Methods
    
    func saveData() {
        var pathToFile = FileManager.filePathInDocumentsDirectory(fileName: fileName)
        var success = NSKeyedArchiver.archiveRootObject(PokeData.sharedData.dex, toFile: pathToFile.path)
        print("Saved = \(success) to \(pathToFile)")
		
        pathToFile = FileManager.filePathInDocumentsDirectory(fileName: fileNameTeam)
        success = NSKeyedArchiver.archiveRootObject(PokeData.sharedData.teams, toFile: pathToFile.path)
        print("Saved = \(success) to \(pathToFile)")
    }
    
    // MARK: - MySearchResultsUpdating Methods
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredPokemon.count
        }
        return PokeData.sharedData.pokemon.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokeCell", for: indexPath) as! PokeCell
        
        let pokemon:Pokemon
        
        if searchController.isActive && searchController.searchBar.text != "" {
            pokemon = filteredPokemon[indexPath.row]
        } else {
            pokemon = PokeData.sharedData.pokemon[indexPath.row]
        }
        
        // Configure the cell...
        cell.configure(pokemon: pokemon)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let selectedRow = indexPath.row
            guard selectedRow < PokeData.sharedData.pokemon.count else {
                print("row \(selectedRow) is not in Pokemon!")
                return
            }
            
            // Select from what is displayed
            let pokemon:Pokemon
            if searchController.isActive && searchController.searchBar.text != "" {
                pokemon = filteredPokemon[selectedRow]
            } else {
                pokemon = PokeData.sharedData.pokemon[selectedRow]
            }
            
            let detailVC = segue.destination as! PokeDetailVC
            detailVC.pokemon = pokemon
            
        }
    }
    
    // MARK: - Loading
    func loadData() {
        guard let path = Bundle.main.url(forResource: "dexList", withExtension: "json") else {
            print ("Error: Could not find dexList.json")
            return
        }
        do {
            let data = try Data(contentsOf: path, options:[])
            let json = JSON(data:data)
            if (json != JSON.null) {
                parse(json:json)
            } else {
                print ("Error: json is null")
            }
        } catch {
            print("Error: Could not initialize the Data() object")
        }
    }
    
    func parse(json:JSON) {
        let array = json["results"].arrayValue
        PokeData.sharedData.dex = []
        
        for d in array {
            let p_name = d["name"].stringValue.capitalized
            let p_num = d["nationalNumber"].int32Value
            let p_url = d["url"].stringValue
            let p_sprite = d["mainSprite"].stringValue
            
            var p_type:[String] = []
            for t in d["type"] {
                p_type.append(t.1.stringValue.capitalized)
            }
            
            PokeData.sharedData.dex.append(Pokemon(name: p_name, num: p_num, url: p_url, type: p_type, sprite: p_sprite))
        }
        
        // Save
        saveData()
    
    }
    
    // MARK: - Notifications
    
    func reload() {
        print("Reload Dex // Save Again")
        saveData()
        tableView.reloadData()
    }

}
