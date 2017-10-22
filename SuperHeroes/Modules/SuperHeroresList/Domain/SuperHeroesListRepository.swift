//
//  SuperHeroesListRepository.swift
//  SuperHeroes
//
//  Created by Rafael Gil Pastor on 22/8/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit

public typealias OnSuperHeroesListResponseType = (Array<SuperHeroEntity>) -> (Void)

public protocol SuperHeroesListRepositoryProtocol {

    var dataSource: SuperHeroesListDataSourceProtocol? { get set }
    var imagesManager: SuperHeroesImagesManagerProtocol? { get set }
    var networkingManager: NetworkingManagerProtocol? { get set }

    func getHeroes(onSuccess: OnSuperHeroesListResponseType?, onFailure: OnFailureResponseType? )
    func getImageHero(uriImage: String, onSuccess: OnImageDataSuperHeroResponseType?, onFailure: OnFailureResponseType?)
}

public class SuperHeroesListRepository: SuperHeroesListRepositoryProtocol {
    
    public var networkingManager: NetworkingManagerProtocol?
    public var imagesManager: SuperHeroesImagesManagerProtocol?
    public var dataSource: SuperHeroesListDataSourceProtocol?
    
    //get super heroes data
    public func getHeroes(onSuccess: OnSuperHeroesListResponseType?, onFailure: OnFailureResponseType? ) {
        
        //ask for heroes
        networkingManager?.getDataFromResource(resource: SuperHeroesListRepositoryConstants.heroesResource, completion: { [weak self] (heroesData, urlResponse, error) in
            
            do {
                guard error == nil, let heroes = try self?.dataSource?.parseSearchSuperHeroesResponse(fromData: heroesData) else {
                    //we haven´t got the heroes from data
                    onFailure?( error != nil ? error! as NSError : ServerError.noDataError())
                    return
                }
                //return the received heroes as SuperHeroEntity objects array
                onSuccess?(heroes)
            } catch let jsonError {
                //throws the error catched from parsing
                onFailure?(jsonError)
            }
        })
    }
    
    //get image from its uri
    public func getImageHero(uriImage: String, onSuccess: OnImageDataSuperHeroResponseType?, onFailure: OnFailureResponseType?) {
        
        imagesManager?.getImageHero(uriImage: uriImage, onSuccess: onSuccess, onFailure: onFailure)
    }
}

fileprivate struct SuperHeroesListRepositoryConstants {
    static let heroesResource: String = "bins/mksp1"
}
