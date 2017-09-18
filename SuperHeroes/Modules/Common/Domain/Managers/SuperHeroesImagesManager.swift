//
//  SuperHeroesImagesManager.swift
//  SuperHeroes
//
//  Created by Rafael Gil Pastor on 22/8/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation

public typealias OnImageDataSuperHeroResponseType = (Data?) -> (Void)

public protocol SuperHeroesImagesManagerProtocol {

    static var sharedInstance: SuperHeroesImagesManagerProtocol { get }
    var imageCacheManager: DataCacheManagerProtocol? { get set }
    var networkingManager: NetworkingManagerProtocol? { get set }
    
    func getImageHero(uriImage: String, onSuccess: OnImageDataSuperHeroResponseType?, onFailure: OnFailureResponseType?)
}

public class SuperHeroesImagesManager: SuperHeroesImagesManagerProtocol {
    
    public static var sharedInstance: SuperHeroesImagesManagerProtocol = SuperHeroesImagesManager()
    
    public var imageCacheManager: DataCacheManagerProtocol?
    public var networkingManager: NetworkingManagerProtocol?
    
    fileprivate init() {}
    
    //get image from its uri
    public func getImageHero(uriImage: String, onSuccess: OnImageDataSuperHeroResponseType?, onFailure: OnFailureResponseType?) {
        
        // check if the image´s hero is cached
        if let imageData = imageCacheManager?.getDataItem(withKey: uriImage) {
            onSuccess?(imageData)
        }
        else {
            //download image from received uri
            downloadImageHero(urlImage: uriImage, onSuccess: onSuccess, onFailure: onFailure)
        }
    }
}

fileprivate extension SuperHeroesImagesManager {
    
    //download image from a string url
    func downloadImageHero(urlImage: String, onSuccess: OnImageDataSuperHeroResponseType?, onFailure: OnFailureResponseType?) {
        if let url = URL(string: urlImage) {
            
            networkingManager?.getDataFromUrl(url: url, completion: { [weak self] (dataImage, urlResponse, error) in
                if error != nil
                {
                    onFailure?(error)
                }
                else {
                    //caching the image
                    if let image = dataImage {
                        self?.imageCacheManager?.setDataItem(dataItem: image, withKey: urlImage)
                    }
                    onSuccess?(dataImage)
                }
            })
        }
    }
}
