//
//  CityListView.swift
//  Autocrypt_Test
//
//  Created by 이명직 on 10/27/24.
//

import UIKit
import RxCocoa
import RxSwift

class CityListView: UIView {
    let cityList = BehaviorRelay<[CityInfo]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    let cityListTableView = UITableView().then {
        $0.backgroundColor = #colorLiteral(red: 0.2973938584, green: 0.4899712801, blue: 0.7369740605, alpha: 0.7)
        $0.register(CityListCell.self, forCellReuseIdentifier: CityListCell.id)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        bindState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(cityListTableView)
        
        cityListTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bindState() {
        cityList
            .asDriver(onErrorJustReturn: [])
            .drive(cityListTableView.rx.items(cellIdentifier: CityListCell.id)) { row, item, cell in
                guard let cell = cell as? CityListCell else { return }
                
                cell.selectionStyle = .none
                cell.configure(item: item)
            }.disposed(by: disposeBag)
    }
}
