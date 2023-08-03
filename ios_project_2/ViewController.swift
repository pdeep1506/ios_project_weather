import CoreLocation
import UIKit


class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var celbtn: UIButton!
    @IBOutlet weak var ferenhitBtn: UIButton!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var imageChangeLabel: UIImageView!

    @IBOutlet weak var citiesBtn: UIButton!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    private var userSearchedLocation: String = ""
    private var activeBtn: String = "C"

    var locationManager: CLLocationManager!
    var locationDelegate: MyLocationDelegate?

    
    var searchedCity : [WeatherData] = []

    let defaults = UserDefaults.standard
    
    private let apiKey = "f02ae5f044a34fa68a6205402230108"

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

    var lastFetchedConditionCode: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        locationManager = CLLocationManager()
        locationDelegate = MyLocationDelegate(apiKey: apiKey, viewController: self)
        locationManager.delegate = locationDelegate
        celbtn.backgroundColor = UIColor.systemBlue
        celbtn.setTitleColor(UIColor.white, for: .normal)
        celbtn.layer.cornerRadius = 5
        celbtn.clipsToBounds = true
        
        ferenhitBtn.backgroundColor = UIColor.clear
        ferenhitBtn.setTitleColor(UIColor.white, for: .normal)
        ferenhitBtn.layer.cornerRadius = 5
        ferenhitBtn.clipsToBounds = true
        
    }

    @IBAction func onCitiesBtn(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToCities", sender: self)
      
        //dismiss(animated:true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCities" {
            let destination = segue.destination as! CityViewController
            destination.activeBtn = activeBtn;
        }
    }
    
    func saveSearchedList(){
        var searchDefaults : [WeatherData] = [];
        
        if let data = UserDefaults.standard.data(forKey: "searchedListKey") {
                do {
                    searchDefaults = try JSONDecoder().decode([WeatherData].self, from: data)
                    
                } catch {
                    print("Error decoding searchedList: \(error)")
                }
            }
        let allSearchedlist = searchDefaults + searchedCity;
        
        do {
               let encodedData = try JSONEncoder().encode(allSearchedlist)
               UserDefaults.standard.set(encodedData, forKey: "searchedListKey")
           } catch {
               print("Error encoding searchedList: \(error)")
           }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        if let city = textField.text {
            userSearchedLocation = city
            print("city \(city)")
            fetchWeatherData(for: city)
        }
        cityNameLabel.text = userSearchedLocation
        return true
    }
 
    @IBAction func onFerClickBtn(_ sender: Any) {
        activeBtn = "F"
        ferenhitBtn.backgroundColor = UIColor.systemBlue
        ferenhitBtn.setTitleColor(UIColor.white, for: .normal)
        
        celbtn.backgroundColor = UIColor.clear
        celbtn.setTitleColor(UIColor.white, for: .normal)
        
        if let temperatureCelsius = locationDelegate?.lastFetchedCelsiusTemperature,
           let temperatureFahrenheit = locationDelegate?.lastFetchedFahrenheitTemperature {
            updateTemperatureLabels(with: temperatureCelsius, temperatureFahrenheit: temperatureFahrenheit, conditionCode: lastFetchedConditionCode)
        }
        
    }

    @IBAction func onCelBtn(_ sender: Any) {
        activeBtn = "C"
        celbtn.backgroundColor = UIColor.systemBlue
        celbtn.setTitleColor(UIColor.white, for: .normal)
        
        ferenhitBtn.backgroundColor = UIColor.clear
        ferenhitBtn.setTitleColor(UIColor.white, for: .normal)
        if let temperatureCelsius = locationDelegate?.lastFetchedCelsiusTemperature,
           let temperatureFahrenheit = locationDelegate?.lastFetchedFahrenheitTemperature {
            updateTemperatureLabels(with: temperatureCelsius, temperatureFahrenheit: temperatureFahrenheit, conditionCode: lastFetchedConditionCode)
        }

    }

    @IBAction func onLocationBtnPressed(_ sender: Any) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    @IBAction func onearchBtnPressed(_ sender: Any) {
        if let searchedCity = searchTextField.text {
            userSearchedLocation = searchedCity
            fetchWeatherData(for: searchedCity)
        }
        cityNameLabel.text = userSearchedLocation
        print(userSearchedLocation)
    }

    func fetchWeatherData(for city: String) {
        let urlString = "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(city)&units=metric"
        print("I am called")
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let weatherData = try decoder.decode(WeatherData.self, from: data)
                        let temperatureCelsius = weatherData.current.temp_c
                        let temperatureFahrenheit = weatherData.current.temp_f
                        let conditionCode = weatherData.current.condition.code
                        print("weather data \(weatherData)")
                    
                        
                        self.searchedCity.append(weatherData);
                        self.saveSearchedList();
                       
                        
                        DispatchQueue.main.async {
                            self.locationDelegate?.lastFetchedCelsiusTemperature = temperatureCelsius
                            self.locationDelegate?.lastFetchedFahrenheitTemperature = temperatureFahrenheit
                            self.lastFetchedConditionCode = conditionCode
                            self.updateTemperatureLabels(with: temperatureCelsius, temperatureFahrenheit: temperatureFahrenheit, conditionCode: conditionCode)
                            self.conditionLabel.text = " \(weatherData.current.condition.text)"
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                } else {
                    print("Error fetching weather data: \(error?.localizedDescription ?? "Unknown error")")
                }
            }.resume()
        }
    }

    func updateTemperatureLabels(with temperatureCelsius: Double, temperatureFahrenheit: Double, conditionCode: Int?) {
        if activeBtn == "C" {
            tempLabel.text = "\(temperatureCelsius)°C"
        } else {
            tempLabel.text = "\(temperatureFahrenheit)°F"
        }
        if let conditionCode = conditionCode {
              print("Condition Code: \(conditionCode)")
          } else {
              print("Condition Code: N/A")
          }
        if let conditionCode = conditionCode, let imageName = weatherConditionImageMap[conditionCode] {
            imageChangeLabel.image = UIImage(named: imageName)
        }
        
    }



    class MyLocationDelegate: NSObject, CLLocationManagerDelegate {
        var apiKey: String
        weak var viewController: ViewController?
        var lastFetchedCelsiusTemperature: Double?
        var lastFetchedFahrenheitTemperature: Double?

        init(apiKey: String, viewController: ViewController) {
            self.apiKey = apiKey
            self.viewController = viewController
        }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last {
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                let urlString = "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(latitude),\(longitude)&units=metric"

                if let url = URL(string: urlString) {
                    URLSession.shared.dataTask(with: url) { (data, response, error) in
                        if let data = data {
                            do {
                                let decoder = JSONDecoder()
                                let weatherData = try decoder.decode(WeatherData.self, from: data)
                                self.lastFetchedCelsiusTemperature = weatherData.current.temp_c
                                self.lastFetchedFahrenheitTemperature = weatherData.current.temp_f
                                let conditionCode = weatherData.current.condition.code

                               
                                
                                DispatchQueue.main.async {
                                    self.viewController?.updateTemperatureLabels(with: weatherData.current.temp_c, temperatureFahrenheit: weatherData.current.temp_f, conditionCode: conditionCode)
                                    self.viewController?.conditionLabel.text = "Condition: \(weatherData.current.condition.text)"
                                }
                            } catch {
                                print("Error parsing JSON: \(error)")
                            }
                        } else {
                            print("Error fetching weather data: \(error?.localizedDescription ?? "Unknown error")")
                        }
                    }.resume()
                }
            }
        }

        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error \(error)")
        }
    }
}

