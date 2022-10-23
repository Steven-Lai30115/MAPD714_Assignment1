//
//  ext.swift
//  calculator
//
//  Created by Charlene Cheung on 2022/09/26.
//

import Foundation
extension String {
    var isNumber: Bool {
        /*let characters = CharacterSet.decimalDigits.inverted
        return !self.isEmpty && rangeOfCharacter(from: characters) == nil*/
        return [CalculatorButton.one.name, CalculatorButton.two.name, CalculatorButton.three.name, CalculatorButton.four.name,  CalculatorButton.five.name,  CalculatorButton.six.name,  CalculatorButton.seven.name,  CalculatorButton.eight.name,  CalculatorButton.nine.name,  CalculatorButton.zero.name, ].contains(self)
    }
    
    var isNumberOperator: Bool {
        return [CalculatorButton.dot.name, CalculatorButton.percentage.name, CalculatorButton.plusMinus.name].contains(self)
    }
    
    var isCalculateOperator: Bool {
        
        return [CalculatorButton.add.name, CalculatorButton.subtract.name, CalculatorButton.multiply.name, CalculatorButton.divide.name].contains(self)
    }
    
    func substring(from: Int, to: Int) -> String {
        let start = index(startIndex, offsetBy: from)
        let end = index(start, offsetBy: to - from + 1)
        return String(self[start ..< end])
    }
}

extension Double {
    var round8Digit: Double {
        let divisor = pow(10.0, Double(8))
        return (self * divisor).rounded() / divisor
    }
}

