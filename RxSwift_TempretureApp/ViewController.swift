//
//  ViewController.swift
//  RxSwift_TempretureApp
//
//  Created by anies1212 on 2022/07/17.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    static let apiKey = "c556559cf9c2188e1aa9b432318c57b5"
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var tempretureLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        humidityLabel.textColor = .darkGray
        humidityLabel.adjustsFontSizeToFitWidth = true
        tempretureLabel.adjustsFontSizeToFitWidth = true
        textField.returnKeyType = .search
        tempretureLabel.text = "Look out for tempreture."
        humidityLabel.text = "Look out for humidity."
        addRxObserver()
        
    }
    
    func addRxObserver(){
        textField.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .map({ self.textField.text })
            .subscribe(onNext: {[weak self] city in
                if let city = city {
                    if city.isEmpty {
                        self?.displayWeather(nil)
                    } else {
                        self?.fetchWeather(by: city)
                    }
                }
            })
            .disposed(by: bag)
    }
    
    func displayWeather(_ weather: Weather?){
        if let weather = weather {
            tempretureLabel.text = "Tempreture: \(weather.temp)℉"
            humidityLabel.text = "Humidity: \(weather.humidity)"
        } else {
            tempretureLabel.text = "Look out for tempreture."
            humidityLabel.text = "Look out for humidity."
        }
    }
    
    func fetchWeather(by city: String){
        guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL.urlForWeatherAPI(city: cityEncoded) else {
            return
        }
        let resource = Resource<WeatherResult>(url: url)
        let searchResult = URLRequest.load(resource: resource)
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: WeatherResult.empty)
        searchResult.map({"Tempreture: \($0.main.temp)℉"})
            .drive(self.tempretureLabel.rx.text)
            .disposed(by: bag)
        
        searchResult.map({"Humidity: \($0.main.humidity)"})
            .drive(self.humidityLabel.rx.text)
            .disposed(by: bag)
        
    }


}
