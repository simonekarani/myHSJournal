//
//  EsteemFeelingType.swift
//  myHSJournal
//
//  Created by Simone Karani on 2/15/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import Foundation

public enum EsteemFeelingType: String, CaseIterable {
    
    case ANGRY = "Angry"
    case ANNOYED = "Annoyed"
    case BORED = "Bored"
    case EMBARRASSED = "Embarrassed"
    case JEALOUS = "Jealous"
    case HAPPY = "Happy"
    case SAD = "Sad"
    case SICK = "Sick"
    case STRESSED = "Stressed"
    case SURPRISED = "Surprised"
    case WORRIED = "Worried"

    static var asArray: [EsteemFeelingType] {return self.allCases}
    
    static var esteemFeelingTypeDict: [String: Int] = [
        "Angry": 0,
        "Annoyed": 1,
        "Bored": 2,
        "Embarrassed": 3,
        "Jealous": 4,
        "Happy": 5,
        "Sad": 6,
        "Sick": 7,
        "Stressed": 8,
        "Surprised": 9,
        "Worried": 10
    ];
    
    static func toInt(value:String) -> Int {
        return esteemFeelingTypeDict[value]!
    }
    
    var description: String {
        switch self {
        case .ANGRY: return "Angry"
        case .ANNOYED: return "Annoyed"
        case .BORED: return "Bored"
        case .EMBARRASSED: return "Embarrassed"
        case .JEALOUS: return "Jealous"
        case .HAPPY: return "Happy"
        case .SAD: return "Sad"
        case .SICK: return "Sick"
        case .STRESSED: return "Stressed"
        case .SURPRISED: return "Surprised"
        case .WORRIED: return "Worried"
        }
    }
    
    init?(id : Int) {
        switch id {
        case 1:
            self = .ANGRY
        case 2:
            self = .ANNOYED
        case 3:
            self = .BORED
        case 4:
            self = .EMBARRASSED
        case 5:
            self = .JEALOUS
        case 6:
            self = .HAPPY
        case 7:
            self = .SAD
        case 8:
            self = .SICK
        case 9:
            self = .STRESSED
        case 10:
            self = .SURPRISED
        case 11:
            self = .WORRIED
        default:
            return nil
        }
    }
    
    func asInt() -> Int {
        return EsteemFeelingType.asArray.firstIndex(of: self)!
    }
}
