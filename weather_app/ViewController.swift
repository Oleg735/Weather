//
//  ViewController.swift
//  weather_app
//
//  Created by user on 21.10.2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherIconImag: UIImageView!
    
    private let locationManager = CLLocationManager()
    var weatherData = WeatherData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLocationManager()
    }
   
    func updateWeatherInfo(latitude: Double, longtitube: Double ){
        let session = URLSession.shared
        
//        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude.description)&lon=\(longtitube.description)&APPID=5bb629c6aa7fbd7bf73ebe35ceedc14d&units=metric")!
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude.description)&lon=\(longtitube.description)&units=metric&cnt=7&appid=5bb629c6aa7fbd7bf73ebe35ceedc14d")!
        let task = session.dataTask(with: url) { (data, responce, error) in
            guard error == nil else {
                print("DAtaTAAsk ErroR \(error?.localizedDescription)")
                return
            }
            do{
                self.weatherData = try JSONDecoder().decode(WeatherData.self, from: data!)
                print(self.weatherData)
                DispatchQueue.main.async {
                    self.updateView()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func updateView() {
        cityNameLabel.text = weatherData.name
        weatherDescriptionLabel.text = DataSource.weatherIDs[weatherData.weather[0].id]
        tempLabel.text = weatherData.main.temp.description + " Cº"
        weatherIconImag.image = UIImage(named: weatherData.weather[0].icon)
    }
    
    func startLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.startUpdatingLocation()
        }
    }

}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            updateWeatherInfo(latitude: lastLocation.coordinate.latitude, longtitube: lastLocation.coordinate.longitude)
            print(lastLocation.coordinate.latitude, lastLocation.coordinate.longitude)
        }
    }
}
