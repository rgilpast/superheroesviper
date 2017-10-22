//
//  TableLoadingIndicatorProtocol.swift
//  SuperHeroes
//
//  Created by Rafael Gil Pastor on 22/8/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit

public protocol ListLoadingIndicatorProtocol:LoadingIndicatorProtocol {
    
    var listView: UIScrollView? { get }
    var loadingIndicator: UIRefreshControl { get }

    func reloadListData()
}

//MARK : Loading Indicator
public extension ListLoadingIndicatorProtocol
{
    func showLoadingIndicator() {
        //show loading indicator only if it isn´t displaying
        if !loadingIndicator.isRefreshing {
            loadingIndicator.beginRefreshing()
        }
    }
    func hideLoadingIndicator() {
        //hide loading indicator only if it is still displaying
        if loadingIndicator.isRefreshing {
            self.reloadListData()
            loadingIndicator.endRefreshing()
        }
    }
}
