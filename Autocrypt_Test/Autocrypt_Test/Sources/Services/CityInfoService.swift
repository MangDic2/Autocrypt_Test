//
//  CityInfoService.swift
//  Autocrypt_Test
//
//  Created by 이명직 on 10/27/24.
//

import Foundation
import RxSwift

class CityInfoService {
    static let shared = CityInfoService()
    
    private init() {}
    
    var originData = [CityInfo]()
    
    func fetchCityData() -> Single<[CityInfo]> {
        return Single.create { [weak self] single in
            DispatchQueue.global(qos: .background).async {
                guard let path = Bundle.main.path(forResource: "reduced_citylist", ofType: "json"),
                      let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
                    single(.failure(NSError(domain: "CityDataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to load city data"])))
                    return
                }
                
                do {
                    let cities = try JSONDecoder().decode([CityInfo].self, from: data)
                    DispatchQueue.main.async {
                        self?.originData = cities
                        single(.success(cities))
                    }
                } catch {
                    single(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
}
