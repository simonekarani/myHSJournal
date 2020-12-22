//
//  HSRecType.swift
//  myHSJournal
//
//  Created by Simone Karani on 12/20/20.
//  Copyright © 2020 simonekarani. All rights reserved.
//

import Foundation

public enum HSRecType: String {
    case ACADEMIC = "Academic"
    case RESEARCH = "Research"
    case INTERNSHIP = "Internship"
    case PASSION = "Passion Project"
    case EXTRACURRICULAR = "Extracurricular"
    
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
}
