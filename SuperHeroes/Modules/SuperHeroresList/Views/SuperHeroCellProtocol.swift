//
//  SuperHeroCellProtocol.swift
//  SuperHeroes
//
//  Created by Rafael Gil Pastor on 1/10/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit

public protocol SuperHeroCellProtocol {

    func bindHero(hero: SuperHeroViewEntity?, presenter: SuperHeroesListPresenterProtocol?)
    static func preferredHeight() -> CGFloat
}

