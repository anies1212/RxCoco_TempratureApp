//
//  URL+Extensions.swift
//  RxSwift_TempretureApp
//
//  Created by anies1212 on 2022/07/17.
//

import Foundation
import RxCocoa
import RxSwift

extension URL {
    
    static func urlForWeatherAPI(city: String) -> URL?{
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(ViewController.apiKey)")
    }
}
