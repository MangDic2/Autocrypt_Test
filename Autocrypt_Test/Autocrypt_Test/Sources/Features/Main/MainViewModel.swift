//
//  MainViewModel.swift
//  Autocrypt_Test
//
//  Created by 이명직 on 10/26/24.
//

import Foundation
import RxSwift
import RxRelay

enum MainViewModelAction {
    case initialize
    case selectCity(CityInfo)
    case searchMode(isSearchMode: Bool)
    case search(query: String)
}

protocol MainViewModelStates {
    var currentWeather: BehaviorRelay<CurrentWeatherInfo?> { get }
    var hourlyForecast: BehaviorRelay<[HourlyWeatherInfo]> { get }
    var dailyForecast: BehaviorRelay<[DailyWeatherInfo]> { get }
    var selectedCityCoordinates: BehaviorRelay<Coordinates?> { get }
    var additionalInfo: BehaviorRelay<AdditionalWeatherInfo?> { get }
    var cityInfo: BehaviorRelay<[CityInfo]> { get }
    var isSearchMode: BehaviorRelay<Bool> { get }
}

class MainViewModel {
    // MARK: - State Structure
    struct State: MainViewModelStates {
        let currentWeather = BehaviorRelay<CurrentWeatherInfo?>(value: nil)
        let hourlyForecast = BehaviorRelay<[HourlyWeatherInfo]>(value: [])
        let dailyForecast = BehaviorRelay<[DailyWeatherInfo]>(value: [])
        let selectedCityCoordinates = BehaviorRelay<Coordinates?>(value: nil)
        let additionalInfo = BehaviorRelay<AdditionalWeatherInfo?>(value: nil)
        let cityInfo = BehaviorRelay<[CityInfo]>(value: [])
        let isSearchMode = BehaviorRelay<Bool>(value: false)
    }
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private var weatherService: WeatherService
    private var cityInfoService: CityInfoService
    
    let actions = PublishRelay<MainViewModelAction>()
    let state = State()
    
    // MARK: - Initializer
    init(weatherService: WeatherService, cityInfoService: CityInfoService) {
        self.weatherService = weatherService
        self.cityInfoService = cityInfoService
        bindActions()
    }
    
    // MARK: - Bind Actions
    private func bindActions() {
        actions
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .initialize:
                    let city = CityInfo(
                        id: 1839726,
                        name: "Asan",
                        country: "KR",
                        coord: Coordinates(latitude: 36.783611, longitude: 127.004173))
                    self.fetchWeatherData(for: city)
                    self.fetchCityInfo()
                    
                case .selectCity(let city):
                    self.fetchWeatherData(for: city)
                case .search(let query):
                    self.searchCity(query: query)
                case .searchMode(let isSearchMode):
                    self.state.isSearchMode.accept(isSearchMode)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Fetch Weather Data
    private func fetchWeatherData(for city: CityInfo) {
        weatherService.fetchWeatherData(for: city.name)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] cityWeather in
                    guard let self = self else { return }
                    self.processWeatherData(cityWeather)
                    self.state.selectedCityCoordinates.accept(Coordinates(latitude: city.coord.latitude, longitude: city.coord.longitude))
                },
                onFailure: { error in
                    print("Error fetching weather data: \(error)")
                }
            )
            .disposed(by: disposeBag)
    }
    
    // MARK: - Process Weather Data
    private func processWeatherData(_ cityWeather: CityWeather) {
        guard let firstEntry = cityWeather.list.first else { return }
        
        let currentWeatherInfo = CurrentWeatherInfo(
            temperature: firstEntry.main.temp,
            cityName: cityWeather.city.name,
            weatherDescription: firstEntry.weather.first?.description ?? "",
            maxTemp: firstEntry.main.tempMax,
            minTemp: firstEntry.main.tempMin
        )
        state.currentWeather.accept(currentWeatherInfo)
        
        let hourlyData = cityWeather.list.prefix(16).map { entry in
            HourlyWeatherInfo(
                time: entry.dtTxt,
                temperature: entry.main.temp,
                weatherDescription: entry.weather.first?.description ?? ""
            )
        }
        state.hourlyForecast.accept(hourlyData)
        
        let dailyData = Dictionary(grouping: cityWeather.list, by: { $0.dtTxt.prefix(10) })
            .sorted(by: { $0.key < $1.key })
            .prefix(5)
            .compactMap { (_, entries) -> DailyWeatherInfo? in
                guard let firstEntry = entries.first else { return nil }
                let maxTemp = entries.map { $0.main.tempMax }.max() ?? firstEntry.main.tempMax
                let minTemp = entries.map { $0.main.tempMin }.min() ?? firstEntry.main.tempMin
                return DailyWeatherInfo(
                    date: String(firstEntry.dtTxt.prefix(10)),
                    maxTemp: maxTemp,
                    minTemp: minTemp,
                    weatherDescription: firstEntry.weather.first?.description ?? ""
                )
            }
        state.dailyForecast.accept(dailyData)
        
        let additionalWeatherInfo = AdditionalWeatherInfo(
            humidity: firstEntry.main.humidity,
            cloudiness: firstEntry.clouds.all,
            windSpeed: firstEntry.wind.speed,
            gustSpeed: firstEntry.wind.gust,
            pressure: firstEntry.main.pressure
        )
        state.additionalInfo.accept(additionalWeatherInfo)
    }
    
    // MARK: - Fetch City Information
    private func fetchCityInfo() {
        cityInfoService.fetchCityData()
            .subscribe(
                onSuccess: { [weak self] cityInfo in
                    guard let self = self else { return }
                    self.state.cityInfo.accept(cityInfo)
                },
                onFailure: { error in
                    print("Error fetching city data: \(error)")
                }).disposed(by: disposeBag)
    }
    
    // MARK: - Search City
    private func searchCity(query: String) {
        let originData = cityInfoService.originData
        
        if query.isEmpty {
            state.cityInfo.accept(originData)
            return
        }

        let filteredData = originData.filter { city in
            city.name.lowercased().contains(query.lowercased()) ||
            city.country.lowercased().contains(query.lowercased())
        }
        
        state.cityInfo.accept(filteredData)
    }
}
