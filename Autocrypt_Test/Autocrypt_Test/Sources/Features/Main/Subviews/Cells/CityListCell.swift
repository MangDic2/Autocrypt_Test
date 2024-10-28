//
//  CityListCell.swift
//  Autocrypt_Test
//
//  Created by 이명직 on 10/28/24.
//

import UIKit

class CityListCell: UITableViewCell {
    static let id = "CityListCell"
    
    private let nameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .white
    }
    
    private let countryLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .white
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(item: CityInfo) {
        nameLabel.text = item.name
        countryLabel.text = item.country
    }
    
    private func setupLayout() {
        backgroundColor = .clear
        
        contentView.addSubviews([nameLabel, countryLabel])
        
        nameLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(15)
        }
        
        countryLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
            $0.leading.bottom.trailing.equalToSuperview().inset(15)
        }
    }
}

