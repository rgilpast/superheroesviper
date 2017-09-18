//
//  SuperHeroDetailViewEntity.swift
//  SuperHeroes
//
//  Created by Rafael Gil Pastor on 22/8/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation

public typealias SuperHeroProperties = [SuperHeroPropertyEnum : String]
public typealias SuperHeroDetailProperties = [SuperHeroDetailPropertiesEnum : SuperHeroProperties]

public enum SuperHeroDetailPropertiesEnum: String
{
    case HumanProperties
    case PowerProperties
    case AbilitiesProperties
    case GroupsProperties
    
    func cellIdentifier() -> String {
        if self == .HumanProperties {
            return SuperHeroHumanPropertiesCell.identifier
        }
        else {
            return SuperHeroAdditionalPropertyCell.identifier
        }
    }
    func description() -> String {
        switch self
        {
        case .PowerProperties:
            return NSLocalizedString("SH_POWER_PROPERTIES_DESCRIPTION", comment: "")
        case .AbilitiesProperties:
            return NSLocalizedString("SH_ABILITIES_PROPERTIES_DESCRIPTION", comment: "")
        case .GroupsProperties:
            return NSLocalizedString("SH_GROUPS_PROPERTIES_DESCRIPTION", comment: "")
        default:
            return ""
        }
    }
}

public enum SuperHeroPropertyEnum: String
{
    case RealName
    case Height
    case Power
    case Abilities
    case Groups
}

public struct SuperHeroDetailViewEntity
{
    let name: String!
    let urlPhoto: String?
    let properties: Array<SuperHeroDetailProperties>?
    
    init?(withHero hero: SuperHeroEntity)
    {
        self.name = hero.name
        self.urlPhoto = hero.urlPhoto
        
        var allProperties: Array<SuperHeroDetailProperties> = []
        var humanProperties: SuperHeroProperties = [:]
        
        if let realName = hero.realName {
            humanProperties[SuperHeroPropertyEnum.RealName] = realName
        }
        if let height = hero.height {
            humanProperties[SuperHeroPropertyEnum.Height] = height
        }
        if humanProperties.count > 0 {
            allProperties.append([SuperHeroDetailPropertiesEnum.HumanProperties : humanProperties])
        }
        if let power = hero.power {
            allProperties.append([SuperHeroDetailPropertiesEnum.PowerProperties : [SuperHeroPropertyEnum.Power : power]])
        }
        if let abilities = hero.abilities {
            allProperties.append([SuperHeroDetailPropertiesEnum.AbilitiesProperties : [SuperHeroPropertyEnum.Abilities : abilities]])
        }
        if let groups = hero.groups {
            allProperties.append([SuperHeroDetailPropertiesEnum.GroupsProperties : [SuperHeroPropertyEnum.Groups : groups]])
        }
        if allProperties.count > 0 {
            self.properties = allProperties
        }
        else {
            self.properties = nil
        }
    }
}
