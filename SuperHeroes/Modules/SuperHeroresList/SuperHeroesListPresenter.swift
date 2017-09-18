//
//  SuperHeroesListPresenter.swift
//  SuperHeroes
//
//  Created by Rafael Gil Pastor on 22/8/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit

public protocol SuperHeroesListPresenterProtocol: class
{
    var interactor: SuperHeroesListInteractorProtocol? { get set }
    weak var router: SuperHeroesListRouterProtocol? { get set }
    
    func viewDidLoad()
    func askForHeroes()
    func askForHeroImage(hero: SuperHeroViewEntity?, onCompletion:OnCompletionImageDownloadType?)
    func didSelectHero(hero: SuperHeroViewEntity)
}

public class SuperHeroesListPresenter: SuperHeroesListPresenterProtocol {
    
    fileprivate weak var ui: SuperHeroesListUIProtocol?
    public weak var router: SuperHeroesListRouterProtocol?
    
    public var interactor: SuperHeroesListInteractorProtocol?
    
    public init(withUI: SuperHeroesListUIProtocol?, router: SuperHeroesListRouterProtocol?)
    {
        ui = withUI
        self.router = router
    }

    public func viewDidLoad() {
        
        //by default ask for all heroes
        askForHeroes()
    }

    //ask for heroes
    public func askForHeroes() {
        
        ui?.showLoadingIndicator()
        
        interactor?.getHeroes(onSuccess: {[weak self] (heroes) -> (Void) in

            DispatchQueue.main.async {
                
                self?.ui?.hideLoadingIndicator()
                
                //map received heroes in a specific view model entities array and pass them to the ui for displaying
                let viewHeroes = heroes.map({ (heroEntity) -> SuperHeroViewEntity in
                    return SuperHeroViewEntity(name: heroEntity.name, urlPhoto: heroEntity.urlPhoto)
                })
                self?.ui?.show(heroes: viewHeroes)
            }
            
        }) { [weak self] (error) -> (Void) in

            DispatchQueue.main.async {
                
                self?.ui?.showMessageError(error: error, completion: {
                    self?.ui?.hideLoadingIndicator()
                })
            }
        }
    }

    //ask for the related image of a hero from its url
    public func askForHeroImage(hero: SuperHeroViewEntity?, onCompletion:OnCompletionImageDownloadType?)
    {
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

    public func didSelectHero(hero: SuperHeroViewEntity) {
        
        if let view = ui as? UIViewController, let hero = interactor?.getHero(forName: hero.name) {
            router?.showDetail(forHero: hero, fromView: view, output: nil)
        }
    }
}
