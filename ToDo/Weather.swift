//
//  Weather.swift
//  ToDo
//
//  Created by 이예민 on 2023/02/02.
//

import Foundation
import CoreLocation

class WeatherData: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var temperature: Double = 0
    @Published var weatherIcon: String = ""
    
    let locationManager = CLLocationManager()
    
    func getData() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        
        let apiKey = "c1016e89a647753de947e7f9c4e7ca2a"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let result = try? JSONDecoder().decode(WeatherResponse.self, from: data)
                DispatchQueue.main.async {
                    if let result = result {
                        result.weather.forEach {
                            print($0.description)
                            if ($0.description == "clear sky") {
                                self.weatherIcon = "sun.max"
                            } else if ($0.description == "few clouds") {
                                self.weatherIcon = "cloud.sun"
                            } else if ($0.description == "scattered clouds" || $0.description == "broken clouds" || $0.description == "overcast clouds") {
                                self.weatherIcon = "cloud"
                            } else if ($0.description == "shower rain") {
                                self.weatherIcon = "cloud.drizzle"
                            } else if ($0.description == "rain") {
                                self.weatherIcon = "cloud.rain"
                            } else if ($0.description == "thunderstorm") {
                                self.weatherIcon = "cloud.bolt"
                            } else if ($0.description == "snow") {
                                self.weatherIcon = "cloud.snow"
                            } else if ($0.description == "mist") {
                                self.weatherIcon = "cloud.fog"
                            }
                        }
                    }
                }
            }
        }.resume()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
}

struct Weather: Decodable {
    var main: String
    var description: String
}

struct WeatherResponse: Decodable {
    let weather: [Weather]
}
