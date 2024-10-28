//
//  WeeklyWeatherCell.swift
//  Autocrypt_Test
//
//  Created by 이명직 on 10/28/24.
//

import UIKit

class WeeklyWeatherCell: UITableViewCell {
    static let id = "WeeklyWeatherCell"
    
    private let weekdayLabel = UILabel().then {
        $0.text = "오늘"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .white
        $0.sizeToFit()
    }
    
    private let iconContentView = UIView()
    
    private let weatherIcon = UIImageView().then {
        $0.image = UIImage(named: "01d")
        $0.contentMode = .scaleToFill
    }
    
    private let minTemperatureLabel = UILabel().then {
        $0.text = "최소: -8"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .thin)
        $0.textColor = .white
    }
    
    private let maxTemperatureLabel = UILabel().then {
        $0.text = "최대: -8"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .white
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(item: DailyWeatherInfo) {
        weekdayLabel.text = item.date.toDayOfWeek()
        minTemperatureLabel.text = "최소: " + String(format: "%.1f", item.minTemp) + "°"
        maxTemperatureLabel.text = "최대: " + String(format: "%.1f", item.maxTemp) + "°"
        let icon = WeatherCondition(rawValue: item.weatherDescription)?.icon
        weatherIcon.image = icon
    }
    
    private func setupLayout() {
        backgroundColor = .clear
        
        contentView.addSubviews([
            weekdayLabel,
            iconContentView,
            minTemperatureLabel,
            maxTemperatureLabel
        ])
        
        iconContentView.addSubview(weatherIcon)
        
        weekdayLabel.setContentHuggingPriority(.required, for: .horizontal)
        minTemperatureLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        weekdayLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        iconContentView.snp.makeConstraints {
            $0.leading.equalTo(weekdayLabel.snp.trailing).offset(10)
            $0.top.bottom.equalToSuperview().inset(5)
        }
        
        weatherIcon.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.size.equalTo(35)
        }
        
        minTemperatureLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(iconContentView.snp.trailing)
            $0.trailing.equalTo(maxTemperatureLabel.snp.leading).offset(-10)
        }
        
        maxTemperatureLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
}
