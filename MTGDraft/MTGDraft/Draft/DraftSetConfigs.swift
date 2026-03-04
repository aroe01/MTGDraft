//
//  DraftSetConfigs.swift
//  MTGDraft
//
//  Created by Adrian Roe on 3/1/26.
//

import Foundation

struct Booster {
    enum CardTypes: CaseIterable {
        case land
        case common
        case uncommon
        case rare // or mythinc
        case foil
        
        var cardCount: Int {
            switch self {
            case .land:
                1
            case .common:
                10
            case .uncommon:
                3
            case .rare:
                1
            case .foil:
                1
            }
        }
    }
    
    
}

protocol DraftConfig {
    var setId: String { get }
    var landIds: Set<Int> { get }
}

struct LorwynEclipsedConfig: DraftConfig {
    var setId = "ecl"
    var landIds = Set(269...283)
}
