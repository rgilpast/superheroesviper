//
//  RouterProtocol.swift
//  SuperHeroes
//
//  Created by Rafael Gil Pastor on 22/8/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit

public protocol RouterOutputProtocol: class {

}

public protocol RouterProtocol {
    
    var mainView: UIViewController? { get set }

    func create(withInfo info: Any?, output: RouterOutputProtocol?) -> UIViewController?
}

public extension RouterProtocol {
    
    static func createViewInstance(withViewId: String, fromStoryboard storyBoardName: String) -> UIViewController? {
        
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: withViewId)
        return view
    }
}
