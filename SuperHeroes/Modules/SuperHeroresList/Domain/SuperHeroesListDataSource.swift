//
//  SuperHeroesListDataSource.swift
//  SuperHeroes
//
//  Created by Rafael Gil Pastor on 22/8/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation

public protocol SuperHeroesListDataSourceProtocol {
    var heroes: [SuperHeroEntity] { get set }
    
    //parse data received from SuperHeroes Google API
    func parseSearchSuperHeroesResponse(fromData data: Data?) throws -> Array<SuperHeroEntity>
}

public class SuperHeroesListDataSource: SuperHeroesListDataSourceProtocol {
    
    public var heroes: [SuperHeroEntity] = []
    //parse data received from SuperHeroes Google API
    public func parseSearchSuperHeroesResponse(fromData data: Data?) throws -> Array<SuperHeroEntity> {
        
        if let data = data, let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSON {
            
            if let heroes = json[SuperHeroesListDataSourceConstants.kSuperHeroesFieldKey] as? Array<JSON> {
                //return the non null SuperHeroEntity entities from received json
                return heroes.flatMap(SuperHeroEntity.init)
            }
            else if let errorItem = json[SuperHeroesListDataSourceConstants.kErrorFieldKey] as? JSON {
                //throw error received from Google or an undefined error
                throw ServerError(json: errorItem)?.toNSError() ?? ServerError.undefinedError()
            }
            else {
                //unexpected data received
                throw ServerError.unexpectedDataError()
            }
        }
        else {
            //not data received or malformed data
            throw ServerError.malformedDataError()
        }
    }
}

fileprivate struct SuperHeroesListDataSourceConstants {
    static let kSuperHeroesFieldKey = "superheroes"
    static let kErrorFieldKey = "error"
}
