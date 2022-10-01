//
//  CalculatorViewModel.swift
//  MAPD714_Assignment2
//
//  Created by Pui Yan Cheung (301252393), Man Nok PUN (301269138), Chin Wai Lai(301257824).
//  Last modified 15:28 29 Sept 2022
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
    var _isCalculated : Bool = false
    
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
        result = ""
        _lastIsOperator = nil
        _isCalculated = false
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
            if i < _numberInput.count {d.append(decimalFilter(input: _numberInput[i]))}
            if i < _operatorInput.count {d.append(_operatorInput[i])}
        }
        return d.joined()
    }
    
    func decimalFilter(input: String) -> String{
        // Check input string has valid decimal (not 2".0")
        if(input.count <= 0) {return input}
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 8
        formatter.numberStyle = .decimal
        let tempSting = formatter.string(from: Double(input)! as NSNumber)
        if(input.last == ".") { return input }
        return tempSting ?? input
    }
    
    
    func getResultDisplay() ->String {
        return decimalFilter(input: result)
    }
    
    func resetCheck( completetCheck : () -> ()){
        if(_isCalculated && _lastIsOperator != true){
            clear()
            completetCheck()
        }
    }
    
    func handleNumberInput(input: String) {
        if (_lastIsOperator == nil) {
            _numberInput.append(input)

        } else if (_lastIsOperator == true) {
            if((_numberInput.last?.hasSuffix(".") == true)){
                let val = _numberInput.popLast()!
                _numberInput.append(val)
            }
            _numberInput.append(input)
        } else {
            var val = _numberInput.popLast()!
            val = val + input
            _numberInput.append(val)
        }
        _lastIsOperator = false
    }
    
    func handleOperatorInput(input: String) {
        _isCalculated = false
        if(_numberInput.isEmpty) {return}
        
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
        
        if(_lastIsOperator == nil || _lastIsOperator == false){
            _operatorInput.append(input)
            _lastIsOperator = true
        }
        else{
            onOperatorChange(input: input)
        }
    }
    
    func onOperatorChange(input : String){
         _operatorInput.removeLast()
        _operatorInput.append(input)
    }
    
    func calculate() {
        if _numberInput.count <= _operatorInput.count { return }
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
        _lastIsOperator = nil
        _isCalculated = true
    }
}
