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
    
    
    func add(val1: String, val2: String) -> String {
        return String(Double(val1)! + Double(val2)!)
    }
    
    func subtract(val1: String, val2: String) -> String {
        return String(Double(val1)! - Double(val2)!)
    }
    
    func multipy(val1: String, val2: String) -> String {
        return String(Double(val1)! * Double(val2)! )
    }
    
    func divide(val1: String, val2: String) -> String {
        return String(Double(val1)! / Double(val2)!)
    }
    
    func toPercentage(val: String) -> String {
        return String(Double(val)! / 100)
    }
    
    func toOpposeValue(val: String) -> String {
        if(val.contains(CalculatorButton.subtract.name)) {
            var t = val
            t.removeFirst()
            return t
        } else {
            return "-\(val)"
        }
    }
    
    func toFloatingPoint(val: String) -> String {
        var value:String = val
        if(!value.contains(CalculatorButton.dot.name)) {
            value = value + CalculatorButton.dot.name
        }
        return value
    }
    
    // return a random number
    // -> 0.12321141
    func generateRandomNumber() -> String {
        return String(Float(arc4random()) / Float(UInt32.max))
    }
    
    // return actual result of sin calculation
    // "123" -> "-0.45990349068959124"
    func calculateSin(val: String) -> String{
        let value = Double(val)
        return String(sin(value!))
    }
    
    // return actual result of cos calculation
    // "123" -> "-0.8879689066918555"
    func calculateCos(val: String) -> String{
        let value = Double(val)
        return String(cos(value!))
    }
    
    // return actual result of tan calculation
    // "123" -> "0.5179274715856551"
    func calculateTan(val: String) -> String{
        let value = Double(val)
        return String(tan(value!))
    }
    
    // return pi value
    // -> "3.14xxxxxxxxxxxx"
    func pi() -> String {
        return String(Float.pi)
    }
    
    // return actual result of sqrt calculation
    // "10" -> 3.1622776601683795
    func calculateSqrt(val: String) -> String{
        let value = Double(val)
        return String(sqrt(value!))
    }
    
    // return actual result of x^2 calculation
    // "10" -> "100.0"
    func calculateSquare(val: String) -> String{
        let value = Double(val)
        return String(value! * value!)
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
    
    // return formula label display text
    func getFormulaDisplay() ->String {
        var d: [String] = []
        let count = max(_numberInput.count, _operatorInput.count)
        for i in 0..<count {
            if i < _numberInput.count {d.append(decimalFilter(input: _numberInput[i]))}
            if i < _operatorInput.count {d.append(_operatorInput[i])}
        }
        return d.joined()
    }
    
    // decimal value validation
    func decimalFilter(input: String) -> String{
        // Check input string has valid decimal (not 2".0")
        if(input.count <= 0) {return input}
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 8
        formatter.numberStyle = .decimal
        if(input.last == "." || input.contains("%")) {
            return input
        } else {
            return formatter.string(from: Double(input)! as NSNumber) ?? input
        }
    }
    
    // return result label display text
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
            if(["-0.0", "0.0", "0", "-0"].contains(_numberInput.first)) {
                _numberInput = [input]
            } else {
                _numberInput.append(input)
            }
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
    
    // handle sub-operator operation ("sin", "cos", "tan", "x^2", "sqrt")
    func handleInstantOperatorInput(input: String) {
        _isCalculated = false
        if(_numberInput.isEmpty) {return}
        
        // reuse result
        if(!result.isEmpty && _lastIsOperator == nil ) {
            _operatorInput = []
            _numberInput = [result]
            result = ""
        }
        
        var val = _numberInput.popLast()!
        val = interpretPi(curVal: val)
        val = interpretRand(curVal: val)
        if val.contains("%"){ val = interpretPercentage(val: val) }
        
        switch(input){
            case CalculatorButton.sine.name: val = calculateSin(val: val)
            case CalculatorButton.cosine.name: val = calculateCos(val: val)
            case CalculatorButton.tangent.name:val = calculateTan(val: val)
            case CalculatorButton.sq.name: val = calculateSquare(val: val)
            case CalculatorButton.sqRoot.name:  val = calculateSqrt(val: val)
            default: return
        }
        
        _numberInput.append(val)
        return
    }
    
    // handle sub-operator operation ("." , "%" , "+/-")
    func handleOperatorInput(input: String) {
        _isCalculated = false
        if(_numberInput.isEmpty) {return}
        
        if(!result.isEmpty && _lastIsOperator == nil ) {
            _operatorInput = []
            _numberInput = [result]
            result = ""
        }
        
        if (input == CalculatorButton.dot.name) {
            if(_numberInput.last!.contains(".")) { return }
            var val = _numberInput.popLast()!
            val = val + "."
            _numberInput.append(val)
            return
        } else if(input == CalculatorButton.percentage.name) {
            if(_numberInput.last!.contains("%")) { return }
            let val = _numberInput.popLast()!
            _numberInput.append(val+"%")
            return
        } else if (input == CalculatorButton.plusMinus.name) {
            let val = _numberInput.popLast()!
            _numberInput.append(self.toOpposeValue(val: val))
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
    
    func interpretPi(curVal: String) -> String{
        if curVal.contains(CalculatorButton.pi.name) {
            let replaced = curVal.replacingOccurrences(of: CalculatorButton.pi.name, with: pi())
            return String(replaced)
        }
        return curVal
    }
    func interpretRand(curVal: String) -> String{
        if curVal.contains(CalculatorButton.Rand.name) {
            let replaced = curVal.replacingOccurrences(of: CalculatorButton.Rand.name, with: generateRandomNumber())
            return String(replaced)
        }
        return curVal
    }
    func interpretPercentage(val: String) -> String{
        var curVal = val
        curVal.removeLast()
        curVal = String(curVal)
        curVal = self.toPercentage(val: curVal)
        return curVal
    }
    
    // calculation method with string evaluation logic + arithmetic operation
    func calculate() {
        if _numberInput.count <= _operatorInput.count { return }
        var seriesFormula : [String] = []
        for i in 0..<_numberInput.count {
            var curVal = _numberInput[i]
            
            curVal = interpretPi(curVal: curVal)
            curVal = interpretRand(curVal: curVal)
            
            if curVal.contains("%"){
                if([CalculatorButton.add.name, CalculatorButton.subtract.name].contains(seriesFormula.last)) {
                    curVal.removeLast()
                    let lastVal = Double(_numberInput[i-1])
                    curVal = String(lastVal! * Double(self.toPercentage(val: curVal))!)
                } else {
                    curVal = interpretPercentage(val: curVal)
                }
            }
            if i < _numberInput.count {seriesFormula.append(curVal)}
            if i < _operatorInput.count {seriesFormula.append(_operatorInput[i])}
            
        }
        // handle multiply value and divide value first
        for operateSymbol in _operatorInput {
            if ![CalculatorButton.divide.name, CalculatorButton.multiply.name].contains(operateSymbol) {
                continue
            }
            let loc = seriesFormula.firstIndex(of: operateSymbol)!
            let val1 : String = seriesFormula[loc-1]
            let val2 : String = seriesFormula[loc+1]
            if operateSymbol == CalculatorButton.divide.name {
                seriesFormula[loc] = self.divide(val1: val1, val2: val2)
            } else {
                seriesFormula[loc] = self.multipy(val1: val1, val2: val2)
            }
            
            seriesFormula.remove(at: loc+1)
            seriesFormula.remove(at: loc-1)
        }
        _operatorInput.removeAll(where: {CalculatorButton.divide.name == $0})
        _operatorInput.removeAll(where: {CalculatorButton.multiply.name == $0})
        
        // then handle add and subtract value
        for operateSymbol in _operatorInput {
            if [CalculatorButton.divide.name, CalculatorButton.multiply.name].contains(operateSymbol) {
                continue
            }
            let loc = seriesFormula.firstIndex(of: operateSymbol)!
            let val1 : String = seriesFormula[loc-1]
            let val2 : String = seriesFormula[loc+1]
            if operateSymbol == CalculatorButton.add.name {
                seriesFormula[loc] = self.add(val1: val1, val2: val2)
            } else {
                seriesFormula[loc] = self.subtract(val1: val1, val2: val2)
            }
            
            seriesFormula.remove(at: loc+1)
            seriesFormula.remove(at: loc-1)
        }
        result = seriesFormula[0]
        _lastIsOperator = nil
        _isCalculated = true
    }
}
