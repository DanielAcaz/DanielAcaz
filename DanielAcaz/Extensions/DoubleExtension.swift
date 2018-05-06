//
//  DoubleExtension.swift
//  DanielAcaz
//
//  Created by Daniel Acaz on 06/05/2018.
//  Copyright © 2018 FIAP. All rights reserved.
//

import Foundation

enum CurrencyLocale: String {
    case EN = "en_US"
    case BR = "pt_BR"
}

private func getCurrencyFormatter(_ locale: CurrencyLocale) -> NumberFormatter {
    let formatter = NumberFormatter()
    formatter.locale = Locale(identifier: locale.rawValue)
    formatter.numberStyle = .currency
    return formatter
}

extension Double {
    /// Arredonda um Double conforme quantidade de casas decimais
    func numberOfDecimalPlaces(_ decimalPlaces: Int) -> Double {
        var format:String {
            let format = NumberFormatter()
            format.minimumFractionDigits = decimalPlaces
            return format.string(from: NSNumber(value: self))!
            
        }
        return Double(format)!
        
    }
    
    func toCurrencyString(forLocale currencyLocale: CurrencyLocale = CurrencyLocale.EN, useSymbol: Bool = false) -> String? {
        let formatter = getCurrencyFormatter(currencyLocale)
        if !useSymbol {
            formatter.currencySymbol = ""
        }
        return formatter.string(from: self as NSNumber)
    }
}
