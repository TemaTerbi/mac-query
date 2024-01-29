//
//  RequestTypeMethod.swift
//  MacQuery
//
//  Created by Артем Соловьев on 26.01.2024.
//

import Foundation

enum RequestTypeMethod {
    case GET
    case POST
    case PUT
    case DELETE
    
    func getName() -> String {
        switch self {
        case .GET:
            "GET"
        case .POST:
            "POST"
        case .PUT:
            "PUT"
        case .DELETE:
            "DELETE"
        }
    }
}
