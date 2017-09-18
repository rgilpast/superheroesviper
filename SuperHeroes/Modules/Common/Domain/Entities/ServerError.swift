//
//  ServerError.swift
//  SuperHeroes
//
//  Created by Rafael Gil Pastor on 22/8/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation

public typealias OnFailureResponseType = (Error?) -> (Void)

public enum ServerErrorCode: Int {
    case Undefined = -1
    case NoData = -2
    case MalformedData = -3
    case UnexpectedData = -4
    case Internal = -5
}

public struct ServerInfoError
{
    //private fields´ keys
    private let kMessageFieldKey = "message"
    private let kLocationTypeFieldKey = "locationType"
    private let kReasonFieldKey = "reason"
    private let kDomainFieldKey = "domain"
    private let kLocationFieldKey = "location"

    //public properties
    public var message: String
    public var locationType: String
    public var reason: String
    public var domain: String
    public var location: String

    public init?(json: JSON)
    {
        
        //check the existence of required data
        guard   let message = json[kMessageFieldKey] as? String,
            let locationType = json[kLocationTypeFieldKey] as? String,
            let reason = json[kReasonFieldKey] as? String,
            let domain = json[kDomainFieldKey] as? String,
            let location = json[kLocationFieldKey] as? String else {
                return nil
        }
        
        self.message = message
        self.locationType = locationType
        self.reason = reason
        self.domain = domain
        self.location = location
    }

}

public struct ServerError
{
    //private fields´ keys
    private let kCodeFieldKey = "code"
    private let kMessageFieldKey = "message"
    private let kErrorsFieldKey = "errors"
    
    //public properties
    public var message: String
    public var code: Int
    public var errors: Array<ServerInfoError>
    
    public init?(json: JSON) {
        //check the existence of required data
        guard   let code = json[kCodeFieldKey] as? Int,
            let message = json[kMessageFieldKey] as? String,
            let errors = json[kErrorsFieldKey] as? Array<JSON> else {
                return nil
        }
        self.code = code
        self.message = message
        self.errors = errors.flatMap(ServerInfoError.init)
    }
    
    public func toNSError() -> NSError {
        return NSError(domain: "com.rgil.superheroes", code: code, userInfo: [NSLocalizedDescriptionKey : message, "errors" : errors])
    }
    
    public static func undefinedError() -> NSError {
        return NSError(domain: "com.rgil.superheroes", code: ServerErrorCode.Undefined.rawValue, userInfo: nil)
    }
    
    public static func noDataError() -> NSError {
        return NSError(domain: "com.rgil.superheroes", code: ServerErrorCode.NoData.rawValue, userInfo: nil)
    }
    
    public static func malformedDataError() -> NSError {
        return NSError(domain: "com.rgil.superheroes", code: ServerErrorCode.MalformedData.rawValue, userInfo: nil)
    }
    
    public static func unexpectedDataError() -> NSError {
        return NSError(domain: "com.rgil.superheroes", code: ServerErrorCode.UnexpectedData.rawValue, userInfo: nil)
    }
    
    public static func internalError() -> NSError {
        return NSError(domain: "com.rgil.superheroes", code: ServerErrorCode.Internal.rawValue, userInfo: nil)
    }
}
