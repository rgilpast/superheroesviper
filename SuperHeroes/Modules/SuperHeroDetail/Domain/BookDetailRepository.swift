//
//  SuperHeroDetailRepository.swift
//  SuperHeroes
//
//  Created by Rafael Gil Pastor on 22/8/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation

public protocol SuperHeroDetailRepositoryProtocol {
    
    var imagesManager: SuperHeroesImagesManagerProtocol? { get set }
    var networkingManager: NetworkingManagerProtocol? { get set }
    var dataSource: SuperHeroDetailDataSourceProtocol? { get set }
    var superHero: SuperHeroEntity? { get set }
    
    func getImageHero(uriImage: String, onSuccess: OnImageDataSuperHeroResponseType?, onFailure: OnFailureResponseType?)
}

public class SuperHeroDetailRepository: SuperHeroDetailRepositoryProtocol{
    
    public var networkingManager: NetworkingManagerProtocol?
    public var imagesManager: SuperHeroesImagesManagerProtocol?
    public var dataSource: SuperHeroDetailDataSourceProtocol?
    public var superHero: SuperHeroEntity? {
        get {
            return dataSource?.superHero
        }
        set {
            dataSource?.superHero = newValue
        }
    }

    //get image from its uri
    public func getImageHero(uriImage: String, onSuccess: OnImageDataSuperHeroResponseType?, onFailure: OnFailureResponseType?) {
        
        imagesManager?.getImageHero(uriImage: uriImage, onSuccess: onSuccess, onFailure: onFailure)
    }
}
