//
//  String+.swift
//  Autocrypt_Test
//
//  Created by 이명직 on 10/26/24.
//

import Foundation

extension String {
    func formatTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        guard let date = dateFormatter.date(from: self) else { return self }
        
        dateFormatter.dateFormat = "a h시"
        return dateFormatter.string(from: date)
    }
    
    func toDayOfWeek() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.locale = Locale(identifier: "ko_KR") 
        
            guard let date = dateFormatter.date(from: self) else { return "" }
            
            dateFormatter.dateFormat = "E"
            return dateFormatter.string(from: date)
        }
}
