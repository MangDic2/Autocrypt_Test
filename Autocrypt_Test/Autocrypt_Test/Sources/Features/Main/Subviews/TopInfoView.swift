//
//  TopInfoView.swift
//  Autocrypt_Test
//
//  Created by 이명직 on 10/26/24.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

class TopInfoView: UIView {
    private let disposeBag = DisposeBag()
    
    let weatherInfo = BehaviorRelay<CurrentWeatherInfo?>(value: nil)
    
    private let cityLabel = UILabel().then {
        $0.text = "Seoul"
        $0.font = UIFont.systemFont(ofSize: 40, weight: .regular)
        $0.textAlignment = .center
        $0.textColor = .white
    }
    
    private let currentTemperatureLabel = UILabel().then {
        $0.text = "-7"
        $0.font = UIFont.systemFont(ofSize: 80, weight: .regular)
        $0.textAlignment = .center
        $0.textColor = .white
    }
    
    private let weatherLabel = UILabel().then {
        $0.text = "맑음"
        $0.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        $0.textAlignment = .center
        $0.textColor = .white
    }
    
    private let temperatureLabel = UILabel().then {
        $0.text = "최고: -1"
        $0.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        $0.textAlignment = .center
        $0.textColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubviews([
            cityLabel,
            currentTemperatureLabel,
            weatherLabel,
            temperatureLabel
        ])
        
        cityLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
        }
        
        currentTemperatureLabel.snp.makeConstraints {
            $0.top.equalTo(cityLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview()
        }
        
        weatherLabel.snp.makeConstraints {
            $0.top.equalTo(currentTemperatureLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.top.equalTo(weatherLabel.snp.bottom).offset(5)
            $0.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    private func bind() {
        weatherInfo
            .subscribe(onNext: { [weak self] info in
                guard let `self` = self else { return }
                guard let info = info else { return }
                self.cityLabel.text = info.cityName
                self.currentTemperatureLabel.text = String(format: "%.1f", info.temperature) + "°"
                self.weatherLabel.text = WeatherCondition(rawValue: info.weatherDescription)?.description
                self.temperatureLabel.text = "최고: " + String(format: "%.1f", info.maxTemp) + "°" + "  |  " + "최저: " + String(format: "%.1f", info.minTemp) + "°"
            }).disposed(by: disposeBag)
    }
}
