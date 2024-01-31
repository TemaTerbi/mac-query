//
//  MainViewModel.swift
//  MacQuery
//
//  Created by Артем Соловьев on 25.01.2024.
//

import Foundation
import Combine
import Alamofire

class MainViewModel: ObservableObject {
    
    @Published var selectedRequest: TreeFolderItem?
    @Published var selectedFolderForCretingNewRequestFromPopUp: TreeFolderItem?
    @Published var isShowAddNewRequest: Bool = false
    @Published var workspaces = TreeFolderItem.createDummyData()
    @Published var newRequestName = ""
    @Published var newRequestDescription = ""
    @Published var newRequestUrl = ""
    @Published var newRequestTypeMethod: RequestTypeMethod = .GET
    @Published var isCreateNewRequest = false
    @Published var isHowLoader = false
    @Published var consoleText = ""
    
    private func isShowLoaderView() async {
        await MainActor.run {
            self.isHowLoader.toggle()
        }
    }
    
    func sendRequest(withUrl url: String, typeOfMethod method: HTTPMethod) async {
        await isShowLoaderView()
        
        let reponse = await RequestSendingManager.shared.sendRequest(withUrl: url, typeOfMethod: method)
        
        await MainActor.run {
            consoleText = reponse
        }
        
        await isShowLoaderView()
    }
}
