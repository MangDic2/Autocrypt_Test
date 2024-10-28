//
//  MainView.swift
//  Autocrypt_Test
//
//  Created by 이명직 on 10/26/24.
//

import UIKit
import RxCocoa
import RxSwift

class MainView: UIView {
    // MARK: - Properties
    
    let backgroundImageRelay = BehaviorRelay<UIImage?>(value: nil)
    let isSearchMode = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()
    
    // MARK: - Views
    
    let searchBar = UISearchBar().then {
        $0.searchTextField.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        $0.searchTextField.layer.borderWidth = 0.5
        $0.searchTextField.layer.cornerRadius = 6
        $0.backgroundColor = .clear
        $0.placeholder = "Search"
        $0.searchBarStyle = .minimal
        $0.searchTextField.alpha = 1.0
        $0.searchTextField.textColor = .white
        $0.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search",
                                                                      attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        if let magnifyingGlass = UIImage(systemName: "magnifyingglass") {
            let tintedImage = magnifyingGlass.withRenderingMode(.alwaysTemplate)
            $0.setImage(tintedImage, for: .search, state: .normal)
            $0.searchTextField.leftView?.tintColor = .lightGray
        }
    }
    
    let topInfoView = TopInfoView()
    let todayWeatherView = TodayWeatherView()
    let weeklyWeatherView = WeeklyWeatherView()
    let precipitationView = PrecipitationView()
    let additionalInfoView = AdditionalInfoView()
    
    let cityListView = CityListView().then {
        $0.isHidden = true
    }
    
    private let searchBarContentView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let scrollView = UIScrollView()
    private let backgroundImage = UIImageView()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        bindState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout Setup
    
    private func setupLayout() {
        backgroundColor = .black
        
        addSubviews([
            backgroundImage,
            scrollView,
            searchBarContentView,
            searchBar,
            cityListView
        ])
        
        scrollView.addSubviews([
            topInfoView,
            todayWeatherView,
            weeklyWeatherView,
            precipitationView,
            additionalInfoView
        ])
        
        backgroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        searchBarContentView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.bottom.equalTo(searchBar).offset(20)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.bottom.trailing.equalToSuperview()
        }
        
        topInfoView.snp.makeConstraints {
            $0.top.equalTo(scrollView.contentLayoutGuide).offset(60)
            $0.centerX.equalToSuperview()
        }
        
        todayWeatherView.snp.makeConstraints {
            $0.top.equalTo(topInfoView.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.width.equalToSuperview().offset(-20)
        }
        
        weeklyWeatherView.snp.makeConstraints {
            $0.top.equalTo(todayWeatherView.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        precipitationView.snp.makeConstraints {
            $0.top.equalTo(weeklyWeatherView.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        additionalInfoView.snp.makeConstraints {
            $0.top.equalTo(precipitationView.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalTo(scrollView.contentLayoutGuide).inset(20)
            $0.width.equalToSuperview().offset(-20)
        }
        
        cityListView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(20)
            $0.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    
    private func bindState() {
        backgroundImageRelay
            .subscribe(onNext: { [weak self] image in
                guard let `self` = self else { return }
                self.showBackgroundChangeAnimation(image: image)
            }).disposed(by: disposeBag)
        
        isSearchMode
            .subscribe(onNext: { [weak self] isSearchMode in
                guard let `self` = self else { return }
                self.toggleSearchMode(isSearchMode: isSearchMode)
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Methods
    
    private func showBackgroundChangeAnimation(image: UIImage?) {
        guard let image = image else { return }
        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundImage.alpha = 0.0
        }, completion: { _ in
            self.backgroundImage.image = image
            UIView.animate(withDuration: 0.1, animations: {
                self.backgroundImage.alpha = 0.7
            })
        })
    }
    
    private func toggleSearchMode(isSearchMode: Bool) {
        scrollView.isHidden = isSearchMode
        cityListView.isHidden = !isSearchMode
        
        searchBarContentView.backgroundColor = isSearchMode ? #colorLiteral(red: 0.2973938584, green: 0.4899712801, blue: 0.7369740605, alpha: 0.7) : .clear
        
        if !isSearchMode {
            self.searchBar.resignFirstResponder()
        }
    }
}
