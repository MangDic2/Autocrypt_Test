//
//  TodayWeatherView.swift
//  Autocrypt_Test
//
//  Created by 이명직 on 10/26/24.
//

import UIKit
import RxSwift
import RxCocoa

class TodayWeatherView: UIView {
    let hourlyData = BehaviorRelay<[HourlyWeatherInfo]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    private let descriptionLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "돌풍의 풍속은 최대 4m/s입니다."
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    }
    
    private let layout = UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        $0.scrollDirection = .horizontal
    }
    
    private lazy var weatherCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.register(TodayWeatherCell.self, forCellWithReuseIdentifier: TodayWeatherCell.id)
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
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
            weatherCollectionView
        ])
        
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(15)
        }
        
        divider.snp.makeConstraints {
            $0.height.equalTo(0.5)
        }
        
        weatherCollectionView.snp.makeConstraints {
            $0.height.equalTo(81.34)
        }
    }
    
    private func bind() {
        hourlyData
            .asDriver(onErrorJustReturn: [])
            .drive(weatherCollectionView.rx.items(cellIdentifier: TodayWeatherCell.id)) { row, item, cell in
                guard let cell = cell as? TodayWeatherCell else { return }
                cell.configure(item: item)
            }.disposed(by: disposeBag)
    }
}
