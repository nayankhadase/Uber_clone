//
//  RideType.swift
//  Uber_clone
//
//  Created by Nayan Khadase on 16/07/23.
//

import Foundation

enum RideType: Int, CaseIterable, Identifiable{
    case UberAuto
    case UberGo
    case UberXL
    
    var id: Int {return rawValue}
    
    var description: String{
        switch self {
        case .UberAuto:
            return "Uber Auto"
        case .UberGo:
            return "Uber Go"
        case .UberXL:
            return "Uber XL"
        }
    }
    
    var imageName: String{
        switch self {
        case .UberAuto:
            return "auto"
        case .UberGo:
            return "car1"
        case .UberXL:
            return "car2"
        }
    }
    
    var baseFarre: Double{
        switch self {
        case .UberAuto:
            return 20
        case .UberGo:
            return 30
        case .UberXL:
            return 45
        }
    }
    
    func getPrice(for distanceMeter: Double) -> Double{
        let km = distanceMeter * 0.001
        switch self {
        case .UberAuto:
            return km * 2 + baseFarre
        case .UberGo:
            return km * 3 + baseFarre
        case .UberXL:
            return km * 5.5 + baseFarre
        }
    }
    
    
}
