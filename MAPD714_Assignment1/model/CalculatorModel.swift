//
//  calculatorModel.swift
//  calculator
//
//  Created by Charlene Cheung on 2022/09/26.
//

import Foundation

enum CalculatorButton: String {
    case clear, plusMinus, percentage, divide, multiply, subtract, add, one, two, three, four, five, six, seven, eight, nine, zero, dot, equal, backspace, sqRoot, sq, pi, sine, cosine, tangent, Rand
    
    var name: String {
        switch self {
        case .clear: return "C"
        case .plusMinus: return "+/-"
        case .percentage: return "%"
        case .divide: return "/"
        case .multiply: return "＊"
        case .subtract: return "-"
        case .add: return "+"
        case .one: return "1"
        case .two: return "2"
        case .three: return "3"
        case .four: return "4"
        case .five: return "5"
        case .six: return "6"
        case .seven: return "7"
        case .eight: return "8"
        case .nine: return "9"
        case .dot: return "."
        case .zero: return "0"
        case .equal: return "="
        case .backspace: return "⌫"
        case .sqRoot: return "√"
        case .sq: return "x^2"
        case .pi: return "π"
        case .sine: return "sin"
        case .cosine: return "cos"
        case .tangent: return "tan"
        case .Rand: return "rand"
        }
    }
}
