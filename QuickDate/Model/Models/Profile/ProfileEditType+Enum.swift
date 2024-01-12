//
//  ProfileEditType+Enum.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 24.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation

struct PropertiesModel {
    var id: String
    var value: String
}

enum ProfileEditType: String {
    case language
    case relationship
    case children
    case workStatus = "Work Status"
    case education
    case ethnicity
    case body
    case liveWith
    case car
    case height
    case character
    case friends
    case pets
    case religion
    case smoke
    case drink
    case travel
    case fromHeight = "From Height"
    case toHeight = "To Height"
    case interest
    case hairColor
    
    var propertiesArray: [PropertiesModel] {
        let adminSettings = AppInstance.shared.adminSettings
        
        switch self {
        case .language:     return getValues(from: adminSettings?.language)
        case .relationship: return getValues(from: adminSettings?.relationship)
        case .children:     return getValues(from: adminSettings?.children)
        case .workStatus:   return getValues(from: adminSettings?.workStatus)
        case .education:    return getValues(from: adminSettings?.education)
        case .ethnicity:    return getValues(from: adminSettings?.ethnicity)
        case .body:         return getValues(from: adminSettings?.body)
        case .liveWith:     return getValues(from: adminSettings?.liveWith)
        case .car:          return getValues(from: adminSettings?.car)
        case .height,
                .fromHeight,
                .toHeight:       return getValues(from: adminSettings?.height)//adminSettings?.height.keys.map { $0 }.sorted { $0<$1 } ?? []
        case .character:    return getValues(from: adminSettings?.character)
        case .friends:      return getValues(from: adminSettings?.friends)
        case .pets:         return getValues(from: adminSettings?.pets)
        case .religion:     return getValues(from: adminSettings?.religion)
        case .smoke:        return getValues(from: adminSettings?.smoke)
        case .drink:        return getValues(from: adminSettings?.drink)
        case .travel:       return getValues(from: adminSettings?.travel)
        case .hairColor:    return getValues(from: adminSettings?.hairColor)
        case .interest:     return []
        }
    }
    
    var heightArray: [String] {
        let appInstance: AppInstance = .shared
        if self == .height || self == .fromHeight || self == .toHeight {
            return appInstance.adminSettings?.height.values.map { $0 } ?? []
        }
        return []
    }
}

extension ProfileEditType {
    
    fileprivate func getValues(from dict: [String: String]?) -> [PropertiesModel] {
        var data: [PropertiesModel] = []
        dict?.forEach({ (key: String, value: String) in
            data.append(PropertiesModel(id: key, value: value))
        })
        return data
    }
}
