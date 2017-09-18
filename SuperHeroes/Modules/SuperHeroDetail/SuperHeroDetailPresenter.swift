//
//  SuperHeroDetailPresenter.swift
//  SuperHeroes
//
//  Created by Rafael Gil Pastor on 22/8/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation

public protocol SuperHeroDetailPresenterProtocol {

    var interactor: SuperHeroDetailInteractorProtocol? { get set }
    
    init(withUI: SuperHeroDetailUIProtocol?, router: SuperHeroDetailRouterProtocol?)
    func viewDidLoad()
    func askForHeroImage(hero: SuperHeroDetailViewEntity?, onCompletion:OnCompletionImageDownloadType?)
    func back()
}

public class SuperHeroDetailPresenter: SuperHeroDetailPresenterProtocol {
    
    fileprivate weak var ui: SuperHeroDetailUIProtocol?
    fileprivate weak var router: SuperHeroDetailRouterProtocol?
    
    public var interactor: SuperHeroDetailInteractorProtocol?
    
    public required init(withUI: SuperHeroDetailUIProtocol?, router: SuperHeroDetailRouterProtocol?)
    {
        ui = withUI
        self.router = router
    }
    
    public func viewDidLoad() {
        
        askHeroDetail()
    }

    public func askForHeroImage(hero: SuperHeroDetailViewEntity?, onCompletion: OnCompletionImageDownloadType?) {
        
        interactor?.getImageHero(uriImage: hero?.urlPhoto, onSuccess: { (imageData) -> (Void) in
            DispatchQueue.main.async {
                onCompletion?(imageData)
            }
            
        }) { (error) -> (Void) in
            DispatchQueue.main.async {
                onCompletion?(nil)
            }
        }
    }
    
    public func back() {
        router?.back()
    }

}

fileprivate extension SuperHeroDetailPresenter {
    
    //ask for book detail whose id is passed in
    func askHeroDetail() {
        
        if let hero = interactor?.superHero, let heroDetail = SuperHeroDetailViewEntity(withHero: hero) {
            self.ui?.showHeroDetail(detail: heroDetail)
        }
    }
}

