//
//  ViewController.swift
//  WeatherSearcher
//
//  Created by Алина Власенко on 21.03.2023.
//

import UIKit
import CoreData

private enum Constants {
    static let temperature = " °C"
    static let pressure = "Pressure: "
    static let humidity = "Humidity: "
    static let windSpeed = "Wind speed: "
    static let feels = "fells like: "
}

class ViewController: UIViewController {
    
    private let cityTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type the City"
        textField.backgroundColor = .secondarySystemBackground
        textField.tintColor = .blue
        textField.textColor = .gray
        textField.font = UIFont.init(name: "Avenir-Medium", size: 22.0)
        textField.clearButtonMode = .whileEditing
        textField.layer.cornerRadius = 8
        textField.setLeftPaddingPoints(10)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemYellow
        label.font = UIFont(name: "Avenir-Medium", size: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont(name: "Avenir-Light", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        //label.textColor = .systemBackground
        label.font = UIFont(name: "Avenir-LightOblique", size: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let pressureLabel: UILabel = {
        let label = UILabel()
        //label.textColor = .systemBackground
        label.font = UIFont(name: "Avenir-Medium", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let humidityLabel: UILabel = {
        let label = UILabel()
        //label.textColor = .systemBackground
        label.font = UIFont(name: "Avenir-Medium", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        //label.textColor = .systemBackground
        label.font = UIFont(name: "Avenir-Medium", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let buttonSearch: UIButton = {
        let button = UIButton()
        button.setTitle("GET WEATHER", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.setTitleColor(.systemGray4, for: .highlighted)
        button.backgroundColor = .systemBlue
        //button.frame = CGRect(x: 230, y: 50, width: 90, height: 40)
        button.layer.cornerRadius = 8
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(getWeather), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityTextField.delegate = self
        view.backgroundColor = .systemBackground
        
        configureNavBar()
        addSubview()
        applyConstraints()
    }
    
    private func addSubview() {
        view.addSubview(cityTextField)
        view.addSubview(buttonSearch)
        view.addSubview(temperatureLabel)
        view.addSubview(feelsLikeLabel)
        view.addSubview(weatherDescriptionLabel)
        view.addSubview(pressureLabel)
        view.addSubview(humidityLabel)
        view.addSubview(windSpeedLabel)
    }
    
    private func configureNavBar() {
        title = "Weather"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemYellow // Чомусь не спрацьовує колір
   }
    
    @objc func getWeather() {
        let city = cityTextField.text
        if let city = city {
            if city.isEmpty {
                setDefaultTextValues()
            } else {
                let cityWithSpaces = allowSpaces(city)
                getWeatherFromNetwork(cityWithSpaces)
                createData(cityWithSpaces)
            }
        }
        //прітнуємо шо ми створюємо дані
        print("creating data")
        //відбувається створення даних
        //зберігання даних в БД
        print("storing")
        //пауза на 1 секунду
        sleep(1)
        //надрукуємо наші дані які ми зберегли
        //кожного разу як ми змінюємо дані, додруковується нова інформація, стара також друнується, тобто вона вже збереглася у БД, вона там є і її кожного разу теж буде друкувати. І кожного разу як ми білдимо програму, створюється ще один запис в БД.
        print("retrieving")
        retrieveData()
    }
    
    // MARK: - Constraints
    private func applyConstraints() {
        let cityTextFieldConstraints = [
            cityTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            cityTextField.widthAnchor.constraint(equalToConstant: 250),
            cityTextField.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let buttonSearchConstraints = [
            buttonSearch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonSearch.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 20),
            buttonSearch.widthAnchor.constraint(equalToConstant: 150),
            buttonSearch.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let temperatureLabelConstraints = [
            temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            temperatureLabel.topAnchor.constraint(equalTo: buttonSearch.bottomAnchor, constant: 50)
        ]
        
        let feelsLikeLabelConstraints = [
            feelsLikeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            feelsLikeLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 10)
        ]

        let weatherDescriptionLabelConstraints = [
            weatherDescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherDescriptionLabel.topAnchor.constraint(equalTo: feelsLikeLabel.bottomAnchor, constant: 50)
        ]
        
        let pressureLabelConstraints = [
            pressureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pressureLabel.topAnchor.constraint(equalTo: weatherDescriptionLabel.bottomAnchor, constant: 50)
        ]
        
        let humidityLabelConstraints = [
            humidityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            humidityLabel.topAnchor.constraint(equalTo: pressureLabel.bottomAnchor, constant: 10)
        ]
        
        let windSpeedLabelConstraints = [
            windSpeedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            windSpeedLabel.topAnchor.constraint(equalTo: humidityLabel.bottomAnchor, constant: 10)
        ]
        
        NSLayoutConstraint.activate(cityTextFieldConstraints)
        NSLayoutConstraint.activate(buttonSearchConstraints)
        NSLayoutConstraint.activate(temperatureLabelConstraints)
        NSLayoutConstraint.activate(feelsLikeLabelConstraints)
        NSLayoutConstraint.activate(weatherDescriptionLabelConstraints)
        NSLayoutConstraint.activate(pressureLabelConstraints)
        NSLayoutConstraint.activate(humidityLabelConstraints)
        NSLayoutConstraint.activate(windSpeedLabelConstraints)
    }
    
    // MARK: - Private
    
    private func getWeatherFromNetwork(_ city: String) {
        Network.shared.getWeather(city) { [weak self] (weather, error) in
            DispatchQueue.main.async {
                if let temperature = weather?.main?.temperature {
                    self?.temperatureLabel.text = String(format: "%.0f", round(temperature)) + Constants.temperature
                }
                if let feels = weather?.main?.feels_like {
                    self?.feelsLikeLabel.text = Constants.feels + String(format: "%.0f", round(feels)) + Constants.temperature
                }
                if let longWeather = weather?.weather?[0].description {
                    self?.weatherDescriptionLabel.text = longWeather
                }
                if let pressure = weather?.main?.pressure {
                    self?.pressureLabel.text = Constants.pressure + String(pressure) + " Pa"
                }
                if let humidity = weather?.main?.humidity {
                    self?.humidityLabel.text = Constants.humidity + String(humidity) + " %"
                }
                if let speed = weather?.wind?.speed {
                    self?.windSpeedLabel.text = Constants.windSpeed + String(speed) + " m/s"
                }
            }
        }
    }
    
    private func allowSpaces(_ city: String) -> String {
        return city.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
    }
    
    private func setDefaultTextValues() {
        temperatureLabel.text = nil
        feelsLikeLabel.text = nil
        weatherDescriptionLabel.text = nil
        pressureLabel.text = nil
        humidityLabel.text = nil
        windSpeedLabel.text = nil
    }
    
    //for CoreData
        func createData(_ city: String) {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let userEntity = NSEntityDescription.entity(forEntityName: "WeatherData", in: managedContext)!
            let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
            
            Network.shared.getWeather(city) { [weak user] (weather, error) in
                DispatchQueue.global().async {
                    if let city = weather?.name {
                        user?.setValue(city, forKey: "nameCity")
                    }
                    if let temperature = weather?.main?.temperature {
                        user?.setValue(temperature, forKey: "temperatures")
                    }
                    if let feels = weather?.main?.feels_like {
                        user?.setValue(feels, forKey: "feelsLike")
                    }
                    if let longWeather = weather?.weather?[0].description {
                        user?.setValue(longWeather, forKey: "descriptions")
                    }
                    if let pressure = weather?.main?.pressure {
                        user?.setValue(pressure, forKey: "pressures")
                    }
                    if let humidity = weather?.main?.humidity {
                        user?.setValue(humidity, forKey: "humidities")
                    }
                    if let speed = weather?.wind?.speed {
                        user?.setValue(speed, forKey: "windSpeed")
                    }
                }
            }
            //        user.setValue(cityTextField.text, forKey: "nameCity")
            //        user.setValue(temperatureLabel.text, forKey: "temperatures")
            //        user.setValue(feelsLikeLabel.text, forKey: "feelsLike")
            //        user.setValue(weatherDescriptionLabel.text, forKey: "descriptions")
            //        user.setValue(pressureLabel.text, forKey: "pressures")
            //        user.setValue(humidityLabel.text, forKey: "humidities")
            //        user.setValue(windSpeedLabel.text, forKey: "windSpeed")
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }


    func retrieveData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WeatherData")

        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                if let nameCity = data.value(forKey: "nameCity") as? String,
                   let temperatures = data.value(forKey: "temperatures") as? Float,
                   let feelsLike = data.value(forKey: "feelsLike") as? Float,
                   let descriptions = data.value(forKey: "descriptions") as? String,
                   let pressures = data.value(forKey: "pressures") as? Int32,
                   let humidities = data.value(forKey: "humidities") as? Int32,
                   let windSpeed = data.value(forKey: "windSpeed") as? Float {
                    print(nameCity, temperatures, feelsLike, descriptions, pressures, humidities, windSpeed)
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}

// MARK: - Extensions

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cityTextField.resignFirstResponder()
        return true
    }
}

//для відступу зліва для тексту в TextField
extension UITextField {

    func setLeftPaddingPoints(_ amount:CGFloat){
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
}

