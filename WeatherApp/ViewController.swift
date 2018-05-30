//
//  ViewController.swift
//  WeatherApp
//
//  Created by Alan on 28/05/2018.
//  Copyright © 2018 Alan. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var appearentTemperatureLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var textField: UITextField!
    @IBAction func changeCityButtonPressed(_ sender: UIButton) {
        guard let address = textField.text else { return }
        getCoordinateFrom(address: address) { coordinate, error in
            guard let coordinate = coordinate, error == nil else { return }
            self.coordinates.latitude = coordinate.latitude
            self.coordinates.longitude = coordinate.longitude
            self.fetchCurrentWeatherData()
            DispatchQueue.main.async {
                print(coordinate)
            }
        }
    }
    
    func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
            completion(placemarks?.first?.location?.coordinate, error)
        }
    }
    
    let locationManager = CLLocationManager()
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        fetchCurrentWeatherData()
    }
    
    lazy var weatherManager = APIWeatherManager(apiKey: "859598347623969febcfeed6a261ba69")
    
    var coordinates = Coordinates(latitude: 20.00, longitude: 22.00)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.attributedPlaceholder = NSAttributedString(string: "Enter your city",
                                                               attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        fetchCurrentWeatherData()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last! as CLLocation
        self.coordinates.latitude = userLocation.coordinate.latitude
        self.coordinates.longitude = userLocation.coordinate.longitude
        self.fetchCurrentWeatherData()

        print("my location latitude: \(userLocation.coordinate.latitude), longitude: \(userLocation.coordinate.longitude)")
    }
    
    func fetchCurrentWeatherData(){
        weatherManager.fetchCurrentWeatherWith(coordinates: coordinates) { (result) in
            switch result {
            case .Success(let currentWeather):
                self.updateUIWith(currentWeather: currentWeather)
            case .Failure(let error as NSError):
                
                let alertController = UIAlertController(title: "Unable to get data ", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            default: break
            }
        }
    }
    
    func updateUIWith(currentWeather: CurrentWeather) {
        
        self.imageView.image = currentWeather.icon
        self.pressureLabel.text = currentWeather.pressureString
        self.temperatureLabel.text = currentWeather.temperatureString
        self.appearentTemperatureLabel.text = currentWeather.appearentTemperatureString
        self.humidityLabel.text = currentWeather.humidityString
    }
}

