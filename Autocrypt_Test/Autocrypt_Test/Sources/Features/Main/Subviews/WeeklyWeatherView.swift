//
//  WeeklyWeatherView.swift
//  Autocrypt_Test
//
//  Created by 이명직 on 10/26/24.
//

import UIKit
import RxCocoa
import RxSwift

class WeeklyWeatherView: UIView {
    let dailyData = BehaviorRelay<[DailyWeatherInfo]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    private let descriptionLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "5일간의 일기예보"
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    }
    
    private let weatherTableView = UITableView().then {
        $0.register(WeeklyWeatherCell.self, forCellReuseIdentifier: WeeklyWeatherCell.id)
        $0.rowHeight = 45
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = false
    }
    
    private let divider = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupContentView()
        setupLayout()
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContentView() {
        backgroundColor = #colorLiteral(red: 0.2973938584, green: 0.4899712801, blue: 0.7369740605, alpha: 0.7)
        layer.cornerRadius = 15
    }
    
    private func setupLayout() {
        addSubview(contentStackView)
        
        contentStackView.addArrangedSubviews([
            descriptionLabel,
            divider,
            weatherTableView
        ])
        
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(15)
        }
        
        divider.snp.makeConstraints {
            $0.height.equalTo(0.5)
        }
        
        weatherTableView.snp.makeConstraints {
            $0.height.equalTo(225)
        }
    }
    
    private func bind() {
        dailyData
            .asDriver(onErrorJustReturn: [])
            .drive(weatherTableView.rx.items(cellIdentifier: WeeklyWeatherCell.id)) { row, item, cell in
                guard let cell = cell as? WeeklyWeatherCell else { return }
                cell.configure(item: item)
                cell.selectionStyle = .none
            }.disposed(by: disposeBag)
    }
}
