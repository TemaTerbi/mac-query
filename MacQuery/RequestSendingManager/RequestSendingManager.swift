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
    
    func sendRequest(withUrl url: String, typeOfMethod method: HTTPMethod) async -> [String: String] {
        return await withCheckedContinuation { cn in
            AF.request(url, method: method).responseData { responseData in
                switch responseData.result {
                case .success(let success):
                    if let json = try? JSONSerialization.jsonObject(with: success, options: .mutableContainers),
                       let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                        let stringResponse = String(decoding: jsonData, as: UTF8.self)
                        let returnedDictionary: [String: String] = [
                            DictionaryResponse.json.rawValue: stringResponse,
                            DictionaryResponse.statusCode.rawValue: String(responseData.response?.statusCode ?? 0),
                            DictionaryResponse.weightOfFile.rawValue: String(success.count) + " byte",
                        ]
                        cn.resume(returning: returnedDictionary)
                    }
                case .failure(let failure):
                    let returnedDictionary: [String: String] = [
                        DictionaryResponse.error.rawValue: failure.localizedDescription,
                    ]
                    cn.resume(returning: returnedDictionary)
                }
            }
        }
    }
}
