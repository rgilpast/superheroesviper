//
//  AlertMessageProtocol.swift
//  SuperHeroes
//
//  Created by Rafael Gil Pastor on 22/8/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit

public typealias AlertMessageCompletion = () -> ()

public protocol AlertMessageProtocol {
    
}

public extension AlertMessageProtocol {
    
    public func showAlertMessage(fromView: UIViewController, error: Error?, completion: AlertMessageCompletion?)
    {
        //Show Message Error
        let alert = UIAlertController(title: NSLocalizedString("SH_APP_TITLE", comment: ""), message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("SH_OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
        fromView.present(alert, animated: true, completion: completion)
    }

}
