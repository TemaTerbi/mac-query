//
//  RequestSendingManager.swift
//  MacQuery
//
//  Created by Артем Соловьев on 26.01.2024.
//

import Foundation
import Alamofire

class RequestSendingManager {
    static let shared = RequestSendingManager()
    
    func sendRequest(withUrl url: String, typeOfMethod method: HTTPMethod) async -> String {
        return await withCheckedContinuation { cn in
            AF.request(url, method: method).responseData { responseData in
                switch responseData.result {
                case .success(let success):
                    if let json = try? JSONSerialization.jsonObject(with: success, options: .mutableContainers),
                       let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                        let stringResponse = String(decoding: jsonData, as: UTF8.self)
                        cn.resume(returning: stringResponse)
                    }
                case .failure(let failure):
                    cn.resume(returning: "Some failure was happened... \(failure.localizedDescription)")
                }
            }
        }
    }
}
