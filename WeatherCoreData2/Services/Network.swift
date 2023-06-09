//
//  Network.swift
//  WeatherSearcher
//
//  Created by Алина Власенко on 21.03.2023.
//

import Foundation

final class Network {
    static let shared = Network()
    private let apiKey = "&appid=ccf629fe4cd5a83b229a01d635a970db"
    private let url = "https://api.openweathermap.org/data/2.5/weather?q="
    private let celciusMetric = "&units=metric"
    
    private init() {}
    
    func getWeather(_ forCity: String, _ completion: @escaping (WeatherModel?, Error?)->()) {
        let fullURL = url + forCity + celciusMetric + apiKey
        guard let weatherUrl = URL(string: fullURL) else {
            return
        }
        URLSession.shared.dataTask(with: weatherUrl) { (data, _, error) in
            guard let data = data else {
                return completion(nil, error)
            }
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherModel.self, from: data)
                completion(weatherData, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}
