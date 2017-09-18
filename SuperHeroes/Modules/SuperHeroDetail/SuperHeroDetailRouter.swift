//
//  SuperHeroDetailRouter.swift
//  SuperHeroes
//
//  Created by Rafael Gil Pastor on 22/8/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit

public typealias SuperHeroDetailExitResult = Any

public struct SuperHeroDetailRouterInfo {
    var hero: SuperHeroEntity
}

public protocol SuperHeroDetailRouterProtocol: class, RouterProtocol {
    
    func back()
}

public protocol SuperHeroDetailOutputProtocol: RouterOutputProtocol {
    
    func exit(result: SuperHeroDetailExitResult?)
}

public class SuperHeroDetailRouter: SuperHeroDetailRouterProtocol {
    
    fileprivate weak var outputHandler: SuperHeroDetailOutputProtocol?
    fileprivate var networkingManager: NetworkingManagerProtocol? = {
        
        var manager: NetworkingManagerProtocol? = nil
        if let urlBase = URL(string:SuperHeroDetailRouterConstants.baseURL) {
            manager = URLSessionManager.sharedInstance(forBaseURL: urlBase)
        }
        return manager
    }()
    
    public var mainView: UIViewController?
    
    public func create(withInfo info: Any?, output: RouterOutputProtocol?) -> UIViewController? {
        
        mainView = SuperHeroDetailRouter.createInstanceFromStoryboard()
        guard let info = info as? SuperHeroDetailRouterInfo, let ui = mainView as? SuperHeroDetailUIProtocol else {
            return nil
        }
        
        createDependencies(forUI: ui, output: output as? SuperHeroDetailOutputProtocol, hero: info.hero)
        
        return mainView
    }
    
    public func back() {
        
        mainView?.navigationController?.popViewController(animated: true)
        outputHandler?.exit(result: nil)
    }
}

fileprivate extension SuperHeroDetailRouter {
    
    class func createInstanceFromStoryboard() -> UIViewController? {
        
        guard let view = SuperHeroDetailRouter.createViewInstance(withViewId: SuperHeroDetailRouterConstants.superHeroesDetailViewId, fromStoryboard: SuperHeroDetailRouterConstants.superHeroesDetailSoryboardId) else {
            return nil
        }
        return view
    }
    
    func createDependencies(forUI ui: SuperHeroDetailUIProtocol, output: SuperHeroDetailOutputProtocol?, hero: SuperHeroEntity) {
        
        let presenter = SuperHeroDetailPresenter(withUI: ui, router: self)
        let interactor = SuperHeroDetailInteractor()
        let repository = SuperHeroDetailRepository()
        var imagesManager = SuperHeroesImagesManager.sharedInstance
        let imageCacheManager = DataMemoryCacheManager.sharedInstance
        let datasource = SuperHeroDetailDataSource(withHero: hero)
        
        imagesManager.imageCacheManager = imageCacheManager
        imagesManager.networkingManager = networkingManager
        repository.dataSource = datasource
        repository.imagesManager = imagesManager
        repository.networkingManager = networkingManager
        interactor.repository = repository
        presenter.interactor = interactor
        ui.presenter = presenter
        
        outputHandler = output
    }
}

fileprivate struct SuperHeroDetailRouterConstants {
    
    static let superHeroesDetailViewId = "SuperHeroDetailViewController"
    static let superHeroesDetailSoryboardId = "Main"
    static let baseURL: String = "https://api.myjson.com/"
}

