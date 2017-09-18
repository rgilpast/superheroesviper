//
//  ViewLoadingIndicatorProtocol.swift
//  SuperHeroes
//
//  Created by Rafael Gil Pastor on 22/8/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit

public protocol ViewLoadingIndicatorProtocol: LoadingIndicatorProtocol {
    
    var view: UIView! { get }
}

//MARK : Loading Indicator
public extension ViewLoadingIndicatorProtocol
{
    func showLoadingIndicator() {
        view.showLoadingIndicator()
    }
    
    func hideLoadingIndicator() {
        view.hideLoadingIndicator()
    }
}
