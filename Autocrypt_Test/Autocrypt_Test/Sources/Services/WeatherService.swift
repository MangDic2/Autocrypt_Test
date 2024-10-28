import Alamofire
import Foundation
import RxSwift

class WeatherService {
    static let shared = WeatherService()

    private let apiKey: String
    
    private init(apiKey: String = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? "") {
        self.apiKey = apiKey
    }
    
    func fetchWeatherData(for city: String) -> Single<CityWeather> {
        let baseURL = "https://api.openweathermap.org/data/2.5/forecast"
        let parameters: [String: Any] = [
            "q": city,
            "appid": self.apiKey,
            "units": "metric"
        ]
        
        return Single.create { single in
            let request = AF.request(baseURL, parameters: parameters)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: CityWeather.self) { response in
                    switch response.result {
                    case .success(let cityWeather):
                        single(.success(cityWeather))
                    case .failure(let error):
                        single(.failure(error))
                    }
                }
            return Disposables.create { request.cancel() }
        }
    }
}
