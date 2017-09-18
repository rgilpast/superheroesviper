//
//  SuperHeroDetailCellProtocol.swift
//  SuperHeroes
//
//  Created by Rafael Gil Pastor on 9/9/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit

public protocol SuperHeroDetailCellProtocol {
    func bindProperties(WithProperties properties: SuperHeroProperties, forType propertiesType: SuperHeroDetailPropertiesEnum)
}
