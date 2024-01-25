//
//  TreeFolderItem.swift
//  MacQuery
//
//  Created by Артем Соловьев on 24.01.2024.
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

struct TreeFolderItem: Identifiable, Hashable {
    let id = UUID()
    
    var title: String
    let createdAt: Date
    let icon: String
    let description: String
    let isWorkspace: Bool
    let isFolder: Bool
    let isRequest: Bool
    var isExpanded: Bool = false
    var isSelected: Bool = false
    let requestTypeMethod: RequestTypeMethod
    var folders: [TreeFolderItem]?
    var requests: [TreeFolderItem]?
    
    init(title: String, description: String = "", createdAt: Date = Date.now, icon: String = "airplayaudio", folders: [TreeFolderItem] = [], requests: [TreeFolderItem] = [], isWorkspace: Bool = true, isFolder: Bool = false, isRequest: Bool = false, requestTypeMethod: RequestTypeMethod = .GET) {
        self.title = title
        self.description = description
        self.createdAt = createdAt
        self.icon = icon
        self.folders = folders
        self.requests = requests
        self.isWorkspace = isWorkspace
        self.isFolder = isFolder
        self.isRequest = isRequest
        self.requestTypeMethod = requestTypeMethod
    }
    
    static func createDummyData() -> [TreeFolderItem] {
        return [
            TreeFolderItem(title: "Test workspace", folders: [TreeFolderItem(title: "AHAHHAHA", icon: "folder.fill", requests: [TreeFolderItem(title: "192.168.1.22", description: "Получение игроков", icon: "shift.fill", isRequest: true), TreeFolderItem(title: "New Request", description: "Получение data", icon: "shift.fill", isRequest: true)], isWorkspace: false, isFolder: true)]),
        ]
    }
    
    static func createNewFolder() -> TreeFolderItem {
        TreeFolderItem(title: "New Workspace")
    }
    
    mutating func createNewFolder() {
        self.folders?.append(TreeFolderItem(title: "New Folder", icon: "folder.fill", requests: [], isWorkspace: false, isFolder: true))
    }
    
    mutating func createNewRequest() {
        self.requests?.append(TreeFolderItem(title: "New Request", icon: "shift.fill", isRequest: true))
    }
    
    mutating func createNewRequest(withName name: String, andDescription description: String = "", methodType type: RequestTypeMethod) {
        self.requests?.append(TreeFolderItem(title: name, description: description, icon: "shift.fill", isRequest: true, requestTypeMethod: type))
    }
    
    mutating func chnageName(newName name: String) {
        self.title = name
    }
}
