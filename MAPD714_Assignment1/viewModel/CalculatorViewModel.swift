//
//  CalculatorViewModel.swift
//  MAPD714_Assignment1
//
//  Created by Charlene Cheung on 27/9/2022.
//

import Foundation

class CalculatorViewModel: ObservableObject {
    
    // result
    var result : String = ""
    
    @Published var buttons: [[CalculatorButton]] = [
            [.clear, .plusMinus, .percentage, .divide],
            [.seven, .eight, .nine, .multiply],
            [.four, .five, .six, .subtract],
            [.one, .two, .three, .add],
            [ .zero, .dot, .equal]
        ]
    // number input
    var _numberInput: [String] = []
    var _operatorInput: [String] = []
    var _lastIsOperator : Bool?
    
    @Published var display: String = "0"
    
    var _isNumber: Bool = false
    var _isNumberOperator: Bool  = false
    var _isCalculateOperator: Bool  = false
    var _isNumberPack: Bool = false
    
    init() {
        
    }
    
    func add(val1: String, val2: String) -> Double {
        return (Double(val1)! + Double(val2)!)
    }
    
    func subtract(val1: String, val2: String) -> Double {
        return (Double(val1)! - Double(val2)!)
    }
    
    func multipy(val1: String, val2: String) -> Double {
        return (Double(val1)! * Double(val2)! )
    }
    
    func divide(val1: String, val2: String) -> Double {
        return (Double(val1)! / Double(val2)!)
    }
    
    func toPercentage(val: String) -> Double {
        return (Double(val)! / 100)
    }
    
    func toOpposeValue(val: String) -> Double {
        return Double(val)! / -1
    }
    
    func toFloatingPoint(val: String) -> String {
        var value:String = val
        if(!value.contains(CalculatorButton.dot.name)) {
            value = value + CalculatorButton.dot.name
        }
        return value
    }
    
    func clear() {
        _numberInput = []
        _operatorInput = []
        _lastIsOperator = nil
    }

    func backspace() {
        if(_operatorInput.isEmpty && _numberInput.isEmpty) {return}
        if (_lastIsOperator == true){
            _operatorInput.removeLast()
            _lastIsOperator = false
        } else {
            let lastNumber = _numberInput.popLast()
            
            if (lastNumber!.count) > 1 {
                let number = lastNumber!.dropLast()
                _numberInput.append(String(number))

            } else {
                _lastIsOperator = true
            }
        }
    }
    
    func getFormulaDisplay() ->String {
        var d: [String] = []
        let count = max(_numberInput.count, _operatorInput.count)
        for i in 0..<count {
            if i < _numberInput.count {d.append(_numberInput[i])}
            if i < _operatorInput.count {d.append(_operatorInput[i])}
        }
        return d.joined()
    }
    
    func getResultDisplay() ->String {
        return result
    }
    
    func handleNumberInput(input: String) {
        if (_lastIsOperator == nil) {
            _numberInput.append(input)

        } else if (_lastIsOperator == true) {
            if((_numberInput.last?.hasSuffix(".") == true)){
                var val = _numberInput.popLast()!
                val = val + input
                _numberInput.append(val)
            }
            else{
                _numberInput.append(input)
            }
        } else {
            var val = _numberInput.popLast()!
            val = val + input
            _numberInput.append(val)
        }
        _lastIsOperator = false
    }
    
    func handleOperatorInput(input: String) {
        if(_numberInput.isEmpty) {return}
        _lastIsOperator = true
        if (input == CalculatorButton.dot.name) {
            if(_numberInput.last!.contains(".")) { return }
            var val = _numberInput.popLast()!
            val = val + "."
            _numberInput.append(val)
            return
        } else if(input == CalculatorButton.percentage.name) {
            let val = _numberInput.popLast()!
            _numberInput.append(String(self.toPercentage(val: val)))
            return
        } else if (input == CalculatorButton.plusMinus.name) {
            let val = _numberInput.popLast()!
            _numberInput.append(String(self.toOpposeValue(val: val)))

            return
        }
        _operatorInput.append(input)
    }
    
    func calculate() {
        if _numberInput.count <= 0 { return }
        var seriesFormula : [String] = []
        for i in 0..<_numberInput.count {
            if i < _numberInput.count {seriesFormula.append(_numberInput[i])}
            if i < _operatorInput.count {seriesFormula.append(_operatorInput[i])}
        }
        for operateSymbol in _operatorInput {
            if ![CalculatorButton.divide.name, CalculatorButton.multiply.name].contains(operateSymbol) {
                continue
            }
            let loc = seriesFormula.firstIndex(of: operateSymbol)!
            let val1 : String = seriesFormula[loc-1]
            let val2 : String = seriesFormula[loc+1]
            if operateSymbol == CalculatorButton.divide.name {
                seriesFormula[loc] = String(divide(val1: val1, val2: val2))
            } else {
                seriesFormula[loc] = String(multipy(val1: val1, val2: val2))
            }
            
            seriesFormula.remove(at: loc+1)
            seriesFormula.remove(at: loc-1)
        }
        _operatorInput.removeAll(where: {CalculatorButton.divide.name == $0})
        _operatorInput.removeAll(where: {CalculatorButton.multiply.name == $0})
        
        for operateSymbol in _operatorInput {
            if [CalculatorButton.divide.name, CalculatorButton.multiply.name].contains(operateSymbol) {
                continue
            }
            let loc = seriesFormula.firstIndex(of: operateSymbol)!
            let val1 : String = seriesFormula[loc-1]
            let val2 : String = seriesFormula[loc+1]
            if operateSymbol == CalculatorButton.add.name {
                seriesFormula[loc] = String(add(val1: val1, val2: val2))
            } else {
                seriesFormula[loc] = String(subtract(val1: val1, val2: val2))
            }
            
            seriesFormula.remove(at: loc+1)
            seriesFormula.remove(at: loc-1)
        }
        result = seriesFormula[0]
        _numberInput = [seriesFormula[0]]
        _operatorInput = []
        _lastIsOperator = nil
    }
}
