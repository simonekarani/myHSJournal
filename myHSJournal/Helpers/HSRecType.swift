//
//  HSRecType.swift
//  myHSJournal
//
//  Created by Simone Karani on 12/20/20.
//  Copyright © 2020 simonekarani. All rights reserved.
//

import Foundation

public enum HSRecType: String, CaseIterable {
    case ACADEMIC = "Academic"
    case RESEARCH = "Research"
    case INTERNSHIP = "Internship"
    case PASSION = "Passion Project"
    case EXTRACURRICULAR = "Extracurricular"
    
    static var asArray: [HSRecType] {return self.allCases}

    static var hsRecTypeDict: [String: Int] = [
        "Academic": 0,
        "Research": 1,
        "Internship": 2,
        "Passion Project": 3,
        "Extracurricular": 4];
    
    static func toInt(value:String) -> Int {
        return hsRecTypeDict[value]!
    }

    var description: String {
        switch self {
        case .ACADEMIC: return "Academic"
        case .RESEARCH: return "Research"
        case .INTERNSHIP: return "Internship"
        case .PASSION: return "Passion Project"
        case .EXTRACURRICULAR: return "Extracurricular"
        }
    }
    
    init?(id : Int) {
        switch id {
        case 1:
            self = .ACADEMIC
        case 2:
            self = .RESEARCH
        case 3:
            self = .INTERNSHIP
        case 4:
            self = .PASSION
        case 5:
            self = .EXTRACURRICULAR
        default:
            return nil
        }
    }

    func asInt() -> Int {
        return HSRecType.asArray.firstIndex(of: self)!
    }
}
