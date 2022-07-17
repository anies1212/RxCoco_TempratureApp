//
//  URLRequest+Extensions.swift
//  RxSwift_TempretureApp
//
//  Created by anies1212 on 2022/07/17.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

struct Resource<T> {
    let url: URL
}

extension URLRequest {
    static func load<T: Decodable>(resource: Resource<T>) -> Observable<T> {
        return Observable.from([resource.url])
            .flatMap ({ url -> Observable<Data> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.data(request: request)
            })
            .map({ data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            }).asObservable()
    }
}
