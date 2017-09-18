//
//  SuperHeroDetailInteractor.swift
//  SuperHeroes
//
//  Created by Rafael Gil Pastor on 22/8/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation

public protocol SuperHeroDetailInteractorProtocol {
    
    var repository: SuperHeroDetailRepositoryProtocol? { get set }
    var superHero: SuperHeroEntity? { get set }
    
    func getImageHero(uriImage: String?, onSuccess: OnImageDataSuperHeroResponseType?, onFailure: OnFailureResponseType?)
}

public class SuperHeroDetailInteractor: SuperHeroDetailInteractorProtocol {
    
    public var repository: SuperHeroDetailRepositoryProtocol?
    public var superHero: SuperHeroEntity? {
        get {
            return repository?.superHero
        }
        set {
            repository?.superHero = newValue
        }
    }

    public func getImageHero(uriImage: String?, onSuccess: OnImageDataSuperHeroResponseType?, onFailure: OnFailureResponseType?) {
        
        guard let uri = uriImage  else {
            onSuccess?(nil)
            return
        }
        repository?.getImageHero(uriImage: uri, onSuccess: onSuccess, onFailure: onFailure)
    }
}
