//
//  MainViewModel.swift
//  MacQuery
//
//  Created by Артем Соловьев on 25.01.2024.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {
    @Published var selectedRequest: TreeFolderItem?
    @Published var selectedFolderForCretingNewRequestFromPopUp: TreeFolderItem?
    @Published var isShowAddNewRequest: Bool = false
    @Published var workspaces = TreeFolderItem.createDummyData()
    @Published var newRequestName = ""
    @Published var newRequestDescription = ""
    @Published var newRequestTypeMethod: RequestTypeMethod = .GET
    @Published var isCreateNewRequest = false
}
