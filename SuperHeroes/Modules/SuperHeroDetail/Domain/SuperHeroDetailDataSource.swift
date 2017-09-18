//
//  SuperHeroDetailDataSource.swift
//  SuperHeroes
//
//  Created by Rafael Gil Pastor on 22/8/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation

public protocol SuperHeroDetailDataSourceProtocol {
    
    var superHero: SuperHeroEntity? { get set }
}

public class SuperHeroDetailDataSource: SuperHeroDetailDataSourceProtocol {
    
    public var superHero: SuperHeroEntity?
    
    public init(withHero hero: SuperHeroEntity) {
        self.superHero = hero
    }    
}
