//
//  DataExtractionProtocol.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 11/03/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation

protocol DataExtractionProtocol {
    var weatherField: String {get}
    func extract(binary: Data) -> Double?
}

class InTempExtractor: DataExtractionProtocol {
    func extract(binary: Data) -> Double? {
        let rawNumber = UInt16(littleEndian: binary.subdata(in: 8..<10).withUnsafeBytes{$0.pointee})
        let value = Double(rawNumber) / 10.0
        if value >= -100.0 && value <= 200.0 {
            return value
        } else {
            return nil
        }
    }
    var weatherField: String = "InTemp"
}

class InHumidityExtractor: DataExtractionProtocol {
    
    func extract(binary: Data) -> Double? {
        let rawNumber = UInt16(littleEndian: binary.subdata(in: 10..<12).withUnsafeBytes{$0.pointee})
       let value = Double(rawNumber)
        if value >= 0.0 && value <= 100.0 {
            return value
        } else {
            return nil
        }
    }
    var weatherField: String = "InHum"
}

class OutTempExtractor: DataExtractionProtocol {
    
    func extract(binary: Data) -> Double? {
        let rawNumber = UInt16(littleEndian: binary.subdata(in: 16..<18).withUnsafeBytes{$0.pointee})
        let value = Double(rawNumber) / 10.0
        if value >= -100.0 && value <= 200.0 {
            return value
        } else {
            return nil
        }
    }
    var weatherField: String = "OutTemp"
}

class OutHumidityExtractor: DataExtractionProtocol {
    
    func extract(binary: Data) -> Double? {
        let rawNumber = UInt16(littleEndian: binary.subdata(in: 18..<20).withUnsafeBytes{$0.pointee})
        let value = Double(rawNumber)
        if value >= 0.0 && value <= 100.0 {
            return value
        } else {
            return nil
        }
    }
    var weatherField: String = "OutHum"
}

class AbsExtractor: DataExtractionProtocol {
    
    func extract(binary: Data) -> Double? {
        let rawNumber = UInt16(littleEndian: binary.subdata(in: 12..<14).withUnsafeBytes{$0.pointee})
        let value = Double(rawNumber) / 10.0
        if value >= 0.0 && value <= 3000.0 {
            return value
        } else {
            return nil
        }
    }
    var weatherField: String = "Abs"
}

class RelExtractor: DataExtractionProtocol {
    
    func extract(binary: Data) -> Double? {
        let rawNumber = UInt16(littleEndian: binary.subdata(in: 14..<16).withUnsafeBytes{$0.pointee})
        let value = Double(rawNumber) / 10.0
        if value >= 0.0 && value <= 3000.0 {
            return value
        } else {
            return nil
        }
    }
    var weatherField: String = "Rel"
}

class DewExtractor: DataExtractionProtocol {
    
    func extract(binary: Data) -> Double? {
        let rawNumber = UInt16(littleEndian: binary.subdata(in: 20..<22).withUnsafeBytes{$0.pointee})
        let value = Double(rawNumber) / 10.0
        if value >= -100.0 && value <= 200.0 {
            return value
        } else {
            return nil
        }
    }
    var weatherField: String = "DewPoint"
}

class ChillExtractor: DataExtractionProtocol {
    
    func extract(binary: Data) -> Double? {
        let rawNumber = UInt16(littleEndian: binary.subdata(in: 22..<24).withUnsafeBytes{$0.pointee})
        let value = Double(rawNumber) / 10.0
        if value >= -100.0 && value <= 200.0 {
            return value
        } else {
            return nil
        }
    }
    var weatherField: String = "WindChill"
}

class HeatIndexExtractor: DataExtractionProtocol {
    
    func extract(binary: Data) -> Double? {
        let rawNumber = UInt16(littleEndian: binary.subdata(in: 24..<26).withUnsafeBytes{$0.pointee})
        let value = Double(rawNumber) / 10.0
        if value >= -100.0 && value <= 200.0 {
            return value
        } else {
            return nil
        }
    }
    var weatherField: String = "HeatIndex"
}

class WindExtractor: DataExtractionProtocol {
    
