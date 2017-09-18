//
//  SuperHeroEntity.swift
//  SuperHeroes
//
//  Created by Rafael Gil Pastor on 22/8/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation


public struct SuperHeroEntity
{
    //private fields´ keys
    private let kNameFieldKey = "name"
    private let kURLPhotoFieldKey = "photo"
    private let kRealNameFieldKey = "realName"
    private let kHeightFieldKey = "height"
    private let kPowerFieldKey = "power"
    private let kAbilitesFieldKey = "abilities"
    private let kGroupsFieldKey = "groups"
    
    //public properties
    public var name: String!
    public var urlPhoto: String?
    public var realName: String?
    public var height: String?
    public var power: String?
    public var abilities: String?
    public var groups: String?
    
    public init?(json: JSON)
    {
        //check the existence of required data
        guard   let name = json[kNameFieldKey] as? String else {
            return nil
        }
        self.name = name
        
        //optional data
        self.urlPhoto = json[kURLPhotoFieldKey] as? String
        self.realName = json[kRealNameFieldKey] as? String
        self.height = json[kHeightFieldKey] as? String
        self.power = json[kPowerFieldKey] as? String
        self.abilities = json[kAbilitesFieldKey] as? String
        self.groups = json[kGroupsFieldKey] as? String
    }
}
