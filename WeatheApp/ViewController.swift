//
//  ViewController.swift
//  WeatheApp
//
//  Created by Alexander on 21.03.2024.
//  Copyright © 2024 Alexander. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    
    @IBOutlet weak var CityNameLabel: UILabel!
    @IBOutlet weak var WeatherDescriptionLabel: UILabel!
    @IBOutlet weak var TemperatureLabel: UILabel!
    @IBOutlet weak var WeatherIconImageView: UIImageView!
    let locationManager = CLLocationManager()
    var weatherData = WeatherData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLocationManager()
    }
    
    func startLocationManager(){
        locationManager.requestWhenInUseAuthorization()
        Di
            
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.startUpdatingLocation()
            }
            
        }
    
    
    func updateView(){
        
        CityNameLabel.text = weatherData.name
        WeatherDescriptionLabel.text = DataSource.weatherIDs[weatherData.weather[0].id]
        TemperatureLabel.text = weatherData.main.temp.description + "°"
        WeatherIconImageView.image = UIImage(named: weatherData.weather[0].icon)
        
    }
    
    
    
    func updateWeatherInfo(latitude: Double, longtitude: Double){
        let session = URLSession.shared
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude.description)&lon=\(longtitude.description)&units=metric&lang=ru&APPID=71d8a9db754f0e5e9d2b894d8c3037a5")!
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("DataTask error: \(error!.localizedDescription)")
                return
            }
            do {
                self.weatherData = try JSONDecoder().decode(WeatherData.self, from: data!)
                DispatchQueue.main.async {
                    self.updateView()
                
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
}


extension ViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last{
            updateWeatherInfo(latitude: lastLocation.coordinate.latitude, longtitude: lastLocation.coordinate.longitude)
        }
    }
    
}


