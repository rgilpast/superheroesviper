//
//  SuperHeroesListRouter.swift
//  SuperHeroes
//
//  Created by Rafael Gil Pastor on 22/8/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit

public protocol SuperHeroesListRouterProtocol: class, RouterProtocol {
    
    func showDetail(forHero hero: SuperHeroEntity, fromView: UIViewController, output: RouterOutputProtocol?)
}

public class SuperHeroesListRouter: SuperHeroesListRouterProtocol {


    public var mainView: UIViewController?
    public var detailRouter: RouterProtocol?
    
    fileprivate var networkingManager: NetworkingManagerProtocol? = {
        
        var manager: NetworkingManagerProtocol? = nil
        if let urlBase = URL(string:SuperHeroesListRouterConstants.baseURL) {
            manager = URLSessionManager.sharedInstance(forBaseURL: urlBase)
        }
        return manager
    }()
    
    public func create(withInfo info: Any?, output: RouterOutputProtocol?) -> UIViewController? {
        
        mainView = SuperHeroesListRouter.createInstanceFromStoryboard()
        guard let ui = mainView as? SuperHeroesListUIProtocol else {
            return nil
        }
        
        createDependencies(forUI: ui)
        
        let navigationView = UINavigationController(rootViewController: mainView!)
        return navigationView
    }
    
    public func showDetail(forHero hero: SuperHeroEntity, fromView: UIViewController, output: RouterOutputProtocol?) {
        
        if let heroDetailView = detailRouter?.create(withInfo: SuperHeroDetailRouterInfo(hero: hero), output: output) {
            fromView.navigationController?.pushViewController(heroDetailView, animated: true)
        }
    }
}

fileprivate extension SuperHeroesListRouter {
    
    class func createInstanceFromStoryboard() -> UIViewController? {
        
        guard let view = createViewInstance(withViewId: SuperHeroesListRouterConstants.superHeroesListViewId, fromStoryboard: SuperHeroesListRouterConstants.superHeroesListSoryboardId) else {
            return nil
        }
        return view
    }
    
    func createDependencies(forUI ui: SuperHeroesListUIProtocol) {
        
        detailRouter = SuperHeroDetailRouter()
        
        let presenter = SuperHeroesListPresenter(withUI: ui, router: self)
        let interactor = SuperHeroesListInteractor()
        let repository = SuperHeroesListRepository()
        var imagesManager = SuperHeroesImagesManager.sharedInstance
        let imageCacheManager = DataMemoryCacheManager.sharedInstance
        let dataSource = SuperHeroesListDataSource()
        
        imagesManager.imageCacheManager = imageCacheManager
        imagesManager.networkingManager = networkingManager
        repository.dataSource = dataSource
        repository.imagesManager = imagesManager
        repository.networkingManager = networkingManager
        interactor.repository = repository
        presenter.interactor = interactor
        ui.presenter = presenter
    }
}

fileprivate struct SuperHeroesListRouterConstants {
    
    static let superHeroesListViewId = "SuperHeroesListViewController"
    static let superHeroesListSoryboardId = "Main"
    static let baseURL: String = "https://api.myjson.com/"
}
