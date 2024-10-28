//
//  MainViewController.swift
//  Autocrypt_Test
//
//  Created by 이명직 on 10/26/24.
//

import UIKit
import RxCocoa
import RxSwift

class MainViewController: UIViewController {
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: MainViewModel
    private let action = PublishRelay<MainViewModelAction>()
    
    // MARK: - Views
    
    private let mainView = MainView()
    
    // MARK: - Initializer
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        bindAction()
        bindState()
    }
    
    // MARK: - Layout Setup
    
    private func setupLayout() {
        view.addSubview(mainView)
        
        mainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    
    private func bindAction() {
        action
            .bind(to: viewModel.actions)
            .disposed(by: disposeBag)
        
        mainView.cityListView.cityListTableView.rx
            .modelSelected(CityInfo.self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] item in
                guard let `self` = self else { return }
                
                self.action.accept(.selectCity(item))
                self.action.accept(.searchMode(isSearchMode: false))
            }).disposed(by: disposeBag)
        
        mainView.searchBar.rx.text
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                guard let `self` = self else { return }
                self.action.accept(.search(query: text ?? ""))
            }).disposed(by: disposeBag)
        
        mainView.searchBar.rx.textDidBeginEditing
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.action.accept(.searchMode(isSearchMode: true))
            }).disposed(by: disposeBag)
        
        action.accept(.initialize)
    }
    
    private func bindState() {
        viewModel.state.isSearchMode
            .bind(to: mainView.isSearchMode)
            .disposed(by: disposeBag)
        
        viewModel.state.currentWeather
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.topInfoView.weatherInfo)
            .disposed(by: disposeBag)
        
        viewModel.state.currentWeather
            .observe(on: MainScheduler.instance)
            .compactMap { $0?.weatherDescription }
            .map { description -> UIImage? in
                guard let condition = WeatherCondition(rawValue: description) else { return UIImage(named: "sunny") }
                return condition.background.image
            }
            .bind(to: mainView.backgroundImageRelay)
            .disposed(by: disposeBag)

        viewModel.state.hourlyForecast
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.todayWeatherView.hourlyData)
            .disposed(by: disposeBag)

        viewModel.state.dailyForecast
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.weeklyWeatherView.dailyData)
            .disposed(by: disposeBag)
        
        viewModel.state.selectedCityCoordinates
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.precipitationView.selectedCityCoordinates)
            .disposed(by: disposeBag)

        viewModel.state.additionalInfo
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.additionalInfoView.additionalInfo)
            .disposed(by: disposeBag)
        
        viewModel.state.cityInfo
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.cityListView.cityList)
            .disposed(by: disposeBag)
    }
}
