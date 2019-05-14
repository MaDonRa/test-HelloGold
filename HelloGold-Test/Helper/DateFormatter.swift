//
//  DateFormatter.swift
//  Box24
//
//  Created by Sakkaphong Luaengvilai on 2/11/2561 BE.
//  Copyright © 2561 MaDonRa. All rights reserved.
//

import Foundation

extension Date {
    
    func DateString(Format : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: Cache.SelectedLanguage == ConfigOther.LanguageName.Thai.Language ? .buddhist : .gregorian)
        dateFormatter.locale = Locale(identifier: Cache.SelectedLanguage == ConfigOther.LanguageName.Thai.Language ? "th" : "en_TH")
        dateFormatter.dateFormat = Format
        return dateFormatter.string(from: self)
    }
}

extension String {
    
    func DateString(CurrentFormat : String , ToFormat : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = CurrentFormat
        
        let date = dateFormatter.date(from: self)
        
        dateFormatter.calendar = Calendar(identifier: Cache.SelectedLanguage == ConfigOther.LanguageName.Thai.Language ? .buddhist : .gregorian)
        dateFormatter.locale = Locale(identifier: Cache.SelectedLanguage == ConfigOther.LanguageName.Thai.Language ? "th" : "en_TH")
        dateFormatter.dateFormat = ToFormat
        return dateFormatter.string(from: date ?? Date())
    }
}
