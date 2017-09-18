//
//  SuperHeroesListInteractor.swift
//  SuperHeroes
//
//  Created by Rafael Gil Pastor on 22/8/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation

public protocol SuperHeroesListInteractorProtocol {
    
    var repository: SuperHeroesListRepositoryProtocol? { get set }
    
    func getHeroes(onSuccess: OnSuperHeroesListResponseType?, onFailure: OnFailureResponseType? )
    func getImageHero(uriImage: String?, onSuccess: OnImageDataSuperHeroResponseType?, onFailure: OnFailureResponseType?)
    func getHero(forName name: String) -> SuperHeroEntity?
}

public class SuperHeroesListInteractor: SuperHeroesListInteractorProtocol {
    
    public var repository: SuperHeroesListRepositoryProtocol?
    
    //get data heroes from repository
    public func getHeroes(onSuccess: OnSuperHeroesListResponseType?, onFailure: OnFailureResponseType? ) {
        
        repository?.getHeroes(onSuccess: { [weak self] (heroes) -> (Void) in
            self?.repository?.dataSource?.heroes = heroes
            onSuccess?(heroes)
        }, onFailure: onFailure)
    }
    
    //get the image´s  hero from a its url
    public func getImageHero(uriImage: String?, onSuccess: OnImageDataSuperHeroResponseType?, onFailure: OnFailureResponseType?) {
        
        guard let uri = uriImage  else {
            onSuccess?(nil)
            return
        }
        repository?.getImageHero(uriImage: uri, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    //get hero data through name property
    public func getHero(forName name: String) -> SuperHeroEntity? {
        var hero: SuperHeroEntity?
        
        if let heroes = repository?.dataSource?.heroes {
            let heroesCandidates = heroes.filter({ (hero) -> Bool in
                return hero.name == name
            })
            hero = heroesCandidates.first
        }
        return hero
    }
}
