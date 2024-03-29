//
//  Result.swift
//  LastFM
//
//  Created by Gianluca Tranchedone on 20/03/2019.
//  Copyright © 2019 Gianluca Tranchedone. All rights reserved.
//

public enum Result<T> {
    case success(T)
    case failure(Error)
}

extension Result {
    
    public func map<U>(_ closure: (T) -> U) -> Result<U> {
        switch self {
        case .success(let value):
            return .success(closure(value))
            
        case .failure(let error):
            return .failure(error)
        }
    }
    
}

extension Result: Equatable where T: Equatable {

    public static func == (lhs: Result<T>, rhs: Result<T>) -> Bool {
        switch (lhs, rhs) {
        case (.success(let lhsValue), .success(let rhsValue)):
            return lhsValue == rhsValue
            
        case (.failure(let lhsError), .failure(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
            
        default:
            return false
        }
    }
    
}
