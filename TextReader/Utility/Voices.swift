//
//  Voices.swift
//  TextReader
//
//  Created by Chris Karani on 09/09/2018.
//  Copyright © 2018 Chris Karani. All rights reserved.
//


enum Voices {
    case dutch
    case english
    case chinese
    case czech
    case japanese
}


extension Voices {
    var name: String {
        switch self {
        case .dutch: return "Xander"
        case .english: return "Daniel"
        case .chinese: return "Ting-Ting"
        case .czech: return "Zuzana"
        case .japanese: return "Sin-Ji"
        }
    }
    
    var language : String {
        switch self {
        case .dutch: return "nl-NL"
        case .english: return "en-GB"
        case .chinese: return "zh-CN"
        case .czech: return "cs-CZ"
        case .japanese: return "zh-HK"
        }
    }
}
