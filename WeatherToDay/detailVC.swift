//
//  detailVC.swift
//  WeatherToDay
//
//  Created by Roman Ziabkin on 16.11.2022.
//

import UIKit

class detailVC: UIViewController {
    
    var cityName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colorTop = UIColor(red:  89/255, green: 156/255, blue: 169/255, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        self.view.layer.addSublayer(gradientLayer)
    }
    
    func currentWeather(city: String) {
        let url = "http://api.weatherapi.com/v1/current.json?key=f0e9aa77ba19409b95b83625221611&q=\(city)"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let name = json["location"]["name"].stringValue
                let temp = json["current"]["temp_c"].doubleValue
                let country = json["location"]["country"].stringValue
                let weatherURLString = "http:\(json["location"][0]["icon"].stringValue)"
                
                self.cityNameLabel.text = name
                self.temp_c.text = String(temp)
                self.countryLabel.text = country
            case .failure(let error):
                print(error)
            }
        }
    }

    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? detailVC {
            vc.cityName = cityName
        }

    }

}
