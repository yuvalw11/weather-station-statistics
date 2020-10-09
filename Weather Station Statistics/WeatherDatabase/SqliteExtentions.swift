//
//  SqliteExtentions.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 28/03/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation
import SQLite

func caseStatement<T>(predicate: Expression<Bool>, choose: Expression<T>, elseChoose: Expression<T>) -> Expression<T> {
    return Expression<T>(literal: "CASE WHEN \(predicate.asSQL()) THEN \(choose.asSQL()) ELSE \(elseChoose.asSQL()) END")
}

extension Expression {
    func alias(_ newName: String) -> Expression {
        var newExp = Expression<Datatype>(template, self.bindings)
        newExp.template = "\(template) AS \"\(newName)\""
        return newExp
    }
}

extension Expression where UnderlyingType == Date {
    
    public func strftime(format: String) -> Expression<Date> {
        return Expression<Date>("strftime('\(format)', \(template))", bindings)
    }
    
    public var day: Expression<Int64> {
        let day = Expression<Date>("strftime('%d', \(template))", bindings)
        return cast(day) as Expression<Int64>
    }
    
    public var month: Expression<Int64> {
        let month = Expression<Date>("strftime('%m', \(template))", bindings)
        return cast(month) as Expression<Int64>
    }
    
    public var year: Expression<Int64> {
        let year = Expression<Date>("strftime('%Y', \(template))", bindings)
        return cast(year) as Expression<Int64>
    }
    
    public var fullDay: Expression<Date> {
        return self.datetime(modifiers: "start of day")
    }
    
    public var fullMonth: Expression<Date> {
        return self.datetime(modifiers: "start of month")
    }
    
    public var fullYear: Expression<Date> {
        return self.datetime(modifiers: "start of year")
    }
        
    public func rangeByMonth(month: Int64) -> Expression<Date> {
        let monthExp = self.month
        let predicate = (monthExp < month)
        
        let prevYearExp = self.datetime(modifiers: "start of year", "+\(month - 1) months", "-1 years")
        let thisYearExp = self.datetime(modifiers: "start of year", "+\(month - 1) months")
                
        return caseStatement(predicate: predicate, choose: prevYearExp, elseChoose: thisYearExp)
    }
    
    public func datetime(modifiers: String...) -> Expression<Date> {
        var modifiersString = ""
        for i in 0..<modifiers.count {
            modifiersString.append(", '\(modifiers[i])'")
        }
        return Expression<Date>("strftime('%Y-%m-%dT%H:%M:%f', \(template) \(modifiersString))", bindings)
    }

}

extension Cursor {

    public func date(_ idx: String) -> Date {
        let dateFormatterRecord = DateFormatter()
        dateFormatterRecord.dateFormat = "yyyy-MM-dd'T'HH:mm.sss"
        dateFormatterRecord.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatterRecord.date(from: self[idx]! as! String)!
    }
    
}

extension Expressible {

    
    public func asSQLNoBinding() -> String {
        let expressed = expression
        return expressed.template.reduce("") { template, character in
            let transcoded: String
            
            transcoded = String(character)
            return template + transcoded
        }
    }

}

public func castToOptional<T: Value, U: Value>(_ expression: Expression<T>) -> Expression<U?> {
    return Expression("CAST (\(expression.template) AS \(U.declaredDatatype))", expression.bindings)
}
