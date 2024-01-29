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
                    let stringData = String(data: success, encoding: .utf8) ?? ""
                    cn.resume(returning: stringData)
                case .failure(let failure):
                    cn.resume(returning: "Some failure was happened... \(failure.localizedDescription)")
                }
            }
        }
    }
}
