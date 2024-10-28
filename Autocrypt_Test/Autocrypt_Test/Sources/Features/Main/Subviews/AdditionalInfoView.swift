//
//  AdditionalInfoView.swift
//  Autocrypt_Test
//
//  Created by 이명직 on 10/28/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class AdditionalInfoView: UIView {
    private let disposeBag = DisposeBag()
    
    let additionalInfo = BehaviorRelay<AdditionalWeatherInfo?>(value: nil)
    
    private var humidityView: UIView!
    private var windSpeedView: UIView!
    private var cloudinessView: UIView!
    private var pressureView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        bindState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        backgroundColor = .clear
        
        humidityView = generateRoundedRectangleView(title: "습도")
        windSpeedView = generateRoundedRectangleView(title: "바람 속도")
        cloudinessView = generateRoundedRectangleView(title: "구름")
        pressureView = generateRoundedRectangleView(title: "기압")
        
        let rowStack1 = UIStackView(arrangedSubviews: [humidityView, cloudinessView])
        let rowStack2 = UIStackView(arrangedSubviews: [windSpeedView, pressureView])
        
        rowStack1.axis = .horizontal
        rowStack1.spacing = 15
        rowStack1.distribution = .fillEqually
        
        rowStack2.axis = .horizontal
        rowStack2.spacing = 15
        rowStack2.distribution = .fillEqually
        
        let mainStack = UIStackView(arrangedSubviews: [rowStack1, rowStack2])
        mainStack.axis = .vertical
        mainStack.spacing = 15
        mainStack.distribution = .fillEqually
        
        addSubview(mainStack)
        
        mainStack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
    }
    
    private func generateRoundedRectangleView(title: String) -> UIView {
        let contentView = UIView()
        contentView.backgroundColor = #colorLiteral(red: 0.2973938584, green: 0.4899712801, blue: 0.7369740605, alpha: 0.7)
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = title
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        
        let dataLabel = UILabel()
        dataLabel.textColor = .white
        dataLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        dataLabel.tag = 100
        
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dataLabel)
        
        descriptionLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(10)
        }
        
        dataLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.height.equalTo(contentView.snp.width)
        }
        
        return contentView
    }
    
    private func bindState() {
        additionalInfo
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] info in
                guard let self = self else { return }
                
                if let humidityLabel = self.humidityView.viewWithTag(100) as? UILabel {
                    humidityLabel.text = "\(info.humidity)%"
                }
                
                if let windSpeedLabel = self.windSpeedView.viewWithTag(100) as? UILabel {
                    windSpeedLabel.text = "\(info.windSpeed) m/s"
                }
                
                if let cloudinessLabel = self.cloudinessView.viewWithTag(100) as? UILabel {
                    cloudinessLabel.text = "\(info.cloudiness)%"
                }
                
                if let pressureLabel = self.pressureView.viewWithTag(100) as? UILabel {
                    pressureLabel.text = "\(info.pressure) hPa"
                }
            })
            .disposed(by: disposeBag)
    }
}
