//
//  EsteemType.swift
//  myHSJournal
//
//  Created by Simone Karani on 2/15/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import Foundation

public enum EsteemType: String, CaseIterable {
    
    case FEELING = "Feeling"
    case LETTER = "Letter"
    case ANGRY = "Angry"
    
    static var asArray: [EsteemType] {return self.allCases}
    
    static var esteemTypeDict: [String: Int] = [
        "Feeling": 0,
        "Letter": 1,
        "Angry": 2
    ];
    
    static func toInt(value:String) -> Int {
        return esteemTypeDict[value]!
    }
    
    var description: String {
        switch self {
        case .FEELING: return "Feeling"
        case .LETTER: return "Letter"
        case .ANGRY: return "Angry"
        }
    }
    
    init?(id : Int) {
        switch id {
        case 1:
            self = .FEELING
        case 2:
            self = .LETTER
        case 3:
            self = .ANGRY
        default:
            return nil
        }
    }
    
    func asInt() -> Int {
        return EsteemType.asArray.firstIndex(of: self)!
    }
}
