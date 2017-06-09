//
//  AddToTeamVC.swift
//  Pokedex
//
//  Created by igmstu on 5/11/17.
//  Copyright © 2017 Jacob Westerback (RIT Student). All rights reserved.
//

import UIKit

class AddToTeamVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Vars
    
    @IBOutlet weak var team1: UISwitch!
    @IBOutlet weak var team2: UISwitch!
    @IBOutlet weak var team3: UISwitch!
    @IBOutlet weak var team4: UISwitch!
    @IBOutlet weak var team5: UISwitch!
    @IBOutlet weak var team6: UISwitch!
    @IBOutlet weak var picker: UIPickerView!
    
    var pokemon:Int32?
    var team:[Bool]?
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
		picker.delegate = self
		picker.dataSource = self
        // Do any additional setup after loading the view.
		
		picker.selectRow(0, inComponent: 0, animated: false)
		updateLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	// MARK: - Picker Delegate Methods
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return PokeData.sharedData.pokemon.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return PokeData.sharedData.pokemon[row].numAndName
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		updateLabel()
	}
	
	func updateLabel(){
		title = PokeData.sharedData.pokemon[picker.selectedRow(inComponent: 0)].numAndName
	}
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        pokemon = PokeData.sharedData.pokemon[picker.selectedRow(inComponent: 0)].number
        team = [team1.isOn, team2.isOn, team3.isOn, team4.isOn, team5.isOn, team6.isOn]
    }

}
