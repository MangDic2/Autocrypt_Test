//
//  TodayWeatherCell.swift
//  Autocrypt_Test
//
//  Created by 이명직 on 10/28/24.
//

import UIKit

class TodayWeatherCell: UICollectionViewCell {
    static let id = "TodayWeatherCell"
    
    private let timeLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textAlignment = .center
    }
    
    private let weatherIcon = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    private let temperatureLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(item: HourlyWeatherInfo) {
        timeLabel.text = item.time.formatTime()
        temperatureLabel.text = String(format: "%.1f", item.temperature) + "°"
        
        let icon = WeatherCondition(rawValue: item.weatherDescription)?.icon
        weatherIcon.image = icon
    }
    
    private func setupLayout() {
        contentView.addSubviews([
            timeLabel,
            weatherIcon,
            temperatureLabel
        ])
        
        timeLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
        }
        
        weatherIcon.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(35)
        }
    
        temperatureLabel.snp.makeConstraints {
            $0.top.equalTo(weatherIcon.snp.bottom).offset(5)
            $0.leading.bottom.trailing.equalToSuperview()
        }
    }
}

