//
//  AppDelegate.swift
//  Autocrypt_Test
//
//  Created by 이명직 on 10/26/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let window = window else { return false }
        
        let weatherService = WeatherService.shared
        let cityInfoService = CityInfoService.shared
        
        let mainViewModel = MainViewModel(weatherService: weatherService, cityInfoService: cityInfoService)
        window.rootViewController = MainViewController(viewModel: mainViewModel)
        window.makeKeyAndVisible()
        window.backgroundColor = .white
        
        return true
    }
}