    func extract(binary: Data) -> Double? {
        let rawNumber = UInt16(littleEndian: binary.subdata(in: 26..<28).withUnsafeBytes{$0.pointee})
        let value = (round(Double(rawNumber) * 3.6) / 10)
        if value >= 0.0 && value <= 100000.0 {
            return value
        } else {
            return nil
        }
    }
    var weatherField: String = "WindSpeed"
}

class GustExtractor: DataExtractionProtocol {
    
    func extract(binary: Data) -> Double? {
        let rawNumber = UInt16(littleEndian: binary.subdata(in: 28..<30).withUnsafeBytes{$0.pointee})
        let value = (round(Double(rawNumber) * 3.6) / 10)
        if value >= 0.0 && value <= 100000.0 {
            return value
        } else {
            return nil
        }
    }
    var weatherField: String = "GustSpeed"
}

class WindDirectionExtractor: DataExtractionProtocol {
    
    func extract(binary: Data) -> Double? {
        let rawNumber = UInt16(littleEndian: binary.subdata(in: 30..<32).withUnsafeBytes{$0.pointee})
        let value = Double(rawNumber)
        if value >= 0.0 && value <= 360.0 {
            return value
        } else {
            return nil
        }
    }
    var weatherField: String = "WindDirection"
}

class RainRateExtractor: DataExtractionProtocol {
    
    func extract(binary: Data) -> Double? {
        let rawNumber = UInt32(littleEndian: binary.subdata(in: 32..<36).withUnsafeBytes{$0.pointee})
        let value = Double(rawNumber) / 10.0
        if value >= 0.0 && value <= 9999999.0 {
            return value
        } else {
            return nil
        }
    }
    var weatherField: String = "RainRate"
}

class DailyRainExtractor: DataExtractionProtocol {
    
    func extract(binary: Data) -> Double? {
        let rawNumber = UInt32(littleEndian: binary.subdata(in: 36..<40).withUnsafeBytes{$0.pointee})
        let value = Double(rawNumber) / 10.0
        if value >= 0.0 && value <= 9999999.0 {
            return value
        } else {
            return nil
        }
    }
    var weatherField: String = "DailyRain"
}

class WeeklyRainExtractor: DataExtractionProtocol {
    
    func extract(binary: Data) -> Double? {
        let rawNumber = UInt32(littleEndian: binary.subdata(in: 40..<44).withUnsafeBytes{$0.pointee})
        let value = Double(rawNumber) / 10.0
        if value >= 0.0 && value <= 9999999.0 {
            return value
        } else {
            return nil
        }
    }
    var weatherField: String = "WeeklyRain"
}

class MonthlyRainExtractor: DataExtractionProtocol {
    
    func extract(binary: Data) -> Double? {
        let rawNumber = UInt32(littleEndian: binary.subdata(in: 44..<48).withUnsafeBytes{$0.pointee})
        let value = Double(rawNumber) / 10.0
        if value >= 0.0 && value <= 9999999.0 {
            return value
        } else {
            return nil
        }
    }
    var weatherField: String = "MonthlyRain"
}

class YearlyRainExtractor: DataExtractionProtocol {
    
    func extract(binary: Data) -> Double? {
        let rawNumber = UInt32(littleEndian: binary.subdata(in: 48..<52).withUnsafeBytes{$0.pointee})
        let value = Double(rawNumber) / 10.0
        if value >= 0.0 && value <= 9999999.0 {
            return value
        } else {
            return nil
        }
    }
    var weatherField: String = "YearlyRain"
}

class UviRExtractor: DataExtractionProtocol {
    
    func extract(binary: Data) -> Double? {
        let rawNumber = UInt32(littleEndian: binary.subdata(in: 52..<54).withUnsafeBytes{$0.pointee})
        let value = round(Double(rawNumber) / 420.0)
        if value >= 0.0 && value <= 1000.0 {
            return value
        } else {
            return nil
        }
    }
    var weatherField: String = "UVI"
}

class RadiationRExtractor: DataExtractionProtocol {
    
    func extract(binary: Data) -> Double? {
        let rawNumber = UInt32(littleEndian: binary.subdata(in: 56..<60).withUnsafeBytes{$0.pointee})
        let value = round(Double(rawNumber) * 0.0079) / 10.0
        if value >= 0.0 && value <= 100000000000.0 {
            return value
        } else {
            return nil
        }
    }
    var weatherField: String = "Radiation"
}
