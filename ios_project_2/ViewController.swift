//
//  ViewController.swift
//  Project_2
//
//  Created by Deep Patel
// on 30 j
import CoreLocation
import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var celbtn: UIButton!
    @IBOutlet weak var ferenhitBtn: UIButton!
    private var userSerchedLocation: String = ""
    private var activeBtn: String = "F"
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    var locationManager: CLLocationManager!
    let locationDelegate = MyLocationDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchTextField.delegate = self
        locationManager = CLLocationManager()
        locationManager.delegate = locationDelegate
     
 

    }
    
    func textFieldShouldReturn(_ textField: UITextField)-> Bool{
        textField.endEditing(true)
//        print("User searched text \(textField.text)" ?? "")
        if let city = textField.text{
            userSerchedLocation = city
            print("city \(city)")
        }
        cityNameLabel.text = userSerchedLocation
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
        locationManager.requestWhenInUseAuthorization()
        

//        locationManager.startUpdatingLocation()
        locationManager.requestLocation()
        
        
    }
    
    
    @IBAction func onearchBtnPressed(_ sender: Any) {
        if let searchedCity = searchTextField.text{
            userSerchedLocation = searchedCity
        }
        cityNameLabel.text = userSerchedLocation
        print(userSerchedLocation)
        
    }
    
    
    class MyLocationDelegate: NSObject, CLLocationManagerDelegate{
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            print("Got Location")
            if let location = locations.last{
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                print("lat \(latitude)   long \(longitude)")
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("error \(error)")
        }
    }
    
}


