//
//  ViewController.swift
//  Project_2
//
//  Created by Deep Patel
// on 30 j

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var celbtn: UIButton!
    @IBOutlet weak var ferenhitBtn: UIButton!
    private var userSerchedLocation: String = ""
    private var activeBtn: String = "F"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField)-> Bool{
        textField.endEditing(true)
//        print("User searched text \(textField.text)" ?? "")
        if let city = textField.text{
            userSerchedLocation = city
            print("city \(city)")
        }
        return true;
    }
    

    @IBAction func onFerClickBtn(_ sender: Any) {
        activeBtn = "F"
        print("Cureent temp in  \(activeBtn)")
    }
    
 
    @IBAction func onCelBtn(_ sender: Any) {
        activeBtn = "C"
        print("Current temp  in  \(activeBtn)")
    }
    
    @IBAction func onLocationBtnPressed(_ sender: Any) {
        
    }
    
    
    @IBAction func onearchBtnPressed(_ sender: Any) {
        if let searchedCity = searchTextField.text{
            userSerchedLocation = searchedCity
        }
        print(userSerchedLocation)
        
    }
    
}


