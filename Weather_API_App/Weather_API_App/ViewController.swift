//
//  ViewController.swift
//  Weather_API_App
//
//  Created by 이득령 on 3/26/24.
//

import UIKit
import OSLog
import CoreLocation
class ViewController: UIViewController,CLLocationManagerDelegate {
    var locationManager: CLLocationManager!
    var lat: Double?
    var lon: Double?
    
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var cityNameTextField: UITextField!
    
    func labelIsHide(isBool: Bool) {
        cityNameLabel.isHidden = isBool
        weatherDescriptionLabel.isHidden = isBool
        tempLabel.isHidden = isBool
        maxTempLabel.isHidden = isBool
        minTempLabel.isHidden = isBool
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelIsHide(isBool: true)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        //위치 권한 묻기
        
    }
    //MARK: - Search BTN 누를때 실행됨
    @IBAction func tapFetchAPI(_ sender: UIButton) {
        let cityName = self.cityNameTextField.text
        let coor = locationManager.location?.coordinate
        lat = coor?.latitude
        lon = coor?.longitude
        print(lat ?? 0, lon ?? 0)
        if cityName == "" {
            self.getCurrentWeatherToLocation(lat: lat!, lon: lon!)
            print("ViewController TapFetchAPI getCurrentWeatherToLocation called")
        } else {
            self.getCurrentWeather(cityName: cityName!)
            print("ViewController TapFetchAPI getCurrentWeather called")
            self.view.endEditing(true)
        }
        
    }
    
    func configureView(weatherInformation: WeatherInformation) {
        self.cityNameLabel.text = weatherInformation.name
        if let weather = weatherInformation.weather.first {
            self.weatherDescriptionLabel.text = weather.description
        }
        self.tempLabel.text = "\(Int(weatherInformation.temp.temp - 273.15))°C"
        self.minTempLabel.text = "min: \(Int(weatherInformation.temp.minTemp - 273.15))°C"
        self.maxTempLabel.text = "max: \(Int(weatherInformation.temp.maxTemp - 273.15))°C"
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController (title: "에러❗️", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //MARK: - 도시이름으로 불러오기
    func getCurrentWeather (cityName: String) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(Bundle.main.apiKey ?? "")") else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url){ [weak self] data, response, error in
            let succesRnage = (200..<300)
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            if let response = response as? HTTPURLResponse, succesRnage.contains(response.statusCode) {
                guard let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data) else { return }
                DispatchQueue.main.async {
                    self?.labelIsHide(isBool: false)
                    self?.configureView(weatherInformation: weatherInformation)
                }
            } else {
                guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
                DispatchQueue.main.async {
                    self?.showAlert(message: errorMessage.message)
                }
            }
        }.resume()
    }
    //MARK: - 현재위치로 불러오기
    func getCurrentWeatherToLocation (lat:Double, lon:Double) {
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(Bundle.main.apiKey!)") else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url){ [weak self] data, response, error in
            let succesRnage = (200..<300)
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            if let response = response as? HTTPURLResponse, succesRnage.contains(response.statusCode) {
                guard let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data) else { return }
                DispatchQueue.main.async {
                    self?.labelIsHide(isBool: false)
                    self?.configureView(weatherInformation: weatherInformation)
                }
            } else {
                guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
                DispatchQueue.main.async {
                    self?.showAlert(message: errorMessage.message)
                }
            }
        }.resume()
    }
    
}

extension Bundle {
    var apiKey: String? {
        guard let file = self.path(forResource: "Secrets", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["API_KEY"] as? String else {
            os_log(.error, log: .default, "⛔️API KEY를 가져오는데 실패하였습니다.")
            return nil
        }
        return key
    }
}
