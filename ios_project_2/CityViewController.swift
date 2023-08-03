//
//  CityViewController.swift
//  ios_project_2
//
//  Created by SMIT KHOKHARIYA on 2023-08-01.
//

import UIKit

class CityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var searchedCity: [WeatherData] = []
    var activeBtn : String = "C"
    
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let weatherConditionImageMap: [Int: String] = [
        1003: "partlyCloude",
        1240: "rainy_day",
        1243: "rainy_day",
        1246: "rainy_night",
        1225: "snow",
        1087: "windy",
        1000: "sunny",
        1195: "rainy",
        1030: "rainy",
    ]
    
    let defaults = UserDefaults.standard;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        if let data = UserDefaults.standard.data(forKey: "searchedListKey") {
                do {
                    searchedCity = try JSONDecoder().decode([WeatherData].self, from: data)
                } catch {
                    print("Error decoding searchedList: \(error)")
                }
            }
        
    
        dataLabel.text = "Cities searched recently"
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedCity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchedCity", for: indexPath)
        
        let city = searchedCity[indexPath.row].location.name
        let temperatureCelsius = searchedCity[indexPath.row].current.temp_c
        let temperatureFahrenheit = searchedCity[indexPath.row].current.temp_f
        
        cell.textLabel?.text = "\(city)"
        
        if activeBtn == "C"{
            cell.detailTextLabel?.text = "\(temperatureCelsius) °C"
        }else{
            cell.detailTextLabel?.text = "\(temperatureFahrenheit) °F"
        }
       
        let image = weatherConditionImageMap[searchedCity[indexPath.row].current.condition.code]
       
        cell.imageView?.image = UIImage(named: image ?? "partlyCloude")
    
        return cell
    }
    
}
