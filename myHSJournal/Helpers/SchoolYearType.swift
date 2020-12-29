//
//  SchoolYearType.swift
//  myHSJournal
//
//  Created by Simone Karani on 12/23/20.
//  Copyright © 2020 simonekarani. All rights reserved.
//

import Foundation

public enum SchoolYearType: String {
    case SIXTH = "6th"
    case SEVENTH = "7th"
    case EIGHTH = "8th"
    case NINETH = "9th"
    case TENTH = "10th"
    case ELEVENTH = "11th"
    case TWELVETH = "12th"
    
    var description: String {
        switch self {
        case .SIXTH: return "6th"
        case .SEVENTH: return "7th"
        case .EIGHTH: return "8th"
        case .NINETH: return "9th"
        case .TENTH: return "10th"
        case .ELEVENTH: return "11th"
        case .TWELVETH: return "12th"
        }
    }
    
    init?(id : Int) {
        switch id {
        case 1:
            self = .SIXTH
        case 2:
            self = .SEVENTH
        case 3:
            self = .EIGHTH
        case 4:
            self = .NINETH
        case 5:
            self = .TENTH
        case 6:
            self = .ELEVENTH
        case 7:
            self = .TWELVETH
        default:
            return nil
        }
    }
}

